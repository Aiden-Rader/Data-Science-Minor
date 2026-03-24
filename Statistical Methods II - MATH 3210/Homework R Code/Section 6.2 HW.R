# Homework R Code


# Question 1 --------------------------------------------------------------

# If random samples of size 1200 are drawn from a population with mean 27 and standard deviation 6, find the standard error of the
# distribution of sample means.

x_bar <- 27
s <- 6
n <- 1200

SE <- round(s/sqrt(n), 3)


# Question 2 --------------------------------------------------------------

# If random samples of size 11 are drawn from a population with mean 7 and standard deviation 2, find the standard error of the
# distribution of sample means.

x_bar <- 7
s <- 2
n <- 11

SE <- round(s/sqrt(n), 3)


# Question 3 --------------------------------------------------------------

# Assume the sample is a random sample from a distribution that is reasonably normally distributed and we are doing inference for a
# sample mean. Find endpoints of a t-distribution with 5% beyond them in each tail if the sample has size n = 10.

n <- 10
df <- n - 1
CI <- 1 - (0.05 * 2)

t_score <- round(qt((1 + CI) / 2, df), 3)


# Question 4 --------------------------------------------------------------

# Assume the sample is a random sample from a distribution that is reasonably normally distributed and we are doing inference for a
# sample mean. Find endpoints of a t-distribution with 1% beyond them in each tail if the sample has size n = 19.

n <- 19
df <- n - 1
CI <- 1 - (0.01 * 2)

t_score <- round(qt((1 + CI) / 2, df), 3)


# Question 5 --------------------------------------------------------------

# Assume the sample is a random sample from a distribution that is reasonably normally distributed and we are doing inference for a
# sample mean. Find the area in a t-distribution above 2.3 if the sample has size n = 6.

n <- 6
df <- n - 1
t_score <- 2.3

res <- round(pt(t_score, df, lower.tail = FALSE), 3)


# Question 6 --------------------------------------------------------------

# Assume the sample is a random sample from a distribution that is reasonably normally distributed and we are doing inference for a
# sample mean. Find the area in a t-distribution below -3.2 if the sample has size n = 50.

n <- 50
df <- n - 1
t_score <- -3.2

res <- round(pt(t_score, df), 3)

# NOTE:
# Area Below (Left tail),P(T≤t),"pt(t_score, df)"
# Area Above (Right tail),P(T>t),"pt(t_score, df, lower.tail = FALSE)" <- also similar to 1 - pt()


# Question 7 --------------------------------------------------------------

# Use the t-distribution to find a confidence interval for a mean u given the relevant sample results. Give the best point estimate for u,
# the margin of error, and the confidence interval. Assume the results come from a random sample from a population that is
# approximately normally distributed.
# 
# A 95% confidence interval for u using the sample results x_bar = 94.3, s = 6.9, and n = 42
# 
# Round your answer for the point estimate to one decimal place, and your answers for the margin of error and the confidence interval
# to two decimal places.

n <- 42
s <- 6.9
x_bar <- 94.3  # <- this is the point est. retard
CI <- 0.95
df <- n - 1

# Find t*
t_score <- qt((1 + CI) / 2, df)

SE <- s/sqrt(n)
ME <- round(t_score * SE, 2)

# Find the results given the data
lower <- round(x_bar - ME, 2)
upper <- round(x_bar + ME, 2)

list(lower, upper)


# Question 8 --------------------------------------------------------------

# Forest Fires in Portugal A study of forest fires in Portugal looked at the effect of many variables on the area of forest that is burned
# by the fire. The study included 517 forest fires and found a mean area burned of 12.85 hectares with a standard deviation of 63.66.
# (The standard deviation is much bigger than the mean because the data is very right-skewed.) Find and interpret a 90% confidence
# interval for the mean area burned by all forest fires in Portugal.

n <- 517
s <- 63.66
x_bar <- 12.85
CI <- 0.90
df <- n - 1

# Find t*
t_score <- qt((1 + CI) / 2, df)

SE <- s/sqrt(n)
ME <- round(t_score * SE, 2)

# Find the results given the data
lower <- round(x_bar - ME, 2)
upper <- round(x_bar + ME, 2)

list(lower, upper)


# Question 9 --------------------------------------------------------------

