/*Name: Aiden Rader
* Date: 02/04/2026
* Class: Data Science II
* Professor: Dr. David Lilley
*
* Assignment: Quiz 1
*/

/*========================================================================================================================================================================*/

/* 1. Use a libname statement and a two-level set command (e.g. set mylib.filename) to bring the prison inmate count data “ncrp_prisons_2000_2010.sas7bdat” into SAS.
Name this file “prisons_orig” */

/* cd to Datasets directory and set libname to anything really */
libname datasets "C:\Users\aiden\OneDrive - University of Toledo\Spring 2026 UT NOW\Data Science II\SAS Enviornment\Quiz\Datasets";
data prisons_orig;
    set datasets.ncrp_prisons_1999_2011;
run;

/* 2. Import the census state-year population data “census_population_file_2000_2010 Clean.xlsx”  Name this file
“census_orig” */
proc import
    out = census_orig
    datafile = "C:\Users\aiden\OneDrive - University of Toledo\Spring 2026 UT NOW\Data Science II\SAS Enviornment\Quiz\Datasets\Census_population_files_2000_2010 Clean.xlsx"
    dbms = xlsx replace;
run;

/*? Check if these imported correctly */
/* proc print data=prisons_orig(obs=20); run; */
/* proc print data=census_orig(obs=20); run; */

/* 3. Using an array and do loop, transpose the census data into a long panel file (So it can be properly merged with the
prison data).  Be sure to keep the state fips code and state name. */
data census_transposed;
    set census_orig;
    array pop{11} pop_2000-pop_2010;
    do i = 1 to 11;
        YEAR = 1999 + i;
        population = pop{i};
        output;
    end;
    keep STATE NAME YEAR population;
run;

/* 4. In the prison file, create a variable named “year” by setting it equal to rptyear (alternatively, you may rename rptyear
as year) */
data prisons_orig;
    set prisons_orig(rename=(rptyear=YEAR));  /*? I use this because it keeps the placement of where rptyear was before */
run;

/* 5. We need a way to count each inmate row to get state incarceration totals.  Create a variable called “inmate_dummy”
that has a value of 1 on each row. */
data prisons_orig;
    set prisons_orig;
    inmate_dummy = 1;
run;

/* 6. Sort prison_orig by state and year */
proc sort data=prisons_orig;
    by STATE YEAR;
run;

/* 7. Aggregate prison_orig to the state-year level (using proc means sum OR first.dot with a counter), so it can be merged
with the census data.  If you haven't already done so, create a variable called “inmate_tot” that totals the number of
inmates in each state and year. */
proc means data=prisons_orig nway noprint;  /*? Using nway to clear up any blanks from either STATE or YEAR */
    class STATE YEAR;
    var inmate_dummy;
    output out=prison_state_year(drop=_type_ _freq_)
        sum=inmate_tot;
run;

/* 8. To prepare for merging, clean the aggregated prison file (if needed) by removing or renaming variables.  Keep only
state (fips code), state_name and inmate_tot. Name the aggregated data file “prison_state_year” */

/*? Check variable lengths and types in case */
/* proc contents data=prison_state_year; */
/* proc contents data=census_transposed; */

/*? Narrow down our variables  */
data prison_state_year;
    set prison_state_year;
    keep STATE YEAR inmate_tot;
run;

/* 9. Remove Washington DC from the prison dataset because it is a city, not a state. */
data prison_state_year;
    set prison_state_year;
    if STATE = 11 then delete;
run;

/*? Check if DC is removed with a freq */
/* proc freq data=prison_state_year; */
/*     tables STATE; */
/* run; */

/* 10. Sort both census and prison datasets by state and year. Then, merge them together using an inner merge. Name
the resulting new dataset "combo_census_prisons" */
proc sort data=prison_state_year;
    by STATE YEAR;
run;
proc sort data=census_transposed;
    by STATE YEAR;
run;

/* Inner Merge */
data combo_census_prisons;
	merge prison_state_year(in=a) census_transposed(in=b);
	by STATE YEAR;

	if a and b;
run;

/* 11. Create a state incarceration rate per 100,000 residents (name this variable incarc_rate) */
data combo_census_prisons;
    set combo_census_prisons;
    incarc_rate = (inmate_tot / population) * 100000;
run;

/* 12. Sort combo_census_prisons so the state with the highest incarceration rate is at the top of the dataset. */
proc sort data=combo_census_prisons;
    by descending incarc_rate;
run;

/*? Check if the data is sorted */
/* proc print data=combo_census_prisons(obs=10); run; */

/* 13. To easily analyze the results, create a dataset called “final” that keeps only the top 10 and bottom 10 records using
the _n_ function. */
data final;
    set combo_census_prisons;
    if _n_ < 11 or _n_ > 380 then output;  /*? There are 390 rows so from 0-10 and 390-380 */
run;

/* 14. In your SAS syntax file, add a comment that indicates which states had the highest and lowest incarceration rates.
Report the actual rate values as well. */

/* COMMENT:
* Highest incarceration rate: Louisiana, 508.529
* Lowest incarceration rate: Minnesota, 127.369
*/

/* 15. Use the code below to print the data from “final” into a text (RTF) file. */
ODS RTF FILE = "C:\Users\aiden\OneDrive - University of Toledo\Spring 2026 UT NOW\Data Science II\SAS Enviornment\Quiz\Printed Outputs\SAS_Output.rtf";
proc print data=final; run;
ODS RTF CLOSE;

/* SUBMISSION ON BLACKBOARD */