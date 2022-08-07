library(rvest)
library(janitor)
library(tidyverse)
library(readxl)
raw_data <- read_xls(path = "API_SP.POP.TOTL_DS2_en_excel_v2_4250716.xls")

trim_data <- raw_data |> 
  row_to_names(row_number = 3) |> 
  clean_names() |> 
  as_tibble() |> 
  filter(country_name == "East Asia & Pacific" |
           country_name == "United States" |
           country_name == "European Union" |
           country_name == "Japan")

wrangled_data <- data.frame(t(trim_data[-1])) |> 
  as_tibble()

colnames(wrangled_data) <- c("Asia_Pacific", "European_Union", "Japan", "US")

growth_data <-wrangled_data |> 
  drop_na() |> 
  filter(Asia_Pacific != "EAS" & Asia_Pacific != "Population, total" & Asia_Pacific != "SP.POP.TOTL") |> 
  filter(European_Union != "EUU" & European_Union != "Population, total" & European_Union != "SP.POP.TOTL") |> 
  filter(Japan != "JPN" & Japan != "Population, total" & Japan != "SP.POP.TOTL") |> 
  filter(US != "USA" & US != "Population, total" & US != "SP.POP.TOTL") |> 
  mutate(year = 1960 : 2021) |> 
  mutate(Asia_Pacific = as.integer(Asia_Pacific),
         European_Union = as.integer(European_Union),
         Japan = as.integer(Japan),
         US = as.integer(US)) |> 
  pivot_longer(names_to = "region",
               values_to = "population",
               cols = -year)
  #mutate(country = rep(c("Asia Pacific", "European Union", "Japan", "US"), by = ))
growth_data
write_rds(growth_data, "growth.rds")
