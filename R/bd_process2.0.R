set.seed(0)

p_birth <- 0.2
p_death <- 0.2
p_no_event <- 1 - p_birth - p_death
steps <- 100
population <-numeric(steps + 1)
population[1] = 100

for (i in 1:steps) {
  current_pop <- population[i]
  if(current_pop == 0) {
    population[i+1] <- 0
  } else {
    births <- rbinom(1,current_pop,p_birth)
    deaths <- rbinom(1,current_pop,p_death)

    population[i+1] <- current_pop + births - deaths
  }
}

plot(population,type = "l")




