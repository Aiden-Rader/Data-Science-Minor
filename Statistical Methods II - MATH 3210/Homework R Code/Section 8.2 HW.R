# Homework R Code for Section 8.2


# Question 2 --------------------------------------------------------------

# pooled std s_p = sqrt(MSE)

s_p <- sqrt(6.31)

# df is just error df from 8.1 so n - k

n <- 15 
k  <- 3

df <- n - k


# Question 3 --------------------------------------------------------------


# Using the last questions values, find the CI for 95%

CI <- 0.95
alpha <- 1 - CI

x_a <- 10.5
n_a <- 5
s_p <- sqrt(6.59)

df <- 12

t_score <- qt(p = 1 - alpha / 2, df = df)

SE <- s_p / sqrt(n_a)
ME <- t_score * SE

# Find test stat
test_stat <- x_a / SE

# We need a two tailed p val (always for ANOVA)
p_val <- 2 * (1 - pt(abs(test_stat), df))

LL <- round(x_a - ME, 3)
UL <- round(x_a + ME, 3)

LL
UL


# Question 4 --------------------------------------------------------------

CI <- 0.90
alpha <- 1 - CI
df <- 12
t_score <- qt(p = 1 - alpha / 2, df = df)

x_b <- 16.7
n_b <- 5

x_c <- 11.1
n_c <- 5

MSE <- 5.54

s_p <- sqrt(MSE)
x_diff <- x_b - x_c

SE <- sqrt(MSE * ((1 / n_b) + (1/ n_c)))
ME <- t_score * SE

LL <- round(x_diff - ME, 3)
UL <- round(x_diff + ME, 3)

LL
UL


# Question 5 --------------------------------------------------------------

x_a <- 10.2
x_c <- 10.8
n_a <- n_c <- 5
df <- 12
t_score <- qt(p = 1 - 0.05 / 2, df = df)

MSE <- 7.32
s_p <- sqrt(MSE)
x_diff <- x_a - x_c

SE <- sqrt(MSE * ((1 / n_a) + (1/ n_c)))

ME <- t_score * SE

# Find test stat
test_stat <- x_diff / SE

# We need a two tailed p val (always for ANOVA)
p_val <- 2 * (1 - pt(abs(test_stat), df))

reject_H0 <- p_val <= 0.05
reject_H0

# Question 6 --------------------------------------------------------------

# The ANOVA table for the SandwichAnts data below indicates that there is a difference in mean number of ants among the three
# types of sandwich fillings. We know that the difference is significant between vegimite and ham & pickles, but not between vegemite
# and peanut butter. What about peanut butter vs ham & pickles? Test whether the difference in mean ant count is significant (at a 5%
# level) between those two fillings, using the information from the ANOVA. Do a pairwise test of 2 vs μ3, where /2 is the mean ant
# count for peanut butter and /3 is the mean ant count for ham & pickles. The sample means are T2 = 34.0 and T3 = 49.25.

alpha <- 0.05

x_2 <- 34.0
x_3 <- 49.25

MSE <- 138.7
s_p <- sqrt(MSE)

df_error <- 21
df_total <- 23

n <- df_total + 1
equal_size <- n / 3
n_2 <- n_3 <- equal_size

x_diff <- x_2 - x_3

SE <- sqrt(MSE * ((1 / n_2) + (1/ n_3)))

# Find test stat
test_stat <- x_diff / SE

# We need a two tailed p val (always for ANOVA)
p_val <- 2 * (1 - pt(abs(test_stat), df_error))

reject_H0 <- p_val <= 0.05
reject_H0

# Question 7 --------------------------------------------------------------

alpha <- 0.05

x_academy <- 70.52
x_nobel <- 72.21
x_olympic <- 67.25

n_academy <- 31
n_nobel <- 149
n_olympic <- 182

MSE <- 144
df_error <- 359

# Academy vs. Nobel
x_diff1 <- x_academy - x_nobel

SE1 <- sqrt(MSE * ((1 / n_academy) + (1/ n_nobel)))

# Find test stat
test_stat1 <- x_diff1 / SE1

# We need a two tailed p val (always for ANOVA)
p_val1 <- 2 * (1 - pt(abs(test_stat1), df_error))

reject_H01 <- p_val1 <= 0.05
reject_H01



# Academy vs. Olympic 
x_diff2 <- x_academy - x_olympic

SE2 <- sqrt(MSE * ((1 / n_academy) + (1/ n_olympic)))

# Find test stat
test_stat2 <- x_diff2 / SE2

# We need a two tailed p val (always for ANOVA)
p_val2 <- 2 * (1 - pt(abs(test_stat2), df_error))

reject_H02 <- p_val2 <= 0.05
reject_H02



# Nobel vs. Olympic
x_diff3 <- x_nobel - x_olympic

SE3 <- sqrt(MSE * ((1 / n_nobel) + (1/ n_olympic)))

# Find test stat
test_stat3 <- x_diff3 / SE3

# We need a two tailed p val (always for ANOVA)
p_val3 <- 2 * (1 - pt(abs(test_stat3), df_error))

reject_H03 <- p_val3 <= 0.05
reject_H03