# Colors

# Base R colors ----
# Recent update to RStudio displays color names in the text editor
"blue"
"lavender"

# And also hexadecimal codes
"#FF0000"
# Also control the transparency/opacity
"#FF000080"

# Base R knows ~700 colors by name
colors()
"bisque"

# Base R colors have a demo function
demo("colors")

# Base R palette ----
# R has a default color palette that it uses when
# you specify a color with an integer.
plot(x = 1:12, y = rep(1, 12), pch = 15, cex = 3,
     col = 1:12)

# View the palette
palette()

# Change the palette
palette(c("orange", "blue", "gold",
          "red", "lavender", "turquoise",
          "pink", "hotpink", "lavenderblush",
          "peachpuff", "forestgreen",
          "blanchedalmond"))

plot(x = 1:12, y = rep(1, 12), pch = 15, cex = 3,
     col = 1:12)

# Change the palette with palette-generating functions
# See some base R palettes with 
?rainbow

# Print out the palette
rainbow(n = 12)

# Set it as our default palette
palette(rainbow(n = 12))

plot(x = 1:12, y = rep(1, 12), pch = 15, cex = 3,
     col = 1:12)

# ggplot2 ----
library(ggplot2)
# Raster of distance from center
r <- expand.grid(x = seq(-100, 100, by = 1),
                 y = seq(-100, 100, by = 1))
r$z <- ((r$x^2 + r$y^2))

p <- ggplot(r, aes(x = x, y = y, fill = z)) +
  geom_raster() +
  coord_equal(expand = FALSE)

# Default color palette:
p

# Color Brewer ----
# Change the color palette
# Color Brewer
p +
  # Continuous version of brewer is distiller
  scale_fill_distiller(palette = "YlOrRd")

# Diverging palette
p +
  scale_fill_distiller(type = "div")

# Change the midpoint

# Categorical palette
p +
  # fermenter bins continuous variable into discrete categories
  scale_fill_fermenter(type = "qual")

# viridis ----
p +
  scale_fill_viridis_c()

# Turbo (rainbow)
p +
  scale_fill_viridis_c(option = "turbo")

# Binned version of that
p +
  scale_fill_viridis_b(option = "turbo")

# gradient fill ----
p +
  scale_fill_gradient2(midpoint = 10000,
                       low = "lavender",
                       mid = "blanchedalmond",
                       high = "seagreen")
