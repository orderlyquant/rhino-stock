# app/view/characteristics

box::use(
  shiny[
    div, h4, moduleServer, NS, uiOutput, renderUI, req, tagList
  ]
)

box::use(
  app/logic/tbl_characteristics[tbl_characteristics]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    div(
      h4(class = "component-title", "Characteristics"),
      div(
        class = "component-box",
        uiOutput(ns("characteristics_table"))
      )
    )
  )
  
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
