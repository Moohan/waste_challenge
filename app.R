#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(googlesheets4)
library(tidyverse)

source("functions.R")

full_data <- get_data()

source("process.R")

# Define UI for application that draws a histogram
ui <- dashboardPage(
  # Application title
  dashboardHeader(title = "Waste Challenge - February 2022"),
  dashboardSidebar(sidebarMenu(
    id = "tabset",
    menuItem(
      "Main waste",
      tabName = "main",
      icon = icon("chart-line")
    )
  )),
  dashboardBody(tabItems( # First tab content
    tabItem(
      tabName = "main",
      plotOutput("mainchart")
    )
  ))
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$mainchart <- renderPlot({
    # generate bins based on input$bins from ui.R

    # draw the histogram with the specified number of bins
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

# Run the application
shinyApp(ui = ui, server = server)
