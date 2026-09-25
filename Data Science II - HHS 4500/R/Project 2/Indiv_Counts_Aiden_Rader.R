# title:
# author: "Aiden Rader"
# date: "2026-04-19"

# Setup -------------------------------------------------------------------

library(tidyverse)
library(readxl)
library(readr)

rm(list = ls())

# Work --------------------------------------------------------------------

# Read in your already-created long school file to avoid rerunning rowwise()
school_long2 <- read_csv("Project 2/Datasets/school_long2.csv")

# Read county FIPS files
school_counties <- read_excel("Project 2/Datasets/ELSI_School_ID_County_FIPS_2001.xlsx") %>%
	rename(school_id = School_ID) %>%
	mutate(school_id = as.numeric(as.character(school_id))) %>%
	rename_with(tolower) %>%
	rename(school_name2 = `school name`) %>%
	select(school_id, school_name2, state_name, state_abbr, fips_state, county_number) %>%
	rename(fips_county = county_number)

school_coord <- read_excel("Project 2/Datasets/All_School_Coordinates_2016_ELSI.xlsx") %>%
	mutate(school_id = as.numeric(as.character(`School ID NCES`))) %>%
	rename_with(tolower) %>%
	select(school_id, school_name, school_name2, state_name, state_abbr, fips_state, county_number) %>%
	rename(fips_county = county_number)

# 1) Original long-panel row count
cat("1) Original long-panel row count:\n")
cat(nrow(school_long2), "\n\n")

# 2) First merge
combo_school_counties <- left_join(school_long2, school_counties, by = "school_id")

cat("2) First merge total row count:\n")
cat(nrow(combo_school_counties), "\n\n")

cat("Distinct school_id after first merge:\n")
cat(combo_school_counties %>% distinct(school_id) %>% nrow(), "\n\n")

# 3) Non-matching after first merge
school_nomatch <- combo_school_counties %>%
	filter(is.na(fips_county))

cat("3) Non-matching row count after first merge:\n")
cat(nrow(school_nomatch), "\n\n")

cat("Distinct non-matching school_id after first merge:\n")
cat(school_nomatch %>% distinct(school_id) %>% nrow(), "\n\n")

# 4) Second merge on non-matching records
school_coord_match <- inner_join(school_nomatch, school_coord, by = "school_id", suffix = c("", "_coord"))

cat("4) Second merge total row count:\n")
cat(nrow(school_coord_match),"\n\n")

cat("Distinct school_id in second merge:\n")
cat(school_coord_match %>% distinct(school_id) %>% nrow(), "\n\n")

# 5) First successful matches from first merge
combo_school_counties_match <- combo_school_counties %>%
	filter(!is.na(fips_county))

cat("5) First-match row count:\n")
cat(nrow(combo_school_counties_match),"\n\n")

cat("Distinct school_id in first-match file:\n")
cat(combo_school_counties_match %>% distinct(school_id) %>% nrow(), "\n\n")

# 6) Final combined file
combo_school_final <- bind_rows(combo_school_counties_match, school_coord_match)

cat("6) Final combined row count:\n")
cat(nrow(combo_school_final), "\n\n")

cat("Distinct school_id in final combined file:\n")
cat(combo_school_final %>% distinct(school_id) %>% nrow(), "\n\n")


# Summary -----------------------------------------------------------------

# Validation counts align with Dr. Lilley example except for a small difference
# of 2 school_id values (24 panel rows), which is probably likely due to source-file
# versioning or minor deduplication differences.

# Create validation summary table
cat("School Enrollment Project - Initial Verification (Merges to County_FIPS)\n")
validation_table <- tibble(
	Step = c(
		"1) Original long-panel rows",
		"2) First merge total rows",
		"2) Distinct schools after first merge",
		"3) Non-matching rows",
		"3) Distinct non-matching schools",
		"4) Second merge total rows",
		"4) Distinct schools in second merge",
		"5) First-match total rows",
		"5) Distinct schools in first match",
		"6) Final combined total rows",
		"6) Distinct schools final"
	),
	Actual = c(
		nrow(school_long2),
		nrow(combo_school_counties),
		combo_school_counties %>% distinct(school_id) %>% nrow(),
		nrow(school_nomatch),
		school_nomatch %>% distinct(school_id) %>% nrow(),
		nrow(school_coord_match),
		school_coord_match %>% distinct(school_id) %>% nrow(),
		nrow(combo_school_counties_match),
		combo_school_counties_match %>% distinct(school_id) %>% nrow(),
		nrow(combo_school_final),
		combo_school_final %>% distinct(school_id) %>% nrow()
	),
	Expected = c(
		1412628,
		1412628,
		NA,
		NA,
		24446,
		77160,
		6430,
		NA,
		93271,
		1196412,
		99701
	)
)

# Male a diff column so we can see HOW far off we are and which ones are further off
# then others?
validation_table <- validation_table %>%
	mutate(Difference = Actual - Expected)

print(validation_table)

