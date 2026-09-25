# title: School Enrollment R Project
# author: "Aiden Rader"
# date: "2026-04-06"

# Part 1 - Fully Merged --------------------------------------------------------------------

# SCHOOL ENROLLMENT PREP SECTION (steps 1 - 8)

# 1. At the top of your R code file, read-in most of the libraries that you will need.
# For example: library(tidyverse), library(panelr).

# Base librariees needed
library(tidyverse)
library(panelr)

# other libraries needed
library(readxl)
library(readr)
library(dplyr)
library(haven)
library(corrr)
library(stargazer)  # for the reg tables in Part 2!

# 2. We will work on the school enrollment data first. Read-in ELSI_School_Enroll_1990_2001_Revised.xlsx.
# Create an exact copy called "school_clean1"

school_data <- read_excel("Project 2/Datasets/ELSI_School_Enroll_1990_2001_Revised.xlsx")
school_clean1 <- school_data
nrow(school_clean1)

# 3. Prepare/clean the file prior to transposing and merging. To replicate the SAS process,
# write some code to replace all "dagger" ("†") values and dashes ("–") from all variables.
# Reassign the values to NA.

# Base R is easiest for this task.
# (Found out about the difference between long dash and normal dash)
school_clean1[school_clean1 == "†"] <- NA
school_clean1[school_clean1 == "–"] <- NA  # long dash
school_clean1[school_clean1 == "-"] <- NA  # normal dash

# 4. Change all variable names to lowercase.
school_clean1 <- school_clean1 %>%
  rename_with(tolower)

# 5. Transpose "school_clean1" from wide to long panel format by using the long_panel command (from panelr). Be sure
# that you understand the code example pasted below.

# Code example (I did use this with panelr):
school_long <- long_panel(
  school_clean1,
  id = "school_id",
  prefix = "_",
  begin = 1990,
  end = 2001,
  label_location = "end"
)

nrow(school_long)

# Transforms the dataset from wide format (one row per school with many year columns)
# into long panel format (one row per school-year). This is required for merging with
# other datasets that are organized by county-year like most of the others actually are.

# 6. After the transpose, rename the variable "wave" (created by long_panel) to
# "year" and change "white", "black", "hispanic" and all other race/ethnic groups
# from character into numeric variable types.

school_long <- school_long %>%
  rename(year = wave)

race_cols <- c("white", "black", "hispanic", "ai_native", "asian_pacif")

# Conversion of race columns + total_enroll column to numeric
school_long_num <- school_long %>%
	mutate(
		across(
			all_of(c(race_cols, "total_enroll")),
			readr::parse_number
		)
	)

# we can take a good sanity check to make sure all the correct variables are numeric

# str for base R
# str(school_long_num)

# OR I found out you can also use DPLYR's "glimpse" function for nicer output
# numeric would equate to a double though
# glimpse(school_long_num)

# 7. Using dplyr and the rowwise() command, create a variable called
# "total_enroll2" by summing all of the race/ethnic counts together for each
# school. Sort the data by school_id, year to inspect your enrollment counts and
# look over the data (some missing values are expected). Drop the original
# "total_enroll" variable as it is no longer needed.

school_long2 <- school_long_num %>%
	rowwise() %>%
	mutate(
		total_enroll2 = {
			vals <- c_across(all_of(race_cols))
			if (all(is.na(vals))) NA_real_ else sum(vals, na.rm = TRUE)
		}
	) %>%
	ungroup() %>%
	arrange(school_id, year) %>%
	select(-total_enroll)

school_long2 <- school_long2 %>%
	ungroup()


# total_enroll2 (replacing total_enroll) is computed as the sum of all race/ethnicity
# counts for each school-year. This ensures consistency with the disaggregated race
# data and handle missing values properly.

# 8. Our school_id variable is now a "factor."  Using base R and dollar$ syntax,
# convert school_id to numeric.  Note: This can be tricky because you may have
# to convert to character first, then numeric (all on a single line of code)

