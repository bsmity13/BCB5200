# Embed

# Load our usual packages ----
library(ggplot2)
library(dplyr)
library(patchwork)
library(ggforce)
library(ggmagnify)
library(ggfx)

# Set default ggplot theme ----
ggplot2::theme_set(theme_bw())

# Elide ----
data("iris")

# Here's the whole dataset
p <- ggplot(iris, 
            aes(x = Sepal.Length, y = Sepal.Width, 
                color = Species)) +
  geom_point()

p

# Limit the axes to show just part.
setosa <- p +
  coord_cartesian(xlim = c(4.25, 5.75),
                  ylim = c(2.25, 4.5))

versicolor <- p +
  coord_cartesian(xlim = c(5, 7),
                  ylim = c(2, 3.5))

# Combine with patchwork
setosa/versicolor

# Zoom in on a plot with 'ggforce::facet_zoom()'
p +
  facet_zoom(xlim = c(4.25, 5.75),
             ylim = c(2.25, 4.5))

# Zoom in on virginica with logical statement
p +
  facet_zoom(xy = Species == "virginica")

# Example with 'starwars'
sw <- starwars %>% 
  filter(mass < 500,
         species %in% c("Human", "Droid", 
                        "Wookiee", "Gungan")) %>% 
  ggplot(aes(x = height, y = mass, color = species)) +
  geom_point()

# Zoom in on humans
sw +
  facet_zoom(xy = species == "Human",
             zoom.data = species == "Human")

# Zoom in with ggmagnify
sw +
  coord_cartesian(xlim = c(50, 250),
                  ylim = c(25, 200)) +
  geom_magnify(from = list(160, 200, 70, 90),
               to = list(50, 125, 100, 200),
               shape = "rect",
               shadow = TRUE)

# Superimpose ----
# Use patchwork to create an inset
inset <- sw +
  coord_cartesian(xlim = c(160, 200),
                  ylim = c(70, 90)) +
  theme(legend.position = "none",
        plot.background = element_rect(fill = "white",
                                       linewidth = 3,
                                       color = "black")) +
  xlab(NULL) +
  ylab(NULL)


sw +
  coord_cartesian(xlim = c(50, 250),
                  ylim = c(25, 200)) +
  patchwork::inset_element(inset, -0.05, 0.4, 0.55, 1.05)

# Second y-axis
sw + 
  scale_y_continuous(name = "Mass (kg)",
                     sec.axis = sec_axis(~ . * 1000,
                                         name = "Mass (g)"))

sw + 
  scale_y_continuous(name = "Mass (kg)",
                     sec.axis = sec_axis(~ log(.),
                                         name = "log(Mass (kg))"))

# Distort ----
# Plot the y-axis on the log scale
sw +
  scale_y_log10()

