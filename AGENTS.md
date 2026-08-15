# AGENTS.md

Guidance for AI coding agents working in this repository.

`shinyds` is an R package that wraps the [Designsystemet](https://designsystemet.no) component
library (the Norwegian government's shared design system) for use in Shiny apps. Components come
from two upstream sources, both bundled under `inst/www/`:

- **`@digdir/designsystemet-css`** — HTML elements styled with CSS classes (`ds-button`, `ds-alert`, etc.)
- **`@digdir/designsystemet-web`** — Custom HTML elements with built-in JS behaviour (`<ds-tabs>`, `<ds-pagination>`, `<ds-suggestion>`)

## Common commands

```r
# Load package during development
devtools::load_all()

# Regenerate documentation from roxygen2 comments
devtools::document()

# Run all tests
devtools::test()

# Run shinytest2 browser tests (skipped on CRAN by default)
NOT_CRAN=true devtools::test()
# or a single file:
NOT_CRAN=true testthat::test_file("tests/testthat/test-showcase-shinytest.R")

# Full R CMD check
devtools::check()
```

`devtools::check()` and the shinytest2 suite spawn a headless Chromium via `chromote` — that's the
established way to drive/screenshot this app (`shinytest2::AppDriver`), not `chromium-cli` or a
separate Playwright/Firefox setup. Reuse it for any ad hoc visual verification too.

## Architecture

### R layer (`R/`)

Each R file wraps one or more components using `htmltools::tag()`. Every component calls
`htmltools::attachDependencies(tag, ds_dependencies())` to inject CSS/JS. The helper
`.ds_classes(...)` in `aaa-utils.R` builds the `class` attribute, filtering NULLs. Never use
`paste()` directly for classes.

**Shiny inputs** require two things:
1. The element (or its container, for group-level inputs — see below) must have
   `class = "ds-shiny-input"` (not `shiny-bound-input` — that is reserved for Shiny internals and
   causes binding conflicts)
2. A matching binding registered in `inst/www/js/ds-bindings.js`

**Group-level inputs.** Some inputs aren't reactive as individual elements — a single
`<input type="radio">` or a single chip button means nothing on its own; only the group has a
value. For these, put `ds-shiny-input` on the *container*, not the individual elements, and bind
`find()` to the container selector (e.g. `fieldset.ds-shiny-input` for `ds_radio_group()`), reading
the value from whichever child is checked/selected. `ds_radio_group()` +`dsRadioGroupBinding` is
the reference implementation of this pattern — mirrors how Shiny's own `radioButtons()` reports one
value per group. Don't try to make each individual radio/chip independently reactive.

### JS bindings (`inst/www/js/ds-bindings.js`)

Each `Shiny.InputBinding` must define `find()`, `getId()`, `getValue()`, `subscribe()`, and
optionally `setValue()` / `receiveMessage()`. Bindings are registered with priority `true` (higher
than Shiny defaults). The `find()` selector must use `.ds-shiny-input`, never `.shiny-bound-input`.

For custom elements that manage their own internal state on user interaction (e.g. `<ds-tabs>`
handling a tab click), remember that `subscribe()`'s event handler and `setValue()` are two
*separate* code paths — a user click never calls `setValue()`. If some side effect (like firing a
Bootstrap-style event for Shiny's suspend-when-hidden mechanism) needs to happen on every value
change, it must be triggered from both places, not just `setValue()`.

### CSS/JS assets (`inst/www/`)

- `css/designsystemet.min.css` — combined theme + component CSS from the upstream build
- `js/designsystemet-web.umd.js` — UMD bundle of web components (must be UMD, not ESM — ESM bare specifiers don't work in browsers without a bundler)
- `js/ds-bindings.js` — hand-written Shiny bindings

`ds_dependencies()` loads all three. `use_designsystemet()` additionally sets
`data-color-scheme` on `<html>`, which is required to activate CSS custom property tokens.

### CSS class contract

Every component wrapper must apply its `ds-{name}` CSS class or styling won't work. The pattern
for web components (which have their own tag name) is:

```r
class = .ds_classes("ds-tabs", "ds-shiny-input", class)   # web component with binding
class = .ds_classes("ds-field", class)                      # web component, no binding
```

For CSS components (plain HTML tags):

```r
class = .ds_classes("ds-button", if (!is.null(inputId)) "ds-action-button")
```

### Behaviour-only modules and phantom Shiny inputs

The `@digdir/designsystemet-web` UMD bundle includes JavaScript modules that enhance **native HTML
elements** rather than defining custom elements. The affected components are:

- `clickdelegatefor`, `dialog`, `fieldset`, `popover`, `readonly`, `toggle-group`

When these elements appear in the DOM, the bundle's `useId` function assigns auto-generated IDs
(`:ds:1`, `:ds:2`, …) to child elements that have no `id` attribute (e.g. `<legend>` inside
`<fieldset>`). Shiny then picks up these generated IDs as phantom input names, producing errors
like:

```
No handler registered for type :ds:1
key must not be "" or NA
```

Two guards are in place to suppress this:

1. **`R/zzz.R`** — registers a pass-through R input handler for type `"ds"` so Shiny does not error on type lookup.
2. **`inst/www/js/ds-bindings.js`** (top of file) — a `shiny:inputchanged` listener that calls `preventDefault()` on any input whose name starts with `:`, blocking the phantom input before it reaches the server.

Do not remove either guard. If adding a new component backed by a behaviour-only module causes
this error, check whether the module assigns `:ds:*` IDs to any elements and whether those elements
are being picked up by an existing binding. This applies to `ds_radio_group()`'s `<fieldset>` too —
it's covered by the same generic guards.

**Reactivity for ⚠️ components.** Do not use `Shiny.InputBinding` for behaviour-only module
components — the binding fights with what the module is already doing to the element. Instead, add
reactivity via `Shiny.setInputValue()` called from a plain JavaScript event listener, and handle it
on the R side with `observeEvent()`:

```javascript
// in the app or a tags$script() block
document.querySelector('#my_toggle').addEventListener('click', function(e) {
  var pressed = e.target.closest('[aria-pressed]');
  if (pressed) Shiny.setInputValue('my_toggle', pressed.textContent.trim());
});
```

```r
observeEvent(input$my_toggle, {
  # react to the selected toggle value
})
```

This sidesteps the binding conflict entirely. The behaviour module handles accessibility;
`Shiny.setInputValue` handles reactivity.

### shinytest2 browser tests (`tests/testthat/test-showcase-shinytest.R`)

shinytest2 tests run the showcase app in a headless Chromium browser and are the only tests that
exercise the JS bindings end-to-end. They are skipped by default (shinytest2 calls
`skip_on_cran()` internally); set `NOT_CRAN=true` to run them locally.

**Clicking elements.** `AppDriver$click()` treats its first positional argument as a Shiny input
name and appends `.shiny-bound-input` to the selector — it cannot target custom elements
(`<ds-tab>`, `<ds-pagination>`) or compound CSS selectors. Use `app$run_js()` instead:

```r
app$run_js('document.querySelector("ds-tab[data-value=\'typography\']").click()')
app$wait_for_idle()
```

`app$set_inputs()` works fine for text, select, and checkbox inputs where you only need to test the
binding's read path.

### Generator (`tools/`)

`tools/generate.R` reads `tools/component-registry.yaml` and is meant to generate R wrappers
directly into `R/` and a combined JS bindings file. **R generation is currently unsafe — do not run
`tools/generate.R --clean` without auditing every "Would write" line first.** Several registry
entries (`chip`, `tag`, `spinner`, `skeleton`, `avatar`, `avatar_stack`, `skip_link`,
`validation_message`, `combobox`, `popover`, …) are already hand-implemented inside `R/ds-misc.R`,
but the generator computes a *different* target filename for each (e.g. `R/ds-chip.R`) and has no
way to know the function already exists elsewhere under a different file. Since that target file
doesn't exist, the generator's hand-written check (which only looks at whether its own target path
exists) doesn't skip it — it writes a second, conflicting definition, breaking
`devtools::load_all()`. The generated JS bindings file (`ds-bindings-generated.js`) is also **not**
loaded by `ds_dependencies()` for the same reason — it hasn't been audited against the hand-written
`ds-bindings.js` for selector/name conflicts. Treat `generate.R` as informational
(`--dry-run`, `--summary`) until this is fixed (see the TODO at the top of `tools/generate.R`).

```bash
Rscript tools/generate.R --summary   # preview component list
Rscript tools/generate.R --dry-run   # preview output without writing
Rscript tools/generate.R --clean     # do NOT run without auditing first — see above
```

### Updating to a new Designsystemet version

See `tools/UPDATE.md` for the full procedure. The short version:

1. Build the upstream: `cd ../designsystemet && pnpm install && pnpm build`
2. Copy assets to `inst/www/`
3. Run `Rscript tools/bootstrap-registry.R` to check for new web components (it won't catch new
   CSS-only components like `file-upload` — check the upstream release notes too)
4. Bump the version strings in `DESCRIPTION` and `R/ds-dependencies.R`, and the "Current bundled
   version" line in `tools/UPDATE.md`
5. Rebuild and re-run `devtools::test()` / `NOT_CRAN=true devtools::test()` / `devtools::check()`,
   and smoke-test all three example apps (`examples/basic`, `examples/faithful`, `examples/showcase`)
   with shinytest2 screenshots — visually confirm styling didn't regress, and check
   `app$get_logs()` for console errors.

## Release process (release-please)

This repo uses [release-please](https://github.com/googleapis/release-please) (config:
`release-please-config.json`, baseline: `.release-please-manifest.json`) with Conventional Commits.
`feat:` bumps minor, a breaking-change footer/`!` bumps major, and **any other Conventional Commit
type (`fix:`, `docs:`, `chore:`, `refactor:`, `ci:`, `test:`, `build:`) bumps patch** — there is no
type that skips versioning entirely. `changelog-sections` in the config only controls which types
are *shown* in the changelog (some are marked `hidden`); it does not affect whether they trigger a
release. Use Conventional Commits for both commit messages and branch names (e.g. `fix/...`,
`feat/...`, `docs/...`) so release-please can parse them correctly.
