# title: Dplyr - First Exercise
# subtitle: "Exercise 1"
# author: "Aiden Rader"
# date: "2026-03-30"


# Steps -------------------------------------------------------------------

# 1. Load both the tidyverse library and haven (to import an SPSS file). If either tidyvere or
# haven are not installed. Please click on "packages" and "install" before loading the library.
library(tidyverse)
library(haven)

# 2. Create a dataframe named "prison_counts" by importing the SPSS (.sav) file
# "ncrp_3years_year_end.sav" from OneDrive.
prison_counts <- read_sav("DPLYR/Exercise 1/Datasets/ncrp_3years_year_end.sav")
# View(prison_counts)

#3. Filter out unwanted years so that only data from the year 2010 remains.
prison_counts2 <- prison_counts %>%
	filter(RPTYEAR == 2010)

#4. Convert all variable names to lower case.
prison_counts2 <- prison_counts2 %>%
	rename_with(tolower)

#5. Create a variable called "year" by assigning it the value of the rptyear variable.
prison_counts2 <- prison_counts2 %>%
	mutate(year = rptyear, inmate_dummy = 1)

#6. Create a dummy variable (inmate_dummy) that is equal to "1" on each row, to make
# inmate counting easier. Keep only the needed variables (year, dummy, state) using SELECT
# function.
prison_counts2 <- prison_counts2 %>%
	select(year, inmate_dummy, state)

# 7. Aggregate the inmate counts by year and state.
prison_counts2 <- prison_counts2 %>%
	group_by(year, state) %>%
	summarise(inmate_dummy = sum(inmate_dummy, na.rm = TRUE), .groups = "drop")

#8. Rename or change the name of "inmate_dummy" to "inmate_count" using vector or
# bracket syntax [ ] and the NAMES function.
names(prison_counts2)[names(prison_counts2) == "inmate_dummy"] <- "inmate_count"

# 9. Import the census population data from census_panel.csv.
census_panel <- read_csv("DPLYR/Exercise 1/Datasets/census_panel.csv")
# View(census_panel)

# modify census panel variables properly, i used multi layer dplyr functions
census_panel <- census_panel %>%
	rename_with(tolower) %>%
		mutate(year = wave) %>%
			select(year, state, name, pop)

# 10. Merge the 2010 state-level inmate count data with census population data.
prison_census <- merge(prison_counts2, census_panel, by = c("year", "state"))

# we can verify that the correct year has been merged.
View(prison_census)

# 11. Create an incarceration rate per 100,000 residents for each state.
prison_census <- prison_census %>%
  mutate(incarceration_rate = (inmate_count / pop) * 100000)

# 12. Sort from high to low incarceration_rate and print the results.
prison_census_sorted <- prison_census[order(prison_census$incarceration_rate, decreasing = TRUE), ]
print(prison_census_sorted[, c("state", "name", "year", "inmate_count", "pop", "incarceration_rate")])

# 13. Submit your code and final output via Blackboard.

# See Submission!