school_long2$school_id <- as.numeric(as.character(school_long2$school_id))

# sanity check if everything looks okay (i.e. school_id is double/numeric and rows
# are not grouped)
glimpse(school_long2)

# Export as a csv so I dont have to run that rowise() function!
write_csv(school_long2, "Project 2/Datasets/school_long2.csv")

rm(list = ls())


# READ-IN AND PREPARE THE SCHOOL COUNTY FIPS DATA – MERGE WITH ENROLLMENTS

# 9. We now need a unique variable for each county (e.g. county_fips). Read-in both school files that contain county fips
# using these names: school_counties <- ELSI_School_ID_County_FIPS_2001.xlsx and school_coord <-
# All_School_Coordinates_2016_ELSI.xlsx.

# Be sure to convert school_id in both of these files into a numeric or integer
# format for merging with school_enrollment (using a single line of Base-R code right after the read-in may work best.)

school_counties <- read_excel("Project 2/Datasets/ELSI_School_ID_County_FIPS_2001.xlsx")
nrow(school_counties)
school_counties <- school_counties %>%
	rename(school_id = School_ID)
school_counties$school_id <- as.numeric(as.character(school_counties$school_id))
nrow(school_counties)

school_coord <- read_excel("Project 2/Datasets/All_School_Coordinates_2016_ELSI.xlsx")
school_coord$school_id <- as.numeric(as.character(school_coord$'School ID NCES'))
nrow(school_coord)

# 10. Prepare / clean both files that contain fips_county (one at a time). Lowercase all variables and keep only the
# needed variables when merging.

school_counties <- school_counties %>%
	rename_with(tolower) %>%
	rename(school_name2 = 'school name') %>%
	select(school_id, school_name2, state_name, state_abbr, fips_state, county_number) %>%
	rename(fips_county = county_number)

school_coord <- school_coord %>%
	rename_with(tolower) %>%
	select(school_id, school_name, school_name2, state_name, state_abbr, fips_state, county_number) %>%
	rename(fips_county = county_number)

# 11. Use dplyr left join to merge the enrollments data frame with school_counties (create: combo_school_counties).
# Then, create a data frame with ONLY the non-matching records from the merge. Merge this non-matching file with
# school_coord using an inner_join. Lastly, merge the matching records from this merge with combo_school_counties.

school_long2 <- read_csv("Project 2/Datasets/school_long2.csv")

combo_school_counties <- left_join(school_long2, school_counties, by = "school_id")
# head(combo_school_counties)

# NOTE: .x is from the school_long2 dataset and .y is from the school_counties dataset

# We can create a dataframe with ONLY non matching records from the previous merge
school_nomatch <- combo_school_counties %>%
	filter(is.na(fips_county))

nrow(school_nomatch)

# The nrow test is to see if we have 24,446 records, the result is 293,352 which
# given 12 years (1990 - 2001) would be 24446 * 12 = 293352! We can even double
# verify this if we look at the number of distinct school_id rows!
school_nomatch %>%
	distinct(school_id) %>%
	nrow()

# Now we can merge the non matching file with school_coord
school_coord_match <- inner_join(school_nomatch, school_coord, by = "school_id", suffix = c("", "_coord"))


# Merge the matching records from this new merge with combo_school_counties
combo_school_counties_match <- combo_school_counties %>%
	filter(!is.na(fips_county))

combo_school_final <- bind_rows(combo_school_counties_match, school_coord_match)


# 12. Clean the final enrollments (combo) file by removing unnecessary variables. Use coalesce to ensure that the
# fips_county variable is as complete as possible.

combo_school_final <- combo_school_final %>%
	mutate(fips_county = coalesce(fips_county, fips_county_coord))

# using coalesce() combines the FIPS values from both merges, ensuring that any missing
# values from the first merge are filled using the fallback merge results.

