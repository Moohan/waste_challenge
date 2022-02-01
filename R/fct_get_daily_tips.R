#' get_daily_tips
#'
#' @param data a tibble with the data
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
get_daily_tips <- function(data) {
  tips <- data %>%
    dplyr::select(.data$household, .data$tip_of_the_day) %>%
    dplyr::mutate(
      tip_of_the_day = stringr::str_c(
        .data$tip_of_the_day,
        dplyr::if_else(
          stringr::str_ends(.data$tip_of_the_day, "[\\.\\?!]"),
          "",
          "."
        )
      ) %>%
        stringr::str_to_sentence()
    )

  # TODO Do spell checking with hunspell?

  return(tips)
}
