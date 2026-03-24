# Question 1 --------------------------------------------------------------

# Consider random samples of size 90 drawn from population A with proportion 0.22 and random samples of size 45 drawn from
# population B with proportion 0.34.

pA <- 0.22
nA <- 90

pB <- 0.34
nB <- 45

# A.) 
varA <- (pA * (1 - pA)) / nA
varB <- (pB * (1 - pB)) / nB

SE <- round(sqrt(varA + varB), 3)


# B.) must pass n * p >= 10 and n * (1 - p) >= 10 for both

# for a
first_test_A <- nA * pA
second_test_A <- nA * (1 - pA)

# for b
first_test_B <- nB * pB
second_test_B <- nB * (1 - pB)


# Question 2 --------------------------------------------------------------

# Consider random samples of size 58 drawn from population A with proportion 0.79 and random samples of size 74 drawn from
# population B with proportion 0.69.

pA <- 0.79
nA <- 58

pB <- 0.69
nB <- 74

# A.) 
varA <- (pA * (1 - pA)) / nA
varB <- (pB * (1 - pB)) / nB

SE <- round(sqrt(varA + varB), 3)


# B.) must pass n * p >= 10 and n * (1 - p) >= 10 for both

# for a
first_test_A <- nA * pA
second_test_A <- nA * (1 - pA)

# for b
first_test_B <- nB * pB
second_test_B <- nB * (1 - pB)


# Question 5 --------------------------------------------------------------

# Use the normal distribution to find a confidence interval for a difference in proportions p1 - p2 given the relevant sample results.
# Assume the results come from random samples.

# A 90% confidence interval for p1 - P2 given that p1 = 0.74 with n1 = 460 and p2 = 0.69 with n2 = 300

CI <- 0.90

p1 <- 0.74
n1 <- 460

p2 <- 0.69
n2 <- 300

leaves <- 1 - CI
split <- leaves/2
val <- 1 - split
z <- round(qnorm(val), 3)

# Best Est.
p_res <- p1 - p2

# Margin of Error
var1 <- (p1 * (1 - p1)) / n1
var2 <- (p2 * (1 - p2)) / n2

SE <- round(sqrt(var1 + var2), 3)
ME <- round(z * SE, 3)

# Confidence Interval
lower <- round(p_res - ME, 3)
upper <- round(p_res + ME, 3)


# Question 6 --------------------------------------------------------------

# In a randomly selected sample of 2237 US adults, 1754 identified themselves as people who use the Internet regularly while the other
# 483 indicated that they do not use the Internet regularly. In addition to Internet use, participants were asked if they agree with the
# statement "most people can be trusted." The results show that 807 of the Internet users agree with this statement, while 130 of the
# non-users agree.

# Find a 95% confidence interval for the difference in the two proportions, pI - pN, where pI is the proportion for the internet users
# who agree with the statement and pN is the proportion for the non-internet users who agree with the statement.

CI <- 0.95

nI <- 1754
pI <- 807 / nI
	
nN <- 483
pN <- 130 / nN

leaves <- 1 - CI
split <- leaves/2
val <- 1 - split
z <- round(qnorm(val), 3)

# Best Est.
p_res <- pI - pN

# Margin of Error
var1 <- (pI * (1 - pI)) / nI
var2 <- (pN * (1 - pN)) / nN

SE <- round(sqrt(var1 + var2), 3)
ME <- round(z * SE, 3)

# Confidence Interval
lower <- round(p_res - ME, 3)
upper <- round(p_res + ME, 3)


# Question 7 --------------------------------------------------------------

CI <- 0.90

nF <- 1423
pF <- round(726 / nF, 3)

nM <- 1329
pM <- round(505 / nM, 3)

leaves <- 1 - CI
split <- leaves/2
val <- 1 - split
z <- round(qnorm(val), 3)

# Best Est.
p_res <- pF - pM

# Margin of Error
var1 <- (pF * (1 - pF)) / nF
var2 <- (pM * (1 - pM)) / nM

SE <- round(sqrt(var1 + var2), 3)
ME <- round(z * SE, 3)


# Confidence Interval
lower <- round(p_res - ME, 2)
upper <- round(p_res + ME, 2)


# Question 8 --------------------------------------------------------------

# Test whether there is a difference between two groups in the proportion who voted, if 45 out of a random sample of 70 in
# Group 1 voted and 56 out of a random sample of 100 in Group 2 voted.
n1 <- 70
x1 <- 45
p1 <- round(x1 / n1, 3)

n2 <- 100
x2 <- 56
p2 <- round(x2 / n2, 3)

alpha <- 0.05

num <- x1 + x2
den <- n1 + n2

p <- round(num / den, 3)

# H0: p1 = p2; Ha: p1 =/ p2;
null_parameter <- 0

# MoE
var1 <- (p * (1 - p)) / n1
var2 <- (p * (1 - p)) / n2

SE <- sqrt(var1 + var2)


# Finding test statistic Z
test_stat <- round((sample_statistic - null_parameter) / SE, 2)

# finding p value, this is an "ok" way of doing it, more in line with how we usually do it
p_val <- 2 * pnorm(abs(test_stat), lower.tail = FALSE)

# Here is another way to find the p value the "pro strat" way
# results <- prop.test(x = c(x1, x2), n = c(n1, n2), correct = FALSE)

# Question 9 --------------------------------------------------------------


