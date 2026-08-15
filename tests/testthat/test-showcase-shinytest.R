# Shinytest2 integration tests for the showcase app.
#
# These tests run the showcase in a headless browser (Chromium via shinytest2)
# and verify that:
#   - the app starts without server-side errors (catches :ds:* phantom-input bug)
#   - Shiny input bindings actually fire and report values to the server
#   - the toggle-group Shiny.setInputValue() approach works
#
# Run:   shinytest2::test_app(system.file("examples/showcase", package="shinyds"))
# Skip:  automatically skipped when shinytest2 or Chromium is unavailable.

skip_if_not_installed("shinytest2")
skip_if_not_installed("chromote")

# Skip when no browser binary is found (CI without Chromium, etc.)
tryCatch(
  chromote::find_chrome(),
  error = function(e) {
    testthat::skip("Chromium not found — run shinytest2::install_chromium()")
  }
)

app_dir <- system.file("examples/showcase", package = "shinyds")
if (nchar(app_dir) == 0) testthat::skip("Package not installed")

# ── Helpers ────────────────────────────────────────────────────────────────

new_app <- function(name) {
  shinytest2::AppDriver$new(
    app_dir,
    name            = name,
    load_timeout    = 20000,
    timeout         = 10000,
    options         = list(shiny.testmode = TRUE)
  )
}

# ── 1. Smoke test ─────────────────────────────────────────────────────────

test_that("showcase loads without server-side errors", {
  app <- new_app("smoke")
  withr::defer(app$stop())
  app$wait_for_idle()

  logs <- app$get_logs()

  # Phantom-input errors (the :ds:* bug) produce either of these messages
  phantom <- grepl(
    "key must not be|No handler registered|:ds:",
    logs$message,
    ignore.case = TRUE
  )
  expect_false(
    any(phantom),
    label = paste(
      "Unexpected phantom-input errors:\n",
      paste(logs$message[phantom], collapse = "\n")
    )
  )
})

# ── 2. Initial input values ────────────────────────────────────────────────

test_that("select has the pre-selected initial value", {
  app <- new_app("init-select")
  withr::defer(app$stop())
  app$wait_for_idle()

  expect_equal(app$get_value(input = "sel_country"), "no")
})

test_that("checked checkbox reports TRUE on load", {
  app <- new_app("init-checkbox")
  withr::defer(app$stop())
  app$wait_for_idle()

  # chk2 has value = TRUE in the showcase
  expect_true(app$get_value(input = "chk2"))
})

test_that("pagination reports the initial current-page value", {
  app <- new_app("init-pagination")
  withr::defer(app$stop())
  app$wait_for_idle()

  # ds_pagination("page_nav", current = 3, ...) in the showcase
  expect_equal(app$get_value(input = "page_nav"), 3L)
})

test_that("toggle group reports its pre-selected value on load", {
  app <- new_app("init-toggle")
  withr::defer(app$stop())
  app$wait_for_idle()

  # First button has aria-pressed="true" and value="list"
  expect_equal(app$get_value(input = "view_mode"), "list")
})

test_that("chip group reports its pre-selected value on load", {
  # Regression test: the shiny:sessioninitialized listener used
  # document.addEventListener(), a native DOM listener, but Shiny fires that
  # event via jQuery's $(document).trigger() — which native listeners never
  # receive. The initial selected chip ("React") was silently never
  # reported, even though clicking chips afterward worked fine (a real
  # native "click" event reaches both listener styles).
  app <- new_app("init-chip-group")
  withr::defer(app$stop())
  app$wait_for_idle()

  expect_equal(app$get_value(input = "showcase_chips"), "react")
})

# ── 3. Tab binding ─────────────────────────────────────────────────────────
#
# app$click() treats its first argument as a Shiny input name and appends
# .shiny-bound-input, which doesn't match ds-tab elements.  Use run_js()
# to dispatch the click directly through the browser instead.

js_click <- function(app, selector) {
  app$run_js(sprintf('document.querySelector(%s).click()', jsonlite::toJSON(selector)))
}

test_that("clicking a tab updates input$main_tabs", {
  app <- new_app("tab-switch")
  withr::defer(app$stop())
  app$wait_for_idle()

  js_click(app, "ds-tab[data-value='typography']")
  app$wait_for_idle()

  expect_equal(app$get_value(input = "main_tabs"), "typography")
})

test_that("tabs can be switched back after an initial switch", {
  app <- new_app("tab-roundtrip")
  withr::defer(app$stop())
  app$wait_for_idle()

  js_click(app, "ds-tab[data-value='layout']")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "main_tabs"), "layout")

  js_click(app, "ds-tab[data-value='inputs']")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "main_tabs"), "inputs")
})

