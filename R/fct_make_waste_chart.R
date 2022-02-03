#' make_waste_chart
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @import ggplot2
#' @import scales
#' @noRd
make_waste_chart <- function(data) {
  renderPlot({
    # Draw the main waste plot
    data %>%
     ggplot(aes(
        x = timestamp,
        colour = household,
        fill = household,
        alpha = type
      )) +
      geom_area(aes(y = cummulative_weight)) +
      theme_minimal() +
      scale_alpha_discrete(name = "Waste type", range = c(0.5, 0.8)) +
      scale_color_brewer(
        name = "Household",
        type = "qual",
        palette = "Set2"
      ) +
      scale_fill_brewer(
        name = "Household",
        type = "qual",
        palette = "Set2"
      ) +
      scale_x_datetime("Date",
                       breaks = breaks_width("1 day"),
                       labels = label_date("%d-%b")
      ) +
      scale_y_continuous("Weight (Kg)",
      )
  })
}
