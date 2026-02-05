# ICA 1 -------------------------------------------------------------------

# Men hoping to have children are encouraged to avoid hot tubs or saunas, because heating the scrotum by just
# 1C can reduce sperm count and sperm quality. A new study indicates that men might want to also avoid using
# a laptop computer on their lap for long periods of time. In the study, 29 men sat with for an hour with a laptop
# computer on their lap. Mean temperature increase was 2.31C with a standard deviation of 0.96C. 

# Test to see if we can conclude that the average temperature increase for a man with a laptop computer on his lap for an
# hour is above the danger threshold of 1C. Show all details of the test

# need to calculate n

s <- 0.96
n <- 29
x_bar <- 2.31
mu0 <- 1
alpha <- 0.05

# use t-test stat
SE <- s/sqrt(n)
test_stat <- (x_bar - mu0)/SE

# Calc degree of freedom
df <- n - 1

# Left tailed!
p_val <- 1 - pt(test_stat, df)

# Should we reject H0?
reject_H0 <- p_val <= alpha
reject_H0


# ICA 2 -------------------------------------------------------------------

# In the 2010-11 National Hockey League (NHL) regular season, the number of penalty minutes per game for each
# of the 30 teams ranged from a low of 8.8 for the Florida Panthers to a high of 18.0 for the New York Islanders.
# The mean for all 30 teams is 12.20 penalty minutes per game with a standard deviation of 2.25. 

# If we assume that this is a sample of all teams in all seasons, test to see if this provides evidence that the mean number of
# penalty minutes per game for a hockey team is less than 13. Show all details of the test.

n <- 30
x_bar <- 12.2
s <- 2.25
mu0 <- 13
alpha <- 0.05

# It will be less than 13 so Ha < 13 so this is a left tailed test

# use t-test stat
SE <- s/sqrt(n)
test_stat <- (x_bar - mu0)/SE

# Calc degree of freedom
df <- n - 1

# Left tailed!
p_val <- pt(test_stat, df)

# Should we reject H0?
reject_H0 <- p_val <= alpha
reject_H0