# How Many Hours on a Computer? Exercise 1.24 introduces the dataset PASeniors which includes many variables on a sample of high
# school seniors in Pennsylvania. One of the variables is ComputerHours, which gives the number of hours the student spent on a
# computer during the previous week. In the sample, 447 students answered the question, and the sample mean was 16.740 hours with
# a standard deviation of 17.688. Find and interpret a 99% confidence interval for the mean number of hours per week that high school
# seniors in Pennsylvania spend on the computer.

n <- 447
s <- 17.688
x_bar <- 16.740
CI <- 0.99
df <- n - 1

# Find t*
t_score <- qt((1 + CI) / 2, df)

SE <- s/sqrt(n)
ME <- round(t_score * SE, 2)

# Find the results given the data
lower <- round(x_bar - ME, 3)
upper <- round(x_bar + ME, 3)

list(lower, upper)



# Question 10 -------------------------------------------------------------

# Use the t-distribution and the sample results to complete the test of the hypotheses. Use a 5% significance level. Assume the results
# come from a random sample, and if the sample size is small, assume the underlying distribution is relatively normal.
# 
# Test Ho: u = 15 vs Ha: u > 15 using the sample results = 17.2, s = 6.4, with n = 40.

s <- 6.4
n <- 40
x_bar <- 17.2
mu0 <- 15
alpha <- 0.05

# use t-test stat
SE <- s/sqrt(n)
test_stat <- round((x_bar - mu0)/SE, 2)

# Calc degree of freedom
df <- n - 1

# Left tailed!
p_val <- round(pt(test_stat, df, lower.tail = FALSE), 2)

# Should we reject H0?
reject_H0 <- p_val <= alpha
reject_H0


# Question 11 -------------------------------------------------------------

# Autistic children often have a small head circumference at birth, followed by a sudden and excessive increase in head circumference
# during the first year of life. A recent study examined the brain tissue in autopsies of seven autistic male children between the ages of
# 2 and 16. The mean number of neurons in the prefrontal cortex in non-autistic male children of the same age is about 1.15 billion. The
# prefrontal cortex is the part of the brain most disrupted in autism, as it deals with language and social communication.

# In the sample of seven autistic children, the mean number of neurons in the prefrontal cortex was 1.94 billion with a standard deviation of 0.50 billion.
# The values in the sample are not heavily skewed. Use the t-distribution to test whether this sample provides evidence that autistic
# male children have more neurons (on average) in the prefrontal cortex than non-autistic children.

n <- 7
x_bar <- 1.94
s <- 0.50
mu0 <- 1.15
alpha <- 0.05

# use t-test stat
SE <- s/sqrt(n)
test_stat <- round((x_bar - mu0)/SE, 2)

# Calc degree of freedom
df <- n - 1

# Left tailed!
p_val <- round(pt(test_stat, df, lower.tail = FALSE), 2)

# Should we reject H0?
reject_H0 <- p_val <= alpha
reject_H0


# Question 12 -------------------------------------------------------------

# In a study1 conducted in Paris, France, equal amounts of pigeon feed were spread on the ground in two adjacent locations. A person
# was present in both sites, with one acting hostile and running at the birds to scare them away and the other acting neutral and just
# observing. The two people were randomly exchanged between the two sites throughout and the birds quickly learned to avoid the
# hostile person's site and to eat at the site of the neutral person. At the end of the training session, both people behaved neutrally but
# the birds continued to remember which one was hostile. In the most interesting part of the experiment, when the two people
# exchanged coats (orange worn by the hostile one and yellow by the neutral one throughout training), the pigeons were not fooled and
# continued to recognize and avoid the hostile person.

# The quantity measured is difference in number of pigeons at the neutral site minus the hostile site. With n = 32 measurements,
# the mean difference in number of pigeons is 3.9 with a standard deviation of 6.8. Test to see if this provides evidence that the mean
# difference is greater than zero, meaning the pigeons can recognize faces (and hold a grudge!)

n <- 32
x_bar <- 3.9
s <- 6.8
mu0 <- 0
alpha <- 0.05

# use t-test stat
SE <- s/sqrt(n)
test_stat <- round((x_bar - mu0)/SE, 2)

# Calc degree of freedom
df <- n - 1

# Right tailed!
p_val <- round(pt(test_stat, df, lower.tail = FALSE), 3)

# Should we reject H0?
reject_H0 <- p_val <= alpha
reject_H0