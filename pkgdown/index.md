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
  ds_heading("Hello Designsystemet!", level = 1),
  ds_field(
    ds_label("Your name", `for` = "name"),
    ds_input("name", placeholder = "Enter your name")
  ),
  ds_button("Greet", inputId = "btn", variant = "primary"),
  uiOutput("greeting")
)

server <- function(input, output, session) {
  output$greeting <- renderUI({
    req(input$btn, input$name)
    ds_alert(paste("Hello,", input$name), variant = "success")
  })
}

shinyApp(ui, server)
```

### Demo

[Old Faithful](https://novica.shinyapps.io/faithful/)

### Getting help

`shinyds` specific questions can be posted to the GitHub [Discussions](https://github.com/novica/shinyds/discussions). 

The broader Designsystemet [community](https://designsystemet.no/en/intro/join-the-community/) has a Slack channel.

