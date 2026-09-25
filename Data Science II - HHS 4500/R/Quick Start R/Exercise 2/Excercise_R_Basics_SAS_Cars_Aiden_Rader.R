#' ---
#' title: "Base-R Exercise 2 - SAS Cars Merge Aggregate"
#' subtitle:  "Excercise 2"
#' author: "Aiden Rader"
#' date: "2026-03-16"

#' ---

# Steps -------------------------------------------------------------------

# 1) Open SAS and save the preloaded "Cars" data file to your computer (e.g. downloads, desktop).  Leave the file in SAS format (.SAS7BDAT).

# See file in explorer!

# 2) Open R and install the "haven" package, then use the library command to load the package into the R software.
# install.packages("haven") or use package manager to the right like shown in class

# Save the sashelp.cars data set as variable
library(haven)

# 3) Import the SAS "Cars" file using the "haven" package.
cars_orig <- read_sas("C:/Users/aiden/OneDrive - University of Toledo/Spring 2026 UT NOW/Data Science II/R Environment/Data_Science_Sp26/Datasets/cars.sas7bdat")

# 4) Make a copy of cars, named "cars2"
cars2 <- cars_orig

# 5) Sort cars2 by make and model.
cars2 <- cars2[order(cars2$Make, cars2$Model),]

# 6) Create a numeric ID variable (using any method).
cars2$id <- 0
cars2$id <- as.integer(rownames(cars2))

# 7) Convert all variable names to lower case.
names(cars2) <- tolower(names(cars2))

# 8) Create a dataframe called cars_half1 that keeps only the variables: id, make, mpg_city, mpg_highway
cars_half1 <- subset(cars2, select = c(id, make, mpg_city, mpg_highway))
 
# 9) Create a dataframe called cars_half2 that keeps only the variables: id, model, type, msrp, weight
cars_half2 <- subset(cars2, select = c(id, model, type, msrp, weight))

# 10) Merge cars_half1 and cars_half2 by id (name the merged file "cars_merged")
cars_merged <- merge(cars_half1, cars_half2, by = "id")

# 11)  Using cars_merged, create a new variable called "mpg_avg" that averages mpg_city and mpg_highway.
cars_merged$mpg_avg <- (cars_merged$mpg_city + cars_merged$mpg_highway) / 2

# 12) Use the "table" function to obtain a frequency count of cars by "type" (write the counts by type using comments).
table(cars_merged$type)

# Hybrid: 3
# Sedan: 262
# Sports: 49
# SUV: 60
# Truck: 24
# Wagon: 30

# 13) Remove all cars that are type "Hybrid" by using a filter variable and bracket notation (two step process).
hybrid_check <- cars_merged$type == "Hybrid"  # gotta remember that comparison operator instead of equate!!
cars_merged <- cars_merged[!hybrid_check, ]

# 14) Aggregate all vehicles by type to identify the mean of mpg_avg for each type.
type_means <- aggregate(mpg_avg ~ type, data = cars_merged, mean)
type_means

# 15) Write a comment that lists the mean values for each type of car.

# type   mpg_avg
# Sedan  24.85687
# Sports 21.94898
# SUV    18.30000
# Truck  18.75000
# Wagon  24.50000
