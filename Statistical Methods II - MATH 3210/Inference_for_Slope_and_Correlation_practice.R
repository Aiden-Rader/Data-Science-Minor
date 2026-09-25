# Section 9.1

1.78+0.0831*(7)

4 - 2.3617



# Example Code ------------------------------------------------------------

# We use lm() to make a simple linear regression
# Then after this if we need a summary of the linear regression use summary() on the result
# from our lm()

# We can then output the ANOVA using anova() with the result from our lm()
f_stat <- 65.4
df_model <- 1
df_error <- 53

p_val <- 1 - pf(f_stat, df_model, df_error)