# app/main.R

box::use(
  shiny[
    actionButton,
    bindEvent,
    bootstrapPage,
    fluidRow,
    moduleServer, NS,
    reactive,
    sidebarLayout, sidebarPanel,
    tags, textInput, textOutput,
    titlePanel
  ],
)

box::use(
  app/view/main_panel
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
        )
      ),
      main_panel$ui(ns("main_panel"))
    )
  )
}

#' @export
server <- function(id) {
  
  moduleServer(id, function(input, output, session) {
    
    cur_ticker <- reactive({input$ticker}) |> bindEvent(input$update)
    
    main_panel$server("main_panel", cur_ticker)
  
  })
}
