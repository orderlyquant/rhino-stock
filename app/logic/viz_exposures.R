# app/logic/viz_exposures

box::use(
  cowplot[theme_minimal_grid],
  dplyr[filter, select, mutate],
  forcats[fct_rev],
  ggplot2[...],
  oqthemes[scale_fill_oq]
)

viz_exposures <- function(tkr, tbl) {
  
  key_factors <- c(
    "Market Sensitivity", "Volatility",
    "Growth", "Profitability",
    "Earnings Yield", "Leverage"
  )
  
  key_exp_tbl <- tbl |> 
    filter(ticker %in% tkr) |> 
    filter(factor %in% key_factors) |> 
    filter(model == "Axioma US Fundamental Equity Risk Model MH 4") |> 
    select(ticker, factor, value) |> 
    mutate(
      ticker = factor(ticker, rev(tkr)),
      factor = factor(factor, key_factors)
    )
  
  max_abs_exp <- max(abs(key_exp_tbl$value))
  
  key_exp_tbl |> 
    ggplot(
      aes(x = value, y = ticker, fill = fct_rev(ticker))
    ) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~ factor, ncol = 2) +
    labs(x = NULL, y = NULL, fill = NULL) +
    xlim(c(-max_abs_exp, max_abs_exp)) +
    theme_minimal_grid() +
    theme(
      panel.spacing = unit(1.5, "lines"),
      legend.position = "bottom"
    ) +
    scale_fill_oq()
  
}