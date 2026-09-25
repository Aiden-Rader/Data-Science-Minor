# This file is our main testing environment for our 2 - 3 Multilinear Regression Models


# Setup -------------------------------------------------------------------

library(readr)
library(dplyr)

# remove any globals in working env first
rm(list = ls())

# Import cleaned auto data set
autos <- read_csv("C:/Users/aiden/OneDrive - University of Toledo/Spring 2026 UT NOW/Statistical Methods II/R Code Project/Dataset/autos_final.csv", show_col_types = TRUE)

# Make sure we imported the correct data set
head(autos)

# We can ALSO look at our datas dimensions
dim(autos)

# Create transformed response variable
autos <- autos %>%
	mutate(log_price = log(price_euros))

# Make a model specific dataset with our canidate variables, 
# this is kind of a form of "feature selection" in learning models
autos_model <- autos %>%
	select(log_price, model_age, km, ps, gearbox, not_repaired_damage)


# Main Models -------------------------------------------------------------

# Here we will show our main models using the primarily chosen variables,
# by primarily chosen we mean that these variables would be the normal
# base case variables and did not need much editing during cleaning.

# Also given the now known plotting from our Data Cleaning step(s), 
# these would be considered the "cleanest" variables to choose from.


#==== MODEL 1 ====#

# With this model we are going with all quantitative variables, this will serve
# as my baseline model for the other models to compare against.

# Explanatory Variable (Y):
# - price_euros

# Explanatory Variables (X):
# - model_age (Quantitative)
# - km (Quantitative)
# - ps (Quantitative)


model1 <- lm(log_price ~ model_age + km + ps, data = autos_model)

summary(model1)

# Get residuals of model and plot a histogram with them
model1_residuals <- model1$residuals
hist(model1_residuals, main = "Residuals Histogram (Model 1)")

# We can plot a QQ Plot to see if this models data is normally distributed
qqnorm(model1_residuals, main = "QQ Plot (Model 1)")
qqline(model1_residuals)


#==== MODEL 2 ====#

# This second model, we are going to add a categorical variable to the 
# regression. Gearbox being our categorical variable (e.g. auto or manual).

# Explanatory Variable (Y):
# - price_euros

# Explanatory Variables (X):
# - model_age (Quantitative)
# - km (Quantitative)
# - ps (Quantitative)
# - gearbox (Categorical)

model2 <- lm(log_price ~ model_age + km + ps + gearbox, data = autos_model)

summary(model2)

# Get residuals of model and plot a histogram with them
model2_residuals <- model2$residuals
hist(model2_residuals, main = "Residuals Histogram (Model 2)")

# We can plot a QQ Plot to see if this models data is normally distributed
qqnorm(model2_residuals, main = "QQ Plot (Model 2)")
qqline(model2_residuals)


#==== MODEL 3 ====#

# The third iteration, we are going to test not_repaired_damage categorical 
# variable.

# Explanatory Variable (Y):
# - price_euros

# Explanatory Variables (X):
# - model_age (Quantitative)
# - km (Quantitative)
# - ps (Quantitative)
# - not_repaired_damage (Categorical)

model3 <- lm(log_price ~ model_age + km + ps + not_repaired_damage, data = autos_model)

summary(model3)

# Get residuals of model and plot a histogram with them
model3_residuals <- model3$residuals
hist(model3_residuals, main = "Residuals Histogram (Model 3)")

# We can plot a QQ Plot to see if this models data is normally distributed
qqnorm(model3_residuals, main = "QQ Plot (Model 3)")
qqline(model3_residuals)


#==== MODEL 3.5 ====#

# Now we can combine models 2 and 3 to see if we can get any better R^2. With
# this dataset being so large most of the variables are quite significant.

# Before combining the two models, lets run an ANOVA test to see which model is
# theoretically better!
anova(model2, model3)

# we can try to combine the two to see if we get a better R^2 value
model3_5 <- lm(log_price ~ model_age + km + ps + gearbox + not_repaired_damage, data = autos_model)

summary(model3_5)

# Get residuals of model and plot a histogram with them
model3_5_residuals <- model3_5$residuals
hist(model3_5_residuals, main = "Residuals Histogram (Model 3.5)")

# We can plot a QQ Plot to see if this models data is normally distributed
qqnorm(model3_5_residuals, main = "QQ Plot (Model 3.5)")
qqline(model3_5_residuals)



