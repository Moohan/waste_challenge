#' fix_data
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
fix_data <- function(data) {
  fixed_data <- data %>%
    group_by(household) %>%
    dplyr::mutate(dplyr::across(tidyr::starts_with("weight_of_"), ~dplyr::if_else(10^(round(log10(.x))) / 10^ceiling(log10(median(.x, na.rm = TRUE))) < 10 | is.na(.x) | dplyr::near(.x, 0) , .x,  .x / 10^(round(log10(.x))) / 10^round(log10(median(.x, na.rm = TRUE)))))) %>%
    ungroup()

  compare <- waldo::compare(data, fixed_data, x_arg = "raw", y_arg = "fixed")

  if (length(compare >= 1)) {
    rlang::inform(c("i" = "Changes applied to data to correct bad values:",
              compare ))
  }

  return(fixed_data)
}
