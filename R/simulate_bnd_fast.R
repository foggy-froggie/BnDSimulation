#' Simulate a Linear Birth-Death Process
#'
#' @description
#' @description
#' A high-performance version of the birth-death simulation. Unlike the standard
#' version, this function does not store the population history. It only tracks
#' the final state for faster simulations
#'
#' @param p_birth Numeric. The individual birth rate.
#' @param p_death Numeric. The individual death rate.
#' @param initial_pop Integer. The starting population size.
#' @param max_time Numeric. The total duration of the simulation.
#' @param seed Integer. Optional seed for reproducibility.
#'
#' @return Integer. The final population count at max_time or extinction.
#' @export

simulate_bnd_fast <- function(p_birth, p_death, initial_pop, max_time, seed = NULL) {

  # Set seed if provided
  if (!is.null(seed)) set.seed(seed)

  # Initialize current state
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
  }
  return(current_n)
}
