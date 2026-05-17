# Package startup: register safety-net input handlers
#
# The @digdir/designsystemet-web bundle assigns :ds:N IDs to native HTML
# elements (e.g. <legend>, <datalist>) that have no id attribute. Shiny
# parses ":ds:1" as key = "" / type = "ds" via strsplit(name, ":"), then
# stops with "No handler registered for type :ds:1".
#
# The primary defence is data-shiny-no-bind-input on vulnerable elements
# (see ds_suggestion) plus the shiny:inputchanged guard in ds-bindings.js.
# This handler is a last-resort safety net for anything that slips through.

.onLoad <- function(libname, pkgname) {
  shiny::registerInputHandler("ds", function(value, session, name) {
    value
  }, force = TRUE)
}
