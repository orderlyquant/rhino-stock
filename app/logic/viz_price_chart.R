# app/logic/viz_price_chart

box::use(
  cowplot[theme_minimal_hgrid],
  dplyr[group_by, mutate, slice_tail, ungroup],
  ggplot2[...],
  oqthemes[scale_color_oq],
  scales[label_percent],
  tidyquant[
    CUMULATIVE_SUM, PCT_CHANGE, tq_get
  ]
)

box::use(
  app/logic/calc_market_data[get_prices_and_returns]
)

#' @export
viz_price_chart <- function(tkr, dr, returns = TRUE) {

  returns_tbl <- get_prices_and_returns(tkr, from = dr[1], to = dr[2])
  returns_tbl <- returns_tbl |>
    mutate(symbol = factor(symbol, tkr))

  num_tkr <- returns_tbl$symbol |> unique() |> length()

  if (num_tkr == 1) {
    one_stock_chart(returns_tbl, returns)
  } else {

    # only show returns for multiple stocks
    many_stock_chart(returns_tbl, returns = TRUE)
  }

}

one_stock_chart <- function(tbl, returns) {

  final_tbl <- tbl |>
    slice_tail(n = 1) |>
    mutate(
      adjusted_label = round(adjusted, 2),
      return_label = round(return * 100, 2)
    )

  if (returns) {

    plot <- tbl |>
      ggplot(
        aes(x = date, y = return)
      ) +
      geom_hline(yintercept = 0) +
      geom_line(size = 1.2) +
      geom_label(
        data = final_tbl,
        aes(label = return_label),
        hjust = "outward",
        show.legend = FALSE
      ) +
      scale_y_continuous(labels = label_percent()) +
      labs(x = NULL, y = NULL)

  } else {

    plot <- tbl |>
      ggplot(
        aes(x = date, y = adjusted)
      ) +
      geom_line(size = 1.2) +
      geom_label(
        data = final_tbl,
        aes(label = adjusted_label),
        hjust = "outward",
        show.legend = FALSE
      ) +
      labs(x = NULL, y = NULL)

  }

  return(
    plot +
      theme_minimal_hgrid()
  )

}

many_stock_chart <- function(tbl, returns) {

  final_tbl <- tbl |>
    group_by(symbol) |>
    slice_tail(n = 1) |>
    mutate(
      adjusted_label = round(adjusted, 2),
      return_label = round(return * 100, 2)
    ) |>
    ungroup()

  if (returns) {

    plot <- tbl |>
      ggplot(
        aes(x = date, y = return)
      ) +
      geom_hline(yintercept = 0) +
      geom_line(aes(color = symbol), size = 1.2) +
      geom_label(
        data = final_tbl,
        aes(label = return_label, color = symbol),
        hjust = "outward",
        show.legend = FALSE
      ) +
      scale_y_continuous(labels = label_percent()) +
      labs(x = NULL, y = NULL, color = NULL)

  } else {

    plot <- tbl |>
      ggplot(
        aes(x = date, y = adjusted)
      ) +
      geom_line(aes(color = symbol), size = 1.2) +
      geom_label(
        data = final_tbl,
        aes(label = adjusted_label, color = symbol),
        hjust = "outward",
        show.legend = FALSE
      ) +
      labs(x = NULL, y = NULL, color = NULL)

  }

  return(
    plot +
      theme_minimal_hgrid() +
      guides(color = guide_legend(nrow = 1)) +
      theme(legend.position = "bottom") +
      scale_color_oq()
  )

}
