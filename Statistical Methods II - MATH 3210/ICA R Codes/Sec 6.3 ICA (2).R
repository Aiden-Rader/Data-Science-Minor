
# Question 1 --------------------------------------------------------------

# Does smoking negatively affect a person’s ability to become pregnant? A study collected data on 678 women
# who were trying to get pregnant. The two-way table shows the proportion who successfully became pregnant
# during the first cycle trying and smoking status. Find a 90% confidence interval for the difference in proportion
# of women who get pregnant, between smokers and non-smokers. Interpret the interval in context.

# THIS IS INCORRECT STILL PLEASE FIX BEFORE USING AS A STUDY TOOL!!!!

CI <- 0.90

leaves <- 1 - CI
split <- leaves/2
val <- 1 - split
z <- round(qnorm(val), 3)

nS <- 38
nNS <- 206

pS <- nS/244
pNS <- nNS / 244

# Best Est.
p_res <- pS - pNS

# Margin of Error
var1 <- (pS * (1 - pS)) / nS
var2 <- (pNS * (1 - pNS)) / nNS

SE <- round(sqrt(var1 + var2), 3)
ME <- round(z * SE, 3)

# Confidence Interval
lower <- round(p_res - ME, 3)
upper <- round(p_res + ME, 3)



# Question 2 --------------------------------------------------------------

# Prop for lying
p1 <- 31/48

# Prop for thruthy
p2 <- 27/48

p_res <- p1 - p2
