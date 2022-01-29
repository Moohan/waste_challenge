#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import dplyr
#' @import tidyr
#' @import ggplot2
#' @noRd
app_server <- function( input, output, session ) {
  main_waste <- get_data() %>%
    select(timestamp, household, weight_of_landfill_waste_kg, bin_emptied, weight_of_plastic_recycling_kg, bin_emptied_2) %>%
    group_by(household) %>%
    mutate(waste_weight = cumsum_bin(weight = weight_of_landfill_waste_kg, bin = bin_emptied),
           plastic_weight = cumsum_bin(weight_of_plastic_recycling_kg, bin_emptied_2)) %>%
    ungroup() %>%
    select(timestamp, household, waste_weight, plastic_weight) %>%
    pivot_longer(cols = c(waste_weight, plastic_weight),
                 names_to = "type",
                 values_to = "weight")

  # Your application server logic
  output$mainchart <- renderPlot({
    # Draw the main waste plot
    main_waste %>%
      ggplot(aes(
        x = timestamp,
        colour = household,
        fill = household,
        alpha = type
      )) +
      geom_area(aes(y = weight)) +
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
