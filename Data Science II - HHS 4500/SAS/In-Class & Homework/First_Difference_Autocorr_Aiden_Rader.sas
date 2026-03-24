/* Learning about first difference autocorrelation */

libname datasets "C:\Users\aiden\OneDrive - University of Toledo\Spring 2026 UT NOW\Data Science II\SAS Enviornment\In-Class & Homework\Datasets";

data crime_data; set datasets.crime_predictors_1990_2015;
run;

/* 1. Identify the largest city (by population) in each county among all states */
proc sort data=crime_data out=sorted_data;
    by STATEFP CNTY POP100 YEAR;
run;

/* Remove all gov levels that are not 2, only keep what we need */
data crime_data_cities;
    set sorted_data;
    if govt_level ne 2 then delete;
    keep ori agency placename govt_level STATEFP CNTY YEAR POP100 state_abbr total_officers violent_crime employ_county;
run;

/* Just find the last most populated city based on the original sort */
data largest_city;
    set crime_data_cities;
    by STATEFP YEAR POP100 CNTY;
    if last.CNTY then output;
run;

/* 2. Create a first difference version of violent_crimes, total_officers, and employ_county for all available years */
data largest_city_fd;
    set largest_city;
    by STATEFP CNTY YEAR;
    retain violent_crime_fd total_officers_fd employ_county_fd;
    if first.YEAR then do;
        violent_crime_fd = 0;
        total_officers_fd = 0;
        employ_county_fd = 0;
    end;
    else do;
        violent_crime_fd = violent_crime - lag(violent_crime);
        total_officers_fd = total_officers - lag(total_officers);
        employ_county_fd = employ_county - lag(employ_county);
    end;
run;

/* 3. Create a Correlation table using proc corr to view relationship between violent_crime, the number of police officers,
* and the number of employed persons in the county. */
title "Correlation Table";
proc corr data=largest_city_fd;
    var violent_crime total_officers employ_county;
run;

/* Next, compare the corr results when only the first difference variables are included. */
title "First Difference Correlation Table";
proc corr data=largest_city_fd;
    var violent_crime_fd total_officers_fd employ_county_fd;
run;

/* Interpretation:
* It seems like the there are subtle changes to the correlation like using only first difference for total_officers_fd vs violent_crime_fd is
*/

/* Run the regression as indicated below to compare the unadjusted (original) versus first-difference models. Was there a noticable difference in results. */