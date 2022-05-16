# app/logic/viz_price_chart

box::use(
  tidyquant[tq_get],
  ggplot2[...]
)

viz_price_chart <- function(tkr, from, to) {
  
  prices_tbl <- tq_get(tkr, from = from, to = to)
  
  prices_tbl |> 
    ggplot(
      aes(x = date, y = adjusted)
    ) +
    geom_line()
}
