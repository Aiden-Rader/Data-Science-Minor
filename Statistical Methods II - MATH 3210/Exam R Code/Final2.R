obs <- c(8, 5, 12, 15)
exp <- c(10, 10, 10, 10)

chisq.test(obs, p = exp)

22.915 * 100

22.915 * 1000

-55.382 * 1000

-55.382 + 62.354*(2000) + +1.636*(3)+22.915*(2)

summary(mod)
anova(mod)


1.636 / 4.327

50 / 200
89-3-1
3/85

cereals <- c("General Mills", "Kellogg", "Quaker")
means <- c(1.469, 1.764, 2.567)
std <- c(1.248, 2.349, 2.174)
samp_size <- c(13, 11, 6)

table <- data.frame(
	cereals, means, std, samp_size
)


mod <- aov(y ~ group, df = table)

SSG <- 13*(1.469-1.797)^2 + 11*(1.764-1.797)^2 + 6*(2.567-1.797)^2
1.248*1.469
2.349*1.764
2.174*2.567

SSE <- ((1.833312 - 1.469)^2 + (4.143636 - 1.764)^2 + (5.580658 - 2.567)^2)

MSG <- SSG/2
MSE <- SSE/27
f_stat <- MSG / MSE

n1 <- 13
n2 <- 11
n3 <- 6

x1 <- 1.469
x2 <- 1.764
x3 <- 2.567

df_error <- 27

x_diff1 <- x1 - x2
SE1 <- sqrt(MSE * (1/n1 + 1/n2))

test_stat1 <- x_diff1 / SE1

# We need a two tailed p val (always for ANOVA)
p_val1 <- 2 * (1 - pt(abs(test_stat1), df_error))

x_diff2 <- x2 - x3
SE2 <- sqrt(MSE * (1/n2 + 1/n3))

test_stat2 <- x_diff2 / SE2

# We need a two tailed p val (always for ANOVA)
p_val2 <- 2 * (1 - pt(abs(test_stat2), df_error))
