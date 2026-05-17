#' Field Container
#'
#' A container for form field elements with proper spacing and layout.
#'
#' @param ... Child elements (label, input, validation message, etc.)
#' @param size Size variant ("sm", "md", "lg")
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_field(
#'   ds_label("Email", `for` = "email"),
#'   ds_input("email", type = "email", placeholder = "your@email.com"),
#'   ds_validation_message("Please enter a valid email")
#' )
ds_field <- function(..., size = NULL, class = NULL) {
  tag <- htmltools::tag("ds-field", list(
    `data-size` = size,
    class = .ds_classes("ds-field", class),
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}

#' Fieldset Component
#'
#' Group related form fields with a legend using Designsystemet styles.
#'
#' @param legend The legend text for the fieldset group
#' @param ... Child elements (fields, inputs, etc.)
#' @param class Additional CSS classes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_fieldset("Preferences",
#'   ds_checkbox("opt1", "Option 1"),
#'   ds_checkbox("opt2", "Option 2")
#' )
ds_fieldset <- function(legend, ..., class = NULL) {
  tag <- htmltools::tag("fieldset", list(
    class = .ds_classes("ds-fieldset", class),
    htmltools::tag("legend", list(legend)),
    ...
  ))
  htmltools::attachDependencies(tag, ds_dependencies())
}
