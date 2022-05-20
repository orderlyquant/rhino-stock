# app/logic/viz_exposures

box::use(
  cowplot[theme_minimal_grid],
  dplyr[filter, select, mutate],
  forcats[fct_rev],
  ggplot2[...],
  oqthemes[scale_fill_oq],
  stringr[str_replace],
  tidyr[pivot_wider]
)

#' @export
viz_exposures <- function(tkr, exp_tbl, risk_tbl) {

  key_factors <- c(
    "Market Sensitivity", "Volatility",
    "Growth", "Profitability",
    "Earnings Yield", "Leverage"
  )

  # Fix for BRK-B and BRK-A, others?
  tkr <- str_replace(tkr, "-", ".")

  key_exp_tbl <- exp_tbl |>
    filter(ticker %in% tkr) |>
    filter(factor %in% key_factors) |>
    filter(model == "Axioma US Fundamental Equity Risk Model MH 4") |>
    select(ticker, factor, value) |>
    mutate(
      ticker = factor(ticker, rev(tkr)),
      factor = factor(factor, key_factors)
    )
  
  key_acct_exp_tbl <- risk_tbl |> 
    filter(model == "Axioma US Fundamental Equity Risk Model MH 4") |> 
    filter(metric_type == "Exposure") |> 
    filter(metric %in% c("exposure_port", "exposure_bench")) |> 
    filter(factor %in% key_factors) |> 
    select(factor, metric, value) |> 
    mutate(
      factor = factor(factor, key_factors)
    ) |> 
    pivot_wider(names_from = metric, values_from = value)

  max_abs_exp <- max(abs(key_exp_tbl$value))
  max_abs_exp <- max(max_abs_exp, 3)

  key_exp_tbl |>
    ggplot(
      aes(x = value, y = ticker, fill = fct_rev(ticker))
    ) +
    geom_vline(
      data = key_acct_exp_tbl,
      aes(xintercept = exposure_port)
    ) +
    geom_vline(
      data = key_acct_exp_tbl,
      aes(xintercept = exposure_bench),
      linetype = 2
    ) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~ factor, ncol = 2) +
    scale_x_continuous(
      breaks = seq(-3, 3, 1),
      limits = c(-max_abs_exp, max_abs_exp)
    ) +
    labs(x = NULL, y = NULL, fill = NULL) +
    theme_minimal_grid() +
    theme(
      panel.spacing = unit(1.5, "lines"),
      legend.position = "bottom"
    ) +
    scale_fill_oq()

}
