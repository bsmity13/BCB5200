# Custom animations 

# Load packages ----
library(ggplot2)
library(dplyr)

# Simulate some data under a random walk ----
# Function sample data from a random walk.
rw <- function(id) {
  # Empty data.frame
  df <- data.frame(id = id, 
                   t = 1:30,
                   x = NA, y = NA)
  # Random starting location
  df$x[1] <- runif(1, min = -3, max = 3)
  df$y[1] <- runif(1, min = -3, max = 3)
  
  # Loop to "walk"
  for (t in 2:30) {
    df$x[t] <- df$x[t - 1] + rnorm(1)
    df$y[t] <- df$y[t - 1] + rnorm(1)
  }
  
  # Return
  return(df)
}

# Sample 3 individuals
set.seed(123456)
dat <- lapply(1:3, rw) %>% 
  bind_rows()

# Plot ----
# Draw line segments between points
dat %>% 
  group_by(id) %>% 
  mutate(xend = lead(x),
         yend = lead(y)) %>% 
  ggplot(aes(x = x, y = y, color = factor(id))) +
  geom_point() +
  geom_segment(aes(xend = xend, yend = yend))

# Draw our own animations ----
# There are 30 timesteps in the data
# Write a for() loop to write each of 30 frames.

# Draw a "tail" showing the last few locations
tail_length <- 3

# Make sure the folder exists to save the frames
dir.create("out")

for (i in 1:30){
  # Report status
  cat(i, "of", 30, "\n")
  
  # The first few frames have a shorter tail.
  if (i <= tail_length) {
    dat_sub <- dat %>% filter(t %in% 1:i)
  } else {
    # Subset the data
    dat_sub <- dat %>% 
      filter(t %in% (i - tail_length):i)
  }
  
  # Create column for transparency
  dat_sub <- dat_sub %>% 
    group_by(id) %>% 
    mutate(alpha = seq(from = 0, to = 1, length.out = n()))
  
  # Make the plot
  p <- dat_sub %>% 
    group_by(id) %>% 
    mutate(xend = lead(x),
           yend = lead(y)) %>% 
    ggplot(aes(x = x, y = y, color = factor(id), alpha = alpha)) +
    geom_point(size = 2) +
    geom_segment(aes(xend = xend, yend = yend)) +
    coord_equal(xlim = c(-10, 8),
                    ylim = c(-7, 9)) +
    ggtitle(paste0("t = ", i)) +
    theme_bw() +
    theme(legend.position = "none")
  
  # Save
  fn <- paste0("out/", stringr::str_pad(i, width = 2, 
                                        side = "left", pad = "0"),
               ".png")
  ggsave(filename = fn, plot = p, width = 6, height = 6, units = "in",
         dpi = 150)
}

# Animate using ImageMagick ----
# You could do this part straight in the terminal, or you could do it 
# from R and pass it to the system.

# I'm assuming Windows, but I think it works the same on Unix-like.

# This assumes ImageMagick is installed and on the system PATH.
# If it's not on the system path, you need the path to magick.exe.
# These commands are passed to the system.

# Delay gives the time the animation spends on each frame in milliseconds.

# This will make a relatively fast animation
cmd_fast <- "magick -delay 10 out/*.png out/move_anim_fast.gif"

# This will make a relatively slow animation
cmd_slow <- "magick -delay 50 out/*.png out/move_anim_slow.gif"

# Pass to system
shell(cmd_fast)
shell(cmd_slow)
