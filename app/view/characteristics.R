# app/view/characteristics

box::use(
  shiny[
    moduleServer, NS, uiOutput, renderUI, req
  ]
)

box::use(
  app/logic/tbl_characteristics[tbl_characteristics]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  uiOutput(ns("characteristics_table"))
  
}

#' @export
server <- function(id, tkr, tbl) {
  moduleServer(id, function(input, output, session) {
    
    output$characteristics_table <- renderUI({
      req(length(tkr() > 0))
      tbl_characteristics(tkr(), tbl)
    })
  })
}
