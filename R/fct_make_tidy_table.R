#' make_tidy_table
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
make_tidy_table <- function(data) {
  data %>%
    dplyr::mutate(
      timestamp = format(timestamp, format = "%d %b"),
      weight = round(weight, 3),
      cummulative_weight = round(cummulative_weight, 3),
      weight_difference = round(weight_difference, 3)
    ) %>%
    dplyr::filter(!near(weight, 0)) %>%
    dplyr::select(
      "Date" = timestamp,
      "Household" = household,
      "Bin type" = type,
      "Weight (kg)" = weight,
      "Weight difference" = weight_difference,
      "Weight to date (kg)" = cummulative_weight
    ) %>%
    dplyr::arrange(Date, Household) %>%
    DT::datatable(
      extensions = c("Responsive"),
      plugins = c("scrolling")
    )
}
