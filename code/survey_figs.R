# Survey figures

# Load packages
library(tidyverse)
library(patchwork)

# Q1: What's your favorite R color?

cols <- c("lavender", "blanchedalmond", 
          "hotpink", "chartreuse", 
          "peachpuff3", "gray73")


png("img/Rcolors.png", width = 10, height = 5, units = "in", res = 200)
par(las = 3, mar = c(4, 0, 0, 0))
plot(NA, xlim = c(0.5, 6.5), ylim = c(0, 1),
     axes = FALSE, xlab = NA, ylab = NA)
points(1:6, rep(0.75, 6), pch = 15, col = cols,
       cex = 15)
axis(1, at = 1:6, labels = cols, line = -9, cex.axis = 1.5)
dev.off()

# Colors by themselves
for (i in 1:length(cols)){
  png(paste0("img/color", i, ".png"), width = 1, height = 1, units = "in", res = 72)
  par(bg = cols[i], mar = c(0, 0, 0, 0))
  plot(NA, xlim = c(0, 1), ylim = c(0, 1),
       axes = FALSE, xlab = NA, ylab = NA)
  dev.off()
}


# Q2: Which is the best regression model?
sw <- starwars %>% 
  filter(!(is.na(mass)),
         mass < 500) %>% 
  ggplot(aes(x = height, y = mass)) +
  geom_point() +
  labs(x = "Height (cm)", y = "Mass (kg)") +
  theme_bw()

lmp <- sw +
  geom_smooth(method = "lm") +
  ggtitle("LM")

glmp <- sw +
  geom_smooth(method = "glm", method.args = list(family = "Gamma")) +
  ggtitle("GLM (Gamma)") +
  labs(y = NULL)

gamp <- sw +
  geom_smooth(method = "gam") +
  ggtitle("GAM") +
  labs(y = NULL)

mods <- lmp + glmp + gamp +
  plot_annotation(title = "Starwars Data",
                  subtitle = "Height & Mass") &
  coord_cartesian(ylim = c(0, 175)) &
  theme(text = element_text(size = 16))

ggsave("img/sw_models.png", plot = mods, 
       width = 10, height = 4, units = "in", dpi = 200)