# Now we can just select the ID, year, enrollment num, and the fips county
combo_school_final <- combo_school_final %>%
	select(school_id, year, total_enroll2, fips_county)


# 13. Aggregate the final enrollments (combo) file to the county-year level by using:
# summarize(county_enroll=sum(total_enroll2)) with groupby. You are done with the school enrollment file.

school_enrollment_county <- combo_school_final %>%
	group_by(fips_county, year) %>%
	summarize(county_enroll = sum(total_enroll2, na.rm = TRUE), .groups = "drop")
# head(school_enrollment_county)

# Aggregates school-level enrollment to the county-year level. This is necessary
# because the  census, crime, and economic data are all reported at the county-year
# level.

# Check if there are 0 dupes in case
school_enrollment_county %>%
	count(fips_county, year) %>%
	filter(n > 1)

summary(school_enrollment_county$county_enroll)


# 14. Create a permanent csv for the county-year level school enrollments file that you just created and write syntax to
# clear all files from the R Global Environment using: rm(list=ls()). Next, read-in the csv that you just created to start fresh.

write_csv(school_enrollment_county, "Project 2/Datasets/school_enrollment_county_year.csv")

rm(list = ls())

school_enrollment_county <- read_csv("Project 2/Datasets/school_enrollment_county_year.csv")

# READ-IN AND PREPARE THE CENSUS AND CRIME DATA – MERGE WITH SCHOOL ENROLLMENTS

# 15. Use library(haven) to read-in census_orig using the SAS dataset "pop_est9001.sas7bdat". Clean and prepare this file
# for merging by creating a numeric or integer fips_county variable and removing unnecessary variables. To aid in
# cleaning/formatting, consider this code: mutate(population=pop, county_name2=county, state_name=state) %>%

census_orig <- read_sas("Project 2/Datasets/pop_est9001.sas7bdat")

names(census_orig)

census_clean <- census_orig %>%
	rename_with(tolower) %>%
	mutate(
		fips_county = as.character(fips),
		population = pop,
		county_name2 = county,
		state_name = state
	)


# 16. We now need census population counts by race and age for use as predictors. Use dplyr left_join to merge the
# aggregated (county-year) level school enrollment file with the county-year level census file.

school_census <- school_enrollment_county %>%
	left_join(census_clean, by = c("fips_county", "year"))

# 17. Read-in the SAS agency-year level crime data "ucr_1990_2001_ori_level.sas7bdat" and prepare this file for merging
# with enrollments.

crime_orig <- read_sas("Project 2/Datasets/ucr_1990_2001_ori_level.sas7bdat")

names(crime_orig)

crime_clean <- crime_orig %>%
	rename_with(tolower)

# 18. You will need to create a unique concatenated fips_state, fips county (i.e. fips_state||fips_county) variable for the
# merge with enrollments. To combine fips_state and fips_county together (in char format with leading zeros), use:
# mutate(fcounty=(formatC(fips_county, digits = 0, width=3, format="d", flag="0"))) %>%. Repeat this process for
# fips_state. Then use str_c or “string concatenate” function to combine the two fips variables together as fips_county.

crime_clean <- crime_clean %>%
	mutate(
		fcounty = formatC(fips_county, width = 3, format = "d", flag = "0"),
		fstate = formatC(fips_state, width = 2, format = "d", flag = "0"),
		fips_county = str_c(fstate, fcounty)
	)

# 19. Use dplyr summarize with groupby to aggregate the crime data to the county-year level. Be sure to keep the key
# crime variables:
# total_crime_county=mean(total_sum),
# total_crime_rate_old=mean(total_rate),
# violent_crime_county=mean(violent_sum),
# violent_rate_old=mean(violent_rate)) %>%

crime_county <- crime_clean %>%
	group_by(fips_county, yearucr) %>%
	summarize(
		total_crime_county = mean(total_sum),
		total_crime_rate_old = mean(total_rate),
		violent_crime_county = mean(violent_sum),
		violent_rate_old = mean(violent_rate),
		.groups = "drop"
	) %>%
	rename(year = yearucr)

