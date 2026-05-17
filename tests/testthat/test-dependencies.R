# Tests for dependency management

test_that("ds_dependencies returns list of htmlDependency objects", {
  deps <- ds_dependencies()

  expect_type(deps, "list")
  expect_true(length(deps) >= 2)

  for (dep in deps) {
    expect_s3_class(dep, "html_dependency")
  }
})

test_that("use_designsystemet returns tagList with dependencies", {
  result <- use_designsystemet()

  expect_s3_class(result, "shiny.tag.list")
})

test_that("components have dependencies attached", {
  btn <- ds_button("btn", "Test")
  deps <- htmltools::htmlDependencies(btn)

  expect_true(length(deps) > 0)
})
