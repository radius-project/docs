#!/bin/bash

# Copyright 2026 The Radius Authors.
# Licensed under the Apache License, Version 2.0.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
TEST_ROOT="$(mktemp -d)"
readonly TEST_ROOT
trap 'rm -rf "${TEST_ROOT}"' EXIT

mkdir -p "${TEST_ROOT}/bin"
cat > "${TEST_ROOT}/bin/gh" << 'EOF'
#!/bin/bash
set -euo pipefail

[[ "$1" == api ]] || exit 1
shift
method=GET
endpoint=""
fields=""
input=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        --method) method="$2"; shift 2 ;;
        --input) [[ "$2" == - ]]; input=true; shift 2 ;;
        --jq) shift 2 ;;
        --silent) shift ;;
        -f | -F) fields+="$2"$'\n'; shift 2 ;;
        *) [[ -z "${endpoint}" ]]; endpoint="$1"; shift ;;
    esac
done
printf '%s %s\n' "${method}" "${endpoint}" >> "${REQUEST_LOG}"
[[ "${endpoint}" == repos/radius-project/docs/* ]] || exit 1
payload=""
if [[ "${input}" == true ]]; then payload="$(cat)"; fi
case "${method} ${endpoint}" in
    "POST repos/radius-project/docs/git/blobs")
        if [[ "${SCENARIO}" == blob-error ]]; then
            echo "injected blob failure" >&2; exit 42
        fi
        jq -e '.encoding == "base64"' <<< "${payload}" > /dev/null
        content="$(jq -r .content <<< "${payload}" | base64 --decode)"
        [[ "${content}" == "$(<docs/config.toml)" ]]
        printf '%s' "${payload}" | jq -r .content | base64 --decode | git hash-object -w --stdin
        ;;
    "POST repos/radius-project/docs/git/trees")
        jq -e --arg base "$(git rev-parse 'HEAD^{tree}')" \
            --arg blob "$(git rev-parse :docs/config.toml)" '
            .base_tree == $base and
            .tree == [{path:"docs/config.toml",mode:"100644",type:"blob",sha:$blob}]
        ' <<< "${payload}" > /dev/null
        if [[ "${SCENARIO}" == wrong-tree ]]; then
            printf '%040d\n' 1
        else
            git write-tree
        fi
        ;;
    "POST repos/radius-project/docs/git/commits")
        if [[ "${SCENARIO}" == commit-error ]]; then
            echo "injected commit failure" >&2; exit 42
        fi
        jq -e --arg parent "$(git rev-parse HEAD)" --arg tree "$(git write-tree)" \
            --arg message "$(printf 'Update docs for v0.63.0\n\nSigned-off-by: %s <%s>' "${BOT_NAME}" "${BOT_EMAIL}")" '
            keys == ["message","parents","tree"] and
            .message == $message and .tree == $tree and .parents == [$parent]
        ' <<< "${payload}" > /dev/null
        verified=true
        reason=valid
        sha=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
        if [[ "${SCENARIO}" == unsigned ]]; then verified=false; reason=unsigned; fi
        if [[ "${SCENARIO}" == invalid-sha ]]; then sha=null; fi
        if [[ "${SCENARIO}" == missing-verification ]]; then
            jq -n --arg sha "${sha}" '{sha:$sha}'
        else
            jq -n --arg sha "${sha}" --arg reason "${reason}" --argjson verified "${verified}" \
                '{sha:$sha,verification:{verified:$verified,reason:$reason}}'
        fi
        ;;
    "GET repos/radius-project/docs/git/matching-refs/heads/v0.63")
        if [[ "${SCENARIO}" == lookup-error ]]; then
            echo "injected branch lookup failure" >&2; exit 42
        fi
        if [[ "${SCENARIO}" == existing || "${SCENARIO}" == update-error ]]; then
            printf '[{"ref":"refs/heads/v0.63"}]\n'
        else
            printf '[{"ref":"refs/heads/v0.630"}]\n'
        fi
        ;;
    "POST repos/radius-project/docs/git/refs")
        [[ "${fields}" == *$'ref=refs/heads/v0.63\n'* ]]
        [[ "${fields}" == *$'sha=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n'* ]]
        ;;
    "PATCH repos/radius-project/docs/git/refs/heads/v0.63")
        [[ "${fields}" == *$'force=false\n'* ]]
        [[ "${fields}" == *$'sha=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n'* ]]
        if [[ "${SCENARIO}" == update-error ]]; then
            echo "non-fast-forward branch update rejected" >&2; exit 42
        fi
        ;;
    *) echo "Unexpected API request: ${method} ${endpoint}" >&2; exit 1 ;;
esac
EOF
chmod +x "${TEST_ROOT}/bin/gh"

run_case() {
    local scenario="$1"
    local expected="$2"
    local root="${TEST_ROOT}/${scenario}"
    local repo="${root}/docs"
    local before status=0 output bot_name=radius-release

    mkdir -p "${repo}/docs"
    git -C "${repo}" init -q -b edge
    git -C "${repo}" config user.name "Release fixture"
    git -C "${repo}" config user.email fixture@example.test
    git -C "${repo}" config commit.gpgsign false
    git -C "${repo}" config core.autocrlf false
    cat > "${repo}/docs/config.toml" << 'EOF'
baseURL = "https://edge.docs.radapp.io/"
version = "edge"
github_branch = "edge"
chart_version = "0.62.0"
indexName = "radapp-dev-edge"
title = "Unrelated configuration"
EOF
    if [[ "${scenario}" == formatted ]]; then
        cat > "${repo}/docs/config.toml" << 'EOF'
  baseURL='https://edge.docs.radapp.io/' # keep tolerated formatting
 version = 'edge' # comment
github_branch= 'edge'
chart_version = '0.62.0' # old chart version
 indexName= 'radapp-dev-edge'
title = "Unrelated configuration"
EOF
    elif [[ "${scenario}" == drift ]]; then
        sed -i '/^chart_version/d' "${repo}/docs/config.toml"
    elif [[ "${scenario}" == no-change ]]; then
        cat > "${repo}/docs/config.toml" << 'EOF'
baseURL = "https://docs.radapp.io/"
version = "v0.63"
github_branch = "v0.63"
chart_version = "0.63.0"
indexName = "radapp-dev"
title = "Unrelated configuration"
EOF
    fi
    printf 'Existing documentation\n' > "${repo}/README.md"
    git -C "${repo}" add .
    git -C "${repo}" commit -qm fixture
    before="$(git -C "${repo}" rev-parse HEAD)"
    if [[ "${scenario}" == dirty ]]; then
        printf 'Uncommitted user change\n' >> "${repo}/README.md"
    elif [[ "${scenario}" == missing-bot ]]; then
        bot_name=""
    fi
    : > "${root}/requests"
    output="$(
        cd "${root}"
        PATH="${TEST_ROOT}/bin:${PATH}" GH_TOKEN=fixture-token \
            GITHUB_REPOSITORY=radius-project/docs BOT_NAME="${bot_name}" \
            BOT_EMAIL='294554884+radius-release[bot]@users.noreply.github.com' \
            REQUEST_LOG="${root}/requests" SCENARIO="${scenario}" \
            bash "${SCRIPT_DIR}/release-docs.sh" 0.63.0 2>&1
    )" || status=$?
    if [[ "${expected}" == success ]]; then
        [[ "${status}" == 0 ]] || {
            echo "${output}" >&2
            return 1
        }
        grep -Fq 'Published verified docs commit' <<< "${output}"
        for line in 'baseURL = "https://docs.radapp.io/"' \
            'version = "v0.63"' 'github_branch = "v0.63"' \
            'chart_version = "0.63.0"' 'indexName = "radapp-dev"' \
            'title = "Unrelated configuration"'; do
            grep -Fxq "${line}" "${repo}/docs/config.toml"
        done
        [[ "$(git -C "${repo}" diff --cached --name-only)" == docs/config.toml ]]
        [[ "$(wc -l < "${root}/requests")" == 5 ]]
        if [[ "${scenario}" == existing ]]; then
            grep -Fxq 'PATCH repos/radius-project/docs/git/refs/heads/v0.63' "${root}/requests"
        else
            grep -Fxq 'POST repos/radius-project/docs/git/refs' "${root}/requests"
        fi
    else
        [[ "${status}" != 0 ]] || {
            echo "${scenario} unexpectedly succeeded" >&2
            return 1
        }
        if grep -Fq 'Published verified docs commit' <<< "${output}"; then
            echo "${scenario} reported a successful publication" >&2
            return 1
        fi
        if [[ "${scenario}" != update-error ]]; then
            if grep -Eq '^(POST|PATCH) repos/radius-project/docs/git/refs' "${root}/requests"; then
                echo "${scenario} published an unverified ref" >&2
                return 1
            fi
        fi
        case "${scenario}" in
        unsigned | missing-verification | invalid-sha)
            grep -Fq 'GitHub did not verify release commit' <<< "${output}"
            if grep -Fq 'GET repos/radius-project/docs/git/matching-refs' "${root}/requests"; then
                echo "${scenario} continued after verification failure" >&2
                return 1
            fi
            ;;
        wrong-tree)
            grep -Fq 'does not match the local release configuration' <<< "${output}"
            if grep -Fq 'POST repos/radius-project/docs/git/commits' "${root}/requests"; then
                echo "${scenario} created a commit from an unexpected tree" >&2
                return 1
            fi
            ;;
        missing-bot | dirty | drift | no-change)
            [[ ! -s "${root}/requests" ]]
            ;;
        esac
    fi
    [[ "$(git -C "${repo}" rev-parse HEAD)" == "${before}" ]]
    [[ "$(git -C "${repo}" branch --show-current)" == edge ]]
    printf 'PASS: %s\n' "${scenario}"
}

run_case create success
run_case existing success
run_case formatted success
run_case unsigned failure
run_case missing-verification failure
run_case invalid-sha failure
run_case wrong-tree failure
run_case blob-error failure
run_case commit-error failure
run_case lookup-error failure
run_case update-error failure
run_case missing-bot failure
run_case dirty failure
run_case drift failure
run_case no-change failure

echo "Docs release script tests passed (15 cases)."
