#' get_data
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
get_data <- function() {
  googlesheets4::gs4_deauth()

  sheet_id <- "1oG6DS4NSYvsSYxYFUxFtGD_u1hY2LdEXWk_E7Zu-NX8"

  xfun::cache_rds(
    googlesheets4::read_sheet(sheet_id, .name_repair = janitor::make_clean_names) %>%
      dplyr::mutate(dplyr::across(
        c(household, tidyselect::contains("bin_emptied")), forcats::as_factor
      ))
  )
}
