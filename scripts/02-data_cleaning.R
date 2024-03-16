#### Preamble ####
# Purpose: Cleans the raw Ontario Data
# Author: Nikhil Iyer
# Date: 16 March 2024
# Contact: nik.iyer@mail.utoronto.ca
# License: MIT
# Pre-requisites: Dependancies Installed

#### Workspace setup ####
library(tidyverse)
library(dplyr)

#### Clean data ####
raw_data <- read_csv("data/raw_data/raw_ontario_cod.csv")

# Filter Ontario only
ontario_only <- raw_data %>% filter(GEO == "Ontario, place of residence", # Filter Ontario Only
                                    as.numeric(substr(REF_DATE, 1, 4)) %in% 2018:2022, # Only years 2018-2022 inclusive
                                    Characteristics == "Number of deaths", # Only number of deaths
                                    Sex == "Both sexes") %>% # Both sexes statistic only
  select(-TERMINATED, -SYMBOL, -STATUS, -DECIMALS, -SCALAR_ID, -DGUID, -UOM, #Remove unnecessary features
         -UOM_ID, -SCALAR_FACTOR, -VECTOR, -COORDINATE) %>%
  mutate(GEO = ifelse(GEO == "Ontario, place of residence", "ONT", GEO))

# Remove COVID because it did not exist in 2018
ontario_only <- ontario_only %>%
  filter(`Leading causes of death (ICD-10)` != "COVID-19 [U07.1, U07.2, U10.9]")

# Split data frames by year
split_data <-split(ontario_only, ontario_only$REF_DATE)

# Access data frame for a specific year
data_2018 <- split_data[["2018"]]
data_2019 <- split_data[["2019"]]
data_2020 <- split_data[["2020"]]
data_2021 <- split_data[["2021"]]
data_2022 <- split_data[["2022"]]


# Top 5 variables for each year
top_5_2018 <- data_2018 %>% arrange(desc(VALUE)) %>% slice_head(n=6)
top_5_2019 <- data_2019 %>% arrange(desc(VALUE)) %>% slice_head(n=6)
top_5_2020 <- data_2020 %>% arrange(desc(VALUE)) %>% slice_head(n=6)
top_5_2021 <- data_2021 %>% arrange(desc(VALUE)) %>% slice_head(n=6)
top_5_2022 <- data_2022 %>% arrange(desc(VALUE)) %>% slice_head(n=6)

# Append data into final data frame
final_data <- bind_rows(
  top_5_2018 %>% mutate(Year = 2018),
  top_5_2019 %>% mutate(Year = 2019),
  top_5_2020 %>% mutate(Year = 2020),
  top_5_2021 %>% mutate(Year = 2021),
  top_5_2022 %>% mutate(Year = 2022)
)


#### Save data ####
write_csv(final_data, "data/analysis_data/cleaned_ontario_data.csv")
