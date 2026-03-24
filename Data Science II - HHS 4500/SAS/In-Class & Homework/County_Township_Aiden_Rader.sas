libname datasets "C:\Users\aiden\OneDrive - University of Toledo\Spring 2026 UT NOW\Data Science II\SAS Enviornment\In-Class & Homework\Datasets";

data crime_orig;
    set datasets.crime_predictors_1990_2015;
run;

/* Find only the counties in Wyoming */
data wyoming;
    retain check;
    set crime_orig;
    where index(agency, "WYOMING");
    check = index(agency, "WYOMING");  /* find exactly where in the string the first letter of WYOMING is */
run;

data wyoming;
    set crime_orig;
    if (index(agency, "WYOMING") > 0) and (state_abbr = 'WY') then output;
run;

data crime_orig2;
    set crime_orig;
    where govt_level = 2;
    rename statefp=fips_state cnty=fips_county;
run;

proc sort data=crime_orig2 out=crime_orig_desc;
    by fips_state fips_county descending county_pop_county;
run;

