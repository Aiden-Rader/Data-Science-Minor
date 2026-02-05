# Author: Aiden Rader
# Date: 1/25/2026
# Assignment: Homework Section P.4


# Question 10 -------------------------------------------------------------

# Find P(X = 7) if X is a binomial random variable with n = 8 and p = 0.9
# Round answer to three decimal places

k <- 7
n <- 8
p <- 0.9

res <- round(dbinom(k, n, p), digits = 3 )  # use dbinom(k,n,p) for binomial probability

# Question 11 -------------------------------------------------------------

# Calculate the mean and standard deviation of a binomial random variable with n = 8 and p = 0.4.
# Enter the exact answer for the mean, and round your answer for the standard deviation to three decimal places.

n <- 8
p <- 0.4

mu <- n*p
sig <- round(sqrt(mu*(1-p)), digits = 3)


# Question 12 -------------------------------------------------------------

# Worldwide, the proportion of babies who are boys is about 0.51. A couple hopes to have 3 children and we assume that the sex of each
# child is independent of the others. Let the random variable X represent the number of girls in the three children, so X might be 0, 1, 2,
# or 3. Give the probability function for each value of X.

x <- 0:3
n <- 3  # number of trials
p_boy <- 0.51  # given prob of success with boys
p_girl <- 1 - 0.51  # calc prob success with girls

res <- dbinom(x, n, p_girl)
res <- round(res, 3)


# Question 13 -------------------------------------------------------------

# From the US Census, we learn that 27.5% of US adults have graduated from college. If we take a random sample of 10 US adults,
# what is the probability that exactly 5 of them are college graduates?

# Round your answer to three decimal places.

x <- 5
n <- 10
p_grads <- 0.275

res <- dbinom(x, n, p_grads)
res <- round(res, 3)

# Question 14 -------------------------------------------------------------

# In the US Census, we learn that 13% of all people in the US are 65 years old or older. If we take a random sample
# of 10 people, what is the probability that 3 of them are 65 or older? What is the probability that 4 of them are 65
# or older?

n <- 10
p <- 0.13

res_3 <- round(dbinom(3, n, p), 3)
res_4 <- round(dbinom(4, n, p), 3)

# Question 15 -------------------------------------------------------------
# 
# Worldwide, the proportion of babies who are girls is about 0.49 . Let the random variable X represent the number
# of girls in six children. Find the mean and standard deviation of this random variable.

n <- 6
p <- 0.49

mu <- n*p
sig <- round(sqrt(mu*(1-p)), digits = 3)

# Question 16 -------------------------------------------------------------

# From the 2010 US Census, we learn that 27.5% of US adults have graduated from college. Let the random
# variable X represent the number of college graduates in a random sample of 10 US adults. Find the mean and
# standard deviation of this random variable.

n <- 10
p <- 0.275

mu <- n*p
sig <- round(sqrt(mu*(1-p)), digits = 3)