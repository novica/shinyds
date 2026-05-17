# Tests for Designsystemet web components (custom elements)

test_that("ds_tabs creates correct HTML structure", {
  tabs <- ds_tabs("test_tabs",
    ds_tablist(
      ds_tab("Tab 1", value = "t1", selected = TRUE),
      ds_tab("Tab 2", value = "t2")
    ),
    ds_tabpanel("Content 1", value = "t1"),
    ds_tabpanel("Content 2", value = "t2")
  )

  expect_s3_class(tabs, "shiny.tag")
  expect_equal(tabs$name, "ds-tabs")
  expect_equal(tabs$attribs$id, "test_tabs")
})

test_that("ds_tab creates correct attributes", {
  tab_selected <- ds_tab("Selected", value = "sel", selected = TRUE)
  tab_normal <- ds_tab("Normal", value = "norm")

  expect_equal(tab_selected$name, "ds-tab")
  expect_equal(tab_selected$attribs$`data-value`, "sel")
  expect_equal(tab_selected$attribs$`aria-selected`, "true")

  expect_equal(tab_normal$attribs$`data-value`, "norm")
})

test_that("ds_tabpanel creates correct attributes", {
  panel <- ds_tabpanel("Panel content", value = "p1")

  expect_equal(panel$name, "ds-tabpanel")
  expect_equal(panel$attribs$`data-value`, "p1")
})

test_that("ds_pagination creates correct HTML structure", {
  pagination <- ds_pagination("test_page", current = 1, total = 10)

  expect_s3_class(pagination, "shiny.tag")
  expect_equal(pagination$name, "ds-pagination")
  expect_equal(pagination$attribs$id, "test_page")
  expect_equal(pagination$attribs$`data-current`, 1)
  expect_equal(pagination$attribs$`data-total`, 10)
})

test_that("ds_suggestion creates correct HTML structure", {
  suggestion <- ds_suggestion("test_suggest",
    choices = c("Option A", "Option B", "Option C"),
    placeholder = "Type to search..."
  )

  expect_s3_class(suggestion, "shiny.tag")
  expect_equal(suggestion$name, "ds-suggestion")
  expect_equal(suggestion$attribs$id, "test_suggest")
})

test_that("ds_breadcrumbs creates correct HTML structure", {
  breadcrumbs <- ds_breadcrumbs(
    ds_link("Home", href = "/"),
    ds_link("Products", href = "/products"),
    ds_link("Item", href = "/products/item")
  )

  expect_s3_class(breadcrumbs, "shiny.tag")
  expect_equal(breadcrumbs$name, "ds-breadcrumbs")
})

test_that("ds_field creates correct HTML structure", {
  field <- ds_field(
    ds_label("Email", `for` = "email"),
    ds_input("email", type = "email")
  )

  expect_s3_class(field, "shiny.tag")
  expect_equal(field$name, "ds-field")
})
