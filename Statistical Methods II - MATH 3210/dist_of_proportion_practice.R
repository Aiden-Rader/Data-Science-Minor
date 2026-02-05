
# Example 1 ---------------------------------------------------------------

# The 2010 census reports that, of all the nation’s occupied housing units, 65.1% are owned by the occupants
# If we were to take random samples of 100 homes, what would the standard error of p_hat be?

p <-0.651
n <- 1000

# mu <- n * p
# sig <- sqrt(mu*(1-p))
se <- sqrt(p*(1-p)/n)

