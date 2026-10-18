# Typsite Template

A ready-to-build, bilingual template for [Typsite](https://github.com/Glomzzz/typsite) 0.1.8, including article examples, migration guides, and the build-pipeline diagram.

## Quick start

Install [Nix](https://nixos.org/download/) on Linux or macOS and enable `experimental-features = nix-command flakes` in your Nix configuration.

```sh
git clone https://github.com/Glomzzz/typsite-template your-site
cd your-site
nix develop
typsite compile --port 8080
```

Open <http://localhost:8080/> or <http://localhost:8080/en/>. To build without the preview server:

```sh
nix develop --command typsite compile
```

The generated site is in `publish/`. Nix supplies both Typsite and Typst; the Typsite revision is pinned to match the bundled resources. The demo does not require preview-package downloads, although external players and web fonts need browser network access.

Without Nix, install Typsite **0.1.8** and the latest stable Typst (tested with **0.15.1**), then run `typsite compile`. Do not run `typsite init` over this checkout: the template already contains the complete site.

## Customize your site

- Write articles in `root/`; start with `root/index.typ` and `root/en/index.typ`.
- Shared Typst helpers live in `root/lib/`.
- Edit `.typsite/options.toml` for metadata and site settings, and `.typsite/schemas/`, `.typsite/components/`, and `.typsite/assets/` for presentation.
- To enable RSS and sitemap output, set `[site].base_url` to your public site URL. The demo homepages already use `#rss(true)`; their direct embeds select feed entries. See [the migration guide](root/en/migrate-to-018.typ) for details.

Keep `publish/.typsite-outputs.json` when reusing an output directory: Typsite uses it to safely remove stale generated files. Normal builds reuse the cache; cleaning before every build is unnecessary. Check the compile command's exit status before deploying.

## GitHub Pages

In your repository's **Settings → Pages**, select **GitHub Actions** as the build source.

The workflow uses the same locked Nix environment as local builds. Pull requests and pushes build the checked-in site, and only successful builds on the repository's default branch deploy to Pages. You can also trigger the workflow manually. It does not reinitialize your sources or ignore compilation failures.