glimpse(crime_county)

# 20. Use dplyr left join to merge the combo_school_enrollments data (from step 16) with the aggregated crime data.

school_census_crime <- school_census %>%
	left_join(crime_county, by = c("fips_county", "year"))

# Some summary stuff (i.e. number of rows, first 6 rows, variable type declarations)
nrow(school_census_crime)
head(school_census_crime)
summary(school_census_crime$total_crime_county)

# check for any duplicates!
school_census_crime %>%
	count(fips_county, year) %>%
	filter(n > 1)


# READ-IN AND PREPARE THE ECONOMIC DATA – MERGE WITH ENROLLMENTS

# 21. Read-in and prepare the economic files using the following code:
files = list.files(path = "Project 2/Datasets/BEA_Economic/", pattern = "*.sas7bdat", full.names=TRUE)

j=1989
for (i in files) {
	j=j+1
	assign(paste0("reis_",j),read_sas(i))
	temp=get(paste0("reis_",j))  # creates temp file for renaming variables and adding year
	names(temp)<- c("fips_county","area_name", "state", "percap_income", "employment")
	temp$year = j
	assign(paste0("reis_",j), temp)  # Renames temp back to original reis_yyyy
}
econ_vect <- mget(ls(pattern="reis_"))
econ_orig <- bind_rows(econ_vect)  # Stacks the econ files together

# Summary stuff for sanity check
head(econ_orig)
str(econ_orig)

# 22. Convert fips_county to numeric or integer format. Then, left_join the most updated enrollment file with the
# economic variables.

school_full <- school_census_crime %>%
	left_join(econ_orig, by = c("fips_county", "year"))

# fips_county is kept as a character variable to preserve leading zeros and
# ensure correct matching with other datasets.

# Summary of some more stats
nrow(school_full)
head(school_full)
summary(school_full$percap_income)

# 23. Create two new county-wide crime rate variables:
# mutate(new_tot_crime_rate=(total_crime_county/population)*100000) %>%
# mutate(new_violent_rate=(violent_crime_county/population)*100000) %>%
# Also, create an employment rate variable: mutate(employment_rate=(employment/population*1000))

school_full <- school_full %>%
	mutate(
		new_tot_crime_rate = (total_crime_county / population) * 100000,
		new_violent_rate = (violent_crime_county / population) * 100000,
		employment_rate = (employment / population) * 1000
	)

# 24. Finish cleaning and relocate variables as needed. For example: relocate(new_tot_crime_rate, new_violent_rate,
# .before=area_name). You now have your final merged file.

school_final <- school_full %>%
	relocate(new_tot_crime_rate, new_violent_rate, .before = area_name)

summary(school_full$percap_income)
summary(school_full$employment)

# 25. Demean the independent and dependent variables for use in panel data regressions:
# school_dm_final <- school_dm_final1%>%
# group_by(fips_county) %>%
# mutate(across(c(county_enroll:employment_rate), ~ .x - mean(.x), .names = "{col}_DM"))

school_dm_final <- school_final %>%
	group_by(fips_county) %>%
	mutate(
		across(
			c(county_enroll, population, prop_nonwhite, prop_male, prop_age1524,
			  total_crime_rate_old, violent_rate_old, new_violent_rate, percap_income, employment_rate),
			~ .x - mean(.x, na.rm = TRUE),
			.names = "{col}_DM"
		)
	)

nrow(school_dm_final)
summary(school_dm_final$county_enroll_DM)
summary(school_dm_final$percap_income_DM)
summary(school_dm_final$employment_rate_DM)

# 26. Write this final file with DM variables into a permanent csv file. You may again wish to clear your Global
# Environment, read-in the permanent csv that you just created and start fresh. Analytics is next.

write_csv(school_dm_final, "Project 2/Datasets/school_dm_final.csv")

