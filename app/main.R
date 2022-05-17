# app/main.R

box::use(
  shiny[
    actionButton, bindEvent, bootstrapPage, checkboxInput,
    fluidRow, moduleServer, NS, reactive,
    sidebarLayout, sidebarPanel, textInput, textOutput,
    titlePanel
  ],
)

box::use(
  app/view/main_panel,
  app/logic/parse_ticker[parse_ticker]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  bootstrapPage(
    titlePanel("rhino - stock"),
    
    sidebarLayout(
      sidebarPanel = sidebarPanel(
        fluidRow(
          textInput(
            ns("ticker"),
            label = "Ticker",
            value = "AAPL"
          )
        ),
        fluidRow(
          actionButton(
            ns("update"),
            label = "Update"
          )
        ),
        fluidRow(
          checkboxInput(
            ns("returns"),
            label = "Show returns",
            value = FALSE
          )
        )
      ),
      main_panel$ui(ns("main_panel"))
    )
  )
}

#' @export
server <- function(id) {
  
  moduleServer(id, function(input, output, session) {
    
    cur_ticker <- reactive(parse_ticker({input$ticker})) |>
      bindEvent(input$update)
    show_returns <- reactive({input$returns})
    
    main_panel$server("main_panel", cur_ticker, show_returns)
  
  })
}
