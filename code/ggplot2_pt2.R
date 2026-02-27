# Plotting with ggplot2, part 2

# Load packages ----
library(tidyverse)

# Bar Plot ----
data("Titanic")

dat <- as.data.frame(Titanic)

# ... option 1 ----
# geom_bar does the counting for us
ggplot(dat, aes(x = Class)) +
  geom_bar()

# ... option 2 ----
# We do the counting ourselves
dat %>% 
  group_by(Class) %>% 
  summarize(y = n()) %>% 
  ggplot(aes(x = Class, y = y)) +
  geom_col()

# ... change the appearance ----
ggplot(dat, aes(y = Class)) +
  geom_bar(color = "black", fill = "gray", 
           linewidth = 1)

# Stacked Bar Plot ----
dat %>% 
  ggplot(aes(x = Class, fill = Age)) +
  geom_bar(color = "black", linewidth = 1)

# If we provide a "weight" variable to the `aes()`,
# geom_bar() will sum the weights instead of counting
# the categories.
dat %>% 
  ggplot(aes(x = Class, fill = Age, weight = Freq)) +
  geom_bar(color = NA)

# Grouped Bar Plot ----
# Align each category with the x-axis
# I.e., unstack the categories
dat %>% 
  ggplot(aes(x = Class, fill = Age, weight = Freq)) +
  # We can use the position_*() functions to change
  # the position of the bars
  # The default width of a bar = 1
  geom_bar(color = NA, width = 1,
           position = position_dodge(0.5))

# ... change drawing order ----
# Previous figure showed Adult drawn over Child
# Reverse the drawing order
dat %>% 
  mutate(age = factor(Age, levels = c("Adult", "Child"))) %>% 
  ggplot(aes(x = Class, fill = age, weight = Freq)) +
  geom_bar(color = NA, width = 1,
           position = position_dodge(0.5))

# The ChickWeight data has "Chick" as an ordered factor
# already. That determines the plotting order.
data("ChickWeight")

ChickWeight %>% 
  group_by(Chick) %>% 
  summarize(weight = max(weight)) %>% 
  ggplot(aes(x = Chick, y = weight)) +
  geom_col()

# Dot and Line Chart ----
head(ChickWeight)

# Dot chart
dc <- ChickWeight %>% 
  filter(Diet == 1, 
         Chick == 1) %>% 
  ggplot(aes(x = Time, y = weight)) +
  geom_point(size = 3,
             # To see choices for shapes, see ?pch
             shape = 15) +
  # Let's say we want to make sure we
  # can see the 0 on the y-axis
  coord_cartesian(ylim = c(0, 
                           # By setting the upper limit
                           # to NA, we let ggplot decide
                           NA))

# Print it out
dc

# Add the lines
dc +
  geom_line()

# Dot and line chart for each diet type
ChickWeight %>%  
  group_by(Time, Diet) %>% 
  summarize(weight = mean(weight)) %>% 
  ggplot(aes(x = Time, y = weight, shape = Diet, 
             color = Diet, fill = Diet)) +
  geom_point(size = 3) +
  # Change the shapes
  scale_shape_manual(values = c(15, 16, 22, 23)) +
  coord_cartesian(ylim = c(0,NA))

# Heat Map ----
head(dat)

dat %>% 
  group_by(Class, Age) %>% 
  summarize(n = sum(Freq)) %>% 
  ggplot(aes(x = Class, y = Age, fill = n)) +
  # Either geom_tile() or geom_raster() work in this case
  geom_raster() +
  scale_fill_viridis_c()

# Generate a dataset
dat2 <- expand.grid(x = 1:100,
                   y = 1:100) %>% 
  mutate(z = rnorm(100^2))

ggplot(dat2, aes(x = x, y = y, fill = z)) +
  geom_raster() +
  scale_fill_viridis_c()

# Scatter Plot Matrix ----
plot(ChickWeight)

# Faceted Scatter Plot ----
ChickWeight %>% 
  ggplot(aes(x = Time, y = weight)) +
  facet_wrap(~ Diet) +
  geom_point()

# Reverse the facet order
ChickWeight %>% 
  mutate(Diet = factor(Diet, levels = 4:1)) %>% 
  ggplot(aes(x = Time, y = weight)) +
  facet_wrap(~ Diet) +
  geom_point()

# Facet grid makes a matrix of scatterplots
# Subset to just 4 chicks to demonstrate
ChickWeight %>% 
  filter(Chick %in% c(18, 28, 36, 43)) %>% 
  ggplot(aes(x = Time, y = weight)) +
  facet_grid(Chick ~ Diet) +
  geom_point()

# Add argument "scales" to facet_*() in order to free
# x-limits, y-limits, or both
ChickWeight %>% 
  filter(Chick %in% c(18, 28, 36, 43)) %>% 
  ggplot(aes(x = Time, y = weight)) +
  facet_grid(Chick ~ Diet, scales = "free") +
  geom_point()

# Parallel Coordinates ----
data("iris")

iris %>% 
  mutate(id = 1:nrow(.)) %>% 
  pivot_longer(Sepal.Length:Petal.Width) %>% 
  arrange(name) %>% 
  group_by(id) %>% 
  mutate(name2 = lead(name), value2 = lead(value)) %>% 
  filter(!is.na(name2)) %>% 
  ggplot(aes(x = name, y = value, 
             xend = name2, yend = value2,
             color = Species)) +
  geom_segment(alpha = 0.2)

# Pie Chart ----

# Polar Area Chart ----
dat %>% 
  ggplot(aes(x = Class, fill = Age, weight = Freq)) +
  geom_bar(color = "black", linewidth = 1) +
  coord_radial()
