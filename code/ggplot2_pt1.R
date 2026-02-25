# Plotting with ggplot2

# Load packages ----
library(tidyverse)

# Demonstrate multiple datasets ----
set.seed(20260219)
# First dataset is a line with a positive slope
b0_1 <- -1
b1_1 <- 3

dat1 <- data.frame(x = runif(n = 100,
                             min = -1,
                             max = 1)) %>% 
  mutate(mu = b0_1 + b1_1 * x,
         y = rnorm(n = nrow(.),
                   mean = mu,
                   sd = 1))

# Second dataset is a line with a negative slope
b0_2 <- 3
b1_2 <- -3

dat2 <- data.frame(x = runif(n = 100,
                             min = -1,
                             max = 1)) %>% 
  mutate(mu = b0_2 + b1_2 * x,
         y = rnorm(n = nrow(.),
                   mean = mu,
                   sd = 1))

# Plot one dataset -----

# ... example 1 ----
# Pass the data as an argument to `ggplot()`
ggplot(dat1, aes(x = x, y = y)) +
  geom_point()

# ... example 2 ----
# Pipe in the data
dat1 %>% 
  ggplot(aes(x = x, y = y)) +
  geom_point()

# ... example 3 ----
# Pass the data to the geom_*()
ggplot() +
  geom_point(data = dat1, mapping = aes(x = x, y = y))

# ... example 4 ----
# Pass the data to ggplot(), define the aesthetics
# for the geom_*()
ggplot(dat1) +
  geom_point(aes(x = x, y = y))

# How to plot these two datasets ----

# ... example 1 ----
# Pass the data to different layers
ggplot() +
  geom_point(aes(x = x, y = y), dat1) +
  geom_point(data = dat2, aes(x = x, y = y))

# ... example 2 ----
# Because the datasets share the same column names,
# we can specify the aesthetic globally and the data
# per layer
ggplot(mapping = aes(x = x, y = y)) +
  geom_point(data = dat1) +
  geom_point(data = dat2)

# ... example 3 ----
# If the datasets had different column names, we
# would need to change the aesthetic between layers
dat3 <- dat2 %>% 
  rename(a = x, b = y)

ggplot() +
  geom_point(aes(x = x, y = y), dat1) +
  geom_point(data = dat3, aes(x = a, y = b))

# ... example 4 ----
# You can change aesthetics between layers
# For example, if you have multiple layers based on
# `dat1`, but then want to add `dat3` later.
ggplot(dat1, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm") +
  geom_point(data = dat3, aes(x = a, y = b)) +
  geom_smooth(method = "lm", 
              data = dat3, aes(x = a, y = b))

# Change colors for the two datasets ----
# ... example 1 ----
# Pass the two datasets as separate layers
# Specify the color manually.
ggplot() +
  geom_point(aes(x = x, y = y), 
             dat1, color = "pink") +
  geom_point(data = dat2, aes(x = x, y = y), 
             color = "lavender") +
  theme_dark()

# ... example 2 ----
# Combine the datasets and add an ID column
dat4 <- bind_rows(dat1, dat2, .id = "id")

ggplot(dat4, aes(x = x, y = y, color = id)) +
  geom_point() +
  # We can also specify our own colors
  scale_color_manual(values = c("pink", "lavender")) +
  theme_dark()

# ... example 3 ----
# Pass the data to different layers, but give an
# informative name for the legend
ggplot() +
  geom_point(aes(x = x, y = y, color = "Dataset 1"), 
             dat1) +
  geom_point(aes(x = x, y = y, color = "Dataset 2"),
             dat2) +
  # We can also specify our own colors
  scale_color_manual(values = c("pink", "lavender")) +
  theme_dark()

# Add some labels to our plot ----

# ... example 1 ----
# Change the name of anything using the scale_*() 
# functions
ggplot(dat4, aes(x = x, y = y, color = id)) +
  geom_point() +
  scale_x_continuous(name = "X-axis",
                     # can also change the breaks here
                     breaks = seq(-1, 1, by = 0.2)
                     ) +
  scale_y_continuous(name = "Y-axis") +
  # We can also specify our own colors
  scale_color_manual(name = "Temperature \nof My Data\n(\u00B0)", 
                     values = c("pink", "lavender")) +
  theme_dark()

# ... example 2 ----
# There are dedicated functions for x-labels and y-labels
ggplot(dat4, aes(x = x, y = y, color = id)) +
  geom_point() +
  xlab("X-axis") +
  ylab("Y-axis") +
  # We can also specify our own colors
  scale_color_manual(name = "Color", 
                     values = c("pink", "lavender")) +
  theme_dark()


# ... example 3 ----
# Add a title
ggplot(dat4, aes(x = x, y = y, color = id)) +
  geom_point() +
  xlab("X-axis") +
  ylab("Y-axis") +
  # We can also specify our own colors
  scale_color_manual(name = "Color", 
                     values = c("pink", "lavender")) +
  # Add a title
  ggtitle("My Plot", subtitle = "(it's really nice)") +
  theme_dark()

# ... example 4 ----
# Add a title
ggplot(dat4, aes(x = x, y = y, color = id)) +
  geom_point() +
  xlab("X-axis") +
  ylab("Y-axis") +
  # We can also specify our own colors
  scale_color_manual(name = "Color", 
                     values = c("pink", "lavender")) +
  # Add a title
  labs(title = "My Plot", 
       subtitle = "(it's really nice)") +
  theme_dark()

# Change the theme ----
# You can change the appearance of (almost?) everything
# with the theme.
?theme

# Maybe you want to make a big figure for a PowerPoint
# But we need large font for the text
# We also might find ourselves with large values
# on the x-axis
dat5 <- dat4 %>% 
  mutate(x = x + 1000000)

ggplot(dat5, aes(x = x, y = y, color = id)) +
  geom_point() +
  xlab("X-axis") +
  ylab("Y-axis") +
  # We can also specify our own colors
  scale_color_manual(name = "Color", 
                     values = c("pink", "lavender")) +
  # Add a title
  labs(title = bquote(italic(My)~ Plot), 
       # You can use special formatting/characters
       # in a label using bquote()
       subtitle = "it's really nice") +
  theme_dark() +
  theme(text = element_text(size = 18), 
        axis.title.x = element_text(size = 30),
        axis.title.y = element_text(size = 10),
        axis.text.x = element_text(angle = 45, 
                                   hjust = 1,
                                   size = 8),
        # If you want to get rid of something,
        # use element_blank()
        panel.grid = element_blank(),
        # Center the title
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(size = 10, 
                                     hjust = 0.5,
                                     # make the whole
                                     # subtitle bold
                                     face = "bold"))

