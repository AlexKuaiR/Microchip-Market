library(rvest)
library(janitor)
library(tidyverse)
library(readxl)

market <- read_xls(path = "WSTS-Historical-Billings-Report-April2022data.xls") |> as_tibble()


market_new <- market |> 
  row_to_names(row_number = 3)


colnames(market_new) <- c("Regions", "January", "February","March","April", "May","June" ,
                          "July" ,"August","September","October", "November", "December", "Total_Year",
                          "Q1" , "Q2" , "Q3", "Q4" )

market_data <- market_new |> 
  mutate(year = rep(1986:2022, each = 6))|>
  filter(!year %in% 2022, Regions != "Worldwide") |>
  mutate(Total_Year = as.integer(Total_Year) / 1000000) |> 
  drop_na()

write_rds(market_data, file = "rawdata.rds")
