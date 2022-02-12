#' make_tidy_table
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
make_tidy_table <- function(data) {
  DT::renderDT({
    data %>%
      dplyr::mutate(timestamp = format(timestamp, format = "%d %b"),
                    weight = round(weight, 3),
                    cummulative_weight = round(cummulative_weight, 3)) %>%
      dplyr::filter(!near(weight, 0)) %>%
      dplyr::select("Date" = timestamp, "Household" = household, "Bin type" = type, "Weight (Kg)" = weight, "Weight to date (Kg)" = cummulative_weight) %>%
      dplyr::arrange(Date, Household) %>%
      DT::datatable()
    })
}
