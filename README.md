<!-- badges: start -->
  [![R-CMD-check](https://github.com/novica/shinyds/actions/workflows/R-CMD-check.yml/badge.svg)](https://github.com/novica/shinyds/actions/workflows/R-CMD-check.yml)
  [![Codecov test coverage](https://codecov.io/gh/novica/shinyds/graph/badge.svg)](https://app.codecov.io/gh/novica/shinyds)
  [![CRAN status](https://www.r-pkg.org/badges/version/shinyds)](https://CRAN.R-project.org/package=shinyds)
  [![CRAN downloads](https://cranlogs.r-pkg.org/badges/shinyds)](https://CRAN.R-project.org/package=shinyds)
  [![Designsystemet version](https://img.shields.io/badge/Designsystemet-1.14.0-blue)](https://github.com/digdir/designsystemet/releases)  
<!-- badges: end -->

# shinyds

<img src="man/figures/shinyds.svg" alt="shinyds logo" width="200">

R wrappers for the [Designsystemet](https://designsystemet.no) component library.

## Installation

```r
# install.packages("remotes")
remotes::install_github("novica/shinyds")
```

## Demo 

[Old Faitful](https://novica.shinyapps.io/faithful/)

## Usage

```r
library(shiny)
library(bslib)
library(shinyds)

ui <- bslib::page_fluid(
  use_designsystemet(),
  ds_heading("Hello", level = 1),
  ds_button("Click me", inputId = "btn")
)
```

## Example apps

Three example apps are included in the package:

| App | Description | Run |
|---|---|---|
| `basic` | Minimal contact form with a button, text inputs, checkbox, and reactive output | `shiny::runApp(system.file("examples/basic", package = "shinyds"))` |
| `faithful` | Old Faithful data explorer — tabs, sidebar controls, plots, and a summary table | `shiny::runApp(system.file("examples/faithful", package = "shinyds"))` |
| `showcase` | Full component reference with all `ds_*` functions, live reactive values in a sticky sidebar | `shiny::runApp(system.file("examples/showcase", package = "shinyds"))` |

## Component coverage

Designsystemet components come from two upstream packages:

- **`packages/css`** — HTML elements styled with CSS classes (e.g. `ds-button`, `ds-alert`)
- **`packages/web`** — Custom elements with built-in JS behaviour (e.g. `<ds-tabs>`, `<ds-pagination>`)

> **⚠️ behaviour-only modules.** Some components are enhanced by JavaScript modules that operate on native HTML elements (`<fieldset>`, `<dialog>`, `<details>`, etc.) rather than defining custom elements. These components work as-is for display. To add Shiny reactivity, use `Shiny.setInputValue()` from a plain JavaScript listener and handle it with `observeEvent()` — do not use a standard `InputBinding`, as it conflicts with what the module is already doing to the element.
>
> ```r
> # In your UI, attach a script that calls Shiny.setInputValue() on interaction:
> tags$script(HTML("
>   document.querySelector('#my_toggle').addEventListener('click', function(e) {
>     var pressed = e.target.closest('[aria-pressed]');
>     if (pressed) Shiny.setInputValue('my_toggle', pressed.textContent.trim());
>   });
> "))
> ```
>
> ```r
> # In your server:
> observeEvent(input$my_toggle, {
>   # react to the selected value
> })
> ```

### Web components (`packages/web`)

| Upstream element | R function(s) | Shiny input |
|---|---|---|
| `<ds-tabs>` / `<ds-tablist>` / `<ds-tab>` / `<ds-tabpanel>` | `ds_tabs()`, `ds_tablist()`, `ds_tab()`, `ds_tabpanel()` | selected tab value |
| `<ds-pagination>` | `ds_pagination()` | current page number |
| `<ds-suggestion>` | `ds_suggestion()` | selected value |
| `<ds-field>` | `ds_field()` | container only |
| `<ds-breadcrumbs>` | `ds_breadcrumbs()` | none |
| `<ds-error-summary>` | `ds_error_summary()` | none |

### CSS components (`packages/css`)

| Upstream CSS class | R function(s) | Shiny input |
|---|---|---|
| `ds-alert` | `ds_alert()` | none |
| `ds-avatar` / `ds-avatar-stack` | `ds_avatar()`, `ds_avatar_stack()` | none |
| `ds-badge` | `ds_badge()` | none |
| `ds-button` | `ds_button()` | action (click count) |
| `ds-card` | `ds_card()`, `ds_card_block()` | none |
| `ds-chip` | `ds_chip()` | none |
| `ds-combobox` | `ds_combobox()` | container only |
| `ds-details` | `ds_details()` | none ⚠️ |
| `ds-dialog` | `ds_dialog()` | none ⚠️ |
| `ds-divider` | `ds_divider()` | none |
| `ds-dropdown` | `ds_dropdown()` | none |
| `ds-fieldset` | `ds_fieldset()` | none ⚠️ |
| `ds-heading` | `ds_heading()` | none |
| `ds-input` | `ds_input()`, `ds_checkbox()`, `ds_radio()`, `ds_select()`, `ds_textarea()` | text / checkbox / select |
| `ds-label` | `ds_label()` | none |
| `ds-link` | `ds_link()` | none |
| `ds-list` | `ds_list()`, `ds_list_item()` | none |
| `ds-paragraph` | `ds_paragraph()` | none |
| `ds-popover` | `ds_popover()` | none ⚠️ |
| `ds-search` | `ds_search()` | text input |
| `ds-skeleton` | `ds_skeleton()` | none |
| `ds-skip-link` | `ds_skip_link()` | none |
| `ds-spinner` | `ds_spinner()` | none |
| `ds-table` | `ds_table()`, `ds_thead()`, `ds_tbody()`, `ds_tr()`, `ds_th()`, `ds_td()` | none |
| `ds-tag` | `ds_tag()` | none |
| `ds-toggle-group` | `ds_toggle_group()` | none ⚠️ |
| `ds-tooltip` | `ds_tooltip()` | none |
| `ds-validation-message` | `ds_validation_message()` | none |
