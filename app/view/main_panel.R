# app/view/main_panel.R

box::use(
  shiny[
    column, fluidRow, h3, mainPanel, moduleServer, NS
  ]
)

box::use(
  app/view/price_summary,
  app/logic/calc_dr[calc_dr]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  mainPanel(
    fluidRow(
      column(5, fluidRow(h3("QTD"), price_summary$ui(ns("qtd")))),
      column(1),
      column(5, fluidRow(h3("YTD"), price_summary$ui(ns("ytd"))))
    ),
    fluidRow(
      column(5, fluidRow(h3("TTM"), price_summary$ui(ns("ttm"))))
    )
  )
}

#' @export
server <- function(id, tkr, show_returns) {
  moduleServer(id, function(input, output, session) {
    price_summary$server("qtd", tkr, calc_dr("qtd"), show_returns)
    price_summary$server("ytd", tkr, calc_dr("ytd"), show_returns)
    price_summary$server("ttm", tkr, calc_dr("ttm"), show_returns)
  })
}
