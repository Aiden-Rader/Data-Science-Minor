# R Code for during the Midterm
# Aiden Rader

var1 <- (0.035 * (1 - 0.035) / 1563)
var2 <- (0.035 * (1 - 0.035) / 579)

SE <- sqrt(var1 + var2)

z_stat <- (0.039 - 0.026) / SE 

p_val <- 2 * (1 - pnorm(abs(z_stat)))


# Not pooled CI
var1 <- (0.039 * (1 - 0.039) / 1563)
var2 <- (0.039 * (1 - 0.039) / 579)

SE <- sqrt(var1 + var2)

z_score <- 1.645 

ME <- z_score * SE


LL <- (0.039 - 0.026) - ME
UU <- (0.039 - 0.026) + ME

LL
UU


# Question 2 --------------------------------------------------------------

x_bar_D <- 4.55
n_D <- 11
SE <- 18.09 / sqrt(11)

t_stat <- x_bar_D / SE
df <- n_D - 1

p_val <- 2 * (1 - pt(abs(t_stat), df))

1 - (1 - 0.99) / 2

t_score <- qt(0.995, df)

LL <- 4.55 - (3.169 * 5.454)
UU <- 4.55 + (3.169 * 5.454)

# Question 3 --------------------------------------------------------------

(17 - 3.9)^2 / 3.9
(35 - 48.1)^2 / 48.1
(8 - 4.6)^2 / 4.6
(53 - 56.4)^2 / 56.4
(22 - 38.5)^2 / 38.5
(491 - 474.5)^2 / 474.5

44.00256 +3.567775+2.513043+0.2049645+7.071429+0.5737619

(3 - 1)*(2 -1)

format(1 - pchisq(57.9, 2), scientific = FALSE)



var1 <- (6.60^2 / sqrt(18))
var2 <- (7.67^2 / sqrt(27))

SE <- sqrt(var1 + var2)

t_stat <- (46.85 - 10.37) / SE 

n1 <- 18 
n2 <- 27 

df <- min (n1 - 1, n2 - 2)
p_val <- 1 - pt(t_stat, df)

format(p_val, scientific = FALSE)


1 - (1 - 0.95) / 2

t_score <- qt(0.975, df)

ME <- t_score * SE

LL <- (46.85 - 10.37) - ME
UU <- (46.85 - 10.37) + ME

# Question 5 --------------------------------------------------------------

aa <- 142
bb <- 121
ab <- 307

obs <- rbind(aa, bb, ab)

n <- length(obs)
df <- n - 1

p_aa <- 0.25
p_bb <- 0.25
p_ab <- 0.5

exp_aa <- aa * p_aa
exp_bb <- bb * p_bb
exp_ab <- ab * p_ab

var1 <- (aa - exp_aa)^2 / exp_aa
var2 <- (bb - exp_bb)^2 / exp_bb
var3 <- (ab - exp_ab)^2 / exp_ab
 
chi_sq <- sum(var1, var2, var3)

p_val <- 1 - pchisq(chi_sq, df)
p_val
