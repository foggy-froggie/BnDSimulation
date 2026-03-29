set.seed(1)

p_birth <- 0.2
p_death <- 0.2
p_no_event <- 1 - p_birth - p_death
steps <- 100
population <- 1

for (i in 1:steps) {
  if(tail(population, 1) > 0) {
    temp <- sample (x = c(-1, 0, 1),
                    size = 1,
                    prob = c(p_death, p_no_event, p_birth))
    population <- c(population, tail(population, 1) + temp)
    next
  }

  if(tail(population, 1) == 0){
    temp <- sample (x = c(0,1),
                    size = 1,
                    prob = c(p_no_event/(p_no_event + p_birth), p_birth/(p_no_event + p_birth)))
    population <- c(population, tail(population, 1) + temp)
  }
}

plot(population, type = "l")
