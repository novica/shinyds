# Tests for the showcase app and components it exercises.
# Existing unit tests (test-components.R, test-web-components.R) cover the
# basic HTML structure for each component. This file focuses on:
#   1. Showcase smoke test (sources without error, ui/server/helpers exist)
#   2. New badge/tag API (count, color, badge_position)
#   3. Components and parameter combinations first used in the showcase

# ── Helpers ────────────────────────────────────────────────────────────────

has_class <- function(tag, cls) {
  classes <- strsplit(tag$attribs$class %||% "", " ")[[1]]
  cls %in% classes
}

# Source the showcase once at file load so all tests share the same env.
showcase_env <- local({
  e <- new.env(parent = globalenv())
  suppressPackageStartupMessages(
    source(
      system.file("examples/showcase/app.R", package = "shinyds"),
      local = e
    )
  )
  e
})

# ── Smoke test ──────────────────────────────────────────────────────────────

test_that("showcase sources without error and exports required objects", {
  expect_true(is.function(showcase_env$server))
  expect_true(inherits(showcase_env$ui, c("shiny.tag", "shiny.tag.list")))
  expect_true(is.function(showcase_env$fn_tag))
  expect_true(is.function(showcase_env$demo_card))
  expect_true(is.function(showcase_env$flex_row))
})

# ── Showcase helpers ────────────────────────────────────────────────────────

test_that("fn_tag renders a span with monospace inline style", {
  tag <- showcase_env$fn_tag("ds_button()")
  expect_s3_class(tag, "shiny.tag")
  expect_equal(tag$name, "span")
  expect_match(tag$attribs$style, "monospace")
  expect_match(as.character(tag$children[[1]]), "ds_button()", fixed = TRUE)
})

test_that("demo_card wraps content in a ds_card", {
  card <- showcase_env$demo_card("Button", list("ds_button()"),
    shiny::tags$p("demo content")
  )
  expect_s3_class(card, "shiny.tag")
  expect_equal(card$name, "div")
  expect_true(has_class(card, "ds-card"))
})

test_that("demo_card with warn=TRUE still renders", {
  card <- showcase_env$demo_card("Toggle", list("ds_toggle_group()"),
    warn = TRUE,
    shiny::tags$p("content")
  )
  expect_s3_class(card, "shiny.tag")
})

test_that("flex_row creates a div with flex display style", {
  row <- showcase_env$flex_row(shiny::tags$span("A"), shiny::tags$span("B"))
  expect_s3_class(row, "shiny.tag")
  expect_equal(row$name, "div")
  expect_match(row$attribs$style, "flex")
})

# ── ds_badge new API ────────────────────────────────────────────────────────

test_that("ds_badge renders count as data-count attribute", {
  badge <- ds_badge(count = 4, color = "danger")
  expect_equal(badge$attribs$`data-count`, "4")
  expect_equal(badge$attribs$`data-color`, "danger")
  expect_true(has_class(badge, "ds-badge"))
})

test_that("ds_badge count=0 renders as '0' not NULL", {
  badge <- ds_badge(count = 0, color = "success")
  expect_equal(badge$attribs$`data-count`, "0")
})

test_that("ds_badge without count omits data-count", {
  badge <- ds_badge(color = "info")
  expect_null(badge$attribs$`data-count`)
})

# ── ds_badge_position ───────────────────────────────────────────────────────

test_that("ds_badge_position creates a span with placement", {
  pos <- ds_badge_position(
    shiny::tags$span("target"),
    ds_badge(count = 3, color = "warning"),
    placement = "top-right"
  )
  expect_s3_class(pos, "shiny.tag")
  expect_equal(pos$name, "span")
  expect_true(has_class(pos, "ds-badge--position"))
  expect_equal(pos$attribs$`data-placement`, "top-right")
})

test_that("ds_badge_position defaults to top-right placement", {
  pos <- ds_badge_position(
    shiny::tags$span("x"),
    ds_badge(count = 1)
  )
  expect_equal(pos$attribs$`data-placement`, "top-right")
})

# ── ds_tag new API ──────────────────────────────────────────────────────────

test_that("ds_tag renders color as data-color attribute", {
  tag <- ds_tag("Active", color = "success")
  expect_equal(tag$attribs$`data-color`, "success")
  expect_true(has_class(tag, "ds-tag"))
})

test_that("ds_tag outline variant sets data-variant", {
  tag <- ds_tag("Beta", color = "info", variant = "outline")
  expect_equal(tag$attribs$`data-color`, "info")
  expect_equal(tag$attribs$`data-variant`, "outline")
})

