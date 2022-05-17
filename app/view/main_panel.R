# app/view/main_panel.R

box::use(
  shiny[
    column, div, fluidRow, h3, mainPanel, moduleServer, NS
  ]
)

box::use(
  app/logic/calc_dr[calc_dr],
  app/view/exposures,
  app/view/price_summary
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  
  mainPanel(
    fluidRow(
      # column(5, fluidRow(h3("QTD"), price_summary$ui(ns("qtd")))),
      # column(1),
      # column(5, fluidRow(h3("YTD"), price_summary$ui(ns("ytd"))))
      column(6, div(class = "component-box", h3("QTD"), price_summary$ui(ns("qtd")))),
      column(6, div(class = "component-box", h3("YTD"), price_summary$ui(ns("ytd"))))
    ),
    fluidRow(
      column(6, div(class = "component-box", h3("TTM"), price_summary$ui(ns("ttm")))),
      column(6, div(class = "component-box", h3("Exposures"), exposures$ui(ns("current"))))
    )
  )
}

#' @export
server <- function(id, tkr, show_returns, exp_tbl) {
  moduleServer(id, function(input, output, session) {
    price_summary$server("qtd", tkr, calc_dr("qtd"), show_returns)
    price_summary$server("ytd", tkr, calc_dr("ytd"), show_returns)
    price_summary$server("ttm", tkr, calc_dr("ttm"), show_returns)
    exposures$server("current", tkr, exp_tbl)
  })
}
