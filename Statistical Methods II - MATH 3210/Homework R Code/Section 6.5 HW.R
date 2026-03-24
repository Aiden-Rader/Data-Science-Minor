# Homework R Code


# Question 1 --------------------------------------------------------------
 
# Use a t-distribution to find a confidence interval for the difference in means ud = 1 - 2 using the relevant sample results
# from paired data. Assume the results come from random samples from populations that are approximately normally distributed,
# and that differences are computed using d = x1 - x2.

# A 95% confidence interval for u a using the paired difference sample results T d = 1.1, sd = 2.4, nd = 30.

# Give the best estimate for ud, the margin of error, and the confidence interval.

# Enter the exact answer for the best estimate, and round your answers for the margin of error and the confidence interval to two
# decimal places.

x_bar_d <- 1.1
sd_d <- 2.4
n_d <- 30
df <- n_d - 1

CI <- 0.95
alpha <- 1 - CI

mu_d <- x_bar_d
t_score <- qt(p = 1 - alpha / 2, df = df)

# Find MoE
SE <- sd_d/sqrt(n_d)
ME <- round(t_score * SE, 2)

lower <- round(x_bar_d - ME, 2)
upper <- round(x_bar_d + ME, 2)


# Question 2 --------------------------------------------------------------

# Use a t-distribution to find a confidence interval for the difference in means pd = 1 - 2 using the relevant sample results
# from paired data. Assume the results come from random samples from populations that are approximately normally
# distributed, and that differences are computed using d = x1 - X2.

# A 99% confidence interval for ud using the paired data in the following table:

# Cases as arrays
treat1 <- c(21, 29, 32, 25, 28)
treat2 <- c(19, 31, 25, 20, 22)

# Give the best estimate for ud, the margin of error, and the confidence interval.

# Enter the exact answer for the best estimate, and round your answers for the margin of error and the confidence interval to
# two decimal places.

d <- treat1 - treat2

x_bar_d <- mean(d)
sd_d <- sd(d)
n <- length(d)
df <- n - 1

CI <- 0.99
alpha <- 1 - CI

t_score <- qt(p = 1 - alpha / 2, df = df)

SE <- sd_d / sqrt(n)
ME <- round(t_score * SE, 2)

lower <- round(x_bar_d - ME, 2)
upper <- round(x_bar_d + ME, 2)

c(lower, upper)


# Question 3 --------------------------------------------------------------

# Use a t-distribution and the given matched pair sample results to complete the test of the given hypotheses. Assume the results
# come from random samples, and if the sample sizes are small, assume the underlying distribution of the differences is relatively
# normal. Assume that differences are computed using d = x1 - x2

# Test Ho: mu_d = O vs Ha: mu_d =/ O using the paired difference sample results x_bar_d = 15.53, sd = 13.3, nd = 25.

x_bar_d = 15.53
mu0 <- x_bar_d  # best est.
sd_d <- 13.3
n <- 25
df <- n - 1

alpha <- 0.05

# Find test stat
SE <- sd_d / sqrt(n)
test_stat <- x_bar_d / SE

# Find p val
p_val <- 2 * (1 - pt(abs(test_stat), df))

round(test_stat, 2)
round(p_val, 3)

reject_H0 <- p_val <= alpha
reject_H0


# Question 4 --------------------------------------------------------------

# Use a t-distribution and the given matched pair sample results to complete the test of the given hypotheses. Assume the results
# come from random samples, and if the sample sizes are small, assume the underlying distribution of the differences is relatively
# normal. Assume that differences are computed using d = x1 - X2.

# Test Ho: mu_d = O vs Ha: mu_d > O using the paired data in the following table:

# Cases as arrays
situation1 <- c(115, 156, 150, 175, 153, 148, 180, 135, 168, 157)
situation2 <- c(120, 150, 142, 150, 160, 148, 160, 142, 162, 150)

d <- situation1 - situation2

x_bar_d <- mean(d)
sd_d <- sd(d)
n <- length(d)
df <- n - 1

alpha <- 0.05

# Find test stat
SE <- sd_d / sqrt(n)
test_stat <- x_bar_d / SE

# Find p val
p_val <- 1 - pt(abs(test_stat), df)

round(test_stat, 2)
round(p_val, 3)

reject_H0 <- p_val <= alpha
reject_H0


# Question 11 -------------------------------------------------------------

# Drink Tea for a Stronger Immune System