test_that("ds_tag without color has no data-color attribute", {
  tag <- ds_tag("Default")
  expect_null(tag$attribs$`data-color`)
})

# ── ds_chip ─────────────────────────────────────────────────────────────────

test_that("ds_chip selected=TRUE sets aria-pressed=true", {
  chip <- ds_chip("React", selected = TRUE)
  expect_equal(chip$attribs$`aria-pressed`, "true")
})

test_that("ds_chip selected=FALSE sets aria-pressed=false", {
  chip <- ds_chip("Vue")
  expect_equal(chip$attribs$`aria-pressed`, "false")
})

test_that("ds_chip accepts extra attributes via ...", {
  chip <- ds_chip("Disabled", disabled = NA)
  expect_false(is.null(chip$attribs$disabled))
})

# ── ds_fieldset ─────────────────────────────────────────────────────────────

test_that("ds_fieldset creates a fieldset with legend", {
  fs <- ds_fieldset(
    legend = "Preferences",
    ds_checkbox("a", label = "Option A"),
    ds_checkbox("b", label = "Option B")
  )
  expect_s3_class(fs, "shiny.tag")
  expect_equal(fs$name, "fieldset")
  expect_true(has_class(fs, "ds-fieldset"))
  html <- as.character(fs)
  expect_match(html, "<legend>")
  expect_match(html, "Preferences")
})

# ── ds_search ───────────────────────────────────────────────────────────────

test_that("ds_search creates a ds-search div wrapping an input", {
  s <- ds_search("inp_search", placeholder = "Search…")
  expect_s3_class(s, "shiny.tag")
  expect_equal(s$name, "div")
  expect_true(has_class(s, "ds-search"))
  html <- as.character(s)
  expect_match(html, 'id="inp_search"')
  expect_match(html, "<input")
})

# ── ds_toggle_group ─────────────────────────────────────────────────────────

test_that("ds_toggle_group returns a tagList containing div and script", {
  tg <- ds_toggle_group(
    "view_mode",
    shiny::tags$button(class = "ds-button", `aria-pressed` = "true",
                       value = "list", "List"),
    shiny::tags$button(class = "ds-button", `aria-pressed` = "false",
                       value = "grid", "Grid")
  )
  expect_s3_class(tg, "shiny.tag.list")
  html <- as.character(htmltools::tagList(tg))
  expect_match(html, "ds-toggle-group")
  expect_match(html, "Shiny.setInputValue")
  expect_match(html, "view_mode")
})

# ── ds_combobox ─────────────────────────────────────────────────────────────

test_that("ds_combobox creates a div with ds-combobox class", {
  cb <- ds_combobox("demo_combo",
    shiny::tags$div(class = "ds-combobox__input__wrapper")
  )
  expect_s3_class(cb, "shiny.tag")
  expect_equal(cb$name, "div")
  expect_true(has_class(cb, "ds-combobox"))
  expect_equal(cb$attribs$id, "demo_combo")
})

# ── ds_details ──────────────────────────────────────────────────────────────

test_that("ds_details creates a details/summary element", {
  d <- ds_details(summary = "Click to expand", ds_paragraph("Content"))
  expect_s3_class(d, "shiny.tag")
  expect_equal(d$name, "details")
  expect_true(has_class(d, "ds-details"))
  html <- as.character(d)
  expect_match(html, "<summary>")
})

test_that("ds_details open=TRUE adds open attribute", {
  d_open   <- ds_details(summary = "Open",   open = TRUE,  ds_paragraph("x"))
  d_closed <- ds_details(summary = "Closed", open = FALSE, ds_paragraph("x"))
  expect_false(is.null(d_open$attribs$open))
  expect_null(d_closed$attribs$open)
})

# ── ds_dialog ───────────────────────────────────────────────────────────────

test_that("ds_dialog creates a dialog element", {
  dlg <- ds_dialog(id = "demo-dialog", ds_paragraph("Content"))
  expect_s3_class(dlg, "shiny.tag")
  expect_equal(dlg$name, "dialog")
  expect_true(has_class(dlg, "ds-dialog"))
  expect_equal(dlg$attribs$id, "demo-dialog")
})

# ── ds_dropdown ─────────────────────────────────────────────────────────────

