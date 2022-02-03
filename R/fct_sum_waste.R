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
  data %>%
    dplyr::select(
      .data$timestamp,
      .data$household,
      {{ type }},
      {{ bin }}
    ) %>%
    tidyr::drop_na() %>%
    tidyr::pivot_longer(
      cols = c({{ type }}),
      names_to = "type",
      values_to = "weight"
    ) %>%
    # Adjust for bin weight
    dplyr::left_join(bin_weights) %>%
    tidyr::replace_na(list(bin_weight = 0)) %>%
    dplyr::mutate(weight = pmax(.data$weight - .data$bin_weight, 0)) %>%
    dplyr::mutate(cummulative_weight = cumsum_bin(weight = .data$weight, bin = {{ bin }})) %>%
    dplyr::mutate(type = stringr::str_replace(.data$type, "weight_of_(.+?)_kg", "\\1") %>%
                    stringr::str_replace_all("_", " ") %>%
                    stringr::str_to_title())
}
