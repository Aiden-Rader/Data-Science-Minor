# Author: Aiden Rader
# Date: 1/25/2026
# Assignment: Homework Section P.5


# Question 4 --------------------------------------------------------------

# a *(area below z = 1.08)
res <- round(pnorm(1.08), 3)

# b (area above z = -1.4)
res <- round(1 - pnorm(-1.4), 3)

# c (area between z = 1.1 and z = 2.0)
res <- round(pnorm(2.0) - pnorm(1.1), 3)


# Question 5  -------------------------------------------------------------

# a *(area below z = 0.8)
res <- round(pnorm(0.8), 3)

# b (area above z = 1.3)
res <- round(1 - pnorm(1.3), 3)

# c (area between z = 1.76 and z = 1.26)
res <- round(pnorm(1.76) - pnorm(1.26), 3)


# Question 6 --------------------------------------------------------------

# a (the area to the left of the endpoint is about 0.06)
res <- round(qnorm(0.06), 3)

# b (the area to the right of the endpoint is about 0.84)
res <- round(qnorm(1 - 0.84), 3)

# c (the area between +/-z is about 0.98)

#  this one we say middle area is 0.98 and total tail area left is 0.02 so each tail is 0.01
res_1 <- round(qnorm(0.99), 3)
res_2 <- round(qnorm(0.01), 3)


# Question 7 --------------------------------------------------------------

# a (the area to the left of the endpoint is about 0.72)
res <- round(qnorm(0.72), 3)

# b (the area to the right of the endpoint is about 0.03)
res <- round(qnorm(1 - 0.03), 3)

# c (the area between +/-z is about 0.86)

# 0.14 / 2 = 0.07 so left endpoint is 0.07, right endpoint is 1 - 0.07 = 0.93
res_1 <- round(qnorm(0.93), 3)
res_2 <- round(qnorm(0.07), 3)


# Question 8 --------------------------------------------------------------

# a (area below 80 on an N(75, 10))
res <- round(pnorm(80, mean = 75, sd = 10), 3)

# b (area above 27 on an N(20, 6))
res <- round(1 - pnorm(27, mean = 20, sd = 6), 3)

# c (Area between 11 and 14 on an N(12.2, 1.6))
res <- round(pnorm(14, mean = 12.2, sd = 1.6) - pnorm(11, mean = 12.2, sd = 1.6), 3)


# Question 9 --------------------------------------------------------------

# a (the area above 7 on a N(5, 1.4))
res <- round(1 - pnorm(7, mean = 5, sd = 1.4), 3)

# b (the area below 14 on a N(20, 3.1))
res <- round(pnorm(14, mean = 20, sd = 3.1), 3)

# c (the area between 87 and 100 on a N(100, 5.8))
res <- round(pnorm(100, mean = 100, sd = 5.8) - pnorm(87, mean = 100, sd = 5.8), 3)


# Question 10 -------------------------------------------------------------

# a (the area to the right of the endpoint on a N(50, 3.2) curve is about 0.01)
res <- round(qnorm(1 - 0.01, mean = 50, sd = 3.2), 1)

# b (the area to the left of the endpoint on a N(2, 0.06) curve is about 0.70)
res <- round(qnorm(0.70, mean = 2, sd = 0.06), 2)

# c (the symmetric middle area on a N(100, 20) curve is about 0.95)
res <- round(qnorm(c(0.025, 0.975), mean = 100, sd = 20), 1)


# Question 11 -------------------------------------------------------------

# a (the area to the right of the endpoint on a N(25, 6) curve is about 0.25)
res <- round(qnorm(1 - 0.25, mean = 25, sd = 6), 1)

# b (the area to the left of the endpoint on a N(500, 86) curve is about 0.02)
res <- round(qnorm(0.02, mean = 500, sd = 86), 1)

# c (the symmetric middle area on a N(10, 4) curve is about 0.95)
res <- round(qnorm(c(0.025, 0.975), mean = 10, sd = 4), 1)


# Question 14 -------------------------------------------------------------

mu <- 55.5
sig <- 2.7

# a (According to this normal distribution, what proportion of 10-year-old boys are between 4 ft 4.0 in and 5 ft 6.5 in tall (between
# 52.0 inches and 66.5 inches)?)
p_res <- round(pnorm(66.5, mean = mu, sd = sig) - pnorm(52.0, mean = mu, sd = sig), 3)

# b (A parent says his 10-year-old son is in the 95th percentile in height. How tall is this boy?)
q_res <- round(qnorm(0.95, mean = 55.5, sd = 2.7), 2)


# Question 15 -------------------------------------------------------------

mu <- 70
sig <- 3

# a (What proportion of US men are between 5 ft 7.2 in and 6 ft 0.8 in tall (67.2 and 72.8 in))
p_res <- round(pnorm(72.8, mean = mu, sd = sig) - pnorm(67.2, mean = mu, sd = sig), 3)

# b (If a man is at the 12th percentile in height, how tall is he?)
q_res <- round(qnorm(0.12, mean = mu, sd = sig), 1)


# Question 16 -------------------------------------------------------------

# Exam grades across all sections of introductory statistics at a large university are approximately normally distributed with a mean of
# 72 and a standard deviation of 11. Use the normal distribution to answer the following questions.

mu <- 72
sig <- 11

# a (what percent of students scored above an 89?)
res_a <- round((1 - pnorm(89, mean = mu, sd = sig)) * 100, 1)

# b (what percent of students scored below a 58?)
res_b <- round((pnorm(58, mean = mu, sd = sig)) * 100, 1)

# c (if the lowest 8% of students will be required to attend peer tutoring sessions, what grade is the cutoff for being required to attend
# these sessions?)
res_c <- round(qnorm(0.08, mean = mu, sd = sig), 1)

# d (if the highest 10% of students will be given a grade of A, what is the cutoff to get an A?)
res_d <- round(qnorm(1 - 0.10, mean = mu, sd = sig), 1)
