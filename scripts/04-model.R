#### Preamble ####
# Purpose: Models the cleaned Mortality in Ontario data
# Author: Nikhil Iyer
# Date: 16 March 2024
# Contact: nik.iyer@mail.utoronto.ca
# License: MIT
# Pre-requisites: Dependancies Installed


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(modelsummary)

#### Read data ####
analysis_data <- read_csv("data/analysis_data/cleaned_ontario_data.csv")
head(analysis_data)

# Plot the variables
analysis_data |>
  ggplot(aes(x = REF_DATE, y = VALUE, color = `Leading causes of death (ICD-10)`)) +
  geom_line() +
  theme_minimal() +
  scale_color_brewer(palette = "Set1") +
  labs(x = "Year", y = "Annual number of deaths in Ontario") +
  facet_wrap(vars(`Leading causes of death (ICD-10)`), dir = "v", ncol = 1) +
  theme(legend.position = "none")

### Model data ####
# Fit Poisson regression model
model_poisson <- stan_glm(
  VALUE ~ `Leading causes of death (ICD-10)`,
  data = analysis_data,
  family = poisson(link = "log"),
  seed = 853
)

# Fit negative Binomial regression model
model_neg_binomial <- stan_glm(
  VALUE ~ `Leading causes of death (ICD-10)`,
  data = analysis_data,
  family = neg_binomial_2(link = "log"),
  seed = 853
)

# Fit Gaussian regression model
model_gaussian <- stan_glm(
  VALUE ~ `Leading causes of death (ICD-10)`,
  data = analysis_data,
  family = gaussian(),
  seed = 853
)


# List of models
model_list <- list(
  "Poisson" = model_poisson,
  "Negative Binomial" = model_neg_binomial,
  "Gaussian" = model_gaussian
)

# Plot all models
plot_list <- lapply(model_list, function(model) {
  pp_check(model) + theme(legend.position = "bottom")
})

gridExtra::grid.arrange(
  grobs = plot_list,
  nrow = 2,
  ncol = 2
)

# Use Loo to compare the models
poisson <- loo(model_poisson, cores = 2)
neg_binomial <- loo(model_neg_binomial, cores = 2)
gaus <- loo(model_gaussian, cores = 2)

loo_compare(gaus, neg_binomial, poisson)

summary(model_neg_binomial)

#### Save model ####
saveRDS(
  neg_binomial,
  file = "models/neg_binomial.rds"
)



