# 📕 Radius documentation

This repo contains the source for the [Radius documentation](https://docs.radapp.io/).

## 📦 Framework

Radius uses [Hugo](https://gohugo.io/) to generate the docs site.

### Theme

The [Docsy theme](https://docsy.dev) is used to style the generated site.

### Auto-generated docs

The [rad CLI](https://github.com/radius-project/radius/tree/main/cmd/rad) reference docs are auto-generated via [Cobra doc gen](https://github.com/spf13/cobra/tree/master/doc).

## 👨‍💻 Contributing

Visit the [docs contribution guide](https://docs.radapp.io/edge/contributing/contributing-docs/) to learn how to contribute to the docs.

### Build or serve locally

The repository root is the Hugo project. Use the Node.js version in [`.node-version`](.node-version) and Go as specified in [`go.mod`](go.mod). From the root:

```sh
npm ci
npm start
```

Open the URL printed by Hugo. In a Codespace, the container runs `npm ci` for you. To build the static site instead, run `npm run build`; Hugo writes it to `public/`.

The lockfile supplies Hugo and Dart Sass; no global installation is needed. After updating Docsy in `go.mod`, run `npm run hugo -- mod npm pack` and `npm install` to refresh the theme workspace and lockfile. The `adm-zip` override pins the Hugo installer's patched ZIP reader on Windows; remove it once `hugo-extended` requires a patched version.

### Validate Bicep configuration

From the repository root, run the release tag-selection tests:

```sh
python3 -m unittest discover -s .github/scripts -p 'test_set_bicep_extension_tags.py'
```

The root `bicepconfig.json` uses the development `edge` tags. New docs releases are generated from the current `edge` source configuration: the release script selects the `major.minor` channel for stable releases and the full version for release candidates. It updates tags only on canonical GHCR development references, preserving explicit stable tags, manifest pins, existing ACR contracts, custom registries, and local extensions. The existing version-only release dispatch is unchanged; no minor-version cutoff decides the registry. Previously published 0.62 docs and applications retain ACR.

The release script publishes both the site configuration and Bicep configuration in one verified App-signed commit. Do not run it for local validation: it writes commits and release refs on GitHub.

The release integration tests use a local `gh` stub and temporary repositories, without publishing anything. On Linux, run:

```sh
bash .github/scripts/release-docs_test.sh
```

These tests require GNU `sed` and `base64`, matching the release runner.

Bicep validation uses v0.46.1, with `experimentalFeaturesEnabled.ociEnabled` enabled in the effective configuration. Both production packages have public development `edge` tags. Point `BICEP_PATH` at a directory containing that `bicep` binary and run:

```sh
BICEP_PATH=/path/to/bicep-directory python3 .github/scripts/validate_bicep.py
```

This command restores extensions and compiles the examples; it does not deploy them. An unavailable public tag blocks this check. Public development artifacts do not establish stable or release-candidate availability. Radius v0.61.1 supplies a compatible compiler, but does not establish a minimum release for GHCR defaults. Before the documentation cutover, identify the release containing those defaults and verify its generated configurations and corresponding published artifacts with the released CLI. A standalone compiler check does not replace that verification.

## ☁ Hosting

The [Publish workflow](.github/workflows/publish.yaml) deploys **one GitHub Pages artifact** with two versions:

- [**latest**](https://docs.radapp.io/latest/) is the newest stable `vMAJOR.MINOR` docs branch, selected by version number. A branch whose `chart_version` is still a release candidate does not become `latest`.
- [**edge**](https://docs.radapp.io/edge/) follows the default `edge` branch.

URLs without a channel open the corresponding stable page: `/` opens `/latest/`, and `/installation/` opens `/latest/installation/`. Unversioned downloads such as `/samples/demo/app.bicep` serve the stable file directly. The Docsy menu shows `edge` or `latest (X.Y)` using the release branch's version. Switching keeps the current page when it exists in both channels.

The [core Radius release process](https://github.com/radius-project/radius/blob/main/.github/scripts/coordinate-release.mjs) dispatches [Release docs](.github/workflows/release.yaml) on `edge` for a final release. That workflow creates the `vMAJOR.MINOR` docs branch without changing the default branch.

Pushes to `edge` rebuild both versions. A push or merged pull request on a release branch triggers the same publisher through **Website**, including on branches cut before this migration. The publisher reads the current tip of the newest stable branch, not the commit that cut the release. A typo fix on that branch therefore updates `/latest/` and the unversioned URLs without a new tag or a merge into `edge`. A fix on an older branch does not change which branch serves `/latest/`.

**Publish** also rebuilds daily at 16:17 UTC to catch changes for which GitHub didn’t emit a push workflow run. To rebuild manually, run it on `edge`. Pull requests to either published branch get a downloadable `docs-preview-*` artifact; extract it and run `python -m http.server 8000` from the extracted directory. Pull requests never deploy to Pages.

For the first deployment, set **Settings → Pages → Source** to **GitHub Actions** and allow `edge` in **Settings → Environments → github-pages → Deployment branches and tags**. The workflow reads the host and base path from `actions/configure-pages`, so the version menu, assets, and page links follow the configured domain without a workflow edit. Only deployments to `docs.radapp.io` update the production Algolia indices; previews use Docsy's per-version search.

Previously cut branches retain their original site layout and workflows. The publisher locates their Hugo project in `docs/` and uses the pinned theme and Sass tools from `edge` for pre-migration releases without changing their content. Backport [the replacement `website.yaml`](.github/workflows/website.yaml) to a maintained release branch to stop its old Azure publisher; keep the workflow name so its pushes still notify Pages.

## Code of Conduct

Please refer to our [Radius Community Code of Conduct](https://github.com/radius-project/radius/blob/main/CODE_OF_CONDUCT.md)
