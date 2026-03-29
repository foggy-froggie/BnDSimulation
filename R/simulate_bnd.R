#' Simulate a Linear Birth-Death Process
#'
#' @description
#' Performs a continuous-time stochastic simulation of a population
#' where birth and death rates scale linearly with the population size.
#'
#' @param p_birth Numeric. The individual birth rate.
#' @param p_death Numeric. The individual death rate.
#' @param initial_pop Integer. The starting population size.
#' @param max_time Numeric. The total duration of the simulation.
#' @param seed Integer. Optional seed for reproducibility.
#'
#' @return A data frame containing two columns: 'time' and 'count'.
#' @example
#' my_data <- simulate_bnd(
#'p_birth = 0.1,
#'p_death = 0.15,
#'initial_pop = 20,
#'max_time = 50
#')
#'
#'plot(my_data$time, my_data$count,
#'     type = "s",
#'     main = "Stochastic Birth-Death Simulation",
#'     xlab = "Time", ylab = "Population Count")
#' @export
simulate_bnd <- function(p_birth, p_death, initial_pop, max_time, seed = NULL) {

  # Set seed if provided
  if (!is.null(seed)) set.seed(seed)

  # Initialize vectors to store the history of the simulation
  times <- 0
  counts <- initial_pop

  current_t <- 0
  current_n <- initial_pop

# Loop until max_time is reached or population goes extinct
  while (current_t < max_time && current_n > 0) {

    # Calculate combined rate of any event occurring
    total_rate <- (p_birth + p_death) * current_n

    # Determine time until next event using an exponential distribution
    dt <- rexp(1, rate = total_rate)
    current_t <- current_t + dt

    # Determine if the event is a birth (+1) or a death (-1)
    event <- sample(c(1, -1), size = 1, prob = c(p_birth, p_death))
    current_n <- current_n + event

    # Append new data to history vectors
    times <- c(times, current_t)
    counts <- c(counts, current_n)
  }

  # Format results as a dataframe
  results <- data.frame(time = times, count = counts)

  # Ensure the final time point is exactly max_time (for cleaner plotting)
  if(tail(results$time, 1) > max_time) {
    results$time[nrow(results)] <- max_time
  }

  return(results)
}

