#' make_waste_chart
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @import ggplot2
#' @import scales
#' @noRd
make_waste_chart <- function(data, input) {
  plot <- data %>%
    ggplot(aes(
      x = timestamp,
      y = cummulative_weight
    ))

  days <-
    as.integer(ceiling(max(data$timestamp) - min(data$timestamp)))

  if (input$plotType == "One plot") {
    # Draw the main waste plot
    plot <- plot +
      geom_area(aes(
        colour = household,
        fill = household,
        alpha = type
      )) +
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
        date_breaks = paste(ceiling(days / 5), "day"),
        date_labels = "%d-%b"
      )
  } else {
    plot <- plot +
      geom_area(aes(fill = type, )) +
      scale_fill_brewer(
        name = "Waste type",
        type = "qual",
        palette = "Paired"
      ) +
      scale_x_datetime("Date",
        date_breaks = paste(ceiling(days / 3), "day"),
        date_labels = "%d-%b"
      ) +
      facet_wrap("household")
  }

  plot +
    scale_y_continuous("Weight (Kg)", ) +
    ggtitle(paste(unique(data$type), collapse = " and ")) +
    theme_minimal()
}
