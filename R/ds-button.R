#' Button Component
#'
#' Create a styled button using Designsystemet styles.
#'
#' @param label The button label
#' @param inputId Optional input ID for Shiny reactivity (creates action button)
#' @param variant Button variant ("primary", "secondary", "tertiary")
#' @param size Size variant ("sm", "md", "lg")
#' @param icon If TRUE, creates an icon-only button
#' @param loading If TRUE, shows loading state
#' @param disabled If TRUE, disables the button
#' @param fullwidth If TRUE, makes the button full width
#' @param type Button type ("button", "submit", "reset")
#' @param ... Additional attributes
#'
#' @return A Shiny tag object
#' @export
#'
#' @examples
#' ds_button("Click me", inputId = "btn")
#' ds_button("Submit", variant = "primary", type = "submit")
#' ds_button("Cancel", variant = "secondary")
ds_button <- function(label, inputId = NULL,
                      variant = c("primary", "secondary", "tertiary"),
                      size = NULL, icon = FALSE, loading = FALSE,
                      disabled = FALSE, fullwidth = FALSE,
                      type = "button", ...) {

  variant <- match.arg(variant)

  attribs <- list(
    id = inputId,
    class = .ds_classes("ds-button", if (!is.null(inputId)) "ds-action-button"),
    type = type,
    `data-variant` = if (variant != "primary") variant else NULL,
    `data-size` = size,
    `data-icon` = if (icon) "" else NULL,
    `data-fullwidth` = if (fullwidth) "" else NULL,
    `aria-busy` = if (loading) "true" else NULL,
    disabled = if (disabled) NA else NULL,
    ...
  )

  attribs <- Filter(Negate(is.null), attribs)

  tag <- htmltools::tag("button", c(attribs, list(label)))
  htmltools::attachDependencies(tag, ds_dependencies())
}
