
# Example 1 ---------------------------------------------------------------

# Finding Z score using P_o and P
res <- round((0.549 - 0.5)/
			 	sqrt(0.5*(1 - 0.5)/
			 		 	2430),
			 2)

# Now with 
res_2 <- 1 - pnorm(res)

# can also do: 1 - pnorm(0.549, 0.5, sqrt(0.5*0.5)/2430)
# res_a <- 1 - pnorm(0.549, 0.5, sqrt((0.5)*(0.5)/2430)

# Example 2 ---------------------------------------------------------------

prob <- 240/428

test_stat <- round((0.561 - 0.5)/
			 	sqrt(0.5*(1 - 0.5)/
			 		 	428),
			 2)

p_val <- 1 - pnorm(test_stat)

# DO MORE OF THIS ONE, LOOK AT REVIEW LECTURES!


# Example 3 - Chips Ahoy! -------------------------------------------------

# Are there MORE THAN ( > ) 1000 chips in each bag, on avg?
n <- 42
sig <- 117.6
x_bar <- 1261.6

# use t-test stat
SE <- sig/sqrt(n)
test_stat <- (x_bar - 1000)/SE

# Calculate the degree of freedom
df <- n - 1

# This is a right tailed test (i.e. >) so we say P(t > test_stat) which uses 1 - pt
p_val <- 1 - pt(test_stat, df)

# Should we reject H0?
reject_H0 <- p_val <= x_bar
reject_H0

# Interpret in context (IMPORTANT):
# We can say this provides extremely strong evidence that the average number of chips
# per bagof Chips Ahoy! cookies are greater than 1000.
