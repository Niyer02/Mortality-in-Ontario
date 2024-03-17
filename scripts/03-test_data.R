#### Preamble ####
# Purpose: Tests the data to ensure the types are correct
# Author: Nikhil Iyer
# Date: 16 March 2024
# Contact: nik.iyer@mail.utoronto.ca
# License: MIT
# Pre-requisites: Dependancies Installed


#### Workspace setup ####
library(tidyverse)
library(assertthat)

#### Test data ####
analysis_data <- read_csv("data/analysis_data/cleaned_ontario_data.csv")

# Test columns are numeric
test_numeric <- function(data) {
  ref_date <- all(sapply(data$REF_DATE, is.numeric))
  value <- all(sapply(data$VALUE, is.numeric))
  
  if (!ref_date) {
    stop("Column 'REF_DATE' is not numeric.")
  }
  if (!value) {
    stop("Column 'VALUE' is not numeric.")
  }
}

# Run the test
test_numeric(analysis_data)

