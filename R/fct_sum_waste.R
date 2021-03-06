#' sum_waste
#'
#' @param data a tibble with the data
#' @param type The type of waste (variable)
#' @param bin The bin emptied variable
#' @param bin_weights The df of bin weights
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
sum_waste <- function(data, type, bin, bin_weights) {
  trimmed_data <- data %>%
    dplyr::select(
      .data$timestamp,
      .data$household,
      {{ type }},
      {{ bin }}
    ) %>%
    tidyr::drop_na()

  pivotted_data <- trimmed_data %>%
    tidyr::pivot_longer(
      cols = c({{ type }}),
      names_to = "type",
      values_to = "weight"
    ) %>%
    # Adjust for bin weight
    dplyr::left_join(bin_weights, by = c("household", "type")) %>%
    tidyr::replace_na(list(bin_weight = 0)) %>%
    dplyr::mutate(type = stringr::str_replace(.data$type, "weight_of_(.+?)_kg", "\\1") %>%
                    stringr::str_replace_all("_", " ") %>%
                    stringr::str_to_title())

  cummulative_weights <- pivotted_data %>%
    dplyr::mutate(weight = pmax(.data$weight - .data$bin_weight, 0)
      ) %>%
    group_by(household) %>%
    dplyr::mutate(weight_difference = weight_diff(weight = .data$weight, bin = {{bin}}),
                   cummulative_weight = cumsum(.data$weight_difference)) %>%
    dplyr::ungroup()

  return(cummulative_weights)
}
