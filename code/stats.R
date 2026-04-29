# Visualizing statistical models

# Load packages ----
library(ggplot2)
library(dplyr)

# Simulating a linear regression ----
# AKA, linear model

# Make-up our parameters
b0 <- 5
b1 <- -2
sigma <- 4

# Make-up some values of a covariate
set.seed(1)
x <- runif(n = 200, -2, 2)

# Our residuals
epsilon <- rnorm(n = length(x), mean = 0, sd = sigma)

# Calculate our response variable
y <- b0 + b1*x + epsilon

# Plot
plot(x, y)

# Put x and y in a data.frame
my_data <- data.frame(x = x, y = y)

# Analyze our data ----
m <- lm(y ~ x)
summary(m)

# Confidence intervals for the parameters
confint(m)

# Visualize our results ----
# Construct a data.frame for our plot
# Include:
#   - Point estimate (MLE)
#   - Uncertainty (95% confidence interval)
#   - A line at 0 to compare the uncertainty
#   - The truth (which we don't know if we didn't simulate)

# Point estimates:
coef(m)
# Confidence interval
confint(m)

betas <- data.frame(est = coef(m)) %>% 
  cbind(confint(m)) %>% 
  mutate(truth = c(b0, b1),
         params = c("b0", "b1"))

ggplot() +
  geom_errorbar(aes(x = params, ymin = `2.5 %`, ymax = `97.5 %`),
                data = betas, width = 0.25) +
  geom_point(aes(x = params, y = est),
             data = betas) +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed") +
  ylab("Estimate (95% CI)") +
  scale_x_discrete(name = "Parameters", 
                   breaks = c("b0", "b1"),
                   labels = expression(beta[0],
                                       beta[1])) +
  theme_bw()

# Model predictions
# For any x, I can calculate the "expected value" of the response

# What if x = 0.75?
coef(m)[[1]] + coef(m)[[2]] * 0.75

# The function in R that does this for us is called "predict()"
?predict
?predict.lm

# If we just do predict() on the model
predict(m)
# We get the prediction for all the data points that
# went into the model.

# You could calculate residuals like this:
y - predict(m)

# Alternatively, there's a function for that:
resid(m)

# But what we probably want here is to predict over "new" data.
# Make a data.frame of new values
pred_df <- data.frame(x = seq(-2, 2, length.out = 100))

# Make the prediction
pred_df$pred <- predict(m, newdata = pred_df)
head(pred_df)

# Draw a line
p <- ggplot() +
  geom_point(aes(x = x, y = y),
             data = my_data) +
  # Draw the line
  geom_line(aes(x = x, y = pred), 
            data = pred_df, color = "lavender",
            linewidth = 1) +
  theme_dark()

p

# Base R plot of this line
plot(x, y)
abline(m, col = "purple", lwd = 2)

# Add the confidence interval
# Make our prediction with the associated standard error
my_pred <- predict(m, newdata = pred_df, se.fit = TRUE)

# Add the standard errors to my data.frame
head(pred_df)
pred_df$se <- my_pred$se.fit

# Confidence interval is:
#   - the mean prediction
#   - plus or minus the critical value times the standard error

pred_df <- pred_df %>% 
  mutate(lwr = pred + qnorm(0.025) * se,
         upr = pred + qnorm(0.975) * se)

p +
  geom_ribbon(aes(x = x, ymin = lwr, ymax = upr),
              data = pred_df, fill = "lavender", color = "lavender",
              linetype = "dashed", alpha = 0.5)


