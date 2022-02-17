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

  googlesheets4::read_sheet(sheet_id, .name_repair = janitor::make_clean_names) %>%
    dplyr::mutate(dplyr::across(c(
      household, tidyselect::contains("bin_emptied")
    ), forcats::as_factor)) %>%
    arrange(household, timestamp) %>%
    fix_data() %>%
    dplyr::group_by(household) %>%
    dplyr::mutate(single_bin = xor(
      is.na(weight_of_landfill_waste_kg),
      is.na(weight_of_plastic_recycling_kg)
    )) %>%
    dplyr::mutate(last_has_all_data = max(dplyr::if_else(!single_bin, timestamp, as.POSIXct(NA)), na.rm = TRUE)) %>%
    tidyr::fill(
      weight_of_landfill_waste_kg,
      weight_of_plastic_recycling_kg
    ) %>%
    dplyr::mutate(across(
      c(bin_emptied, bin_emptied_2),
      ~ dplyr::if_else(
        single_bin &
          is.na(.x) &
          timestamp >= last_has_all_data,
        "No",
        as.character(.x)
      )
    )) %>%
    dplyr::mutate(
      weight_of_landfill_waste_kg = dplyr::if_else(
        !single_bin &
          is.na(bin_emptied),
        NA_real_,
        weight_of_landfill_waste_kg
      ),
      weight_of_plastic_recycling_kg = dplyr::if_else(
        !single_bin &
          is.na(bin_emptied_2),
        NA_real_,
        weight_of_plastic_recycling_kg
      )
    )
}
