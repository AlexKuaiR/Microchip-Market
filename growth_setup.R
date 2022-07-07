library(rvest)
library(janitor)
library(tidyverse)
library(readxl)
raw_data <- read_xls(path = "API_NY.GDP.PCAP.CD_DS2_en_excel_v2_4250700.xls")

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
  filter(Asia_Pacific != "EAS" & Asia_Pacific != "GDP per capita (current US$)" & Asia_Pacific != "NY.GDP.PCAP.CD") |> 
  filter(European_Union != "EAS" & European_Union != "GDP per capita (current US$)" & European_Union != "NY.GDP.PCAP.CD") |> 
  filter(Japan != "EAS" & Japan != "GDP per capita (current US$)" & Japan != "NY.GDP.PCAP.CD") |> 
  filter(US != "EAS" & US != "GDP per capita (current US$)" & US != "NY.GDP.PCAP.CD") |> 
  drop_na() |> 
  mutate(year = 1970 : 2021) |> 
  mutate(Asia_Pacific = as.integer(Asia_Pacific),
         European_Union = as.integer(European_Union),
         Japan = as.integer(Japan),
         US = as.integer(US)) |> 
  pivot_longer(names_to = "region",
               values_to = "GDP",
               cols = -year)

write_rds(growth_data, "growth.rds")
