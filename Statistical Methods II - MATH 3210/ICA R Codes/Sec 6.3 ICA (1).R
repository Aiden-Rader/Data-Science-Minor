
# Question 1 --------------------------------------------------------------

# From the 2010 US Census, we learn that 13.9% of the residents of Arizona were born outside the US while 3.4%
# of the residents of Alabama were born outside the US. If we take random samples of 500 residents from each
# state and calculate the difference in the proportion of foreign-born residents (Arizona – Alabama), describe the
# shape, mean, and standard error of the distribution of differences in proportions.


p1 <- 13.9
p2 <- 3.4

center <- p1 - p2

var1 <- (0.139 * (1 - 0.139)) / 500
var2 <- (0.034 * (1 - 0.034)) / 500

SE <- sqrt(var1 + var2)


# Question 2 --------------------------------------------------------------
# 
# Suppose 500 people participate in a blind Coke/Pepsi taste test, and 285 of them prefer Coke while the other
# 215 of them prefer Pepsi.

pC <- 285/500
pP <- 215/500

#	(a) If we conduct inference (creating a confidence interval or conducting a hypothesis test) using this data,
# should we use the formulas for a single proportion or a difference in proportions?

# USE SINGLE PROPORTION SINCE THERE IS ONLY 1 GROUP

# 	(b) If we want to test whether the preferences are equally split between Coke and Pepsi, what is the null
# hypothesis?

# IDK

# 	(c) In terms of the outcome of the test, does it matter whether we define p to be the proportion of people
# who prefer Coke or the proportion of people who prefer Pepsi?

# SINCE YOU CAN BASICALLY SPLIT IT, TAKE EITHER ONE AND THEN THE RESULT - 1 WOULD GIVE YOU THE OTHER
