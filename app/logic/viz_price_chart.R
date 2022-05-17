# app/logic/viz_price_chart

box::use(
  cowplot[theme_minimal_hgrid],
  dplyr[group_by, mutate, ungroup],
  ggplot2[...],
  oqthemes[scale_color_oq],
  scales[label_percent],
  tidyquant[
    CUMULATIVE_SUM, PCT_CHANGE, tq_get
  ]
)

viz_price_chart <- function(tkr, dr, returns = TRUE) {
  
  prices_tbl <- tq_get(tkr, from = dr[1], to = dr[2])
  prices_tbl <- prices_tbl |> 
    mutate(symbol = factor(symbol, tkr))
  
  num_tkr <- prices_tbl$symbol |> unique() |> length()
  
  if (num_tkr == 1) {
    one_stock_chart(prices_tbl, returns)
  } else {
    
    # only show returns for multiple stocks
    many_stock_chart(prices_tbl, returns = TRUE)
  }

}

one_stock_chart <- function(tbl, returns) {
  
  if(returns) {
    returns_tbl <- tbl |> 
      mutate(
        returns = PCT_CHANGE(adjusted, fill_na = 0),
        return  = CUMULATIVE_SUM(returns)
      )
    
    plot <- returns_tbl |> 
      ggplot(
        aes(x = date, y = return)
      ) +
      geom_hline(yintercept = 0) +
      geom_line() +
      scale_y_continuous(labels = label_percent()) +
      labs(x = NULL, y = NULL)
    
  } else {
    
    plot <- tbl |> 
      ggplot(
        aes(x = date, y = adjusted)
      ) +
      geom_line() +
      labs(x = NULL, y = NULL)
    
  }
  
  return(
    plot +
      theme_minimal_hgrid()
  )
  
}

many_stock_chart <- function(tbl, returns) {
  
  symbol_order <- 
  
  if(returns) {
    returns_tbl <- tbl |> 
      group_by(symbol) |> 
      mutate(
        returns = PCT_CHANGE(adjusted, fill_na = 0),
        return  = CUMULATIVE_SUM(returns)
      ) |> 
      ungroup()
    
    plot <- returns_tbl |> 
      ggplot(
        aes(x = date, y = return)
      ) +
      geom_hline(yintercept = 0) +
      geom_line(aes(color = symbol)) +
      scale_y_continuous(labels = label_percent()) +
      labs(x = NULL, y = NULL, color = NULL)
    
  } else {
    
    plot <- tbl |> 
      ggplot(
        aes(x = date, y = adjusted)
      ) +
      geom_line(aes(color = symbol)) +
      labs(x = NULL, y = NULL, color = NULL)
    
  }
  
  return(
    plot +
      theme_minimal_hgrid() +
      theme(legend.position = "bottom") +
      scale_color_oq()
  )
  
}