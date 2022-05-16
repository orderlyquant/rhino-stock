# app/logic/viz_price_chart

box::use(
  dplyr[mutate],
  ggplot2[...],
  scales[label_percent],
  tidyquant[
    CUMULATIVE_SUM,
    PCT_CHANGE,
    tq_get
  ]
)

viz <- function(tkr, dr, returns = TRUE) {
  
  prices_tbl <- tq_get(tkr, from = dr[1], to = dr[2])
  
  if(returns) {
    returns_tbl <- prices_tbl |> 
      mutate(
        returns = PCT_CHANGE(adjusted, fill_na = 0),
        return  = CUMULATIVE_SUM(returns)
      )
    
    plot <- returns_tbl |> 
      ggplot(
        aes(x = date, y = return)
      ) +
      geom_line() +
      scale_y_continuous(labels = label_percent()) +
      labs(x = NULL, y = NULL)
    
  } else {
    
    plot <- prices_tbl |> 
      ggplot(
        aes(x = date, y = adjusted)
      ) +
      geom_line() +
      labs(x = NULL, y = NULL)
    
  }
  
  return(plot)
}
