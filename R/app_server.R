#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @import dplyr
#' @import tidyr
#' @import ggplot2
#' @import scales
#' @noRd
app_server <- function(input, output, session) {
  all_data <- get_data()

  daily_tips <- get_daily_tips(all_data)

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
      weight_of_landfill_waste_kg = c(1.293, 1.054, NA),
      weight_of_plastic_recycling_kg = c(0.2, 0, NA),
      weight_of_food_waste_kg = c(0.272, NA, NA),
      weight_of_other_recycling_kg = c(0.544, NA, NA),
      weight_of_glass_recycling_kg = c(NA, NA, NA),
      weight_of_clinical_waste_kg = c(0.043, NA, NA)
    ) %>%
    pivot_longer(-household,
      names_to = "type",
      values_to = "bin_weight"
    )

  landfill_waste <-
    sum_waste(
      all_data,
      weight_of_landfill_waste_kg,
      bin_emptied,
      bin_weights
    )

  plastic_recycling <-
    sum_waste(
      all_data,
      weight_of_plastic_recycling_kg,
      bin_emptied_2,
      bin_weights
    )

  food_waste <-
    sum_waste(
      all_data,
      weight_of_food_waste_kg,
      bin_emptied_3,
      bin_weights
    )

  other_recycling <-
    sum_waste(
      all_data,
      weight_of_other_recycling_kg,
      bin_emptied_4,
      bin_weights
    )

  glass_recycling <-
    sum_waste(
      all_data,
      weight_of_glass_recycling_kg,
      bin_emptied_5,
      bin_weights
    )

  clinical_waste <-
    sum_waste(
      all_data,
      weight_of_clinical_waste_kg,
      bin_emptied_6,
      bin_weights
    )

  # Your application server logic
  output$main_waste_chart <-
    renderPlot({
      make_waste_chart(bind_rows(landfill_waste, plastic_recycling), input)
    })
  output$main_waste_table <-
    DT::renderDT({
      make_tidy_table(bind_rows(landfill_waste, plastic_recycling))
    })

  output$food_waste_chart <-
    renderPlot({
      make_waste_chart(food_waste, input)
    })
  output$food_waste_table <-
    DT::renderDT({
      make_tidy_table(food_waste)
    })

  output$other_recycling_chart <-
    renderPlot({
      make_waste_chart(other_recycling, input)
    })
  output$other_recycling_table <-
    DT::renderDT({
      make_tidy_table(other_recycling)
    })

  output$glass_recycling_chart <-
    renderPlot({
      make_waste_chart(glass_recycling, input)
    })
  output$glass_recycling_table <-
    DT::renderDT({
      make_tidy_table(glass_recycling)
    })

  output$clinical_waste_chart <-
    renderPlot({
      make_waste_chart(clinical_waste, input)
    })
  output$clinical_waste_table <-
    DT::renderDT({
      make_tidy_table(clinical_waste)
    })
}
