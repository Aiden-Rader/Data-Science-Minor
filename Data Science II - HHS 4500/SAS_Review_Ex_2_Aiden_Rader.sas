/*Name: Aiden Rader
* Date: 01/25/2026
* Class: Data Science II
* Professor: Dr. David Lilley
*
* Assignment: SAS Review Exercise 2
*/

/*========================================================================================================================================================================*/

/* Initial Importing of Census and Crime Predictor Files, print them afterwards to take a look */
proc import
	out = census_pop_file
	datafile = "C:\Users\aiden\OneDrive - University of Toledo\Spring 2026 UT NOW\Data Science II\SAS Enviornment\Datasets\Census_population_files_2000_2010 Clean.xlsx"
	dbms = xlsx replace;
run;
proc print data=census_pop_file(obs=20);
run;

/* this is a massive file so it will take a bit of time */
proc import
	out = crime_pred_file
	datafile = "C:\Users\aiden\OneDrive - University of Toledo\Spring 2026 UT NOW\Data Science II\SAS Enviornment\Datasets\Crime_Predictors_1990_2015.xlsx"
	dbms = xlsx replace;
run;
proc print data=crime_pred_file(obs=20);
run;

/* when looking through the crime_pred_file dataset with the obs, I noticed both YEAR and crime_year and want to make sure they are the exact same to each other for every given row */
data year_check;
    set crime_pred_file;
    diff = (YEAR ne crime_year);
run;
proc freq data=year_check;
    tables diff;
run;

/* JUST as expected mostly the same HOWEVER there are actually 9 rows that do not match, we can standardize this so that our frequency is alot cleaner and matching, print to check */
data crime_clean; set crime_pred_file;

    /* standardize YEAR */
    if missing(YEAR) then 
		YEAR = crime_year;

	drop crime_year;
run;
proc print data=crime_clean(obs=20);
run;

/* Transpose the census data with the array and do loop */
data census_pop_long; set census_pop_file;
	array pops{11} pop_2000-pop_2010;

	do i = 1 to 11;
		YEAR = 1999 + i;
		population = pops{i};

		state_fips = STATE;  /*rename the state column to state_fips for clarity */
		output;
	end;

	keep state_fips name YEAR population;  /* keep the base columns that we will need like the state number and the population + year*/
run;

/* running an aggregation on the crime_clean dataset */
proc summary data=crime_clean nway;
    where YEAR between 2000 and 2010;
    class state_fips YEAR;
    var violent_crime;
    output out=crime_state_year(drop=_type_ _freq_)  /* Personally I want to drop these two columns because my dataset gets really messy and they are unneeded */
        sum=violent_crime;
run;

/*Sort our datasets!*/
proc sort data=crime_state_year; 
	by state_fips YEAR; 
run;
proc sort data=census_pop_long;
	by state_fips YEAR;
run;

/*Quick check which helps with merging as I have come to realize, this makes sure we see our 1-56 state_fips codes in the census data*/
proc freq data=census_pop_long;
    tables state_fips;
run;

/* so we are for some reason missing I think state_fips code 7  I think this is due to their not being census data for said fips number*/ 

/* now time for the inner merge!*/
data merged_state_year;
	merge crime_state_year(in=a) census_pop_long(in=b);
	by state_fips YEAR;

	if a and b;  /* this is the portion that makes it an inner merge basically like a AND statement */
run;

/* print out visual to get a closer look at the data, only do the first 20 just to see if the merge worked properly*/
proc print data=merged_state_year(obs=20);
run;

/* after the visual inspection we can go ahead and get a violent rate percentage also rounded to 0.01 for clarity*/
data merged_rates; set merged_state_year;
    violent_crime_rate = round((violent_crime / population) * 100000, 0.01);
run;

/* another quick print check to see if that new column was added AND to look at the rates*/
proc print data=merged_rates(obs=10);
    var state_fips YEAR violent_crime population violent_crime_rate;
run;

/* sort the new merged data*/
proc sort data=merged_rates;
    by state_fips YEAR;
run;

/* final step in the process, we need to compute the year-to-year % change!*/
data pct_change; set merged_rates;
	by state_fips;

	retain prev_rate prev_year;

	if first.state_fips then do;
		prev_rate = violent_crime_rate;
		prev_year = YEAR;
		pct_change = .;
    end;
    else do;
		pct_change = ((violent_crime_rate - prev_rate) / prev_rate) * 100;
		output;

		prev_rate = violent_crime_rate;
		prev_year = YEAR;
		end;

	keep state_fips NAME prev_year prev_rate YEAR violent_crime_rate pct_change;
run;

/* sort this new data, descending will help with seeing the top percentages first! */
proc sort data=pct_change;
    by descending pct_change;
run;

/* printing only the top two percentages*/
title Final Dataset;
proc print data=pct_change(obs=2);
    var NAME prev_year prev_rate YEAR violent_crime_rate pct_change;
    format prev_rate violent_crime_rate 8.2 pct_change 8.2;  /* when we do print these we can show them specifically 2 deci places and with 8 characters */
run;

/* this portion is rhetorical but I want to see not including DC which is a district what the pct_change would be for those actual states */
data merged_rates_states_only; set merged_rates;
    if state_fips ne 11;  /* since DC is the only district remove it, I did however check if there were anymore districts or territories but DC was the only one */
run;

/* like last time sort our dataset by fips codes and YEARS */
proc sort data=merged_rates_states_only;
    by state_fips YEAR;
run;

/* rerun the pct_change but for states only now! */
data pct_change_states_only; set merged_rates_states_only;
	by state_fips;

	retain prev_rate prev_year;

	if first.state_fips then do;
		prev_rate = violent_crime_rate;
		prev_year = YEAR;
		pct_change = .;
    end;
    else do;
		pct_change = ((violent_crime_rate - prev_rate) / prev_rate) * 100;
		output;

		prev_rate = violent_crime_rate;
		prev_year = YEAR;
		end;

	keep state_fips NAME prev_year prev_rate YEAR violent_crime_rate pct_change;
run;

/* sort this new data, descending will help with seeing the top percentages first! */
proc sort data=pct_change_states_only;
    by descending pct_change;
run;

/* printing only the top two percentages*/
title Rhetorical Dataset;
proc print data=pct_change_states_only(obs=2);
    var NAME prev_year prev_rate YEAR violent_crime_rate pct_change;
    format prev_rate violent_crime_rate 8.2 pct_change 8.2;  /* when we do print these we can show them specifically 2 deci places and with 8 characters */
run;

/* THE REST IS ANSWERED ON THE DOCX ASSIGNMENT */
