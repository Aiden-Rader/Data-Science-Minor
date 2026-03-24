# Homework R Code

# Question 1 --------------------------------------------------------------
# Consider random samples of size 60 from a population with proportion 0.25.
# Find the standard error of the distribution of sample proportions.

p <- 0.25
n <- 60

SE <- round(sqrt(p * (1 - p) / n), 3)
SE


# Question 2 --------------------------------------------------------------
# Consider random samples of size 800 from a population with proportion 0.70.
# Find the standard error of the distribution of sample proportions.

p <- 0.70
n <- 800

SE <- round(sqrt(p * (1 - p) / n), 3)  # we use: SE = √p(1-p)/n
SE


# Question 3 --------------------------------------------------------------
# Compute the standard error for sample proportions from a population with
# proportion p = 0.45 for sample sizes of n = 30, n = 300, and n = 1000.

p <- 0.45
n <- c(30, 300, 1000)

SE <- round(sqrt(p * (1 - p) / n), 3)  # auto loops all n values

# To see exactly which n value equates to which SE we can use a dataframe (similar to python)

res <- data.frame(
	n = n,
	SE = SE
)
res


# Question 4 --------------------------------------------------------------

# Use the normal distribution to find a confidence interval for a proportion
# p given the relevant sample results. Give the best point estimate for p, the
# margin of error, and the confidence interval. Assume the results come from a
# random sample.

# A 99% confidence interval for p given that p_hat = 0.34 and n = 450.

CI <- 0.99
p_hat <- 0.34
n <- 450

# really the best point est. is just p_hat so 

best_point_est = round(p_hat, 2)

# we are going to need z value, I will calculate from scratch

leaves <- 1 - CI
split <- leaves/2
val <- 1 - split

# Always take the z* by the left side which is what R defaults to which finds a pos number
z <- round(qnorm(val), 3)

# Now we can calucalte the ME
ME <- round(z*(sqrt(p_hat*(1-p_hat)/n)), 3)

# Calc the sides from ___ to ____
lower <- p_hat - ME
upper <- p_hat + ME


# Question 5 --------------------------------------------------------------

# Use the normal distribution to find a confidence interval for a proportion p
# given the relevant sample results. Give the best point estimate for p, the
# margin of error, and the confidence interval. Assume the results come from
# a random sample.

# A 99% confidence interval for the proportion who will answer "Yes" to a
# question, given that 67 answered yes in a random sample of 90 people.

CI <- 0.99
n <- 90
p_hat <- round(67/n, 3)

leaves <- 1 - CI
split <- leaves/2
val <- 1 - split
z <- round(qnorm(val), 3)

# Make it simple and calc SE seperate from ME
SE <- round(sqrt(p_hat * (1 - p_hat) / n), 3)

ME <- round(z * SE, 3)

lower <- p_hat - ME
upper <- p_hat + ME


# Question 6 --------------------------------------------------------------

# What Proportion of Americans Say They Are Poor? A survey of 1000 US Adults conducted in October 2019 found that 182
# of them described themselves as poor. In Exercise 3.128, we used a bootstrap distribution to find a 90% confidence interval
# for the proportion of all US adults who would describe themselves as poor. Here, we find this 90% confidence interval using
# the normal distribution and a formula for the standard error

# Seems like a population proportion
CI <- 0.90
n <- 1000

# a. give value for sample statistic
p_hat <- round(182/n, 3)

# b. find standard error for this sample statistic
SE <- round(sqrt(p_hat * (1 - p_hat) / n), 3)

# c. what is z score for a 90% confidence interval
leaves <- 1 - CI
split <- leaves/2
val <- 1 - split
z <- round(qnorm(val), 3)

# Use results to find the 90% confidence interval
ME <- round(z * SE, 3)

res1 <- p_hat - ME
res2 <- p_hat + ME


# Question 7 --------------------------------------------------------------

# Teen Cigarette Use Is Down The US Centers for Disease Control conducts the National Youth Tobacco Survey each year. The
# preliminary results1 of 2019 show that e-cigarette use is up among US teens while cigarette use is down. We examined e-
# cigarette use in Exercise 3.137 and here we estimate cigarette use. In the sample of 1582 teens, 92 reported smoking a
# cigarette in the last 30 days.

# a. give notation for the parameter we are est.
#  I would say this is a true proportion (p)

