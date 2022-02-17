#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    waiter::autoWaiter(),
    shinydisconnect::disconnectMessage(),
    dashboardPage(
      dashboardHeader(
        title = "Waste Challenge - February 2022",
        dropdownMenuOutput("messageMenu")
      ),
      dashboardSidebar(
        sidebarMenu(
          id = "tabset",
          menuItem(
            "Main waste",
            tabName = "main",
            icon = icon("trash-alt")
          ),
          menuItem(
            "Food waste",
            tabName = "food-waste",
            icon = icon("drumstick-bite")
          ),
          menuItem(
            "Other recycling",
            tabName = "other-recycling",
            icon = icon("recycle")
          ),
          menuItem(
            "Glass recycling",
            tabName = "glass-recycling",
            icon = icon("wine-bottle")
          ),
          menuItem(
            "Clinical waste",
            tabName = "clinical-waste",
            icon = icon("syringe")
          ),
          radioButtons(
            inputId = "plotType",
            label = "Plot to draw",
            choices = c(
              "One plot",
              "Split plot"
            )
          )
        )
      ),
      dashboardBody(tabItems(
        # First tab content
        tabItem(
          tabName = "main",
          fluidRow(box(
            width = 12,
            plotOutput("main_waste_chart")
          )),
          fluidRow(box(
            width = 12,
            DT::DTOutput("main_waste_table")
          ))
        ),
        tabItem(
          tabName = "food-waste",
          fluidRow(box(
            width = 12,
            plotOutput("food_waste_chart")
          )),
          fluidRow(box(
            width = 12,
            DT::DTOutput("food_waste_table")
          ))
        ),
        tabItem(
          tabName = "other-recycling",
          fluidRow(box(
            width = 12,
            plotOutput("other_recycling_chart")
          )),
          fluidRow(box(
            width = 12,
            DT::DTOutput("other_recycling_table")
          ))
        ),
        tabItem(
          tabName = "glass-recycling",
          fluidRow(box(
            width = 12,
            plotOutput("glass_recycling_chart")
          )),
          fluidRow(box(
            width = 12,
            DT::DTOutput("glass_recycling_table")
          ))
        ),
        tabItem(
          tabName = "clinical-waste",
          fluidRow(box(
            width = 12,
            plotOutput("clinical_waste_chart")
          )),
          fluidRow(box(
            width = 12,
            DT::DTOutput("clinical_waste_table")
          ))
        )
      ))
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path("www", app_sys("app/www"))

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "waste_challenge"
    )
  )
}
