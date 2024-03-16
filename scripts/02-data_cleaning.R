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
                                    as.numeric(substr(REF_DATE, 1, 4)) %in% 2002:2022, # Only years 2018-2022 inclusive
                                    Characteristics == "Number of deaths", # Only number of deaths
                                    Sex == "Both sexes") %>% # Both sexes statistic only
  select(-TERMINATED, -SYMBOL, -STATUS, -DECIMALS, -SCALAR_ID, -DGUID, -UOM, #Remove unnecessary features
         -UOM_ID, -SCALAR_FACTOR, -VECTOR, -COORDINATE) %>%
  mutate(GEO = ifelse(GEO == "Ontario, place of residence", "ONT", GEO))

# Remove COVID because it did not exist in 2018
ontario_only <- ontario_only %>%
  filter(`Leading causes of death (ICD-10)` != "COVID-19 [U07.1, U07.2, U10.9]")

ontario_only <- ontario_only %>%
  filter(`Leading causes of death (ICD-10)` != "Total, all causes of death [A00-Y89]")

# Find causes of death in every year
common_causes <- ontario_only %>%
  group_by(`Leading causes of death (ICD-10)`) %>%
  filter(n_distinct(REF_DATE) == 21) %>%
  pull(`Leading causes of death (ICD-10)`) %>%
  unique()

# Only get values that are in every year
df_common <- ontario_only %>%
  filter(`Leading causes of death (ICD-10)` %in% common_causes)

# Fine top 5 highest frequencies
top_5_causes <- df_common %>%
  group_by(`Leading causes of death (ICD-10)`) %>%
  summarize(Avg_Value = mean(VALUE)) %>%
  top_n(5, Avg_Value)

# Filter for top 5
df_top_5 <- df_common %>%
  filter(`Leading causes of death (ICD-10)` %in% top_5_causes$`Leading causes of death (ICD-10)`)


#### Save data ####
write_csv(df_top_5, "data/analysis_data/cleaned_ontario_data.csv")
