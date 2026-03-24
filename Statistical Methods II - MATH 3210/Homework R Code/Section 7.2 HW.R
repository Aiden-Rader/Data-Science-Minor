# Homework R Code for Section 7.2



# Question 1 --------------------------------------------------------------

# This way sucks to be honest, lets do it a different way

group1 <- c(yes = 55, no = 40)
group2 <- c(yes = 134, no = 65)
group3 <- c(yes = 67, no = 26)

group1_total <- sum(group1)
group2_total <- sum(group2)
group3_total <- sum(group3)

yes_total <- sum(group1["yes"], group2["yes"], group3["yes"])
no_total <- sum(group1["no"], group2["no"], group3["no"])

n <- sum(yes_total, no_total)

exp_group1_yes <- group1_total * yes_total / n
exp_group1_no <- group1_total * no_total / n

exp_group2_yes <- group2_total * yes_total / n
exp_group2_no <- group2_total * no_total / n

exp_group3_yes <- group3_total * yes_total / n
exp_group3_no <- group3_total * no_total / n

exp_counts <- matrix(c(exp_group1_yes, exp_group1_no,
					   exp_group2_yes, exp_group2_no,
					   exp_group3_yes, exp_group3_no),
					 nrow = 3, byrow = TRUE)

colnames(exp_counts) <- c("yes", "no")
rownames(exp_counts) <- c("group1", "group2", "group3")
round(exp_counts, 1)


# Question 1 (Better) -----------------------------------------------------

group1 <- c(yes = 55, no = 40)
group2 <- c(yes = 134, no = 65)
group3 <- c(yes = 67, no = 26)

# Make a matrix out of our data (key = col, variable name = row, val = data)
obs <- rbind(group1, group2, group3)

row_totals <- rowSums(obs)
col_totals <- colSums(obs)
n <- sum(obs)

exp_counts <- outer(row_totals, col_totals) / n
round(exp_counts, 1)

contrib <- (obs - exp_counts)^2 / exp_counts
round(contrib, 3)


# Question 5 --------------------------------------------------------------

group1 <- c("4_yr_college" = 88, Not_4_yr_college = 122)
group2 <- c("4_yr_college" = 170, Not_4_yr_college = 156)
group3 <- c("4_yr_college" = 276, Not_4_yr_college = 108)

# Make a matrix out of our data (key = col, variable name = row, val = data)
obs <- rbind(group1, group2, group3)

row_totals <- rowSums(obs)
col_totals <- colSums(obs)
n <- sum(obs)

exp_counts <- outer(row_totals, col_totals) / n
round(exp_counts, 1)

contrib <- (obs - exp_counts)^2 / exp_counts
round(contrib, 3)

# Find the chi-sqaure stat
chi_sq <- sum(contrib)
round(chi_sq, 3)

# Find p value
df <- (2 - 1) * (3 - 1)
p_val <- 1 - pchisq(chi_sq, df)
round(p_val, 3)


# Question 6 --------------------------------------------------------------

survived <- c(metal = 37, electronic = 64)
died <- c(metal = 123, electronic = 119)

obs <- rbind(survived, died)

row_totals <- rowSums(obs)
col_totals <- colSums(obs)
n <- sum(obs)

exp_counts <- outer(row_totals, col_totals) / n
round(exp_counts, 2)

contrib <- (obs - exp_counts)^2 / exp_counts
round(contrib, 3)

# Find the chi-sqaure stat
chi_sq <- sum(contrib)
round(chi_sq, 1)

# Find p value
df <- (2 - 1) * (2 - 1)
p_val <- 1 - pchisq(chi_sq, df)
round(p_val, 3)

alpha <- 0.05
reject_H0 <- p_val <= alpha
reject_H0


# Question 7 --------------------------------------------------------------

NSAID <- c(Miscarriage = 18, No_Miscarriage = 57)
Acetaminophen <- c(Miscarriage = 24, No_Miscarriage = 148)
No_Painkiller <- c(Miscarriage = 103, No_Miscarriage = 659)

obs <- rbind(NSAID, Acetaminophen, No_Painkiller)

row_totals <- rowSums(obs)
row_count <- nrow(obs)
col_totals <- colSums(obs)
col_count <- ncol(obs)
n <- sum(obs)

exp_counts <- outer(row_totals, col_totals) / n
round(exp_counts, 2)

contrib <- (obs - exp_counts)^2 / exp_counts
round(contrib, 3)

# Find the chi-sqaure stat
chi_sq <- sum(contrib)
round(chi_sq, 2)

# Find p value
df <- (row_count - 1) * (col_count - 1)  # (r - 1) * (c - 1)
p_val <- 1 - pchisq(chi_sq, df)
round(p_val, 3)

alpha <- 0.05
reject_H0 <- p_val <= alpha
reject_H0
