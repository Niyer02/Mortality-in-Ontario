#### Preamble ####
# Purpose: Downloads and saves the data from statcan
# Author: Nikhil Iyer
# Date: 16 March 2024
# Contact: nik.iyer@mail.utoronto.ca
# License: MIT
# Pre-requisites: Dependancies Installed


#### Workspace setup ####
library(tidyverse)
library(readr)

#### Download data ####
# Use tempfile to unzip the package and read it into a DF
temp <- tempfile()
download.file("https://www150.statcan.gc.ca/n1/tbl/csv/13100801-eng.zip",temp)

# Read data
ontario_cod_raw <- read_csv(unz(temp, "13100801.csv"))
unlink(temp)


#### Save data ####
write_csv(ontario_cod_raw, "data/raw_data/raw_ontario_cod.csv") 
