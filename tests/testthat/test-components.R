# Tests for Designsystemet component wrappers

has_class <- function(tag, cls) {
  cls %in% strsplit(tag$attribs$class %||% "", " ")[[1]]
}

# ── ds_action_button ─────────────────────────────────────────────────────────

test_that("ds_action_button produces same tag as ds_button with args swapped", {
  via_alias  <- ds_action_button("btn1", "Click me")
  via_button <- ds_button("Click me", inputId = "btn1")
  expect_equal(as.character(via_alias), as.character(via_button))
})

test_that("ds_action_button sets id and action class", {
  btn <- ds_action_button("my_btn", "Go")
  expect_equal(btn$attribs$id, "my_btn")
  expect_true(has_class(btn, "ds-action-button"))
})

test_that("ds_action_button forwards extra args to ds_button", {
  btn <- ds_action_button("btn2", "Save", variant = "secondary", size = "sm")
  expect_equal(btn$attribs$`data-variant`, "secondary")
  expect_equal(btn$attribs$`data-size`, "sm")
})

test_that("ds_action_button inputId first matches shiny::actionButton signature", {
  btn <- ds_action_button("pos_id", "Positional label")
  expect_equal(btn$attribs$id, "pos_id")
  expect_match(as.character(btn), "Positional label")
})

# ── ds_button ─────────────────────────────────────────────────────────────────

test_that("ds_button creates correct HTML structure", {
  btn <- ds_button("Click me", inputId = "test_btn")

  expect_s3_class(btn, "shiny.tag")
  expect_equal(btn$name, "button")

  expect_true("ds-button" %in% strsplit(btn$attribs$class, " ")[[1]])
  expect_equal(btn$attribs$id, "test_btn")
})

test_that("ds_button variant works", {
  btn_primary <- ds_button("Primary", inputId = "btn1", variant = "primary")
  btn_secondary <- ds_button("Secondary", inputId = "btn2", variant = "secondary")

  # Primary is default, so data-variant is NULL (not set)
  expect_null(btn_primary$attribs$`data-variant`)
  expect_equal(btn_secondary$attribs$`data-variant`, "secondary")
})

test_that("ds_input creates correct HTML structure", {
  input <- ds_input("test_input", value = "hello")

  expect_s3_class(input, "shiny.tag")
  expect_equal(input$name, "input")
  expect_true("ds-input" %in% strsplit(input$attribs$class, " ")[[1]])
  expect_equal(input$attribs$id, "test_input")
  expect_equal(input$attribs$value, "hello")
})

test_that("ds_input type validation works", {
  text_input <- ds_input("i1", type = "text")
  email_input <- ds_input("i2", type = "email")

  expect_equal(text_input$attribs$type, "text")
  expect_equal(email_input$attribs$type, "email")
})

test_that("ds_checkbox creates correct HTML structure", {
  cb <- ds_checkbox("test_cb", label = "Accept terms")

  # Should return a tagList with input and label

  expect_s3_class(cb, "shiny.tag.list")
})

test_that("ds_select creates correct HTML structure", {
  sel <- ds_select("test_sel", choices = c("A" = "a", "B" = "b"))

  expect_s3_class(sel, "shiny.tag")
  expect_equal(sel$name, "select")
  expect_true("ds-input" %in% strsplit(sel$attribs$class, " ")[[1]])
})

test_that("ds_card creates correct HTML structure", {
  card <- ds_card(ds_card_block("Content"))

  expect_s3_class(card, "shiny.tag")
  expect_equal(card$name, "div")
  expect_true("ds-card" %in% strsplit(card$attribs$class, " ")[[1]])
})

test_that("ds_alert creates correct HTML structure", {
  alert <- ds_alert("Warning message", variant = "warning")

  expect_s3_class(alert, "shiny.tag")
  expect_equal(alert$name, "div")
  expect_true("ds-alert" %in% strsplit(alert$attribs$class, " ")[[1]])
  expect_equal(alert$attribs$`data-variant`, "warning")
  expect_equal(alert$attribs$role, "alert")
})

test_that("ds_heading creates correct HTML tag based on level", {
  h1 <- ds_heading("Title", level = 1)
  h2 <- ds_heading("Subtitle", level = 2)
  h3 <- ds_heading("Section", level = 3)

  expect_equal(h1$name, "h1")
  expect_equal(h2$name, "h2")
  expect_equal(h3$name, "h3")
  expect_true("ds-heading" %in% strsplit(h1$attribs$class, " ")[[1]])
})

test_that("ds_paragraph creates correct HTML structure", {
  p <- ds_paragraph("Some text", size = "lg")

  expect_s3_class(p, "shiny.tag")
  expect_equal(p$name, "p")
  expect_true("ds-paragraph" %in% strsplit(p$attribs$class, " ")[[1]])
  expect_equal(p$attribs$`data-size`, "lg")
})

test_that("ds_link creates correct HTML structure", {
  link <- ds_link("Click here", href = "https://example.com")

  expect_s3_class(link, "shiny.tag")
  expect_equal(link$name, "a")
  expect_true("ds-link" %in% strsplit(link$attribs$class, " ")[[1]])
  expect_equal(link$attribs$href, "https://example.com")
})

test_that("ds_divider creates correct HTML structure", {
  hr <- ds_divider()

  expect_s3_class(hr, "shiny.tag")
  expect_equal(hr$name, "hr")
  expect_true("ds-divider" %in% strsplit(hr$attribs$class, " ")[[1]])
})

test_that("ds_badge creates correct HTML structure", {
  badge <- ds_badge("New", variant = "info")

  expect_s3_class(badge, "shiny.tag")
  expect_equal(badge$name, "span")
  expect_true("ds-badge" %in% strsplit(badge$attribs$class, " ")[[1]])
})

test_that("ds_spinner creates correct HTML structure", {
  spinner <- ds_spinner(title = "Loading...")

  expect_s3_class(spinner, "shiny.tag")
  expect_equal(spinner$name, "span")
  expect_true("ds-spinner" %in% strsplit(spinner$attribs$class, " ")[[1]])
  expect_equal(spinner$attribs$`aria-label`, "Loading...")
})

test_that("ds_table creates correct HTML structure", {
  tbl <- ds_table(
    ds_thead(ds_tr(ds_th("Col1"), ds_th("Col2"))),
    ds_tbody(ds_tr(ds_td("A"), ds_td("B")))
  )

  expect_s3_class(tbl, "shiny.tag")
  expect_equal(tbl$name, "table")
  expect_true("ds-table" %in% strsplit(tbl$attribs$class, " ")[[1]])
})
