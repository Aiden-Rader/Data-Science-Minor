# Section 6.4


# Example 1 ---------------------------------------------------------------

# 210 first-year college students were randomly assigned roommates

# For the 78 students assigned to roommates who brought a videogame to college: 
# average GPA after the first semester was 2.84, with a sd of 0.669.

# For the 132 students assigned to roommates who did not bring a videogame to college,
# average GPA after the first semester was 3.105, with a sd of 0.625.

# How much does getting assigned a  roommate who brings a videogame to college affect your first semester GPA? 
	
CI <- 0.90

x1_bar <- 2.84
x2_bar <- 3.105
s1 <- 0.669
s2 <- 0.625
n1 <- 78
n2 <- 132

alpha <- 0.05

# Check conditions first
cond1 <- n1 >= 30
cond2 <- n2 >= 30

df1 <- n1 - 1  # this is smaller so we use this
df2 <- n2 - 1

split <- (1 - CI) / 2
val <- 1 - split

# Find t*
t_score <- round(qt(p = val, df1), 3)

# Calc stat
x_bar <- x1_bar - x2_bar

# Calc SE
SE <- sqrt((s1^2 / n1) + (s2^2 / n2))
ME <- t_score * SE

# Calc CI
lower <- x_bar - ME
upper <- x_bar + ME

round(c(lower, upper), 3)

# Interpretation:
# We are 90% confident that getting assigned a roommate who brings a videogame 
# to college decreases the MEAN first semester GPA by between 0.11 to 0.42 points.


# Example 2 ---------------------------------------------------------------

# The Pygmalion Effect

