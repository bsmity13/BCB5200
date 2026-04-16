# Spatial Data in R

# Load packages ----
library(sf)
library(terra)
library(rnaturalearth)
library(ggplot2)
library(dplyr)

# Load data ---
# Shapefile of universities
uni <- st_read("../data/BCB5200 Spatial Data/out/local_universities.shp")

# Load a raster (Digital Elevation Model = DEM)
elev <- rast("../data/BCB5200 Spatial Data/out/regional_DEM.tif")

# Load the cities (CSV file)
cities <- read.csv("../data/BCB5200 Spatial Data/out/cities.csv")

# Look at the shapefile ----
# Print it to see the data and some metadata
uni
# Check the class
class(uni)
# If you plot it, the default plot method plots all the
# columns
plot(uni)
# If you just want to plot the geometry, two ways:
plot(uni$geometry)
plot(st_geometry(uni))
# If you want the default plot for just one column,
# subset it with single brackets and quotes
plot(uni["enroll_25"], pch = 16)


# Look at the raster ----

# Print it to get some metadata
elev

# Plot with default method
plot(elev)

# Add to a plot
# Add the universities on top of the raster
plot(uni$geometry, add = TRUE, pch = 16, col = "white")

# Extract information about the raster with the points
terra::extract(elev, uni)

# Add the elevation to the university
uni$elev <- terra::extract(elev, uni)$elev

# Plot with ggplot2
ggplot(uni, aes(color = elev)) +
  geom_sf() +
  coord_sf() +
  labs(x = "Longitude", y = "Flatitude") + 
  theme_bw()

# How do we add the raster to the plot?
?terra::as.data.frame
elev_df <- as.data.frame(elev, xy = TRUE)
head(elev_df)

# Use ggplot to plot this data.frame
ggplot(elev_df, aes(x = x, y = y, fill = elev)) +
  geom_raster() +
  geom_sf(data = uni, inherit.aes = FALSE)

# Project to UTM ----
# Raster
elev_utm <- project(elev, "epsg:32611")
plot(elev_utm)

# Vector
uni_utm <- st_transform(uni, st_crs(32611))
plot(uni_utm$geometry, add = T, pch = 16, col = "white")

# We can make our cities data.frame into an 'sf' object
cities_utm <- st_as_sf(cities, coords = c("utm_e", "utm_n"),
                       crs = st_crs(32611))

# Add the cities to the raster
# I could do this two ways
# Spatial object
plot(cities_utm$geometry, add = TRUE, pch = 16, col = "lavender")

# I could have done this with the data.frame
points(cities$utm_e, cities$utm_n, pch = 16, cex = 0.5, col = "black")

# If you want help with plotting a raster, see
?terra::plot

# To control the legend limits:
plot(elev, range = c(0, 2500))

# Joins ----
# Sometimes we have "non-spatial" or implicitly spatial data,
# e.g., data related to a particular state or country that we 
# could map, but the data do not come with coordinates, per se.

# Get a map of US states from 'rnaturalearth'
states <- ne_states(country = "United States of America")
plot(states$geometry)

# Check this object out
class(states)
head(states)

# Subset to just the contiguous 48
states <- states %>% 
  dplyr::filter(!(postal %in% c("AK", "HI"))) %>% 
  select(postal)
plot(states$geometry)

# Useful for base R plotting
# We don't need any margins here (unless we want a title or add coords)
par(mar = c(0, 0, 0, 0))
plot(states$geometry)

# Make up some data
dat <- data.frame(state = c("ID", "WA", "MT", "OR", "FL", "TN"),
                  rating = c(10, 2, 8, 6, 5, 1))

# Join using dplyr::left_join()
state_dat <- left_join(states, dat, by = c("postal" = "state"))
head(state_dat)
plot(state_dat["rating"])

ggplot() +
  geom_sf(aes(fill = rating), data = state_dat) +
  geom_sf_label(aes(label = postal), data = state_dat)
