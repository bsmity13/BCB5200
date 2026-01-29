# Image formats
# and graphics devices in R

# Load packages ----
library(ggplot2)
library(ragg)

# Graphics devices ----
# When I go to plot, R opens a new "graphics device".
plot(1:10, 1:10)
points(1:10, 10:1, pch = 16, col = "lavender")

# If I'm not using it, I can turn it off.
dev.off()

# Instead of writing to the RStudio graphics device,
# I can write to a file.

# With base R ----

# For example, I can use the 'jpeg()' graphics device
?jpeg

# Open up a new JPEG graphics device
{
  jpeg() # use all the defaults
  
  # Create my plot
  plot(1:10, 1:10)
  points(1:10, 10:1, pch = 16, col = "lavender")
  
  # Closing the graphics device saves the plot
  dev.off()
}

# Customize from the defaults
{
  jpeg("my_plot.jpg", width = 7.25, height = 5, units = "in",
       res = 300, quality = 100) # use all the defaults
  
  # Create my plot
  plot(1:10, 1:10)
  points(1:10, 10:1, pch = 16, col = "lavender")
  
  # Closing the graphics device saves the plot
  dev.off()
}

# Save this at a low resolution
{
  jpeg("my_plot_low.jpg", width = 7.25, height = 5, units = "in",
       res = 300, quality = 10) # use all the defaults
  
  # Create my plot
  plot(1:10, 1:10)
  points(1:10, 10:1, pch = 16, col = "lavender")
  
  # Closing the graphics device saves the plot
  dev.off()
}

# With ggplot2 and ragg ----

# Create a ggplot
data("mtcars")
p <- ggplot(mtcars, aes(x = cyl, y = mpg, color = factor(gear))) +
  geom_point(size = 2)

# Save with the function ggsave()
ggsave("gg_plot.tif", plot = p, device = agg_tiff,
       width = 7.25, height = 5, units = "in",
       dpi = 300, compression = "lzw")

# Save without compression
ggsave("gg_plot_big.tif", plot = p, device = agg_tiff,
       width = 7.25, height = 5, units = "in",
       dpi = 300, compression = "none")
