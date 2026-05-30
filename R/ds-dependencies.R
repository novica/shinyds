#' Designsystemet Dependencies
#'
#' Returns the HTML dependencies required for Designsystemet components.
#'
#' @return A list of htmltools htmlDependency objects
#' @export
#'
#' @examples
#' ds_dependencies()
ds_dependencies <- function() {
  list(
    # CSS from @digdir/designsystemet-css
    htmltools::htmlDependency(
      name = "designsystemet-css",
      version = "1.15.0",
      src = system.file("www/css", package = "shinyds"),
      stylesheet = "designsystemet.min.css"
    ),

    # Web components from @digdir/designsystemet-web (UMD bundle)
    htmltools::htmlDependency(
      name = "designsystemet-web",
      version = "1.15.0",
      src = system.file("www/js", package = "shinyds"),
      script = "designsystemet-web.umd.js"
    ),

    # Shiny input bindings
    htmltools::htmlDependency(
      name = "designsystemet-bindings",
      version = utils::packageVersion("shinyds"),
      src = system.file("www/js", package = "shinyds"),
      script = "ds-bindings.js"
    )
  )
}

#' Use Designsystemet in a Shiny App
#'
#' Include this function in your UI to load all necessary Designsystemet
#' CSS and JavaScript dependencies.
#'
#' @param color_scheme Color scheme to apply to the page. One of `"light"` or
#'   `"dark"`. Sets the `data-color-scheme` attribute on `<html>`, which
#'   activates Designsystemet's CSS custom property tokens.
#'
#' @return A tagList containing the dependencies
#' @export
#'
#' @examples
#' ui <- bslib::page_fluid(
#'   use_designsystemet(),
#'   ds_button("Click me", inputId = "btn")
#' )
use_designsystemet <- function(color_scheme = "light") {
  htmltools::tagList(
    ds_dependencies(),
    htmltools::tags$script(htmltools::HTML(sprintf(
      'document.documentElement.setAttribute("data-color-scheme", "%s");',
      color_scheme
    )))
  )
}
