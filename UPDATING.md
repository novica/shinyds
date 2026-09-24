# Updating shinyds when Designsystemet changes

When a new Designsystemet version is released there are two paths:

- **Automated** — the GitHub Action `.github/workflows/update-components.yml` checks
  daily for a new upstream release. When it finds one it builds upstream, copies the
  assets, bumps the version strings (steps 1, 2 and 4 below) and opens a PR whose
  description contains the release notes of every version since the bundled one.
  You then do step 3 on the PR branch: read the notes, fix affected wrappers, push.
  It can also be run manually from the Actions tab (blank version = latest release).
- **Manual** — follow the steps below when you need more control or are working locally.

Current bundled version: **1.22.0**

---

## Manual update procedure

### 1. Build the upstream

```bash
cd ../designsystemet
git fetch --tags
git checkout v<new-version>
pnpm install --frozen-lockfile
pnpm build
```

### 2. Copy assets

```bash
# From the shinyds package root:

# Theme must be prepended — since 1.15.0 it lives in a separate file.
cat ../designsystemet/packages/css/dist/theme/designsystemet.css \
    ../designsystemet/packages/css/dist/src/index.css \
    > inst/www/css/designsystemet.min.css

cp ../designsystemet/packages/web/dist/umd/index.js \
   inst/www/js/designsystemet-web.umd.js
```

The JS bundle **must be the UMD build** (`dist/umd/index.js`), not the ESM build.
ESM bare specifiers don't work in browsers without a bundler.

### 3. Review the upstream changelog and update wrappers

Read the release notes for every version between the bundled one and the new
one (<https://github.com/digdir/designsystemet/releases>, or
`packages/css/CHANGELOG.md` and `packages/web/CHANGELOG.md` in the upstream
checkout). Look for:

- **Markup changes** to existing components (e.g. 1.21.0 changed AvatarStack
  from `<div>` to `<ul>`/`<li>`) — update the matching wrapper in `R/`.
- **New components or attributes** — add a hand-written wrapper, and a binding
  in `inst/www/js/ds-bindings.js` if it should be a Shiny input.
- **Deprecations** — stop emitting deprecated attributes or classes.

All wrappers are hand-written; there is no code generator.

### 4. Bump version strings

In **`R/ds-dependencies.R`**, update both `version = "..."` strings in the
`htmlDependency()` calls to match the new Designsystemet version.

In **`README.md`**, update the Designsystemet version badge, and update
"Current bundled version" at the top of this file.

Do not bump `Version:` in `DESCRIPTION` — release-please manages it.

### 5. Run checks

```r
devtools::document()
devtools::test()
NOT_CRAN=true devtools::test()   # includes shinytest2 browser tests
devtools::check()
```

### 6. Test the example apps

```r
shiny::runApp(system.file("examples/basic",    package = "shinyds"))
shiny::runApp(system.file("examples/faithful", package = "shinyds"))
shiny::runApp(system.file("examples/showcase", package = "shinyds"))
```

Verify components render correctly and Shiny inputs report values.

---

## File locations

| What | Where |
|---|---|
| CSS asset | `inst/www/css/designsystemet.min.css` |
| JS (UMD) asset | `inst/www/js/designsystemet-web.umd.js` |
| Shiny bindings | `inst/www/js/ds-bindings.js` |
| R wrappers | `R/` |

## Troubleshooting

**Components not styled** — check that `inst/www/css/designsystemet.min.css` was
copied and that `ds_dependencies()` path is correct.

**Web components not working** — ensure the UMD bundle was used, not the ESM build.
Check the browser console for JS errors. Verify `ds-shiny-input` class is on the
element.

**Phantom input errors (`:ds:*`)** — the JS guard in `ds-bindings.js` and the
`zzz.R` handler suppress these. If a new component triggers them, see the
"Behaviour-only modules" section in `CLAUDE.md`.

**Shiny inputs returning NULL** — verify the JS binding's `find()` selector
matches the element's classes, and that `getId()` is defined.
