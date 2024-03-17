# Mortality Trends in Ontario

## Overview
This paper analyzes and discusses the results that were formed from mortality data collected by Statistics Canada (Statistics Canada 2023).  This paper models morality trends in Ontario from 2002 to 2022. The analysis was performed in `R`(R Core Team 2021), using `tidyverse`(Wickham et al. 2019),
`tibble`(Müller and Wickham 2023), `dplyr`(Wickham et al. 2023), `ggplot2`(Wickham 2016), `rstanarm` (Goodrich et al. 2024).


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from Statistics Canada (Statistics Canada 2023).
-   `data/analysis_data` contains the cleaned dataset that was constructed.
-   `model` contains fitted models. 
-   `other` contains details about LLM chat interactions, and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data.


## Statement on LLM usage
**Statement on LLM usage: No aspects of the code or paper were written with the help of an LLM**
