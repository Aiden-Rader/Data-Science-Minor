
# Q1 (Inferences of one population proportion) --------------------------------------------------------------

# Alcohol abuse has been described by college presidents as the number one problem on campus and it is
# an important cause of death in young adults. How common is it? A survey of 17,096 students in U.S.
# four-year colleges collected information on drinking behavior and alcohol-related problems. The
# researchers defined “frequent binge drinking” as having five or more drinks in a row three or more times
# in the past two weeks. According to this definition, 3314 students were classified as frequent binge
# drinkers.

# a) What is the sample proportion of student drinkers?
x <- 3314
n <- 17096
p_hat <- x / n

# b) Construct a 99% confidence interval for the true proportion of college students that are frequent binge drinkers.
CI <- 0.99

results <- prop.test(x, n, conf.level = CI)

# Organize Stats
conf_int <- results$conf.int


# Q2 (Inferences of difference in two population proportions) ---------------------------------------------------------------------

# 2005 survey of Internet users reported that 22% downloaded music onto their computers. The filing of
# lawsuits by the recording industry may be a reason why this percent has decreased from the estimate of
# 29% from a survey taken two years before. Assume that the sample sizes are both 1421.
n <- 1421
p1 <- 0.29
p2 <- 0.22
alpha <- 0.05

# Calculate the x values
x1 <- p1 * n
x2 <- p2 * n

# a) Using a significance test (α = 0.05), evaluate whether or not there has been a change in the
# percent of Internet users who download music.

# H0: p1 = p2, Ha: p1 =/ p2 (two sided test)

# b) Report a 95% confidence interval for the difference in proportions.
CI <- 0.95
results <- prop.test(x = c(x1, x2), n = c(n, n), conf.level = CI, alternative = "two.sided")

# Organize Stats
p_val <- results$p.value
conf_int <- results$conf.int

# Check the rejection status (maybe...?)
reject_H0 <- p_val <= alpha
reject_H0


# Q3 (Inferences of one population mean) ----------------------------------------------------------------------

# The Nielsen Company states that adults age 18 to 24 years old average 18.5 hours per week watching
# traditional television. Does this average seem reasonable for college students? We drew an SRS of eight
# college students and obtained the following data, in hours of TV watched per week (see table)

# We can check to see if the line follows a straight line on the points (check normality of data set)
qqnorm(TV_hour$hours)
qqline(TV_hour$hours)

# a) Estimate the true mean hours of television watched per week, μ, of all college students with a
# 95% confidence level.
CI <- 0.95
x_bar <- mean(TV_hour$hours)
s <- sd(TV_hour$hours)
n <- length(TV_hour$hours)

# b) Test whether the average time that college students watch television differs from the reported
# value of 18.5.

results <- t.test(TV_hour$hours, alternative = "two.sided", mu = 18.5, conf.level = CI)  # we can actually just do this
p_val <- results$p.value
t_score <- results$statistic
std <- results[["stderr"]]
conf_int <- results$conf.int
# x_bar <- results$estimate
# df <- results$parameter

# Q4 (Inferences of the difference in means (two independent samples) --------

# The Wade Tract Preserve in Georgia is an old-growth forest of longleaf pines that has survived in a
# relatively undisturbed state for hundreds of years. One question of interest to foresters who study the
# area is “How do the sizes of longleaf pine trees in the northern and southern halves of the forest
# compare?” To find out, researchers took random samples of 30 trees from each half and measured the
# diameter at breast height (DBH) in centimeters. Comparative boxplots of the data and summary
# statistics from Minitab are shown below.
attach(nstreediameter)

N <- tapply(dbh, ns, length)
Mean <- tapply(dbh, ns, mean)
StDev <- tapply(dbh, ns, sd)
cbind(N, Mean, StDev)
boxplot(dbh~ns,data = nstreediameter)

# a) Construct and interpret a 90% confidence interval for the difference in the mean DBH for
# longleaf pines in the northern and southern halves of the Wade Tract Preserve.
CI <- 0.90
results <- t.test(dbh~ns, data = nstreediameter, conf.level = CI, alternative = "two.sided")

# b) Test if the mean DBH for longleaf pines in the northern halves is significantly different than that
# in the southern halves.


# Q5 (Inferences of the difference in means (paired data)) ----------------

# THIS IS A VERY IMPORTANT PROBLEM! PRACTICE THIS PLEASE #

# If we increase our food intake, we generally gain weight. Nutrition scientists can calculate the amount of
# weight gain that would be associated with a given increase in calories. In one study, 16 randomly
# selected nonobese adults, aged 25 to 36 years, were fed 1000 calories per day in excess of the calories
# needed to maintain a stable body weight. The subjects maintained this diet for 8 weeks, so they
# consumed a total of 56000 extra calories. According to theory, 3500 extra calories will translate into a
# weight gain of 1 pound. Therefore, we expect each of these subjects to gain 56000/3500=16 pounds(lb).
# Here are the weights before and after the 8-week period expressed in kilograms (kg):

attach(weight_gain)

# Compute weight differences
diff <- Weight_after - Weight_before

x_bar <- mean(diff)
sd_d <- sd(diff)
n <- length(diff)

# a) Does the sample provide evidence that the average weight gain associated with the given
# increase of calories (1000 per day for 8 weeks) is 16 lb? State the appropriate Ho and Ha for
# addressing this question.

mu0 <- 16 * 0.45359237  # convert from lbs -> kg

# OR WE CAN USE THIS LIBRARY



# b) Define in words the parameter in your hypotheses above.

# H0: mu_d = mu0, Ha: mu_d =/ mu0 (two sided test)

# c) Calculate the test statistic. Show your work. Include the formula and the numerical value of
# every quantity in the formula.
# use t-test stat
SE <- sd_d/sqrt(n)
test_stat <- (x_bar - mu0)/SE

# d) Find the P-value for your test. Draw a well-labeled sketch of a normal curve to indicate what
# probability you are finding.
df <- n - 1
p_val <- 2 * pt(-abs(test_stat), df = df)

# OR WE CAN DO THIS (test to see if p.value = p_val)

res <- t.test(diff, mu = mu0, alternative = "two.sided")
res$statistic
res$parameter
res$p.value
res$estimate

# e) Can Ho be rejected using α = 0.05? why?
alpha <- 0.05

reject_H0 <- res$p.value <= alpha
reject_H0

# Yes, it can be since it is less than (<) our alpha of 0.05

# f) Write a sentence of interpretation (understandable to someone who has never studied
# statistics) explaining the outcome of your test. Talk about the average weight gain that is
# associated with the given increase of calories.

# There is in fact strong evidence that the true mean weight gain for adults on this 1000 cal/day diet for 
# 8 weeks is NOT 16 lbs (or about 7.26 kg). The sample mean gain was about 4.73125 kg 
# which is significantly lower than predicted.

