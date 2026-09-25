# Homework Section 9.2


# Question 4 ---------------------------------------------------------------

R2 <- 3404.6 / 35960.0
R2


# Question 5 --------------------------------------------------------------

df_mod <- 1
df_error <- 98
df_total <- 99

SSM <- 290
SST <- 3000

SSE <- SST - SSM

MSM <- SSM / df_mod
MSE <- SSE / df_error

f_stat <- MSM / MSE

p_val <- 1 - pf(f_stat, df_mod, df_error)


# Question 7 --------------------------------------------------------------


pred_price <- 378 - 18.6 * (10)

SSR <- 57604
SST <- 136237

R2 <- SSR / SST

# Question 8 --------------------------------------------------------------

mating_act <- 0.480 - 0.323 * (0.40)
