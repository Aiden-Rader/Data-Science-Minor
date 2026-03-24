# Section 8.1


# Example 1 ---------------------------------------------------------------

# Manually calculating ANOVA table in R
SSG <- 318
SSE <- 24984

k <- 3
df_group <- k - 1

n <- 72 + 74 + 52
df_error <- n - k

# Calcuate our mean squares
MSG <- SSG / (df_group)
MSE <- SSE / (df_error)

# Finding f stat with our MSG and MSE
f_stat <- MSG/MSE

p_val <- 1 - pf(f_stat, df_group, df_error)
p_val

# We would not have enough evidence to reject H0

# Using Base R ANOVA function in R

res <- anova()



# Example 2 ---------------------------------------------------------------

k <- 4
df_group <- k - 1

n <- c(36, 35, 20, 39)
n_tot <- sum(n)
df_error <- n_tot - k

s <- c(1.873, 2.795, 3.216, 2.361)
means <- c(64.25, 64.89, 69.15, 70.72)
overall_mean <- 67.12

SSE <- sum((n-1)*s^2)
SSG <- sum(n * (means - overall_mean)^2)

SST <- SSG + SSE

MSG <- SSG / df_group
MSE <- SSE / df_error

f_stat <- MSG / MSE
f_stat

p_val <- 1 - pf(f_stat, df_group, df_error)
p_val
