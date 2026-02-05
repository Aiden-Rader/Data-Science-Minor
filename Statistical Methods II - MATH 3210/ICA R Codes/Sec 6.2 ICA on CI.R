
# ICA 1 & 2 CI ----------------------------------------------------------------

# Eleven people were given 46 grams (1.6 ounces) of dark chocolate every day for two weeks, and their vascular
# health was measured before and after the two weeks. Larger numbers indicate greater vascular health, and the
# mean increase for the participants was 1.3 with a standard deviation of 2.32. Assume a dotplot shows the data
# are reasonably symmetric with no extreme values.

# Find and interpret a 90% confidence interval for the mean increase in this measure of vascular health after two 
# weeks of eating dark chocolate. Can we be 90% confident that the mean change for everyone would be positive?

n <- 11
x_bar <- 1.3
s <- 2.32
CI <- 0.90
df <- n - 1

# Find t*
t_score <- qt((1 + CI) / 2, df)

# Find the results given the data
res1 <- x_bar - t_score * s/sqrt(n)
res2 <- x_bar + t_score * s/sqrt(n)

list(res1, res2)

# 2.a Find the ME
SE <- s/sqrt(n)
ME <- t_score * SE

# 2.b What sample size is needed if we want a margin of error within ±0.5, with 90% confidence?
val <- 1 - ((1 - CI) / 2)
z <- round(qnorm(val), 3)

targ_ME <- 0.50
n_req <- (z * s / targ_ME)^2


# ICA 3 -------------------------------------------------------------------

# A survey of 1,917 cell phone users in May 2010 asked “On an average day, about how many cell phone calls do
# you make and receive on your cell phone?” The mean number of calls was 13.10, with a standard deviation of
# about 10.2. Find and interpret a 99% confidence interval for the mean number of cell phone calls for all cell
# phone users.

n <- 1917
x_bar <- 13.10
s <- 10.2
CI <- 0.99
df <- n - 1

# Find t*
t_score <- qt((1 + CI) / 2, df)

# Find ME
SE <- s/sqrt(n)
ME <- t_score * SE

# Finding the confidence interval
lower <- x_bar - ME
upper <- x_bar + ME
