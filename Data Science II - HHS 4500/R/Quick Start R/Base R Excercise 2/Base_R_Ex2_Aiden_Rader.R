# title: Base R - Exercise 2
# subtitle:  "Exercise 2"
# author: "Aiden Rader"
# date: "2026-03-23"

# Steps -------------------------------------------------------------------

# 1. Load the “haven” package to import an SPSS file.  If haven is not installed, please click on 
# “packages” and “install” before loading the library. 

library(haven)

# 2. Create a dataframe named “prison_counts” by importing the SPSS (.sav) file 
# “ncrp_3years_year_end.sav” from OneDrive (under the “Crime” and “Prison”) subfolders.

prison_counts <- read_sav("Datasets/ncrp_3years_year_end.sav")  # taken from the import screen
# View(prison_counts)

#3. Filter out unwanted years so that only data from the year 2010 remains.

prison_counts2 <- prison_counts

prison_counts2 = subset(prison_counts2, prison_counts2$RPTYEAR == 2010)
# View(prison_counts2)

#  we can do it like this!
# prison_counts_test = prison_counts2[prison_counts2$RPTYEAR == 2010, ]
# View(prison_counts_test)

#4. Convert all variable names to lower case.
names(prison_counts2) <- tolower(names(prison_counts2))

#5. Create a variable called "year" by assigning it the value of the rptyear variable.
prison_counts2$year <- prison_counts2$rptyear

#6. Create a dummy variable (inmate_dummy) that is equal to “1” on each row, to make
# inmate counting easier. Keep only the needed variables (year, dummy, state) using SELECT
# function.
prison_counts2$inmate_dummy <- 1
prison_counts2 <- subset(prison_counts2, select = c(year, inmate_dummy, state))
# View(prison_counts2)

#7. Aggregate all needed variables using the AGGREGATE and CBIND functions.
prison_counts_aggr <- aggregate(inmate_dummy ~ state, data = prison_counts2, sum)
# View(prison_counts_aggr)

prison_counts_aggr$year <- 2010  # hardcode just 2010

#8. Rename or change the name of “inmate_dummy" to "inmate_count" using vector or
# bracket syntax [ ] and the NAMES function.
names(prison_counts_aggr)[names(prison_counts_aggr) == "inmate_dummy"] <- "inmate_count"
# View(prison_counts_aggr)

#9. Import the census population data from OneDrive “census_panel.csv” (under the “Crime”
# sub folder).
library(readr)
census_panel <- read_csv("Datasets/census_panel.csv")
View(census_panel)

# rename the wave -> year and remove the wave variable
census_panel$year <- census_panel$wave
census_panel$wave <- NULL

# lowercase all variables (since we can combine state then!)
names(census_panel) <- tolower(names(census_panel))

#10. Merge the 2010 state-level inmate count data with census population data (using the Base
# R inner join function. Verify that the correct year has been merged.

# Example: database_inner <- merge(data_A, data_B, by = "ID")

merged_data <- merge(prison_counts_aggr, census_panel, by=c("year", "state"))

#11. Create an incarceration rate (per 100,000 residents) for each state.
merged_data$incarceration_rate <- (merged_data$inmate_count / merged_data$pop) * 100000

#12. Sort the (from high to low incarceration_rate) using the order function, then print out the
# incarceration rate data with (including state name and year).

# Example: print(dataframe).

merged_data_sorted <- merged_data[order(merged_data$incarceration_rate, decreasing = TRUE), ]
print(merged_data_sorted[, c("state", "name", "year", "incarceration_rate")])

#13. Submit your code and final output via Blackboard.

# See Submisson! #

