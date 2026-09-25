# Title: Lab for Chapter 9
# Subtitle: ICA Questions
# Name: Aiden Rader
# Date: 03/31/2026

# Prompt ------------------------------------------------------------------

# Decrease in physical activity is considered to be a major contributor to the increase 
# in prevalence of overweight and obesity in the general adult population. Because 
# the prevalence of physical inactivity among college students is similar to the adult 
# population, many researchers feel a clear understanding of college students’ 
# physical activity behaviors is needed to develop early interventions. As part of a 
# recent study, researchers looked at the relationship between physical activity (PA) 
# measured with a pedometer and body mass index (BMI). Each participant wore the 
# pedometer for a week and the average steps per day (in thousands) was recorded. 

# Various body composition variables, including BMI (kg/m2) were also measured. 
# For this example, we focus on a sample of 100 female undergraduates.


# Setup -------------------------------------------------------------------

# Is this observational or experimental?
# Observational study

# Import the data set
library(readxl)
pabmi <- read_excel("Chapter Labs/Chapter 9/Datasets/pabmi.xls")
attach(pabmi)

# Fit the regression and add the line to the plot
pabmi.lm=lm(BMI~PA, data=pabmi)  
abline(pabmi.lm)

# Get a summary of Residuals + Coefficients
summary(pabmi.lm)

B1_hat <- -0.6547

# Questions ---------------------------------------------------------------

# a) What is the average BMI for a woman averages 9500 steps per day?
avg_BMI_95 <- predict(pabmi.lm, newdata = data.frame(PA = 9.5))
avg_BMI_95


# b) If an observed BMI at x = 9.5 were 22.8, what is the residual? 
res_BMI <- 22.8 - avg_BMI_95
res_BMI

# c) Construct a 95% confidence interval for the slope.
df <- nrow(pabmi) - 2
t_val <- qt(0.975, df)
mean_PA <- mean(PA)
sd_PA <- sd(PA)

conf_slope_est <- confint(pabmi.lm, "PA", 0.95)
conf_slope

# d) Construct a 95% confidence interval for an average of 9000 steps per day.
newdata = data.frame(PA=9.0)
predict(pabmi.lm, newdata, interval = "confidence")

# e) Calculate the 95% prediction interval for an average of 9000 steps per day.
newdata = data.frame(PA=9.0)
predict(pabmi.lm, newdata, interval = "predict")
