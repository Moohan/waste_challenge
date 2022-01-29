get_data <- function() {
  googlesheets4::gs4_deauth()
  googlesheets4::read_sheet("1oG6DS4NSYvsSYxYFUxFtGD_u1hY2LdEXWk_E7Zu-NX8", .name_repair = janitor::make_clean_names) %>%
    mutate(across(c(household, contains("bin_emptied")), as_factor))
}

cumsum_bin <- function(weight, bin) {
  if_else({{bin}} == "Yes",
          {{weight}},
          pmax({{weight}},
               {{weight}} + lag({{weight}}),
               na.rm = TRUE)) %>%
    cumsum()
}
