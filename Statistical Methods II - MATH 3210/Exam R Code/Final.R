# R Code for during the Final Exam
# Aiden Rader


# Questions -------------------------------------------------------------------




# Sections ----------------------------------------------------------------

# Section 8.1
mod <- aov(y ~ group, data = df)
summary(mod)

p_val >= alpha # fail to reject the null hypothesis
p_val < alpha # reject the null hypothesis

# Reject H0 → at least one group mean differs
# Fail → not enough evidence means differ

# Section 8.2

TukeyHSD(mod)
# Shows:
# diff = mean difference
# lwr/upr = CI
# p adj = adjusted p-value

# Manually calculate stats
SE <- sqrt(MSE * (1/n1 + 1/n2))
t <- (x1 - x2) / SE
p <- 2 * (1 - pt(abs(t), df))
ME <- qt(1 - alpha/2, df) * SE
CI <- (x1 - x2) + c(-ME, ME)

# Section 9.1
mod <- lm(y ~ x, data = df)
summary(mod)


# Section 9.2
anova(mod)  # after the lm() anova result

# Section 9.3
new <- data.frame(x = x_star)
predict(mod, newdata = new, interval = "confidence")
predict(mod, newdata = new, interval = "prediction")

# Section 10.1
mod <- lm(y ~ x1 + x2 + x3, data = df)
summary(mod)
anova(mod)

# Effect of xi holding all other variables constant

# Section 10.2
plot(mod)  # plots the multilinear regression


# Useful plots:
plot(fitted(mod), residuals(mod))
abline(h = 0)

hist(residuals(mod))
qqnorm(residuals(mod))
qqline(residuals(mod))

# Section 10.3
summary(mod)$r.squared
summary(mod)$adj.r.squared
sigma(mod)   # residual standard error

# Higher adjusted R² = better
# Lower sigma/mod residual SE = better
# Lower p-values = better predictors

# If needed Section 7.1 / 7.2

# goodness of fih
obs <- c(...)
prob <- c(...)

chisq.test(obs, p = prob)

# test of association
tbl <- matrix(c(...), nrow = ..., byrow = TRUE)
chisq.test(tbl)

# expected counts
chisq.test(tbl)$expected