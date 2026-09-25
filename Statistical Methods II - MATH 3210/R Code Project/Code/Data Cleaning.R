# This is the data clean up part of using a real life data set since the "used cars" data set does 
# include a lot of unnecessary variables!


# Setup --------------------------------------------------------------------

# import our autos dataset!
library(readr)
library(dplyr)

# remove any globals in working env first
rm(list = ls())

# To view original look at autos
autos <- read_csv("C:/Users/aiden/OneDrive - University of Toledo/Spring 2026 UT NOW/Statistical Methods II/R Code Project/Dataset/autos.csv")
# View(autos)

autos_edited <- autos

# Cleaning ----------------------------------------------------------------

# Drop all columns I would NOT use in any of my tests
autos_edited <- select(autos, -dateCrawled, -seller, -offerType, -abtest, -model, 
						-monthOfRegistration, -nrOfPictures, -postalCode, -lastSeen)

# To not have to import again and agian make another datafrane
autos_cleaned <- autos_edited

# Lowercase all names
autos_cleaned <- autos_cleaned %>%
	rename_all(tolower)

# Rename some of the columns
names(autos_cleaned)[names(autos_cleaned) == "vehicletype"] <- "vehicle_type"
names(autos_cleaned)[names(autos_cleaned) == "yearofregistration"] <- "model_year"
names(autos_cleaned)[names(autos_cleaned) == "powerps"] <- "ps"
names(autos_cleaned)[names(autos_cleaned) == "price"] <- "price_euros"
names(autos_cleaned)[names(autos_cleaned) == "kilometer"] <- "km"  # km is already capped around 150,000 km
names(autos_cleaned)[names(autos_cleaned) == "fueltype"] <- "fuel_type"
names(autos_cleaned)[names(autos_cleaned) == "notrepaireddamage"] <- "not_repaired_damage"
names(autos_cleaned)[names(autos_cleaned) == "datecreated"] <- "date_created"  # this will just serve as just a visualizer for me

# Analysis before cleaning!!
summary(autos_cleaned$price_euros)
summary(autos_cleaned$ps)

# Remove invalid values
autos_cleaned <- autos_cleaned[autos_cleaned$price_euros > 100 & autos_cleaned$price_euros < 500000, ]  # most used cars are not over 500k euros realistically, even that is a stretch
autos_cleaned <- autos_cleaned[autos_cleaned$model_year >= 1920 & autos_cleaned$model_year <= 2026, ]  # don't want any weird outlier years
autos_cleaned <- autos_cleaned[autos_cleaned$ps > 10 & autos_cleaned$ps < 500, ]  # most used cars are about 50 - 400 ps even sports cars rarely exceed the 500 mark!

# Create a new variable for model_age given the actual number of years from the
# year the data was crawled (2016)
autos_cleaned <- autos_cleaned %>%
	mutate(model_age = 2016 - autos_cleaned$model_year)

# Analysis after cleaning!!
summary(autos_cleaned$price_euros)
summary(autos_cleaned$ps)

# Clean our categorical variables
autos_cleaned$gearbox[autos_cleaned$gearbox == "automatik"] <- "automatic"
autos_cleaned$gearbox[autos_cleaned$gearbox == "manuell"] <- "manual"

autos_cleaned$not_repaired_damage[autos_cleaned$not_repaired_damage == "ja"] <- "yes"
autos_cleaned$not_repaired_damage[autos_cleaned$not_repaired_damage == "nein"] <- "no"

autos_cleaned$fuel_type[autos_cleaned$fuel_type == "diesel"] <- "diesel"
autos_cleaned$fuel_type[autos_cleaned$fuel_type == "benzin"] <- "gasoline"
autos_cleaned$fuel_type[autos_cleaned$fuel_type == "lpg"] <- "lpg"
autos_cleaned$fuel_type[autos_cleaned$fuel_type == "andere"] <- "other"
autos_cleaned$fuel_type[autos_cleaned$fuel_type == "hybrid"] <- "hybrid"
autos_cleaned$fuel_type[autos_cleaned$fuel_type == "cng"] <- "cng"
autos_cleaned$fuel_type[autos_cleaned$fuel_type == "elektro"] <- "electric"

autos_cleaned$vehicle_type[autos_cleaned$vehicle_type == "kleinwagen"] <- "small_car"
autos_cleaned$vehicle_type[autos_cleaned$vehicle_type == "limousine"] <- "sedan"
autos_cleaned$vehicle_type[autos_cleaned$vehicle_type == "kombi"] <- "wagon"
autos_cleaned$vehicle_type[autos_cleaned$vehicle_type == "cabrio"] <- "convertible"
autos_cleaned$vehicle_type[autos_cleaned$vehicle_type == "andere"] <- "other"

autos_cleaned$brand[autos_cleaned$brand == "sonstige_autos"] <- "other"

# Simplify the vehicle types from 8 categories -> 2 categories (makes regression easy)
autos_cleaned$vehicle_simple <- ifelse(
	autos_cleaned$vehicle_type %in% c("suv", "bus", "wagon"), "large", "small")


# NA any empty string boxes
autos_cleaned$gearbox[autos_cleaned$gearbox == ""] <- NA
autos_cleaned$not_repaired_damage[autos_cleaned$not_repaired_damage == ""] <- NA


