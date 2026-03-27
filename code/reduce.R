# Reducing items and attributes

library(tidyverse)

# Penguins dataset
head(penguins)

# Explore! ----
# aka, plot them all
plot(penguins$bill_len, penguins$bill_dep)
plot(penguins$bill_len, penguins$flipper_len)
plot(penguins$bill_len, penguins$body_mass)

# Could plot them all
penguins %>% 
  select(bill_len, bill_dep, body_mass,
         flipper_len) %>% 
  plot()

# Correlation coefficients
penguins %>% 
  select(bill_len, bill_dep, body_mass,
         flipper_len) %>% 
  cor(use = "complete.obs")

# Plot the least correlated two
# with a custom palette
palette(c("lavender", "yellow", "blue"))
plot(penguins$bill_len, penguins$bill_dep,
     pch = 16, 
     col = factor(penguins$species))

# Plot the two most correlated
plot(penguins$body_mass, penguins$flipper_len,
     pch = 16, 
     col = factor(penguins$species))

# Reset to the default palette
palette("default")

# Aggregate items ----
# Plot bill depth and bill length with means/SDs for species
penguins %>% 
  group_by(species) %>% 
  summarize(mean_bill_dep = mean(bill_dep, na.rm = TRUE),
            sd_bill_dep = sd(bill_dep, na.rm = TRUE),
            mean_bill_len = mean(bill_len, na.rm = TRUE),
            sd_bill_len = sd(bill_len, na.rm = TRUE)) %>% 
  mutate(bill_dep_lwr = mean_bill_dep - sd_bill_dep,
         bill_dep_upr = mean_bill_dep + sd_bill_dep,
         bill_len_lwr = mean_bill_len - sd_bill_len,
         bill_len_upr = mean_bill_len + sd_bill_len) %>% 
  ggplot(aes(x = mean_bill_len, y = mean_bill_dep,
             color = species)) +
  # length errorbars
  geom_errorbar(aes(xmin = bill_len_lwr,
                    xmax = bill_len_upr)) +
  # depth errorbars
  geom_errorbar(aes(ymin = bill_dep_lwr,
                    ymax = bill_dep_upr)) +
  # Add the points
  geom_point(size = 2) +
  xlab("Bill Length") +
  ylab("Bill Depth") +
  theme_bw()

# Some ggplot geoms do the summarizing for you:
penguins %>% 
  ggplot(aes(x = bill_len, y = bill_dep,
             color = species)) +
  # Contour plot
  geom_density_2d() +
  xlab("Bill Length") +
  ylab("Bill Depth") +
  theme_bw()

# Aggregate attributes ----
# In base R, use this function for PCA:
?prcomp

# Fit the PCA
pca <- prcomp(~ bill_len + bill_dep + flipper_len +
                body_mass,
              data = penguins)

# Default plot shows the variance for each component
plot(pca)
axis(1)
mtext("Principal Component", side = 1, line = 3)

# Summary shows the variances and the % variance
summary(pca)

# Function to plot the biplot
biplot(pca)

# Get the predicted PCs for each row of data
pred <- predict(pca, penguins)
penguins <- cbind(penguins, pred)

# Plot density of PC1 for each species
ggplot(penguins, aes(x = PC1, color = species)) +
  geom_density() +
  theme_bw()
