---
type: docs
title: "How-To: Contribute to the Radius documentation"
linkTitle: "Contribute to docs"
description: "How to contribute to the Radius documentation"
weight: 200
aliases: ["/community/contributing/docs/", "/contributing/docs/contributing-docs/", "/community/maintainers/docs-maintainers/", "/contributing/docs/maintainers-docs/", "/contributing/maintainers-docs/"]
---

Radius uses the [Diátaxis framework](https://diataxis.fr/) for its documentation:

{{< image src="diataxis.png" alt="Diagram showing the diataxis framework" width=800px >}}

Follow the guidance on this page to learn how to get started, how to contribute, and how to use the Diátaxis framework to create new docs.

## Setup your docs environment

{{< tabs "GitHub Codespace" "Local machine" >}}

{{% codetab %}}
The easiest way to get up and running is with a GitHub Codespace. This gives you a fully configured environment with all the tools you need to build the docs, all in your browser.

{{< button link="https://github.com/codespaces/new?hide_repo_select=true&repo=421982809" text="Create codespace" >}}

> Note the `postCreateCommand` may take up to 3 minutes to complete after the codespace is created.

1. Start Codespace
1. Wait for `postCreateCommand` to complete
1. Run `cd docs` to enter the hugo site directory
1. Run `hugo server` to start the local server
1. Click on the link in the terminal to open the docs in your browser
{{% /codetab %}}

{{% codetab %}}
**Pre-requisites**

- [Hugo extended version](https://gohugo.io/getting-started/installing)
- [Node.js](https://nodejs.org/en/)
- [git](https://git-scm.com/downloads)

**Environment setup**

1. Ensure pre-requisites are installed
1. Clone this repository and the radius repository

   ```sh
   git clone https://github.com/radius-project/radius.git
   git clone https://github.com/radius-project/docs.git
   ```

1. Generate CLI docs:

   ```sh
   pushd radius
   go run ./cmd/docgen/main.go ../docs/docs/content/reference/cli
   popd
   ```

1. Update submodules:

   ```sh
   cd docs
   git submodule update --init --recursive
   ```

1. Install npm packages:

   ```sh
   npm install
   ```

1. Initialize the docsy theme:

   ```sh
   cd themes/docsy
   npm install
   cd ..
   ```

**Run local server**

1. Make sure you're still in the `docs` directory
1. Run

   ```sh
   hugo server
   ```

1. Navigate to `http://localhost:1313/`
{{% /codetab %}}

{{< /tabs >}}

## Developer Certificate of Origin

The Radius project follows the [Developer Certificate of Origin](https://developercertificate.org/). This is a lightweight way for contributors to certify that they wrote or otherwise have the right to submit the code they are contributing to the project.

Contributors sign-off that they adhere to these requirements by adding a Signed-off-by line to commit messages.

```text
This is my commit message

Signed-off-by: Random J Developer <random@developer.example.org>
```

Git even has a -s command line option to append this automatically to your commit message:

```text
git commit -s -m 'This is my commit message'
```

Visual Studio Code has a setting, `git.alwaysSignOff` to automatically add a Signed-off-by line to commit messages. Search for "sign-off" in VS Code settings to find it and enable it.

## Types of docs

Radius follows the [Diátaxis framework](https://diataxis.fr/). Pick the type that matches your goal — the docs are organized by type, so place your page in the matching section:

- **Concept** — explain what something is and why it matters, so the reader understands the problem it solves.
- **Tutorial** — teach a newcomer by guiding them through a complete, hands-on lesson from start to finish.
- **How-To** — walk a reader who already knows the basics through completing a specific task, step by step.
- **Reference** — describe the details of a feature precisely; auto-generate from source code where possible.
- **Schema** — document the schema of a resource type or API, typically generated from the source definition.

Whatever you write:

- Reuse an existing section instead of creating a new one where possible — there's a good chance the right place already exists.
- Write for a new-developer audience: keep steps explicit, copy-pasteable, and environment-agnostic unless the doc is specific to one environment.
- Link to related concepts, overviews, how-to guides, and references.

## Writing styles and tips

### Style and tone

These conventions should be followed throughout all Radius documentation to ensure a consistent experience across all docs.

| Style/Tone | Guidance |
|---------|-------------|
|**Casing**|Use upper case only:<ul><li>At the start of a sentence or header</li><li>For proper nouns including names of technologies (Redis, Kubernetes, etc.)</li> <li>Names of Radius concepts (Radius Recipe, Radius Environment, Radius Application, etc.)</li></ul>|
|**Headers and titles**|Headers and titles must be descriptive and clear, use sentence casing i.e. use the above casing guidance for headers and titles too|
|**Use simple sentences**|Easy-to-read sentences mean the reader can quickly use the guidance you share.|
|**Avoid the first person**|Use second person "you", "your" instead of "I", "we", "our".|
|**Assume a new developer audience**|Some obvious steps can seem hard. E.g. Now set an environment variable Radius to a value X. It is better to give the reader the explicit command to do this, rather than having them figure this out.|
|**Use present tense**|Avoid sentences like "this command will install redis", which implies the action is in the future. Instead, use "This command installs redis" which is in the present tense. |

### Spelling

The docs pipeline uses [cspell](https://cspell.org/) to check for spelling mistakes. The configuration lives in `.github/configs/.cspell.yml` and is synced from the [radius-project/.github](https://github.com/radius-project/.github) repository so spell-checking behaves the same across Radius repos. If you need to add a new custom word to the allow-list, append it to `.cspellignore` at the repository root (keep the list sorted, one word per line).

To run the spell checker locally:

```shell
npm install -g cspell
cspell lint --config ./.github/configs/.cspell.yml --no-progress --dot "**/*.md"
```

### Numbering

All numbered lists use `1.` as the number, regardless of the order. The list numbers are then incremented automatically during the build process of the docs.

#### Example

```md
1. This is the first step of a process.
1. This is the second step, and will be displayed with a 2 in the docs.
1. This is the third step, and will be displayed with a 3.
```

## Tips and tricks

Any contribution must ensure not to break the website build. The way Hugo builds the website requires following the below guidance.

### Front-matter

[Front-matter](https://www.docsy.dev/docs/adding-content/content/#page-frontmatter) is what takes regular markdown files and upgrades them into Hugo-compatible docs for rendering into the nav bars and ToCs.

Every page needs a section at the top of the document like this:

```yaml
---
type: docs
title: "TITLE FOR THE PAGE"
linkTitle: "SHORT TITLE FOR THE NAV BAR"
weight: (number)
description: "1+ SENTENCES DESCRIBING THE ARTICLE"
tags: "METADATA ON THE DOCUMENT"
---
```

#### Example

```yaml
---
type: docs
title: "Recipes overview"
linkTitle: "Overview"
weight: 10
description: "A quick overview of Radius Recipes and how to use them to deploy infrastructure for your application"
tags: "Recipes"
---
```

> **Weight** determines the order of the pages in the left sidebar, with 0 being the top-most.
>
> - Index file weights follow the parent directory's ordering.
> - For the first page in a new directory, reset the counter and set the weight to be an order of magnitude greater.

Front-matter should be completed with all fields including type, title, linkTitle, weight, description, and tags.

- `title` should be 1 sentence, with no period at the end
- `linkTitle` should be 1-3 words, with the exception of How-to at the front.
- `description` should be 1-2 sentences on what the reader will learn, accomplish, or do in this doc.
- `tags` should be a comma-separated list of metadata tags.

As per the [styling conventions](#style-and-tone), titles should only capitalize the first word and proper nouns, with the exception of "How-To:"
    - "Getting started with Radius Recipes"
    - "How-To: Setup a local Redis instance"

### Referencing other pages

Hugo `ref` and `relref` [shortcodes](https://gohugo.io/content-management/cross-references/) are used to reference other pages and sections. It also allows the build to break if a page is incorrectly renamed or removed.

This shortcode, written inline with the rest of the markdown page, will link to the _index.md of the section/folder name:

```md
{{</* ref "folder" */>}}
```

This shortcode will link to a specific page:

```md
{{</* ref "page.md" */>}}
```

> Note that all pages and folders need to have globally unique names in order for the ref shortcode to work properly. If there are duplicate names the build will break and an error will be thrown.

#### Referencing sections in other pages

To reference a specific section on another page, add `#section-short-name` to the end of your reference.

As a general rule, the section's short name is the text of the section title, all lowercase, with spaces changed to "-". You can check the section's short name by visiting the website page, clicking the link icon (🔗) next to the section, and see how the URL renders in the nav bar. The content after the "#" is your section shortname.

As an example, for this specific section, the complete reference to the page and section would be:

```md
{{</* ref "contributing-docs.md#referencing-sections-in-other-pages" */>}}
```

### Code snippets

Use the `rad` shortcode to reference code snippets from a file. By convention place code snippets in a `snippets` folder.

```md
{{</* rad file="snippets/mysample.bicep" embed=true */>}}
```

{{% alert title="Warning" color="warning" %}}
All Bicep sample code should be self-contained in separate files, not in markdown. We validate all `.bicep` files as part of the build for syntactic and semantic correctness, and so all `.bicep` sample code must be complete and correct. Use the techniques described here to highlight the parts of the sample code users should focus on.
{{% /alert %}}

Use the `embed` parameter (default `false`) to include a download link and embed the content in the page.

Use the `lang` (default `bicep`) parameter to configure the language used for syntax highlighting.

Use the `marker` parameter to limit the embedded snipped to a portion of the sample file. This is useful when you want to show just a portion of a larger file. The typical way to do this is surround the interesting code with comments, and then pass the comment text into `marker`.

The shortcode below and code sample:

```md
{{</* rad file="snippets/mysample.bicep" embed=true marker="//SAMPLE" */>}}
```

```bicep
// in snippets/mysample.bicep
resource app 'radius.dev/Application@v1alpha3' = {
  name: 'storefront-app'

  //SAMPLE
  resource store 'Container' = {
    name: 'storefront'
    properties: {
      container: {
        image: 'foo'
      }
    }
  }
  //SAMPLE
}
```

Will result in the following output:

```bicep
  resource store 'Container' = {
    name: 'storefront'
    properties: {
      container: {
        image: 'foo'
      }
    }
  }
```

Use the `replace-key-[token]` and `replace-value-[token]` parameters to limit the embedded snipped to a portion of the sample file. This is useful when you want abbreviate a portion of the code sample. Multiple replacements are supported with multiple values of `token`.

The shortcode below and code sample:

```md
{{</* rad file="snippets/mysample.bicep" embed=true marker="//SAMPLE" replace-key-container="//RUN" replace-value-container="container: {...}" replace-key-connections="//CONNECTIONS" replace-value-connections="connections: {...}" */>}}
```

```bicep
// in snippets/mysample.bicep
resource app 'radius.dev/Application@v1alpha3' = {
  name: 'storefront-app'

  //SAMPLE
  resource store 'Container' = {
    name: 'storefront'
    properties: {
      //RUN
      container: {
        image: 'foo'
      }
      //RUN
      //BINDINGS
      connections: {
        backend: {
          source: other.id
        }
      }
      //BINDINGS
    }
  }
  //SAMPLE
}
```

Will result in the following output:

```bicep
  resource store 'Container' = {
    name: 'storefront'
    properties: {
      container: {...}
      connections: {...}
    }
  }
```

### Images

The markdown spec used by Docsy and Hugo does not give an option to resize images using markdown notation. Instead, raw HTML is used.

Begin by placing images under `/docs/static/images` with the naming convention of `[page-name]-[image-name].[png|jpg|svg]`.

Then link to the image using:

```md
{{</* image src="/images/[image-filename]" width=1000 alt="Description of image" */>}}
```

>Don't forget to set the alt attribute to keep the docs readable for our visually impaired users.

#### Example

This HTML will display the `radius-overview.png` image on the `overview.md` page:

```md
{{</* image src="radius-overview.png" width=1000 alt="Overview diagram of Radius and its core concepts" */>}}
```

### Alerts

The **alert** shortcode creates an alert block that can be used to display notices or warnings.

```go-html-template
{{%/* alert title="Warning" color="warning" */%}}
This is a warning.
{{%/* /alert */%}}
```

Renders to:

{{% alert title="Warning" color="warning" %}}
This is a warning.
{{% /alert %}}

| Parameter        | Default    | Description  |
| ---------------- |------------| ------------|
| color | primary | One of the theme colors, eg `primary`, `info`, `warning` etc.

### Page info banner

The **pageinfo** shortcode creates a text box that you can use to add banner information for a page: for example, letting users know that the page contains placeholder content, that the content is deprecated, or that it documents a beta feature.

```go-html-template
{{%/* pageinfo color="primary" */%}}
This is placeholder content.
{{%/* /pageinfo */%}}
```

Renders to:

{{% pageinfo color="primary" %}}
This is placeholder content
{{% /pageinfo %}}

| Parameter        | Default    | Description  |
| ---------------- |------------| ------------|
| color | primary | One of the theme colors, eg `primary`, `info`, `warning` etc.

### Tabbed content

Tabs are made possible through [Hugo shortcodes](https://gohugo.io/content-management/shortcodes/).

The overall format is:

```
{{</* tabs [Tab1] [Tab2]>}}

{{% codetab %}}
[Content for Tab1]
{{% /codetab %}}

{{% codetab %}}
[Content for Tab2]
{{% /codetab %}}

{{< /tabs */>}}
```

All content you author will be rendered to Markdown, so you can include images, code blocks, YouTube videos, and more.

#### Example

````
{{</* tabs Windows Linux MacOS>}}

{{% codetab %}}
```powershell
iwr -useb "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.ps1" | iex
```
{{% /codetab %}}

{{% codetab %}}
```bash
wget -q "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.sh" -O - | /bin/bash
```
{{% /codetab %}}

{{% codetab %}}
```bash
curl -fsSL "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.sh" | /bin/bash
```
{{% /codetab %}}

{{< /tabs */>}}
````

This example will render to this:

{{< tabs Windows Linux MacOS>}}

{{% codetab %}}

```powershell
iwr -useb "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.ps1" | iex
```

{{% /codetab %}}

{{% codetab %}}

```bash
wget -q "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.sh" -O - | /bin/bash
```

{{% /codetab %}}

{{% codetab %}}

```bash
curl -fsSL "https://raw.githubusercontent.com/radius-project/radius/main/deploy/install.sh" | /bin/bash
```

{{% /codetab %}}

{{< /tabs >}}

### YouTube videos

Hugo can automatically embed YouTube videos using a shortcode:

```
{{</* youtube [VIDEO ID] */>}}
```

#### Example

Given the video `https://youtu.be/dQw4w9WgXcQ`

The shortcode would be:

```
{{</* youtube dQw4w9WgXcQ */>}}
```

### Buttons

To create a button in a webpage, use the `button` shortcode.

An optional `newtab` parameter will indicate if the page should open in a new tab. Options are "true" or "false". Default is "false", where the page will open in the same tab.

#### Link to an external page

```text
{{</* button text="My Button" link="https://example.com" */>}}
```

{{< button text="My Button" link="https://example.com" >}}

#### Link to another docs page

You can also reference pages in your button as well:

```text
{{</* button text="My Button" page="contributing" newtab="true" */>}}
```

{{< button text="My Button" page="contributing" newtab="true" >}}

#### Link to a GitHub file/directory

You can link to a GitHub repo and path with the `githubRepo` and `githubPath` parameters:

```text
{{</* button text="My Button" githubRepo="samples" githubPath="samples" */>}}
```

{{< button text="My Button" githubRepo="samples" githubPath="samples" >}}

#### Button colors

You can customize the colors using the Bootstrap colors:

```text
{{</* button text="My Button" link="https://example.com" color="primary" */>}}
{{</* button text="My Button" link="https://example.com" color="secondary" */>}}
{{</* button text="My Button" link="https://example.com" color="success" */>}}
```

{{< button text="My Button" link="https://example.com" color="primary" >}}
{{< button text="My Button" link="https://example.com" color="secondary" >}}
{{< button text="My Button" link="https://example.com" color="success" >}}

#### Inline buttons

By default, buttons are padded with new lines below the button. To remove these new lines to create multiple buttons in-line, add a `newline="false"` parameter:

```text
{{</* button text="Previous" link="https://example.com" newline="false" */>}}
{{</* button text="Next" link="https://example.com" */>}}
```

{{< button text="Previous" link="https://example.com" newline="false" >}}
{{< button text="Next" link="https://example.com" >}}

## Maintaining the docs

This section covers routine Radius docs maintainer and approver responsibilities. To perform these tasks, you need either approver or maintainer status in the [`radius-project/docs`](https://github.com/radius-project/docs) repo.

### Branch guidance

The Radius docs handles branching differently than most code repositories. Instead of a `main` branch, every branch is labeled to match the major and minor version of a runtime release, plus an `edge` branch for in-flight work. For example, the `v1.0` branch contains the docs for the `v1.0` release. The `edge` branch contains the latest in-flight work.

### Managing content between branches

As a docs approver or maintainer, you need to perform routine **upmerges** to keep the pre-release `edge` branch aligned with updates to the current release branch. It is recommended to upmerge the current branch into the pre-release branch on a weekly basis.

For the following steps, treat `v1.0` as the current release and `edge` as the pre-release branch.

1. Open Visual Studio Code to the Radius docs repo.
1. From your local repo, switch to the latest branch (`v1.0`) and synchronize changes:

   ```bash
   git pull upstream v1.0
   git push origin v1.0
   ```

1. Switch to the upcoming branch (`edge`) and synchronize changes:

   ```bash
   git pull upstream edge
   git push origin edge
   ```

1. Create a new branch from `edge`:

   ```bash
   git checkout -b upmerge_MM-DD
   ```

1. Open a terminal and stage a merge from the latest release into the upmerge branch:

   ```bash
   git merge --no-ff --no-commit v1.0
   ```

1. Make sure included files look accurate. Inspect any merge conflicts in VS Code. Remove configuration changes or version information that does not need to be merged. Examples of files that usually shouldn't be merged:
   - docs/config.toml
   - docs/layouts/partials/hooks/body-end.html
   - docsy sub-module
1. Commit the staged changes and push to the upmerge branch (`upmerge_MM-DD`).
1. Open a PR from the upmerge branch to the upcoming release branch (`edge`).
1. Review the PR and double check that no unintended changes were pushed to the upmerge branch.

### References

- [Docsy authoring guide](https://www.docsy.dev/docs/adding-content/)