# Convert categorical variables to factors
autos_cleaned$gearbox <- as.factor(autos_cleaned$gearbox)
autos_cleaned$not_repaired_damage <- as.factor(autos_cleaned$not_repaired_damage)
autos_cleaned$vehicle_simple <- as.factor(autos_cleaned$vehicle_simple)


# Optional ----------------------------------------------------------------

# Optionally made horsepower and miles variable
autos_cleaned$hp <- round(autos_cleaned$ps * 0.9863200706, digits = 2)
autos_cleaned$miles <- round(autos_cleaned$km * 0.6213711922, digits = 2)
autos_cleaned$price_usd <- round(autos_cleaned$price_euros * 1.1520498423, digits = 2)

# Remove missing values
autos_cleaned <- na.omit(autos_cleaned)

# Export the final rendition of the CSV
write_csv(autos_cleaned, "C:/Users/aiden/OneDrive - University of Toledo/Spring 2026 UT NOW/Statistical Methods II/R Code Project/Dataset/autos_final.csv")


# Statistics --------------------------------------------------------------

str(autos_cleaned)
summary(autos_cleaned)
glimpse(autos_cleaned)
names(autos_cleaned)


# Plots -------------------------------------------------------------------

autos_cleaned <- read_csv("C:/Users/aiden/OneDrive - University of Toledo/Spring 2026 UT NOW/Statistical Methods II/R Code Project/Dataset/autos_final.csv")

autos_data_frame <- data.frame(autos_cleaned)

# Just removing any unnecessary optional ones
autos_data_frame <- autos_data_frame %>%
	select(-index, -date_created, -hp, -miles, -price_usd)

# Getting the distinct counts of all variables
distinct_counts <- sapply(autos_data_frame, function(x) n_distinct(x))
distinct_counts

# Find each unique value for specific variables
unique(autos_data_frame$vehicle_type)
sort(table(autos_data_frame$brand), decreasing = TRUE)
table(autos_data_frame$fuel_type)

# Histograms for numerical values
num_vars <- autos_data_frame[sapply(autos_data_frame, is.numeric)]

for (col in names(num_vars)) {
	hist(num_vars[[col]],
		 main = paste("Histogram of", col),
		 xlab = col)
}
rm(col)

# Bar Graph for categorical values

autos_data_frame_no_name <- autos_data_frame %>%
	select(-name)

cat_vars <- autos_data_frame_no_name[sapply(autos_data_frame_no_name, function(x) is.factor(x) || is.character(x))]

for (col in names(cat_vars)) {
	barplot(table(cat_vars[[col]]),
			main = paste("Barplot of", col),
			las = 2)
}
rm(col)


# For EDA Slide on Presentation -------------------------------------------

# Singular Histogram for price dist.
hist(autos_cleaned$price_euros,
	 main = "Distribution of Car Prices",
	 xlab = "Price (Euros)",
	 breaks = 50)

# Log version since dist is squished
hist(log(autos_cleaned$price_euros),
	 main = "Distribution of Log(Car Prices)",
	 xlab = "Log(Price (Euros))",
	 breaks = 50)


# Scatterplots vs. price plots #

# Plot of Price vs. Milage
plot(autos_cleaned$km, log(autos_cleaned$price_euros),
	 main = "Log(Price) vs Mileage",
	 xlab = "Mileage (km)",
	 ylab = "Log(Price (Euros))",
	 pch = 16, cex = 0.3,
	 col = rgb(0,0,0,0.05))

# Adding trend line to show signify decreasing in price with higher milage
lines(lowess(autos_cleaned$km, log(autos_cleaned$price_euros)),
	  col = "red", lwd = 2)

# Plot of Price vs. Model Age (via 2016)
plot(autos_cleaned$model_age, log(autos_cleaned$price_euros),
	 main = "Log(Price) vs Model Age",
	 xlab = "Model Age (years)",
	 ylab = "Log(Price (Euros))",
	 pch = 16, cex = 0.3)

lines(lowess(autos_cleaned$model_age, log(autos_cleaned$price_euros)),
	  col = "red", lwd = 2)

# Plot of Price vs. Power (Pferdestärke)
plot(autos_cleaned$ps, log(autos_cleaned$price_euros),
	 main = "Log(Price) vs Power",
	 xlab = "Power (Pferdestärke)",
	 ylab = "Log(Price (Euros))",
	 pch = 16, cex = 0.3)

# Using linear fit instead of smoothing method fit (LOWESS)
abline(lm(log(price_euros) ~ ps, data = autos_cleaned),
	   col = "red", lwd = 2)

# Boxplot for prices to gearbox
boxplot(log(price_euros) ~ gearbox, data = autos_data_frame,
		main = "Log(Price) by Gearbox",
		xlab = "Gearbox",
		ylab = "Log(Price)")

# Boxplot for prices to vehicle condition
boxplot(log(price_euros) ~ not_repaired_damage, data = autos_data_frame,
		main = "Log(Price) by Damage Status",
		xlab = "Damage Status",
		ylab = "Log(Price)")


# For Corr Analysis Slide -------------------------------------------------
# I wanted to build a sort of corr matrix!

corr_data <- autos_data_frame[, c("price_euros", "model_age", "km", "ps")]

# If you're using log(price)
corr_data$log_price <- log(autos_data_frame$price_euros)

# Compute correlation matrix
cor_matrix <- cor(corr_data[, c("log_price", "model_age", "km", "ps")],
				  use = "complete.obs")

round(cor_matrix, 3)