rm(list = ls())


# Part 2 - GET ANSWERS - DATA ANALYTICS -----------------------------------

school_dm_final <- read_csv("Project 2/Datasets/school_dm_final.csv")

# 27. Create nation-year descriptive variables to check overall trends.  Were enrollments, crime, econ up or down over the
# 12-year time period (1990-2001)?  A few simple line plots are optional.
national_schools1 <- school_dm_final %>%
	group_by(year) %>%
	summarize(county_enroll_dm=mean(county_enroll_DM, na.rm=TRUE),
			  prop_nonwhite_dm=mean(prop_nonwhite_DM, na.rm=TRUE),
			  prop_age1524_dm=mean(prop_age1524_DM, na.rm=TRUE),
			  total_crime_rtdm=mean(total_crime_rate_old_DM, na.rm=TRUE),
			  employment_rate_dm=mean(employment_rate_DM, na.rm=TRUE),
			  percap_income_dm=mean(percap_income_DM, na.rm=TRUE),
			  violent_rate_old_dm=mean(violent_rate_old_DM, na.rm=TRUE))
# Optional line plot code (you may also use ggplot2):
# Not required:
plot(national_schools1$year, national_schools1$county_enroll_dm, type = "l")


# 28. Check inter-variable correlations (any values higher than .65 should be used with caution)

# To check the first half of the variables
corr1 <- school_dm_final %>%   # Creates a nice, clean correlation dataframe.
	correlate() %>%    # Create correlation data frame (cor_df)
	focus(county_enroll_DM, population_DM, prop_nonwhite_DM, prop_male_DM, prop_age1524_DM,
		  mirror = TRUE) %>%
	rearrange() %>%  # rearrange by correlations
	shave()  # Shave off the upper triangle for a clean result
# view(corr1)


# #To check the second half of the variables
corr2 <- school_dm_final %>%  # Creates a nice, clean correlation dataframe.
	correlate() %>%    # Create correlation data frame (cor_df)
	focus(county_enroll_DM, violent_rate_old_DM, new_violent_rate_DM, percap_income_DM, employment_rate_DM,
		  mirror = TRUE) %>%  # Focus on cor_df without 'cyl' and 'vs'
	rearrange() %>%  # rearrange by correlations
	shave() # Shave off the upper triangle for a clean result
# view(corr2)

# Question:  What variable is most correlated with “year”?

# look at all names that have the demeaned tag on the end
dm_vars <- c( "year", names(school_dm_final)[grepl("_DM$", names(school_dm_final))])
dm_vars

# Creating a corr matrix using all the demeaned variables, helps detect multi-
# coliniearity first of all so we don't mix any together that are highly correlated!
corr_all <- school_dm_final %>%
	select(all_of(dm_vars)) %>%
	correlate()
corr_all

# Focus specifically on correlations with the dependent/explanatory variable (county_enroll_DM)
corr_target <- corr_all %>%
	focus(county_enroll_DM)
corr_target

corr_year <- corr_all %>%
	focus(year)
corr_year

# Answer:
# The variable most correlated with year is percap_income_DM, with a correlation
# of approximately 0.912. This indicates a very strong positive relationship,
# suggesting that per capita income increased consistently over time during
# the study period.

# I want to plot to make sure and it is proven right!
plot(national_schools1$year, national_schools1$percap_income_dm, type = "l")


# 29. Regress enrollment by each predictor, one at a time.  Lastly, run the
# final regression model with all statistically significant predictors together

