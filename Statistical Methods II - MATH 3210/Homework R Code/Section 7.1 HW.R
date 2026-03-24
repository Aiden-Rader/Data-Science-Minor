# Homework R Code for Section 7.1


# Question 1 --------------------------------------------------------------

# Find expected counts in each category using the given sample size and null
# hypothesis.

# p1 = p2 = p3 = p4 = 0.25
# n = 300

p <- 0.25
n <- 300
exp_count <- n * p


# Question 2 --------------------------------------------------------------

# Find the expected in each category using the given sample size and null
# hypothesis.

# H0: All three categories A, B, C are equally likely (3 categories so each is 1/3)
# n = 600

p <- 1/3
n <- 600
exp_count <- n * p


# Question 3 --------------------------------------------------------------

# Find the expected in each category using the given sample size and null
# hypothesis.

# H0: pA = 0.40, pB = 0.25, pC = 0.35
# n = 500

pA <- 0.40
pB <- 0.25
pC <- 0.35
n <- 500

catA <- n * pA
catB <- n * pB
catC <- n * pC

catA
catB
catC


# Question 4 --------------------------------------------------------------

# The categories of a categorical variable are given along with the observed counts from a sample. The
# expected counts from a null hypothesis are given in parentheses. Compute the x2-test statistic, and use the
# x -- distribution to find the p-value of the test.

catA_obs <- 32
catB_obs <- 38
catC_obs <- 65

catA_exp <- 45
catB_exp <- 45
catC_exp <- 45

# Manual Chi-Squared Test
test_stat <- (c(catA_obs, catB_obs, catC_obs) - c(catA_exp, catB_exp, catC_exp))^2 / c(catA_exp, catB_exp, catC_exp)
chi_sq <- sum(test_stat)
round(chi_sq, 2)

# Using R Function
# check_ts <- chisq.test()

# Find P Value
n <- 3 # categories
df <- n - 1

p_val <- 1 - pchisq(q = chi_sq, df = df)
format(round(p_val, 3), scientific = FALSE)


# Question 5 --------------------------------------------------------------

# The categories of a categorical variable are given along with the observed counts from a sample. The
# expected counts from a null hypothesis are given in parentheses. Compute the x2-test statistic, and use the
# x -- distribution to find the p-value of the test.

catA_obs <- 61
catB_obs <- 37
catC_obs <- 52

cat_exp <- 50  # switched to one variable since all expected vals are the same

# Manual Chi-Squared Test
test_stat <- (c(catA_obs, catB_obs, catC_obs) - c(cat_exp, cat_exp, cat_exp))^2 / c(cat_exp, cat_exp, cat_exp)
chi_sq <- sum(test_stat)
round(chi_sq, 2)

# Find P Value
n <- 3 # categories
df <- n - 1

p_val <- 1 - pchisq(q = chi_sq, df = df)
format(round(p_val, 4), scientific = FALSE)


# Question 6 --------------------------------------------------------------

# A null hypothesis for a goodness-of-fit test and a frequency table from a sample are given.

# Ho: Pa = Pb = Pc = Pd = 0.25
# Ha: Some pi =/ 0.25

# Set up stats
p <- 0.25  # all proportions
n <- 220  # total


# HERE GOES MY COMPLICATED WAY OF DOING THIS
labels <- list(
	"A"=51,
	"B"=46,
	"C"=62,
	"D"=61
	)

# (a) Find the expected count for the category labeled B.
exp_count <- n * p

# (b) Find the contribution to the sum of the chi-square statistic for the category labeled B.
test_stat <- round((c(labels$A, labels$B, labels$C, labels$D) - c(exp_count, exp_count, exp_count, exp_count))^2 / c(exp_count, exp_count, exp_count, exp_count), 2)
chi_sq <- sum(test_stat)
round(chi_sq, 2)

# (c) Find the degrees of freedom for the chi-square distribution for this table.
cat_count <- length(labels)
df <- cat_count - 1


# Question 7 --------------------------------------------------------------

# Are Food Delivery Apps Equally Popular? Exercise 1.61 introduces a 2019 study which asked 160 US
# adults who regularly use a food delivery app which one they used most recently. The results are shown in
# the table below.

# Test to see if the four options are equally likely (KEYWORD EQUALLY LIKELY) 
# among US adults who regularly use a food deliver app.

# Ho: Pa = Pb = Pc = Pd = ? (0.25)
# Ha: Some pi =/ ? (0.25)

# TRYING A BETTER METHOD AFTER LOOKING ONLINE
obs <- c(
	DoorDash = 44,
	GrubHub = 43,
	UberEats = 40,
	Other = 33
)

k <- length(obs)  # this is my cat_count but the actual name of the variable
n <- sum(obs)
df <- k - 1

alpha <- 0.05

p <- rep(1/k, k)
exp_count <- n * p

# Finding contributions
contrib <- (obs - exp_count)^2 / exp_count
chi_sq <- sum(contrib)

# Finding p_val
p_val <- 1 - pchisq(chi_sq, df)

round(chi_sq, 3)
round(p_val, 3)

reject_H0 <- p_val <= alpha
reject_H0


# Question 8 --------------------------------------------------------------

# Observed counts
obs <- c(on = 1436, off = 1119, not = 2649)

# Assumed proportions
p <- c(on = 0.25, off = 0.25, not = 0.50)

n <- sum(obs)  # the total calculated

exp <- n * p  # for each obs we can calculate the exp value and return an array
exp

contrib <- (obs - exp)^2 / exp  # this will give individual contribution values but in an array
contrib

# Finding Contribution values
chi_sq <- sum(contrib)
round(chi_sq, 3)

# Find the degree of freedom and p value
df <- length(obs) - 1 
p_val <- 1 - pchisq(chi_sq, df)  # Chi-sqaure tests are ALWAYS right tailed tests
round(p_val, 3)

alpha <- 0.05  # by default

p_val <= alpha



# Question 10 -------------------------------------------------------------


