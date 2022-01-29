library(googlesheets4)
library(tidyverse)

main_waste <- full_data %>%
  select(timestamp, household, weight_of_landfill_waste_kg, bin_emptied, weight_of_plastic_recycling_kg, bin_emptied_2) %>%
  group_by(household) %>%
  mutate(waste_weight = cumsum_bin(weight = weight_of_landfill_waste_kg, bin = bin_emptied),
         plastic_weight = cumsum_bin(weight_of_plastic_recycling_kg, bin_emptied_2)) %>%
  ungroup() %>%
  select(timestamp, household, waste_weight, plastic_weight) %>%
  pivot_longer(cols = c(waste_weight, plastic_weight),
               names_to = "type",
               values_to = "weight")


