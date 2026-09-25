# Assignment: Quiz 1 - Base R
# Professor: Dr. David Lilley

# Name: Aiden Rader
# Date: 3/25/2026


# Steps -------------------------------------------------------------------

# 1. Load the "haven" packaghe to import an SPSS file.
library(haven)

# 2. reate a dataframe named “prison_counts” by importing the SPSS (.sav) file
# “ncrp_3years_year_end.sav” from OneDrive (under the “Crime” and “Prison”) subfolders.
prison_counts <- read_sav("Datasets/ncrp_3years_year_end.sav")  # taken from the import screen
# View(prison_counts)

#3. Filter out unwanted years so that only data from the years 2000 and 2010 remains.
prison_counts2 <- prison_counts

prison_counts2 = subset(prison_counts2, prison_counts2$RPTYEAR == 2000 | prison_counts2$RPTYEAR == 2010)

#4. Convert all variable names to lower case.
names(prison_counts2) <- tolower(names(prison_counts2))


#5. Create a variable called "year" by assigning it the value of the rptyear variable.
prison_counts2$year <- prison_counts2$rptyear


#6. Create a dummy variable (inmate_dummy) that is equal to “1” on each row, to make inmate counting
# easier. Keep only the needed variables (year, dummy, state) using SUBSET function. **Also, create a counter
# for female inmates.
prison_counts2$inmate_dummy <- 1
prison_counts2$female_dummy <- ifelse(prison_counts2$sex == 2, 1, 0)
prison_counts2 <- subset(prison_counts2, select = c(year, inmate_dummy, state, female_dummy))

# CHECKS #
# Count a total of how many female inmates there are to check
print(length(prison_counts2$female_dummy[prison_counts2$female_dummy == 1]))

# How many are not female?
print(length(prison_counts2$female_dummy[prison_counts2$female_dummy == 0]))


#7. Aggregate all needed variables using the AGGREGATE function. You may use CBIND to combine the
# female count with the overall inmate count (if you aggregated them separately).
total_count_aggr <- aggregate(inmate_dummy ~ year + state, data = prison_counts2, sum)
female_count_aggr <- aggregate(female_dummy ~ year + state, data = prison_counts2, sum)


#8. Rename or change the name of “inmate_dummy" to "inmate_count" using vector or bracket syntax [ ]
# and the NAMES function. Do the same for “female_count.”
names(total_count_aggr)[names(total_count_aggr) == "inmate_dummy"] <- "inmate_count"
names(female_count_aggr)[names(female_count_aggr) == "female_dummy"] <- "female_count"

# Then we can merge the two together just so we have both total counts AND female_counts
prison_count_aggr <- merge(total_count_aggr, female_count_aggr, by = c("year", "state"))


#9. Import the census population data from OneDrive “census_panel.csv” (under the “Crime” subfolder)
library(readr)
census_panel <- read_csv("Datasets/census_panel.csv")
# View(census_panel)


#10. Merge the 2010 state-level inmate count data with census population data (using the Base R inner join
# function. Verify that the correct year has been merged.

# Example: database_inner <- merge(data_A, data_B, by = "ID")

# rename the wave -> year and remove the wave variable
census_panel$year <- census_panel$wave
census_panel$wave <- NULL

# lowercase all variables (since we can combine state then!)
names(census_panel) <- tolower(names(census_panel))

prison_census <- merge(prison_count_aggr, census_panel, by = c("year", "state"))
# View(prison_census)


#11. Create an incarceration rate (per 100,000 residents) for female inmates in each state.
prison_census$incarceration_rate <- (prison_census$inmate_count / prison_census$pop) * 100000
prison_census$female_incarceration_rate <- (prison_census$female_count / prison_census$pop) * 100000


#12. Remove “District of Columbia” (also known as Washington, DC) from the dataframe because this is a city,
# not a state
prison_census <- subset(prison_census, prison_census$name != "District of Columbia")


#13. Sort the (from high to low incarceration_rate) using the order function, then print out the incarceration
# rate data with (including state name and year) so I can review all results.

# Example: print(dataframe).
total_prison_census_sorted <- prison_census[order(prison_census$incarceration_rate, decreasing = TRUE), ]
print(total_prison_census_sorted[, c("state", "name", "year", "incarceration_rate")])

female_prison_census_sorted <- prison_census[order(prison_census$female_incarceration_rate, decreasing = TRUE), ]
print(female_prison_census_sorted[, c("state", "name", "year", "female_incarceration_rate")])

# Interpretation:

# Printing both the total incarceration rate and the female incarceration rate, we can see that when it was total
# 2010 Louisiana was our highest incarceration rate (877.4208). Now with the new knowledge of having the female 
# only incarceration rate, our highest would be 2010 Oklahoma (70.845591)!

# Most of the states with the highest female incarceration rate are southern (except Alaska) and most are also 
# in 2010.


# 14. Submit your code and final output via Blackboard.

# SEE SUBMISSION #


