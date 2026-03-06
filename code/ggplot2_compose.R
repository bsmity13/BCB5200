# Composing plots in ggplot2

library(ggplot2)
library(dplyr)
library(patchwork)
library(grid)

# Graphical parameters ----
par()

# four-panel figure, by row
par(mfrow = c(2, 2))
hist(rnorm(100))
plot(runif(100))
hist(rgamma(100, shape = 10, scale = 2))
plot(1:10, 10:1, pch = 15, col = "lavender")

# If I were to keep going, it would start over with a 
# new "page"
hist(rnorm(200))

# If I turn the device off, it clears the parameters
dev.off()
hist(rnorm(200))

# Another useful graphical parameter is the margins
# Default margins
par()$mar # units are "lines"

# Example plot
hist(rnorm(100), main = "default margins")

# Maybe you want 0 margin all the way around
par(mar = c(0, 0, 0, 0))
hist(rnorm(100), main = "No margins")

# Compose a plot with no margins on one panel
dev.off()
par(mfrow = c(1, 2))
hist(rnorm(100))
# Control the inner margins of a single panel
par(mai = c(0, 0, 0, 0))
hist(rnorm(200))

# patchwork ----
# ... plot labeling ----
# Create two figures to compose together
p1 <- ggplot(data.frame(x = rnorm(200)), aes(x = x)) +
  geom_histogram(color = "black", fill = "gray90") +
  theme_bw()

p2 <- ggplot(data.frame(x = rexp(200)), aes(x = x)) +
  geom_histogram(color = "black", fill = "lavender") +
  theme_bw()

# Can combine them with just the `+`
p1 + p2

# Can control labelling with plot_annotation()
p1 + p2 +
  plot_annotation(tag_levels = "1",
                          tag_suffix = ".)",
                          tag_prefix = "(")

# Set x-axis the same for both panels
(p1 + coord_cartesian(xlim = c(-4, 4))) + 
  (p2 + coord_cartesian(xlim = c(-4, 4))) + 
  plot_annotation(tag_levels = "1",
                  tag_suffix = ".)",
                  tag_prefix = "(")

p1 + p2 +
  plot_annotation(tag_levels = "1",
                  tag_suffix = ".)",
                  tag_prefix = "(") &
  coord_cartesian(xlim = c(-4, 4))

(p1 +
    ggtitle("Panel 1")) + 
  (p2 +
     ggtitle("Panel 2")) +
  plot_annotation(tag_levels = "1",
                  tag_suffix = ".)",
                  tag_prefix = "(") &
  coord_cartesian(xlim = c(-4, 4))

# ... complex design ----

dat <- data.frame(x = rexp(100),
                  y = rnorm(100))

# Main plot
main <- ggplot(dat, aes(x = x, y = y)) +
  geom_point() +
  theme_bw()

# x-axis density
x_dens <- ggplot(dat, aes(x = x)) +
  geom_density(fill = "gray90", color = "black") +
  theme_bw() +
  theme(axis.text.x = element_blank(),
        axis.title.x = element_blank())

# y-axis density
y_dens <- ggplot(dat, aes(y = y)) +
  geom_density(fill = "gray90", color = "black") +
  theme_bw() +
  theme(axis.text.y = element_blank(),
        axis.title.y = element_blank())

# Compose
# Text string to define the layout

des <- "AAAA#
        BBBBC
        BBBBC
        BBBBC
        BBBBC"

x_dens + main + y_dens + plot_layout(design = des)

# What happens if you do diagonals?
des2 <- "ABBB#
         BABBC
         BBABC
         BBBAC
         BBBBA"
x_dens + main + y_dens + plot_layout(design = des2)
# Answer: you get an error

# ... add text as a plot area ----
# Make a plot area that's just text.
my_text <- grid::textGrob("Just Some Text")
grid.draw(my_text)

wrap_elements(my_text) + 
  main + 
  y_dens + 
  plot_layout(design = des)

# ... add an inset plot ----
main + 
  # Units are 0 - 1 by default (proportion of the plot area)
  inset_element(x_dens, 0.6, 0.6, 1, 1)