test_that("ds_dropdown creates a div with trigger and content", {
  dd <- ds_dropdown(
    trigger = ds_button("Open Menu"),
    shiny::tags$p("item 1"),
    shiny::tags$p("item 2")
  )
  expect_s3_class(dd, "shiny.tag")
  expect_equal(dd$name, "div")
  expect_true(has_class(dd, "ds-dropdown"))
  html <- as.character(dd)
  expect_match(html, "ds-dropdown__content")
})

# ── ds_popover ──────────────────────────────────────────────────────────────

test_that("ds_popover creates a div with ds-popover class", {
  pop <- ds_popover(id = "pop1", popover = NA, ds_paragraph("Content"))
  expect_s3_class(pop, "shiny.tag")
  expect_equal(pop$name, "div")
  expect_true(has_class(pop, "ds-popover"))
  expect_equal(pop$attribs$id, "pop1")
})

test_that("ds_popover tinted variant sets data-variant", {
  pop <- ds_popover(variant = "tinted", ds_paragraph("x"))
  expect_equal(pop$attribs$`data-variant`, "tinted")
})

# ── ds_skeleton ─────────────────────────────────────────────────────────────

test_that("ds_skeleton with width/height injects inline style", {
  s <- ds_skeleton(variant = "circle", width = "48px", height = "48px")
  expect_true(has_class(s, "ds-skeleton"))
  expect_match(s$attribs$style, "width:48px")
  expect_match(s$attribs$style, "height:48px")
})

test_that("ds_skeleton without dimensions has no style attribute", {
  s <- ds_skeleton(variant = "text")
  expect_null(s$attribs$style)
})

# ── ds_avatar / ds_avatar_stack ─────────────────────────────────────────────

test_that("ds_avatar creates a span with size", {
  av <- ds_avatar("AB", size = "lg")
  expect_s3_class(av, "shiny.tag")
  expect_equal(av$name, "span")
  expect_true(has_class(av, "ds-avatar"))
  expect_equal(av$attribs$`data-size`, "lg")
})

test_that("ds_avatar_stack creates a div wrapping avatars", {
  stack <- ds_avatar_stack(
    ds_avatar("AB"),
    ds_avatar("CD"),
    ds_avatar("EF")
  )
  expect_s3_class(stack, "shiny.tag")
  expect_equal(stack$name, "div")
  expect_true(has_class(stack, "ds-avatar-stack"))
})

# ── ds_validation_message ───────────────────────────────────────────────────

test_that("ds_validation_message error variant is set", {
  vm <- ds_validation_message("Required", variant = "error")
  expect_true(has_class(vm, "ds-validation-message"))
  expect_equal(vm$attribs$`data-variant`, "error")
})

test_that("ds_validation_message warning variant is set", {
  vm <- ds_validation_message("Unusual value", variant = "warning")
  expect_equal(vm$attribs$`data-variant`, "warning")
})

# ── ds_error_summary ────────────────────────────────────────────────────────

test_that("ds_error_summary uses custom heading", {
  es <- ds_error_summary(
    heading = "Fix the following errors:",
    shiny::tags$li("Name is required")
  )
  expect_equal(es$name, "ds-error-summary")
  html <- as.character(es)
  expect_match(html, "Fix the following errors:")
})

test_that("ds_error_summary uses default heading when none provided", {
  es <- ds_error_summary(shiny::tags$li("An error"))
  html <- as.character(es)
  expect_match(html, "Feil i skjema")
})

# ── ds_skip_link ────────────────────────────────────────────────────────────

test_that("ds_skip_link creates an anchor pointing to #main by default", {
  sl <- ds_skip_link("Skip to content")
  expect_equal(sl$name, "a")
  expect_true(has_class(sl, "ds-skip-link"))
  expect_equal(sl$attribs$href, "#main")
})

test_that("ds_skip_link accepts custom href", {
  sl <- ds_skip_link("Skip", href = "#content")
  expect_equal(sl$attribs$href, "#content")
})

# ── ds_tooltip ──────────────────────────────────────────────────────────────

test_that("ds_tooltip adds data-tooltip and placement to the wrapped element", {
  btn <- ds_button("Hover me")
  tt  <- ds_tooltip(btn, text = "Helpful hint", placement = "right")
  expect_equal(tt$attribs$`data-tooltip`, "Helpful hint")
  expect_equal(tt$attribs$`data-tooltip-placement`, "right")
})

test_that("ds_tooltip defaults to top placement", {
  btn <- ds_button("Hover")
  tt  <- ds_tooltip(btn, text = "tip")
  expect_equal(tt$attribs$`data-tooltip-placement`, "top")
})
