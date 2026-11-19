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

### Local server

Visit the [docs guide](./docs) to learn how to build the docs locally.

## ☁ Hosting

The [Publish docs workflow](.github/workflows/publish.yaml) deploys **one GitHub Pages artifact** with two versions:

- [**latest**](https://docs.radapp.io/latest/) is the newest stable `vMAJOR.MINOR` docs branch, selected by version number. A branch whose `chart_version` is still a release candidate does not become `latest`.
- [**edge**](https://docs.radapp.io/edge/) follows the default `edge` branch.

URLs without a channel open the corresponding stable page: `/` opens `/latest/`, and `/installation/` opens `/latest/installation/`. Unversioned downloads such as `/samples/demo/app.bicep` serve the stable file directly. The Docsy menu shows `edge` or `latest (X.Y)` using the release branch's version. Switching keeps the current page when it exists in both channels.

The [core Radius release process](https://github.com/radius-project/radius/blob/main/.github/scripts/coordinate-release.mjs) dispatches [Release docs](.github/workflows/release.yaml) on `edge` for a final release. That workflow creates the `vMAJOR.MINOR` docs branch without changing the default branch.

Pushes to `edge` rebuild both versions. A push or merged pull request on a release branch triggers the same publisher through **Radius Website**, including on branches cut before this migration. The publisher reads the current tip of the newest stable branch, not the commit that cut the release. A typo fix on that branch therefore updates `/latest/` and the unversioned URLs without a new tag or a merge into `edge`. A fix on an older branch does not change which branch serves `/latest/`.

**Publish docs** also rebuilds daily at 16:17 UTC to catch changes for which GitHub didn’t emit a push workflow run. To rebuild manually, run it on `edge`. Pull requests to either published branch get a downloadable `docs-preview-*` artifact; extract it and run `python -m http.server 8000` from the extracted directory. Pull requests never deploy to Pages.

For the first deployment, set **Settings → Pages → Source** to **GitHub Actions** and allow `edge` in **Settings → Environments → github-pages → Deployment branches and tags**. The workflow reads the host and base path from `actions/configure-pages`, so the version menu, assets, and page links follow the configured domain without a workflow edit. Only deployments to `docs.radapp.io` update the production Algolia indices; previews use Docsy's per-version search.

Previously cut branches retain their old workflows. Backport [the replacement `website.yaml`](.github/workflows/website.yaml) to a maintained release branch to stop it dispatching Azure deployments; keep the workflow name so its pushes still notify Pages. The separate [legacy `radapp.dev` redirect](redirect/) is not part of this site.

## Code of Conduct

Please refer to our [Radius Community Code of Conduct](https://github.com/radius-project/radius/blob/main/CODE_OF_CONDUCT.md)
