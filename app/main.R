# app/main.R

box::use(
  shiny[
    actionButton,
    bootstrapPage,
    fluidRow,
    moduleServer, NS,
    observeEvent,
    sidebarLayout, sidebarPanel,
    tags, textInput, textOutput,
    titlePanel
  ],
)

box::use(
  app/view/sidebar,
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
  
    cur_ticker <- observeEvent(
      input$update,
      input$ticker
    )  
    
    main_panel$server("main_panel")
  
  })
}
