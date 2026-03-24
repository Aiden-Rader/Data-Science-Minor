/*Name: Aiden Rader
* Date: 02/02/2026
* Class: Data Science II
* Professor: Dr. David Lilley
*
* Assignment: SAS Review Exercise (Preparation for the Competency Quiz)
*/

/*========================================================================================================================================================================*/

/* Import the ncrp_full_year_end.sav file as prison_orig */
proc import
    out = prison_orig
    datafile = "C:\Users\aiden\OneDrive - University of Toledo\Spring 2026 UT NOW\Data Science II\SAS Enviornment\In-Class & Homework\Datasets\ncrp_full_year_end.sav"
    dbms = spss replace;
run;

/* Create the dummy code variable AND rename rptyear to YEAR */
data prison_orig;
    set prison_orig(rename=(rptyear=YEAR));
    dummy_code = 1;
run;

/* cd to Datasets directory */
libname datasets "C:\Users\aiden\OneDrive - University of Toledo\Spring 2026 UT NOW\Data Science II\SAS Enviornment\In-Class & Homework\Datasets";

/* Import crime_predictors_1990_2015, keep all the agency identifiers, fips codes, violent_crime (count), and population, rename STATEFP to STATE */
data crime_orig;
    set datasets.crime_predictors_1990_2015(rename=(STATEFP=STATE));
    keep ori place_fips STATE state_abbr CNTY YEAR violent_crime population;
run;

/* Sort by state and year for BY-group operations */
proc sort data=crime_orig;
    by STATE YEAR;
run;
proc sort data=prison_orig;
    by STATE YEAR;
run;

/* Next aggr both files to the state-year level and then merge the state incarc counts with the crime data (not using SUM but using MEANS) */
proc means data=crime_orig nway noprint;
    where population > 20000;  /*? Something of interest from one of his lecture videos is that he will always keep those population values that are greater than 20,000, I will assume this is what to do because of filtering reasons */
    class STATE state_abbr YEAR;
    var violent_crime population;
    output out=crime_state_year(drop=_type_ _freq_)
        mean=violent_crime population;
run;

/*? There are missing YEAR and STATE values in some rows. I added an nway to the proc means statement to combat this */

/* Use a counter (with first.dot) to find annual inmate counts for each state in each year, make count variable called inmate_count */
data prison_state_year;
    set prison_orig;
    by STATE YEAR;
    retain inmate_count;

    if first.YEAR then inmate_count = 0;

    inmate_count = inmate_count + dummy_code;

    if last.YEAR then output;

    keep STATE YEAR inmate_count;
run;

/* Sort before a merge! */
proc sort data=crime_state_year;
    by STATE YEAR;
run;
proc sort data=prison_state_year;
    by STATE YEAR;
run;

/* Check the contents and format of variables */
proc contents data=crime_state_year; run;
proc contents data=prison_state_year; run;

/* Standardize lengths to match for 0 discrepancies, also length comes before set statement... */
data crime_state_year;
    length STATE 8 YEAR 8;
    set crime_state_year;

run;

data prison_state_year;
    length STATE 8 YEAR 8;
    set prison_state_year;
run;

/* Now we can merge the two datasets together! */
data merged_state_year;
    merge crime_state_year(in=a) prison_state_year(in=b);
    by STATE YEAR;

    if a and b;
run;

/* Create a violent crime rate per 100,000 residents with the violent_crime and population variables */
/* Create an incarceration per 100,000 residents with the incarceration_count and population variables */
data rates;
    set merged_state_year;
    violent_crime_rate = (violent_crime / population) * 100000;
    incarceration_rate = (inmate_count / population) * 100000;
run;

/* Sort the data by state and year after our rates calculations */
proc sort data=rates;
    by STATE YEAR;
run;

/* Use the first year data to identify the baseline violence_rate and incarceration rate. Next find the annual percentage change in both of these rates
* for all states in each year. Be sure to use the first year as the baseline value. */
data pct_change;
    set rates;
    by STATE;
    retain base_v base_i;

    if first.STATE then do;
        base_v = violent_crime_rate;
        base_i = incarceration_rate;
    end;

    pct_change_v = ((violent_crime_rate - base_v) / base_v) * 100;
    pct_change_i = ((incarceration_rate - base_i) / base_i) * 100;

    keep STATE state_abbr YEAR
        violent_crime_rate base_v pct_change_v
        incarceration_rate base_i pct_change_i;
run;

proc print data=pct_change(obs=50);
run;

/* Create a trend line graphic that shows teh Ohio incarceration rate (pct_change_i) and violence_rate (pct_change_v) */
title "Ohio Incarceration & Violence Rates from 2000 to 2015";
proc sgplot data=pct_change;
    where STATE = 39;
    series x=YEAR y=pct_change_i / legendlabel='Incarceration % change';
    series x=YEAR y=pct_change_v / legendlabel='Violence % change';
    xaxis label='Years captured in dataset';
    yaxis label='Percent Change from baseline';
run;

/* INTERPRETATION:
* From our plot for Ohio we can actually see that the incarceration rate has been steadily increasing over the years.
* On the other hand, the violence rate which shot was the highest around 2008 has been tanking ever since the
* around 2009. The next test I wanted to do was to see if there was a correlation between the violence rate and incarceration rate.
*/

/* EXTRA: Create a correlation between the violence rate and incarceration rate in Ohio */
proc corr data=pct_change;
    where STATE = 39;
    var pct_change_i pct_change_v;
run;


/* INTERPRETATION:
* From the correlation we can see that there is a weak correlation (r around -0.098) between the violence rate and incarceration rate.
* Looking more into this I found online that this is fairly common due to trends with both incarceration and violent crime rates,
* too many for me to go over to be honest haha.
*/