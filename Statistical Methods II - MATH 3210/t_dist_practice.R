
# Example 1 ---------------------------------------------------------------
# A sample of 50 gribbles finds an average length of 3.1 mm with a standard deviation of 0.72 mm.
# Give a 90% confidence interval for the average length of gribbles.

n <- 50
s <- 0.72
x_bar <- 3.1
CI <- 0.90

df <- n - 1


# NOTE: 
t <- round(qt(0.95, df), 2)


