# Q1 — Normal Approximation to Binomial (P.5)
# A factory produces lightbulbs and 8% are defective. A shipment contains 200 bulbs.

n <- 200
p <- 0.08

# Can we use the normal approximation?
n * p >= 10
n * (1 - p) >= 10

# Yes we can! It passes both checks

# Find the mean and standard deviation.

mu <- n * p
mu # =  16


sig <- sqrt(mu * (1 - p))
sig # = 3.836665

# Approximate the probability that at least 20 bulbs are defective.
# x <- 20  # ATLEAST 20 so P(X >= 20) ~ P(Y >= 19.5)
x <- 19.5
z <- (x - mu) / sig
z # = 1.042572





# Question 2 --------------------------------------------------------------

# Q2 — One-Sample t Test (6.2)
# A nutrition label claims the average sodium content in a snack is 250 mg.
# A random sample of 18 bags gives:

# x_bar = 262, s = 30

# At α = 0.05, test whether the mean sodium content differs from 250 mg.

# You must:
# 1. State hypotheses
# 2. Compute test statistic
# 3. State df
# 4. State p-value setup (don’t need exact value)
# 5. Conclusion in context


# 0. Setup
x_bar <- 262
s <- 30
n <- 18
alpha <- 0.05
CI <- 1 - alpha

# Find value to put into p val function
split <- alpha / 2
val <- 1 - split  # = 0.975

# 1. State hypotheses

# H0: mu = 250
# Ha: mu =/ 250

# 2. Compute test stat
df <- n - 1  # = 17
# t <- qt(val, df)  # = 2.109816
# t
# 
SE <- s/sqrt(n)
# ME <- t * SE
# 
# LB <- x_bar - ME
# UB <- x_bar + ME
# 
# LB
# UB

# ALL WRONG DO NOT COMPUTE t* for Hypothesis!! 

t_stat <- x_bar - 250 / SE

# (247.0814, 276.9186)

# 3. State df
#  df = 17

# 4. State p-value setup (don’t need exact value)
p_val <- 2 * (1 - pt(abs(t), df))

# 5. Conclusion in context
reject_H0 <- p_val < alpha
reject_H0  # Fail to reject the null hypotheiss

# Interpretation:
# According to our data, there does not appear to be sufficient evidence that
# the mean sodium content differs from 250 mg.


# Question 3 --------------------------------------------------------------

# Q3 — Two Proportions Test (6.3)
# In a survey:
#	90 out of 150 college students prefer online exams.
#	60 out of 120 high school students prefer online exams.

# Test whether the proportions differ at α = 0.05.

# 1. Is pooling required?
# 2. Write the test statistic formula.
# 3. What is the df? (trick question)
# 4. What distribution do we use?

# 0. Setup
x1 <- 90
n1 <- 150
p1 <- x1/n1

x2 <- 60
n2 <- 120
p2 <- x2/n2

# MUST USE POOLING 
p_hat <- x1 + x2 / n1 + n2

			  
# checks
n1 * p1 >= 10
n1 * (1 - p1) >= 10

n2 * p2 >= 10
n2 * (1 - p2) >= 10

# All passed

# 1.
# Yes for the hypothesis testing yes it is require

# 2. 
var1 <- (p_hat * (1 - p_hat)) / n1
var2 <- (p_hat * (p_hat)) / n2

SE <- sqrt(var1 + var2)
z <- (p1 - p2) / SE

p_val <- 2 * (1 - pnorm(abs(z)))

# What is df?
# z test stat does not need or have a degree of freedom value

# What distribution do we use?
# normal distribution using z score


# Question 4 --------------------------------------------------------------

# Q4 — Paired t Test (6.5)

# A group of 12 students take a practice exam before and after tutoring.
# The mean difference (After − Before) is:

# x_bar_D = 5.4, s_D = 6.0

# At α = 0.05, test whether tutoring increases scores.
# 1. State hypotheses.
# 2. Compute test statistic.
# 3. df?
# 4. Distribution used?
# 5. Tail?

x_bar_D <- 5.4
s_D <- 6.0
n <- 12
alpha <- 0.05

# 1. state hypothesis

# REMEBER TO WRITE HYPOTHESIS AS mu_D NOT mu!!!
# H0: mu_D = 0
# Ha: mu_D > 0

# 2. Compute test stat
SE <- s_D / sqrt(n)
SE # = 1.732051

t <- x_bar_D / SE
t # = 3.117691

# 3. DF
df <- n - 1  # 11

# 4. Dist used

# t distribution is used for paired means

# 5. Tail?

# Righ tailed! so it should be a 

p_val <- 1 - pt(t, df)
p_val  # = 0.00489511

p_val < alpha

# Reject H0

# We have sufficient evidence that tutoring increases scores given our
# data.


# Question 5 --------------------------------------------------------------

# Q5 — Chi-Square Association (7.2)

# A study records:

male <- c(tea = 40, coffee = 60)
female <- c(tea = 70, coffee = 30)

# 1. What is the expected count for Male & Tea?
# 2. df?
# 3. State H₀.
# 4. Is this ever left-tailed?
# 5. If χ² = 16.0, what would that imply about the p-value (qualitatively)?

obs <- rbind(male, female)

row_total <- rowSums(obs)
row_count <- nrow(obs)

col_total <- colSums(obs)
col_count <- ncol(obs)

n <- sum(obs)

# 1. What is the expected count for Male & Tea?
exp_counts <- outer(row_total, col_total) / n
round(exp_counts, 2)  # = 55 for male tea

# 2. df?
df <- (row_count - 1) * (col_count - 1)  # (r - 1) * (c - 1)

# 3. State H0

# The two variables male and tea do NOT have an association between them

# 4. Is this ever left-tailed?

# No, Chi-sqaured is ALWAYS rigth tailed

# 5. If χ² = 16.0, what would that imply about the p-value (qualitatively)?

# the p_val would most likely be smaller