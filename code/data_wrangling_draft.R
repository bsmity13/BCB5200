# Draft of data wrangling script.
# Formulating a rough plan for what I will live code in class.

# Load packages ----
library(tidyverse)

# Sample data ----
data("starwars")
data("relig_income")

# Explore ----
print(starwars, n = 6, width = 5000)

# This dataset includes list columns (films, vehicles, starships),
# meaning this is not a simple flat table.
starwars$films[[1]]

# This is the example in the 'pivot' vignette
head(relig_income)
