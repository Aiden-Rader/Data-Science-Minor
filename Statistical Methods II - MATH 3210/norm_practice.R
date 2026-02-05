# init practice
q <- 1.4

print(1 - pnorm(q))

# Example 2 ---------------------------------------------------------------


# Suppose that verbal SAT scores for applicants at a college 
# follow a normal distribution with mean µ = 580 and std. dev. σ =70.
# What proportion of applicants have SAT scores above 700?

mean <- 580
std <- 70
q <- 700

print(1 - pnorm(q, mean = mean, sd = std))

# Example 3 ---------------------------------------------------------------

# Suppose that the distribution of student heights follows a 
# normal density with a mean of 68 inches and standard deviation of 4 inches.
# Find a height so that just 10% of students are shorter than that endpoint.

mean <- 68
std <- 4
q <- 0.1

print(qnorm(q, mean = mean, sd = std))  # use qnorm instead for the inverse due to the phrase "shorter than that endpoint"

# Example 4 ---------------------------------------------------------------


# What is the area below 70 in a N(100,20) distribution?

mean <- 100
std <- 20
q <- 70

print(pnorm(q, mean, std))

# Example 5 ---------------------------------------------------------------

# What is the endpoint for N(100,20) if the area to the right (above it) it is 0.04 ?

mean <- 100
std <- 20
q <- 1 - 0.04  # we are looking ABOVE the area

print(qnorm(q, mean, std))

# Example 6 ---------------------------------------------------------------

# Suppose that the distribution of student heights follows a 
# normal density with a mean of 68 inches and standard deviation of 4 inches.
# Find a height so that just 10% of students are shorter than that endpoint.

# USING STANDARD NORM DIST.

mean <- 68
std <- 4
q <- 0.1

# 1 - pnorm(65, 68, 4)  you can use this but we can also just calc the z score

z <- qnorm()

print(qnorm(q, mean = mean, sd = std))


# Example 7 ---------------------------------------------------------------

# Find the 25%-tile for the Verbal SAT~N(580,70) distribution using N(0,1)

mean <- 580
std <- 70
q <- 0.25

z <- qnorm(q)

# Example 8 ---------------------------------------------------------------

# What is the endpoint z in a standard normal distribution if the area between z and –z is 0.60?

area_between <- 0.6
