# Title: Lab for Chapter 9
# Name: Aiden Rader
# Date: 03/31/2026


# Setup/Understanding --------------------------------------------------------------------

library(readxl)
pabmi <- read_excel("Chapter Labs/Chapter 9/Datasets/pabmi.xls")
View(pabmi)

# First draw the graph/scatter plot to see if there is a linear relation
attach(pabmi)

# draws a scatter plot
plot(PA, BMI, main = "Scatter Plot BMI ~ PA")

# Fit the regression and add the line to the plot
pabmi.lm=lm(BMI~PA, data=pabmi)  
abline(pabmi.lm)

# Get a summary of Residuals + Coefficients
summary(pabmi.lm)  # this focuses on the B1 hypothesis testing (figure out how to interpret)

# Residual against the Explanatory variable
plot(PA, residuals(pabmi.lm), xlab="PA(thousands of steps)", ylab="Residuals")

# QQPlot for the residual (based on z = x - mu / sig)
qqnorm(residuals(pabmi.lm), xlab="Normal Score", ylab="Residuals")
qqline(residuals(pabmi.lm))

# Find the confidence interval for the mean response
newdata = data.frame(PA=9.5)

# Find the prediction interval for a future observation
conf <- predict(pabmi.lm, newdata, interval = "confidence")
conf
pred <- predict(pabmi.lm, newdata, interval = "predict")
pred

# Produce an ANOVA table
anova_test <- anova(pabmi.lm)
anova_test

# Correlation test
corr_test <- cor.test(PA, BMI)
format(corr_test["p.value"], scientific = FALSE)


# 1. Interpretation based on P-Value (Correlation Test): ------------------
# H0: Roe = 0, Ha: Roe =/ 0

# We have significant evidence that there is a linear relationship between 
# physical activity (PA) and BMI.

# Summary: Reject H0


# 2. Interpretation based on B1 (running summary on pabmi.lm): ------------
# H0: B1 = 0, Ha: B1 =/ 0


# Summary: 

# 3. Interpretation based on model effectiveness (ANOVA) ------------------
# H0: The model is ineffective, Ha: The model is effective

# 14.8% of BMI can be explained by the Physical Activity (based on R^2),
# In other words, only 15% of the model can be explained by the BMI

# Summary: 