test_that("an output inside a non-default tab renders after switching to it", {
  # Regression test for the suspend-when-hidden bug: dsTabsBinding only
  # toggled the `hidden` attribute on panels and never fired the
  # `shown.bs.tab` event Shiny's own suspend-when-hidden mechanism listens
  # for, so outputs inside any tab other than the initially active one
  # (chip_out lives in the "feedback" tab, not the default "inputs" tab)
  # stayed suspended server-side forever, even after switching to their tab.
  # Interacting with a chip after switching proves the output is both
  # rendering and reactive, not just frozen at a stale/blank value.
  app <- new_app("tab-output-render")
  withr::defer(app$stop())
  app$wait_for_idle()

  js_click(app, "ds-tab[data-value='feedback']")
  app$wait_for_idle()

  app$run_js('document.querySelector("#showcase_chips .ds-chip[value=\'vue\']").click()')
  app$wait_for_idle()

  chip_out <- app$get_value(output = "chip_out")
  expect_match(chip_out, "vue")
})

# ── 4. Action button binding ───────────────────────────────────────────────

test_that("action button starts at 0 and increments on each click", {
  app <- new_app("btn-click")
  withr::defer(app$stop())
  app$wait_for_idle()

  expect_equal(app$get_value(input = "btn_primary"), 0)

  js_click(app, "#btn_primary")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "btn_primary"), 1)

  js_click(app, "#btn_primary")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "btn_primary"), 2)
})

# ── 5. Text input binding ─────────────────────────────────────────────────

test_that("typing in a text input updates its Shiny value", {
  app <- new_app("text-input")
  withr::defer(app$stop())
  app$wait_for_idle()

  app$set_inputs(inp_text = "hello")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "inp_text"), "hello")
})

test_that("clearing a text input sets value to empty string", {
  app <- new_app("text-clear")
  withr::defer(app$stop())
  app$wait_for_idle()

  app$set_inputs(inp_text = "temporary")
  app$wait_for_idle()
  app$set_inputs(inp_text = "")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "inp_text"), "")
})

# ── 6. Checkbox binding ────────────────────────────────────────────────────

test_that("clicking an unchecked checkbox makes it TRUE", {
  app <- new_app("chk-click")
  withr::defer(app$stop())
  app$wait_for_idle()

  expect_false(app$get_value(input = "chk1"))
  js_click(app, "#chk1")
  app$wait_for_idle()
  expect_true(app$get_value(input = "chk1"))
})

# ── 7. Select binding ─────────────────────────────────────────────────────

test_that("changing a select updates its Shiny value", {
  app <- new_app("select-change")
  withr::defer(app$stop())
  app$wait_for_idle()

  app$set_inputs(sel_country = "se")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "sel_country"), "se")
})

# ── 8. Toggle group (Shiny.setInputValue path) ─────────────────────────────

test_that("clicking a toggle button updates view_mode via setInputValue", {
  app <- new_app("toggle-click")
  withr::defer(app$stop())
  app$wait_for_idle()

  js_click(app, "#view_mode button[value='grid']")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "view_mode"), "grid")
})

test_that("toggle group selection can be changed multiple times", {
  app <- new_app("toggle-multi")
  withr::defer(app$stop())
  app$wait_for_idle()

  js_click(app, "#view_mode button[value='map']")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "view_mode"), "map")

  js_click(app, "#view_mode button[value='list']")
  app$wait_for_idle()
  expect_equal(app$get_value(input = "view_mode"), "list")
})

# ── 9. Reactive output reflects all inputs ─────────────────────────────────

test_that("reactive output updates when a button is clicked", {
  app <- new_app("output-update")
  withr::defer(app$stop())
  app$wait_for_idle()

  js_click(app, "#btn_secondary")
  app$wait_for_idle()

  # Verify the button value via input (direct) and that the output rendered it
  expect_equal(app$get_value(input = "btn_secondary"), 1L)
  output_text <- app$get_value(output = "values")
  expect_match(output_text, "secondary")
  expect_match(output_text, "\\[1\\] 1")
})

# ── 10. Radio group binding ─────────────────────────────────────────────────

test_that("radio group reports its pre-selected value on load", {
  app <- new_app("init-radio-group")
  withr::defer(app$stop())
  app$wait_for_idle()

  # ds_radio_group("radio_grp", ..., selected = "a") in the showcase
  expect_equal(app$get_value(input = "radio_grp"), "a")
})

test_that("clicking a different radio updates the group's Shiny value", {
  app <- new_app("radio-group-click")
  withr::defer(app$stop())
  app$wait_for_idle()

  js_click(app, "#radio_grp_b")
  app$wait_for_idle()

  expect_equal(app$get_value(input = "radio_grp"), "b")

  output_text <- app$get_value(output = "values")
  expect_match(output_text, "radio_grp")
  expect_match(output_text, '"b"', fixed = TRUE)
})
