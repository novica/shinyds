#' Heading Component
#'
#' Create a styled heading using Designsystemet styles.
#'
#' @param ... Heading content
#' @param level Heading level (1-6)
#' @param size Size variant ("2xs", "xs", "sm", "md", "lg", "xl", "2xl")
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_heading("Page Title", level = 1)
#' ds_heading("Section Title", level = 2, size = "lg")
ds_heading <- function(..., level = 2, size = NULL, class = NULL) {
  tag_name <- paste0("h", level)
  tag <- htmltools::tag(tag_name, list(
    class = .ds_classes("ds-heading", class),
    `data-size` = size,
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Paragraph Component
#'
#' Create a styled paragraph using Designsystemet styles.
#'
#' @param ... Paragraph content
#' @param size Size variant ("sm", "md", "lg")
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_paragraph("This is a paragraph of text.")
ds_paragraph <- function(..., size = NULL, class = NULL) {
  tag <- htmltools::tag("p", list(
    class = .ds_classes("ds-paragraph", class),
    `data-size` = size,
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Link Component
#'
#' Create a styled link using Designsystemet styles.
#'
#' @param ... Link content
#' @param href Link URL
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_link("Visit our website", href = "https://example.com")
ds_link <- function(..., href = "#", class = NULL) {
  tag <- htmltools::tag("a", list(
    class = .ds_classes("ds-link", class),
    href = href,
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Label Component
#'
#' Create a styled form label using Designsystemet styles.
#'
#' @param ... Label content
#' @param `for` The ID of the input this label is for
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_label("Email address", `for` = "email")
ds_label <- function(..., `for` = NULL, class = NULL) {
  tag <- htmltools::tag("label", list(
    class = .ds_classes("ds-label", class),
    `for` = `for`,
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}
