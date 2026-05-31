# shinyds

<img src="man/figures/shinyds.svg" alt="shinyds logo" width="180" align="right" style="margin-left:1.5rem;">

## Designsystemet components for Shiny

### Overview

`shinyds` lets you build Norwegian public sector Shiny applications that follow
[Designsystemet](https://designsystemet.no) — the shared design system for Norwegian
government services. Components are accessible, consistently styled, and work with
`input$id` just like native Shiny inputs.

### Installation

```r
remotes::install_github("novica/shinyds")
```

### Quick start

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

`use_designsystemet()` must appear in the app's UI — it loads the CSS and JavaScript and activates the design token color scheme.

### Demo

[Old Faithful](https://novica.shinyapps.io/faithful/)

### Getting help

`shinyds` specific questions can be posted to the GitHub [Discussions](https://github.com/novica/shinyds/discussions). 

The broader Designsystemet [community](https://designsystemet.no/en/intro/join-the-community/) has a Slack channel.

