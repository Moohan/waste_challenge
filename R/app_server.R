#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @import dplyr
#' @import tidyr
#' @import ggplot2
#' @noRd
app_server <- function(input, output, session) {
  daily_tips <- get_daily_tips(get_data())

  output$messageMenu <- renderMenu({
    # Code to generate each of the messageItems here, in a list. This assumes
    # that messageData is a data frame with two columns, 'from' and 'message'.
    msgs <- apply(daily_tips, 1, function(row) {
      messageItem(from = row[["household"]], message = row[["tip_of_the_day"]])
    })

    # This is equivalent to calling:
    # dropdownMenu(type="messages", msgs[[1]], msgs[[2]], ...)
    dropdownMenu(type = "messages", .list = msgs)
  })

  bin_weights <-
    data.frame(
      household = c("James & Camille", "Amy", "Amy & Jonny"),
      weight_of_landfill_waste_kg = c(1.3, 0, 0),
      weight_of_plastic_recycling_kg = c(0.7, 0, 0),
      clinical = c(0.043, 0, 0),
      food_waste = c(0.272, 0, 0)
    ) %>%
    pivot_longer(-household,
      names_to = "type",
      values_to = "bin_weight"
    )


  landfill_waste <-
    sum_waste(
      get_data(),
      weight_of_landfill_waste_kg,
      bin_emptied,
      bin_weights
    )

  plastic_recycling <-
    sum_waste(
      get_data(),
      weight_of_plastic_recycling_kg,
      bin_emptied_2,
      bin_weights
    )

  # Your application server logic
  output$mainchart <- renderPlot({
    # Draw the main waste plot
    bind_rows(landfill_waste, plastic_recycling) %>%
      ggplot(aes(
        x = timestamp,
        colour = household,
        fill = household,
        alpha = type
      )) +
      geom_area(aes(y = waste_weight)) +
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
      )
  })
}
