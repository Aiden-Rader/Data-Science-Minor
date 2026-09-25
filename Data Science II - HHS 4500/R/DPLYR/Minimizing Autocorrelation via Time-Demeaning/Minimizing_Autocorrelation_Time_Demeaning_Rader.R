# title: Minimizing Autocorrelation via Time-Demeaning the Variables
# subtitle: Excercise 4
# author: "Aiden Rader"
# date: "2026-04-08"


# Steps -------------------------------------------------------------------

library(readxl)
library(dplyr)
library(tidyverse)

# 1. Create a dataframe called “crime” from the downloaded crime_predictors_1990_2015.xlsx
# dataset. Include only jurisdictions where months_reported contains ‘Dec’ (or December).

crime <- read_excel("DPLYR/Minimizing Autocorrelation via Time-Demeaning/Datasets/Crime_Predictors_1990_2015.xlsx")
View(crime)

crime2 <- crime %>%
	rename_with(tolower) %>%
	filter(grepl("Dec|December", months_reported))

# 2. Create a smaller dataframe called “michigan_crime” that includes only Michigan jurisdictions
# (i.e. agencies) with over 10,000 population and where total_officers is not missing (!is.na). Keep
# only the following variables: ori, agency, year, population, violent_crime_rate, total_officers

michigan_crime <- crime2 %>%
	filter(grepl("MI", ori)) %>%
	filter(!is.na(total_officers)) %>%
    filter(population > 10000) %>%
    select(ori, agency, year, population, violent_crime_rate, total_officers)

# 3. Create a new dataframe “michigan_avg” that contains the average for three variables,
# (violent_crime_rate, population, and total_officers) for each agency over all of the years. To
# calculate the averages, use the group_by and summarize functions.

michigan_avg <- michigan_crime %>%
    group_by(agency) %>%
    summarize(
        violent_crime_rate_avg = mean(violent_crime_rate, na.rm = TRUE),
        population_avg = mean(population, na.rm = TRUE),
        total_officers_avg = mean(total_officers, na.rm = TRUE)
    )

# 4. Merge the summarized dataframe (michigan_avg) with michigan_crime to obtain time
# demeaned variables (population_dm, violent_dm, officer_dm). Create these time demeaned
# variables by subtracting the mean values from the annual values.

michigan_crime_dm <- michigan_crime %>%
    left_join(michigan_avg, by = "agency") %>%
    mutate(
        population_dm = population - population_avg,
        violent_dm = violent_crime_rate - violent_crime_rate_avg,
        officer_dm = total_officers - total_officers_avg
    ) %>%
    select(
    	ori,
    	agency,
    	year,
    	population,
    	population_dm,
    	violent_crime_rate,
    	violent_dm,
    	total_officers,
    	officer_dm
	)

# 5. Use the cor function to find the correlations between the three original values (population,
# violent_crime_rate, total_officers). The simplest way to obtain a correlation matrix (table) for
# more then two variables is to create a new dataframe (new_df) that includes only the variables
# that are needed via the dplyr “select” command. Then run: cor(new_df)

new_df <- michigan_crime_dm %>%
    select(population, violent_crime_rate, total_officers)

corr_normal <- cor(new_df)
corr_normal

# 6. Next, use the cor function to find the correlations between the three demeaned values
# (population_dm, violent_dm, officer_dm). Notice that the original values will typically have a
# higher (stronger) correlation than the demean values due to autocorrelation.

new_dm_df <- michigan_crime_dm %>%
	select(population_dm, violent_dm, officer_dm)

corr_dm <- cor(new_dm_df)
corr_dm

# Interpretation:
# After analysis, the demeaned correlation values are far smaller then the normal correlated values.
# This makes sense since the demeaned removed the between-agency portion of our data so there is
# less variability.

# 7. Lastly, run two linear regression models (one using original values, the other using time
# demeaned values).

# NOTE: This would be measuring two separate things one being broad agency changes (within-agency
# AND between-agency) and the demeaned model is using just the in-agency change over time.

df_result <- lm(violent_crime_rate ~ population + total_officers, data = michigan_crime_dm)
summary(df_result)

# Interpretation:
# In this original file, we can see that population and total_officers are both significant predictors
# of violent_crime_rate. The model statistically explains about 10% of the variation in violent crime
# rates.

df_result_dm <- lm(violent_dm ~ population_dm + officer_dm, data = michigan_crime_dm)
summary(df_result_dm)

# Interpretation:
# Now after running with the demeaned values, the two variables are STILL both significant predictors,
# a big change that I can see is that our R^2 value has a sharp drop (0.012 in comparison, the original
# was 0.1). I would say this means that the demeaned model is removing the in between agency differences.
# So really this model would be far better to use if studying just the in-agency changes over time even
# if it is practically showing less variability over time.
