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
      dashboardSidebar(sidebarMenu(
        id = "tabset",
        menuItem(
          "Main waste",
          tabName = "main",
          icon = icon("chart-line")
        ),
        menuItem(
          "Food waste",
          tabName = "food-waste",
          icon = icon("chart-line")
        )
      )),
      dashboardBody(tabItems( # First tab content
        tabItem(
          tabName = "main",
          plotOutput("mainchart")
        ),
        tabItem(
          tabName = "food-waste"
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