# b. give notation of the sample statistic.
#  If we need the true prop then use sample prop (p_hat)

CI <- 0.99
n <- 1582

# give value for sample statistic
p_hat <- round(92/n, 3)

# c. find standard error for this sample statistic
SE <- round(sqrt(p_hat * (1 - p_hat) / n), 3)

# d. what is z score for a 99% confidence interval
leaves <- 1 - CI
split <- leaves/2
val <- 1 - split
z <- round(qnorm(val), 3)

# e. What is the 99% confidence interval?
# f. What is the best est for the parameter we are estinmating and what is the margin of error?

ME <- round(z * SE, 3)

res1 <- p_hat - ME
res2 <- p_hat + ME



# Question 8 --------------------------------------------------------------

# Use the normal distribution and the given sample results to complete the test of the given hypotheses. Assume the results come
# from a random sample and use a 5% significance level.

# Test Ho : p = 0.5 vs Ha : p > 0.5 using the sample results p_hat = 0.60 with n = 75
p_hat <- 0.60
p_0 <- 0.5
n <- 75
x <- p_hat * n  # we dont need it but it is just converting back to a count

alpha <- 0.05

# Test Statistic (z)
test_stat <- round((p_hat - p_0)/
				   	sqrt(p_0*(1 - p_0)/
				   		 	n),
				   2)

# P Value (right tailed becauase H_a uses >)

p_val <- round(1 - pnorm(test_stat), 3)

# I figured out you can make Bool values so this is what this is in CS terms:
# if (p_value <= alpha) {
# 	"Reject H0"
# } else {
# 	"Fail to reject H0"
# }

reject_H0 <- p_val <= alpha
reject_H0


# Question 9 --------------------------------------------------------------

# Use the normal distribution and the given sample results to complete the test of the given hypotheses. Assume the results come
# from a random sample and use a 5% significance level.

# Test Ho : p =0.3 vs Ha : p < 0.3 using the sample results p_hat = 0.21 with n = 199

p_hat <- 0.21
p_0 <- 0.3
n <- 199
alpha <- 0.05

# Test Statistic (z)
test_stat <- round((p_hat - p_0)/
				   	sqrt(p_0*(1 - p_0)/
				   		 	n),
				   2)

# P Value (left tailed becauase H_a uses <)

p_val <- round(pnorm(test_stat), 3)

reject_H0 <- p_val <= alpha
reject_H0


# Question 10 -------------------------------------------------------------

# A Canadian longitudinal study1 examined whether giving antibiotics in infancy increases the likelihood that the child will be
# overweight later in life. The study included 616 children and found that 438 of the children had received antibiotics during
# the first year of life. Test to see if this provides evidence that more than 70% of Canadian children receive antibiotics during
# the first year of life. Show all details of the hypothesis test, including hypotheses, the standardized test statistic, the p-value,
# the generic conclusion using a 5% significance level, and a conclusion in context.

# Test Ho : p = 0.7 vs Ha : p > 0.7
n <- 616
p_hat <- round(438/n, 3)
p_0 <- 0.7
alpha <- 0.05

# Test Statistic (z)
test_stat <- round((p_hat - p_0)/
				   	sqrt(p_0*(1 - p_0)/
				   		 	n),
				   2)

# P Value (right tailed becauase H_a uses >)

p_val <- round(1 - pnorm(test_stat), 3)

reject_H0 <- p_val <= alpha
reject_H0


# Question 11 -------------------------------------------------------------

# Approximately 10% of Americans are left-handed (we will treat this as a known population parameter). A study on the
# relationship between handedness and profession found that in a random sample of 105 lawyers, 16 of them were left-
# handed.1 Test the hypothesis that the proportion of left-handed lawyers differs from the proportion of left-handed
# Americans.

# Test Ho : p = 0.1 vs Ha : p =/ 0.1
n <- 105
p_hat <- round(16/n, 3)
p_0 <- 0.1
alpha <- c(0.05, 0.1)

# Test Statistic (z)
test_stat <- round((p_hat - p_0)/
				   	sqrt(p_0*(1 - p_0)/
				   		 	n),
				   2)

# P Value (This is a two tailed test so we need two right tailed tests)

p_val <- round((2 * (1 - pnorm(test_stat))),3)

reject_H0 <- p_val <= alpha
reject_H0
