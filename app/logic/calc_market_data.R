# app/logic/calc_market_data

box::use(
  dplyr[filter, group_by, lag, mutate, ungroup],
  tidyquant[tq_get]
)

get_prices_and_returns <- function(tkr, from, to) {

  tbl <- tq_get(tkr, from = from, to = to)

  tbl <- tbl |>
    group_by(symbol) |>
    mutate(adjusted_lag = lag(adjusted)) |>
    mutate(return = (adjusted / adjusted_lag) - 1) |>
    mutate(return = ifelse(is.na(return), 0, return)) |>
    mutate(return = cumprod(1 + return) - 1) |>
    ungroup()

  return(tbl)

}
