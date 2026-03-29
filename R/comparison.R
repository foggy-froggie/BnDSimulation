#Setup
source("R/simulate_bnd_fast.R")
library(tictoc)
library(dplyr)

# Running 50 trials for 17 birth probabilities
birth_rates <- seq(0.1, 0.9, by = 0.05)
n_rates <- length(birth_rates)

# Initialize results dataframe
results_r <- data.frame(
  birth_rate = birth_rates,
  r_mean = numeric(n_rates),
  r_sd = numeric(n_rates)
)

tic("Total R Simulation Time")

for (i in 1:n_rates) {
  b <- birth_rates[i]
  r_runs <- replicate(50, {
    sim <- simulate_bnd_fast(b, 1 - b, initial_pop = 100, max_time = 8)
  })

  # Calculate average and standard deviation from the 50 runs
  results_r$r_mean[i] <- mean(r_runs)
  results_r$r_sd[i] <- sd(r_runs)
}

toc()

# Load Python JSF benchmark results for comparison
results_py <- read.csv("Data/jsf_benchmark.csv")

# Round birth rates to 2 decimals to ensure the merge works
results_py$birth_rate <- round(results_py$birth_rate, 2)
results_r$birth_rate <- round(results_r$birth_rate, 2)

# Combine R and Python results into one table
comparison_df <- merge(results_r, results_py, by = "birth_rate")


# Difference in mean population
comparison_df$mean_diff <- (comparison_df$r_mean - comparison_df$py_mean) / comparison_df$r_mean

ggplot(comparison_df, aes(x = birth_rate, y = mean_diff)) +
  geom_point(size = 2.5, color = "blue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  coord_cartesian(clip = "off") +
  labs(
    title = "Difference in mean population for each probability of birth in relation to R results",
    y = "Relative Difference (%)",
    x = "Probability of birth"
  ) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank())


# Difference in standard deviation

# Reshape data to show the R noise vs Python noise side-by-side
std_long <- comparison_df %>%
  select(birth_rate, r_sd, py_sd) %>%
  pivot_longer(cols = c(r_sd, py_sd),
               names_to = "Model",
               values_to = "sd_value") %>%
  mutate(Model = ifelse(Model == "r_sd", "R Stochastic", "Python JSF"))

ggplot(std_long, aes(x = birth_rate, y = sd_value, color = Model, group = Model)) +
  geom_point(size = 2.5, alpha = 0.7) +
  labs(title = "Standard devation for probabilty of birth",
       y = "Standard deviation",
       x = "Probability of birth")+
  theme_minimal()



