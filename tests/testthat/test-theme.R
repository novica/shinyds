# Tests for ds_theme

test_that("ds_theme with no args returns empty tagList", {
  result <- ds_theme()
  expect_s3_class(result, "shiny.tag.list")
  expect_length(result, 0)
})

test_that("ds_theme color injects data-color script", {
  result <- ds_theme(color = "brand1")
  html <- as.character(htmltools::tagList(result))
  expect_match(html, 'data-color.*brand1', perl = TRUE)
})

test_that("ds_theme font_size injects CSS custom property", {
  result <- ds_theme(font_size = "18px")
  html <- as.character(htmltools::tagList(result))
  expect_match(html, "--ds-font-size-base")
  expect_match(html, "18px")
})

test_that("ds_theme border_radius injects CSS custom property", {
  result <- ds_theme(border_radius = "0")
  html <- as.character(htmltools::tagList(result))
  expect_match(html, "--ds-border-radius-md")
  expect_match(html, ":root")
})

test_that("ds_theme button_padding injects CSS custom property", {
  result <- ds_theme(button_padding = "0.3rem 0.8rem")
  html <- as.character(htmltools::tagList(result))
  expect_match(html, "--dsc-button-padding")
  expect_match(html, "0.3rem 0.8rem")
})

test_that("ds_theme ... passes arbitrary token overrides", {
  result <- ds_theme(`--ds-border-width-focus` = "3px")
  html <- as.character(htmltools::tagList(result))
  expect_match(html, "--ds-border-width-focus")
  expect_match(html, "3px")
})

test_that("ds_theme multiple args produce both style and script tags", {
  result <- ds_theme(color = "brand2", border_radius = "2px")
  html <- as.character(htmltools::tagList(result))
  expect_match(html, "<style")
  expect_match(html, "<script")
  expect_match(html, "brand2")
  expect_match(html, "--ds-border-radius-md")
})