# Running regressions on every single one of the demeaned values vs. country enroll dm
m1 <- lm(county_enroll_DM ~ population_DM, data = school_dm_final)
m2 <- lm(county_enroll_DM ~ prop_nonwhite_DM, data = school_dm_final)
m3 <- lm(county_enroll_DM ~ prop_age1524_DM, data = school_dm_final)
m4 <- lm(county_enroll_DM ~ total_crime_rate_old_DM, data = school_dm_final)
m5 <- lm(county_enroll_DM ~ violent_rate_old_DM, data = school_dm_final)
m6 <- lm(county_enroll_DM ~ percap_income_DM, data = school_dm_final)
m7 <- lm(county_enroll_DM ~ employment_rate_DM, data = school_dm_final)
m8 <- lm(county_enroll_DM ~ year, data = school_dm_final)
m9 <- lm(county_enroll_DM ~ prop_male_DM, data = school_dm_final)
m10 <- lm(county_enroll_DM ~ new_violent_rate_DM, data = school_dm_final)


# Look at summary stats, this helps us see which exact variables are significant in our model
summary(m1)  # population_DM
summary(m2)  # prop_nonwhite_DM
summary(m3)  # prop_age1524_DM
summary(m4)  # total_crime_rate_old_DM
summary(m5)  # violent_rate_old_DM
summary(m6)  # percap_income_DM
summary(m7)  # employment_rate_DM
summary(m8)  # year
summary(m9)  # prop_male_DM
summary(m10)  # new_violent_rate_DM

# First trial model
model1 <- lm(
	county_enroll_DM ~ population_DM +
		prop_nonwhite_DM +
		prop_age1524_DM +
		percap_income_DM +
		employment_rate_DM,
	data = school_dm_final
)

summary(model1)

# Using stargazer to make a regression table
stargazer(m1, m2, m3, m6, m7, model1, type = "text")

# Finding out that population_DM DOES dominate the entire model which is because its
# practically enrollment itself!

# This second model is closer to what you (Dr. Lilley) have on your assignment sheet!
model2 <- lm(
	county_enroll_DM ~ year +
		prop_male_DM +
		prop_age1524_DM +
		prop_nonwhite_DM +
		total_crime_rate_old_DM +
		percap_income_DM +
		employment_rate_DM,
	data = school_dm_final
)

summary(model2)

stargazer(m1, m2, m3, m4, m6, m7, m8, m9, model2, type = "text")

# This is a trial of a third model, refining the second model
model3 <- lm(
	county_enroll_DM ~ year +
		prop_male_DM +
		prop_age1524_DM +
		prop_nonwhite_DM +
		total_crime_rate_old_DM,
	data = school_dm_final
)

summary(model3)

stargazer(m1, m2, m3, m4, m6, m7, m8, m9, model2, model3, type = "text")
# This one lowered the entire R^2 value from model2 so we can still go with model2!

# For this assignment, I would go with Final Model 1 BUT I will use Final Model 2 since it is closer to what you the
# professor has on the worksheets!!

# 30.  Which census, economic, and crime variables significantly predicted county school enrollment from 1990-2012?
# What was the overall predictive value of the final regression model (adjusted R-square)?  Which variables predicted a
# decline in enrollment (e.g. people leaving the area due to bad conditions in the county)?  In a few brief sentences,
# explain your results.

# Answer (USING FINAL MODEL 2):
# The variables that significantly predicted county school enrollment were proportion of males, proportion of individuals
# aged 15–24, proportion of nonwhite population, total crime rate, per capita income, and employment rate.

# The final model had an adjusted R² of approximately 0.13, indicating moderate explanatory power. Variables associated
# with declines in enrollment include year, proportion of males, proportion of individuals aged 15–24, total crime
# rate, and employment rate, as they had negative coefficients. Overall, demographic and economic factors help explain
# changes in enrollment, though other unobserved factors likely also play a role.


# REPORT STATS ------------------------------------------------------------

# Showing final regression table
stargazer(model2, type = "text")

# Showing comparison between model 2 and 3
stargazer(model2, model3, type = "text")

# Making a trend line of year vs percap income demeaned
plot(national_schools1$year, national_schools1$percap_income_dm, type = "l",
	 main = "Average Demeaned Per Capita Income Over Time",
	 xlab = "Year",
	 ylab = "Average Demeaned Per Capita Income")
