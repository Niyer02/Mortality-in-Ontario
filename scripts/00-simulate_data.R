#### Preamble ####
# Purpose: Simulates the Mortality rates and causes in Ontario
# Author: Nikhil Iyer
# Date: 16 March 2024
# Contact: nik.iyer@mail.utoronto.ca
# License: MIT
# Pre-requisites: Dependancies Installed



#### Workspace setup ####
library(tidyverse)
library(ggplot2)

#### Simulate data ####
ontario_death_simulation <- tibble(
  cause = rep(c("COVID-19", "Disease", "Homicide", "Accident", "Suicide"), each = 5),
  year = rep(2018:2022, times = 5),
  deaths = rnbinom(n = 25, size = 20, prob = 0.1)
)

# View the initial 6 lines of the DF
head(ontario_death_simulation)