# We have seen that drinking tea appears to offer a strong boost to the immune system. In a study extending the results,1 blood
# samples were taken on 5 participants before and after one week of drinking about five cups of tea a day (the participants did
# not drink tea before the study started). The before and after blood samples were exposed to e.coli bacteria, and production of
# interferon gamma, a molecule that fights bacteria, viruses, and tumors, was measured. Mean production went from 155 pg/mL
# before tea drinking to 448 pg/mL after tea drinking. The mean difference for the 5 subjects is 293 pg/mL with a standard
# deviation in the differences of 242. The paper implies that the use of the t-distribution is appropriate.

x_bar_d <- 448 - 155  # before tea - after tea
sd_d <- 242
n <- 5
df <- n - 1

CI <- 0.90
alpha <- 1 - CI

# Finding t score
t_score <- qt(p = 1 - alpha / 2, df = df)

SE <- sd_d / sqrt(n)
ME <- t_score * SE

LL <- round(x_bar_d - ME, 1)
UL <- round(x_bar_d + ME, 1)


# Question 12 -------------------------------------------------------------

# Testing the Effects of Tea on the Immune System

# Use the information to test whether mean production of interferon gamma as a response to bacteria
# is significantly higher after drinking tea than before drinking tea. Use a 5% significance level.

# HYPOTHESIS TESTING #

# H0: mu_d = 0	Ha: mu_d > 0  (right tailed test)

x_bar_d <- 448 - 155  # before tea - after tea
sd_d <- 242
n <- 5
df <- n - 1

CI <- 0.90
# alpha <- 1 - CI
alpha <- 0.05

# Finding t score
t_score <- qt(p = 1 - alpha / 2, df = df)

SE <- sd_d / sqrt(n)
ME <- t_score * SE

# finding the test stat
test_stat <- x_bar_d / SE

# now find the p value
p_val <- 1 - pt(abs(test_stat), df)

LL <- round(x_bar_d - ME, 1)
UL <- round(x_bar_d + ME, 1)


# reject or do not reject the null hypothesis
reject_H0 <- p_val <= alpha
reject_H0
round(test_stat, 2)
round(p_val, 3)


# Question 13 -------------------------------------------------------------

# Testing whether Story Spoilers Spoil Stories

# A story spoiler gives away the ending early. Does having a story spoiled in this way diminish
# suspense and hurt enjoyment? A study1 investigated this question. For twelve different short
# stories, the study's authors created a second version in which a spoiler paragraph at the beginning
# discussed the story and revealed the outcome. Each version of the twelve stories was read by at
# least 30 people and rated on a 1 to 10 scale to create an overall rating for the story, with higher
# ratings indicating greater enjoyment of the story. The ratings are given in Table 1 and stored in
# StorySpoilers. Stories 1 to 4 were ironic twist stories, stories 5 to 8 were mysteries, and stories 9 to
# 12 were literary stories. Test to see if there is a difference in mean overall enjoyment rating based on
# whether or not there is a spoiler.

attach(StorySpoilers)

# HYPOTHESIS TESTING #

# Use:
# mu_s = mean enjoyment rating for the spoiler version
# mu_o = mean enjoyment rating for the original version

# H0: mu_s = mu_o	Ha: mu_s =/ mu_o
# OR (depending on how we want to write this)
# H0: mu_s - mu_o = 0	Ha: mu_s - mu_o =/ 0

diff <- (Spoiler - Original)

x_bar_d <- mean(diff)
sd_d <- sd(diff)
n <- length(diff)
df <- n - 1

alpha <- 0.05


t_score <- qt(p = 1 - alpha / 2, df = df)
SE <- sd_d / sqrt(n)
ME <- t_score * SE

# Find test stat
test_stat <- x_bar_d / SE

# We need a two tailed p val
p_val <- 2 * (1 - pt(abs(test_stat), df))

reject_H0 <- p_val <= alpha
reject_H0
round(test_stat, 2)
# round(p_val, 4)
format(round(5e-04, 4), scientific = FALSE)


# Question 14 -------------------------------------------------------------

# Measuring the Effect of Story Spoilers

# Find a 95% confidence interval for the difference in mean enjoyment rating between
# stories with a spoiler and stories without.

attach(StorySpoilers)

diff <- (Spoiler - Original)

x_bar_d <- mean(diff)
sd_d <- sd(diff)
n <- length(diff)
df <- n - 1

CI <- 0.95
alpha <- 1 - CI


t_score <- qt(p = 1 - alpha / 2, df = df)
SE <- sd_d / sqrt(n)
ME <- t_score * SE

# Find test stat
test_stat <- x_bar_d / SE

# We need a two tailed p val
p_val <- 2 * (1 - pt(abs(test_stat), df))

LL <- round(x_bar_d - ME, 3)
UL <- round(x_bar_d + ME, 3)

LL
UL