# Experimental Models -----------------------------------------------------

# Now that we know a good "base" model we can try adding even more variables,
# these variables took more cleaning and standardizing.

autos_model_exp <- autos %>%
	select(log_price, model_age, km, ps, gearbox, not_repaired_damage, fuel_type, brand, vehicle_simple)

#==== MODEL 4 ====#

# Explanatory Variable (Y):
# - price_euros

# Explanatory Variables (X):
# - model_age (Quantitative)
# - km (Quantitative)
# - ps (Quantitative)
# - not_repaired_damage (Categorical)
# - fuel_type (Categorical)

model4 <- lm(log_price ~ model_age + km + ps + gearbox + not_repaired_damage + fuel_type, data = autos_model_exp)

summary(model4)

# Get residuals of model and plot a histogram with them
model4_residuals <- model4$residuals
hist(model4_residuals, main = "Residuals Histogram (Model 4)")

# We can plot a QQ Plot to see if this models data is normally distributed
qqnorm(model4_residuals, main = "QQ Plot (Model 4)")
qqline(model4_residuals)

# Interpretation:
# While the inclusion of fuel type increased the R-squared value, it also
# introduced additional complexity and reduced the interpretability of the model.
# Therefore, model 3.5 is still perferable.

#==== MODEL 5 ====#

# Explanatory Variable (Y):
# - price_euros

# Explanatory Variables (X):
# - model_age (Quantitative)
# - km (Quantitative)
# - ps (Quantitative)
# - not_repaired_damage (Categorical)
# - vehicle_simple (Categorical)

model5 <- lm(log_price ~ model_age + km + ps + gearbox + not_repaired_damage + vehicle_simple, 
			 data = autos_model_exp)

summary(model5)

# Interpretation:
# Adding our categorized vehicle_type variable in fact did NOT make substantial
# changes to our models variablilty so still we will say that model 3.5 is our 
# best option.


#==== MODEL 6 ====#

# This test is going to have multiple different types of testing models based on
# how we categorize our brands to lower the sheer number of categories based on
# brand name. In theory this SHOULD imporve our R^2 value!

# Get top 10 brands
top_brands <- autos_model_exp %>%
	count(brand, sort = TRUE) %>%
	slice_head(n = 10) %>%
	pull(brand)

# Create grouped variable
autos_model_exp <- autos_model_exp %>%
	mutate(brand_group = ifelse(brand %in% top_brands, brand, "other"))

autos_model_exp$brand_group <- as.factor(autos_model_exp$brand_group)

# Explanatory Variable (Y):
# - price_euros

# Explanatory Variables (X):
# - model_age (Quantitative)
# - km (Quantitative)
# - ps (Quantitative)
# - not_repaired_damage (Categorical)
# - brand_group (Categorical)

model6 <- lm(log_price ~ model_age + km + ps + gearbox + not_repaired_damage + brand_group,
			 data = autos_model_exp)

summary(model6)

# Final Summary -----------------------------------------------------------

model_results <- data.frame(
	Model = c("Model 1", "Model 2", "Model 3", "Model 3.5", "Model 4", "Model 5", "Model 6"),
	
	R2 = c(
		summary(model1)$r.squared,
		summary(model2)$r.squared,
		summary(model3)$r.squared,
		summary(model3_5)$r.squared,
		summary(model4)$r.squared,
		summary(model5)$r.squared,
		summary(model6)$r.squared
	),
	
	Adj_R2 = c(
		summary(model1)$adj.r.squared,
		summary(model2)$adj.r.squared,
		summary(model3)$adj.r.squared,
		summary(model3_5)$adj.r.squared,
		summary(model4)$adj.r.squared,
		summary(model5)$adj.r.squared,
		summary(model6)$adj.r.squared
	)
)

model_results

# Diagnostic Plot for Model 3.5 which is our best plot
plot(model3_5$fitted.values, model3_5$residuals,
	 main = "Residuals vs Fitted (Model 3.5)",
	 xlab = "Fitted Values",
	 ylab = "Residuals")
abline(h = 0, col = "red")

plot(model4$fitted.values, model4$residuals,
	 main = "Residuals vs Fitted (Model 4)",
	 xlab = "Fitted Values",
	 ylab = "Residuals")
abline(h = 0, col = "red")
