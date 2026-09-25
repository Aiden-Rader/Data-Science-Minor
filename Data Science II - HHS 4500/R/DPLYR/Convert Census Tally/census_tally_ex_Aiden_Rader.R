# title: Convert Census "Tally Sheet" Data into Population Totals for Needed Categories
# author: "Aiden Rader"
# date: "2026-04-06"

# Problem Statement -------------------------------------------------------

# Problem Overview: As part of our R programming project, we are attempting to track and
# explain population migration from large cities to nearby suburban and rural locations across
# America during the years 1990-2001. We are also attempting to identify the specific
# locations (and types of places) that residents moved toward and why people are left.

# Subtask Goal: Using R, convert the census data "tally sheet" file into an analytic file that could
# be used in long panel (longitudinal panel) data format. The data must be aggregated to the
# county-level so each county has only a single row of data for the year 1990.


# Steps --------------------------------------------------------------------

# 1 Download the file to be converted: On OneDrive, locate the "School Project R"
# folder. Next, under "Census_Population," download the file "icen1990.xlsx".

library(readxl)
library(dplyr)

icen1990 <- read_excel("DPLYR/Convert Census Tally/Datasets/icen1990.xlsx")
View(icen1990)

# 2 Create Needed Variables:
# a) A total population count (i.e. for the whole county).

icen1990_county_totals <- icen1990 %>%
	group_by(state, county) %>%
	summarise(county_pop = sum(popest, na.rm = TRUE), .groups = "drop")

View(icen1990_county_totals)

# b) Population counts for three (3) different demographic groups by county:
# 1) Counts of nonhispanic White residents (for all that ARE 1 & 2 & nonhispanic).

icen1990_white_nh <- icen1990 %>%
	filter(race %in% c(1, 2), hispanic == 1) %>%
	group_by(state, county) %>%
	summarise(white_nh_pop = sum(popest, na.rm = TRUE), .groups = "drop")

# 2) Counts of Nonwhite residents (for all other race/ethncities, (for all that ARE NOT 1 & 2 & nonhispanic)).

icen1990_nonwhite <- icen1990 %>%
	filter(!(race %in% c(1, 2) & hispanic == 1)) %>%
	group_by(state, county) %>%
	summarise(nonwhite_pop = sum(popest, na.rm = TRUE), .groups = "drop")

# 3) Subgroup population counts for 3 age groups (0-29, 30-59, 60+).

# Age Group 0 - 29
icen1990_age_group_0_29 <- icen1990 %>%
	filter(agecat %in% 0:6) %>%
	group_by(state, county) %>%
	summarise(age_pop_0_29 = sum(popest, na.rm = TRUE), .groups = "drop")

# Age Group 30 - 59
icen1990_age_group_30_59 <- icen1990 %>%
	filter(agecat %in% 7:12) %>%
	group_by(state, county) %>%
	summarise(age_pop_30_59 = sum(popest, na.rm = TRUE), .groups = "drop")

# Age Group 60 - inf
icen1990_age_group_60_plus <- icen1990 %>%
	filter(agecat %in% 13:18) %>%
	group_by(state, county) %>%
	summarise(age_pop_60_plus = sum(popest, na.rm = TRUE), .groups = "drop")

# Combine everything into one county-level analytic file (using left joins instead of merge!)
icen1990_county_analytic <- icen1990_county_totals %>%
	left_join(icen1990_white_nh, by = c("state", "county")) %>%
	left_join(icen1990_nonwhite, by = c("state", "county")) %>%
	left_join(icen1990_age_group_0_29, by = c("state", "county")) %>%
	left_join(icen1990_age_group_30_59, by = c("state", "county")) %>%
	left_join(icen1990_age_group_60_plus, by = c("state", "county"))

# Why I used left joins is because its MUCH cleaner (similar to SQL) since we are using dplyr
# and using a base R merge would be very messy...

View(icen1990_county_analytic)
