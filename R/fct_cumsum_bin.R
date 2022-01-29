#' cumsum_bin
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
cumsum_bin <- function(weight, bin) {
  if_else({{ bin }} == "Yes",
    {{ weight }},
    pmax({{ weight }},
      {{ weight }} + lag({{ weight }}),
      na.rm = TRUE
    )
  ) %>%
    cumsum()
}
