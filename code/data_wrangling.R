# Data wrangling
# Using the tidyverse

# Load packages ----
library(tidyverse)
library(broom)

# Attach sample data ----
data("starwars")

# dplyr verbs ----

# ... piping ----
# The pipe operator takes the output of the last function and
# passes it to the input for the next function.

# Without piping, imagine we want to do 3 things to a dataset.
h(g(f(x), arg1 = "abc"), opt = TRUE)

# We could do this in 3 steps and improve readability
y <- f(x)
z <- g(y, arg1 = "abc")
a <- h(z, opt = TRUE)
# but this makes a bunch of copies and wastes RAM (memory)

# Instead, we can define a function (the pipe) that passes the
# output of one as an input to the next
f(x) %>% 
  g(arg1 = "abc") %>% 
  h(opt = TRUE)

# This is the tidyverse pipe: %>% 
# This is the base R pipe: |> 

# ... mutate ----
head(starwars)
class(starwars)
# Ask it to print more rows/columns (sort of)
print(starwars, n = 15, width = 5000)

# mutate() adds columns
dat <- starwars %>% 
  mutate(bmi = mass/height^2*10000)

# filter ----
# filter() selects rows according to a logical condition
# Let's find Yoda
dat %>% 
  filter(name == "Yoda") %>% 
  print(width = 5000)

# Let's get Yoda and Obi-Wan Kenobi
# This isn't correct and will produce a warning
dat %>% 
  filter(name == c("Obi-Wan Kenobi", "Yoda")) %>% 
  print(width = 5000)

# This is correct
dat %>% 
  filter(name %in% c("Yoda", "Obi-Wan Kenobi")) %>% 
  print(width = 5000)

# The difference is in R's vector recycling rules
# The == recycles both vectors
dat$name == c("Yoda", "Obi-Wan Kenobi")
dat$name %in% c("Yoda", "Obi-Wan Kenobi")

# select ----
# 'select()' subsets columns
dat %>% 
  select(name, bmi) %>% 
  filter(name %in% c("Yoda", "Obi-Wan Kenobi"))

# The tidyverse functions support "tidy select", which means you
# have lots of ways to search for columns.
# See the help file
?select

# If I want all the columns between two end points
dat %>% 
  select(name:hair_color)

# You can select by position
dat %>% 
  select(1:4)

# There are helper functions to search for columns
dat %>% 
  select(contains("hair"))

# summarize ----
# summarize() creates summary statistics
dat %>% 
  summarize(mean_height = mean(height, na.rm = TRUE),
            mean_weight = mean(mass, na.rm = TRUE))

# But I can also use group_by() here
dat %>% 
  group_by(species)%>% 
  summarize(mean_height = mean(height, na.rm = TRUE),
            mean_weight = mean(mass, na.rm = TRUE),
            n = n())

# more group_by() ----
# Find the row of the character with the lowest weight
dat %>% 
  filter(mass == min(mass, na.rm = TRUE))

# Find the character of each sex with the lowest weight
dat %>% 
  group_by(sex) %>% 
  filter(mass == min(mass, na.rm = TRUE))

# Number each of these
dat %>% 
  group_by(sex) %>% 
  filter(mass == min(mass, na.rm = TRUE)) %>% 
  select(name, mass) %>% 
  mutate(number = 1:n())

# tidyr ----
# Check out the vignette on pivoting
vignette("pivot")
# You can also find it on the web by Googling
