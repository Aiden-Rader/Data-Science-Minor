***********************************************************;
*  Understanding SAS Program Syntax                       *;
***********************************************************;
*  Syntax                                                 *;
*    /*comment*/                                          *;
*    *comment;                                            *;
***********************************************************;
*     Exploring Data with Procedures             *;
**************************************************;
*  Syntax                                        *;
*                                                *;
*    PROC PRINT DATA=input-table(OBS=n);         *;
*        VAR col-name(s);                        *;
*    RUN;                                        *;
*                                                *;
*    PROC MEANS DATA=input-table;                *;
*        VAR col-name(s);                        *;
*    RUN;                                        *;
*                                                *;
*    PROC UNIVARIATE DATA=input-table;           *;
*        VAR col-name(s);                        *;
*    RUN;                                        *;
*                                                *;
*    PROC FREQ DATA=input-table;                 *;
*        TABLES col-name(s);                     *;
*    RUN;                                        *;
**************************************************;

/*Import the cars.csv datafile and call it cars*/
proc import out=work.cars
	datafile="C:\Users\aiden\Downloads\cars.csv"
	dbms = csv;
	getnames=yes; /* Get variable names from the first row of the file */
run;

/*Create a copy of cars and call it mycars
  Compute average mpg for each car and call it AvgMPG
  Use the mean function: mean(var1, var2)
*/
data mycars; set cars;
	AvgMPG= mean(MPG_City, MPG_Highway); /* Calculate the average MPG */
run;

/* Chanegs the title of the NEXT output */
title "Cars with Average MPG Over 35";
/*
  Create a new variable called fuel_eff for cars with average
  mpg over 35=1 and 0 otherwise. Use if-else statement.*/

data mycars; set mycars;
	if (AvgMPG >= 35) then
		fuel_eff = 1; /* Fuel-efficent car */
	else
		fuel_eff = 0; /* Not Fuel-efficent car */
run;


***********************************************************;
*  Creating Summary Statistics Reports (Aggregation)      *;
***********************************************************;
*  Syntax and Example                                     *;
*                                                         *;
*    PROC MEANS DATA=input-table stat-list;               *;
*        VAR col-name (s);                                *;
*        CLASS col-name (s);                              *;
*    RUN;                                                 *;
***********************************************************;
/*Compute average MPG by Car Type for all cars*/
title "Average MPG by Car Type";
proc means data=mycars mean min max maxdec=1;
	var AvgMPG; /* Target variable: AvgMPG */
	class Type; /* Group by car Type */
run;

/*Compute average MPG by Type and fuel efficiency for all cars*/
title "Average MPG by Car Type & Fuel_eff";
proc means data=mycars mean min max maxdec=1;
	var AvgMPG; /* Target variable: AvgMPG */
	class Type fuel_eff; /* Group by car Type AND fuel_eff flag */
run;

/*Examine summary statistics for MPG_city and MPG_hwy*/
proc means data=mycars;
	var MPG_city MPG_highway; /* Target variables: MPG_city and MPG_highway */
run;

/*examine extreme values for MPG_city and MPG_highway*/
proc univariate data=mycars;
	var MPG_city MPG_highway;
run;

/*list unique values and frequencies for different makes and types*/
proc freq data=mycars;
	tables Type Make; /* Generate frequency tables for Type and Make */
run;


***********************************************************;
* Using Character Functions                               *; 
***********************************************************;
*  Character Functions:                                   *;
*    UPCASE(char)                                         *;
*    PROPCASE(char, <delimiters>)                         *;
*    CATS(char1, char2, ...)                              *;
*    SUBSTR(char, position, <length>)                     *;
***********************************************************;
data mycars2; set mycars;
	Type=upcase(Type); /* Convert Type to uppercase */
	P_model=propcase(Model); /* Convert Model to proper case */
	Name = cats(Make, Model); /* Concatenate Make and Model */
	format AvgMPG 4.1; /* Format AvgMPG to one decimal */
	keep Make Model MSRP Invoice AvgMPG Type; /* Keep these columns */
run;


***********************************************************;
*  Processing Multiple Statements with IF-THEN/DO         *;
***********************************************************;
*  Syntax and Example                                     *;
*                                                         *;
*    IF expression THEN DO;                               *;
*        <executable statements>                          *;
*    END;                                                 *;
*    ELSE IF expression THEN DO;                          *;
*        <executable statements>                          *;
*    END;                                                 *;
*    ELSE DO;                                             *;
*        <executable statements>                          *;
*    END;                                                 *;
***********************************************************;
/*
  Create a new variable called Cost_Group.
  Keep Make, Model, MSRP, and Cost_Group
  if MSRP<20000, set Cost_Group to 1 and output the row to 
  the underpriced datafile.
  if MSRP>=20000 but less than 40000, set Cost_Group to 2 
  and output the row to the underpriced datafile
  else set Cost_Group to 3 and output the row to the
  overpriced datafile.
*/
data underpriced overpriced; set mycars;
	keep Make, Model, MSRP, Cost_Group; /* Keep these columns */
	num_MSRP = input(MSRP, dollar10.); /* Convert MSRP from character to numeric */

	/* Categorize cars based on MSRP and output to different datasets */
	if (num_MSRP < 20000) then do;
		Cost_Group = 1; /* Group 1: Under $20,000 */
		output underpriced;
	else if (num_MSRP >= 20000 AND num_MSRP < 40000) then do;
		Cost_Group = 2; /* Group 2: $20,000 to $39,999 */
		output underpriced;
	else do;
		Cost_Group = 3; /* Group 3: $40,000 and above */
		output overpriced;
	end;
run;


***********************************************************;
*  Creating Frequency Reports and Graphs                  *;
***********************************************************;
*  Syntax and Example                                     *;
*                                                         *;
*    ODS GRAPHICS ON;                                     *;
*    PROC FREQ DATA=input-table <proc-options>;           *;
*        TABLES col-name(s) / options;                    *;
*    RUN;                                                 *;
*                                                         *;
*    PROC FREQ statement options:                         *;
*        ORDER=FREQ|FORMATTED|DATA                        *;
*        NLEVELS                                          *;
*    TABLES statement options:                            *;
*        NOCUM                                            *;
*        NOPERCENT                                        *;
*        PLOTS=FREQPLOT                                   *;
*           (must turn on ODS Graphics)                   *;
*        OUT=output-table                                 *;
***********************************************************;

/* Generate frequency reports and plots for car Type */
proc freq data=mycars order=freq nlevels;
	tables Type / plots=freqplot; /* Frequency plot for car Type */
run;   


***********************************************************;
*  Creating Two-Way Frequency Reports                     *;
***********************************************************;
*  Syntax and Example                                     *;
*                                                         *;
*    PROC FREQ DATA=input-table;                          *;
*        TABLES col-name*col-name </ options>;            *;
*    RUN;                                                 *;
*                                                         *;
*    PROC FREQ statement options:                         *;
*        NOPRINT                                          *;
*    TABLES statement options:                            *;
*        NOROW, NOCOL, NOPERCENT                          *;
*        CROSSLIST, LIST                                  *;
*        OUT=output-table                                 *;
***********************************************************;

/* Generate two-way frequency report for car Type and fuel efficiency */
proc freq data=mycars;
	tables Type*Fuel_eff; /* Cross-tabulation of Type and fuel_eff */
run;

***********************************************************;
*  Exporting Results to Excel                             *;
***********************************************************;
*  Syntax and Example                                     *;
*                                                         *;
*    ODS EXCEL FILE="filename.xlsx" <STYLE=style>         *;
*              <OPTIONS (SHEET_NAME='label')>;            *;
*        /* SAS code that produces output */              *;
*    ODS EXCEL OPTIONS (SHEET_NAME='label');              *;
*        /* SAS code that produces output */              *;
*    ODS EXCEL CLOSE;                                     *;
***********************************************************;

/*part 1*/

/* Export results to an Excel file */
ods excel file="C:\Users\aiden\Downloads\Cars_Analysis.xlsx";

/* Summary statistics for cars by type */
title "Summary Statistics for Cars";
ods noproctitle;
proc means data=mycars min mean median max maxdec=0;
    class Type; /* Group by car Type */
    var AvgMPG; /* Target variable: AvgMPG */
run;

/* Histogram of AvgMPG */
title "Histogram of AvgMPG";
proc sgplot data=mycars;
    histogram AvgMPG; /* Create a histogram for AvgMPG */
    density AvgMPG; /* Add a density curve */
run; 
title;  
ods proctitle;

ods excel close; /* Close Excel output */


***********************************************************;
*  Exporting Results to PDF                               *;
***********************************************************;
*  Syntax                                                 *;
*                                                         *;
*    ODS PDF FILE="filename.xlsx" STYLE=style             *;
*            STARTPAGE=NO PDFTOC=1;                       *;
*    ODS PROCLABEL "label";                               *;
*        /* SAS code that produces output */              *;
*    ODS PDF CLOSE;                                       *;
***********************************************************;

/* Export results to a PDF file */
ods pdf file="C:\Users\aiden\Downloads\Cars_Analysis.pdf" style=statistical;
ods proclabel "Cars Analysis Report";

/* Summary statistics for cars with AvgMPG over 35 */
title "Cars with Average MPG Over 35";
proc means data=mycars mean min max;
    var AvgMPG; /* Target variable: AvgMPG */
run;

ods pdf close; /* Close PDF output */

/*=================================================================================================*/

/* DAY 1 EXAMPLES */
*  Perform the data preparation step (which will include merging, subsetting, column creation, creating new datafiles, and exporting data).
*/

/* Example of Merging two Datasets */

/* Merge two datasets by a common column, 'ID' */
data merged_data;
    merge dataset1 (in=a) dataset2 (in=b);
    by ID; /* Merge by the common column 'ID' */
    if a and b; /* Keep only matching records */
run;

/* Example of Subsetting Data */

/* Subset cars with an average MPG greater than 30 */
data high_mpg_cars;
    set cars;
    if AvgMPG > 30;
run;


/* Example of Creating New Columns */

/* Create a new column, 'Fuel_Efficiency', based on the value of AvgMPG */
data cars_new;
    set cars;
    if AvgMPG >= 35 then Fuel_Efficiency = "Efficient";
    else Fuel_Efficiency = "Not Efficient";
run;


/* Example of Creating new Datafiles */

/* Split the data into two new datasets based on cost group */
data cheap_cars expensive_cars;
    set cars;
    if MSRP < 20000 then output cheap_cars;
    else if MSRP >= 20000 then output expensive_cars;
run;


/* Example of Exporting Data */

/* Export the dataset to an Excel file */
proc export data=cars_new
    outfile="C:\Users\aiden\Documents\Cars_New.xlsx"
    dbms=xlsx
    replace;
run;


/* Full example of Data preparation workflow */

/* Import the two datasets */
proc import datafile="C:\Users\aiden\Downloads\cars1.csv"
    out=cars1
    dbms=csv
    replace;
    getnames=yes;
run;

proc import datafile="C:\Users\aiden\Downloads\cars2.csv"
    out=cars2
    dbms=csv
    replace;
    getnames=yes;
run;

/* May also get asked about combining two excel sheets */
PROC IMPORT DATAFILE="C:/path/to/yourfile.xlsx"
    OUT=sheet1
    DBMS=XLSX
    REPLACE;
    SHEET="Sheet1";
RUN;

PROC IMPORT DATAFILE="C:/path/to/yourfile.xlsx"
    OUT=sheet2
    DBMS=XLSX
    REPLACE;
    SHEET="Sheet2";
RUN;


/* Merge the datasets by 'ID' */
data merged_cars;
    merge cars1(in=a) cars2(in=b);
    by ID;
    if a and b; /* Keep only matching records */
run;

/* Subset the merged data to keep only fuel-efficient cars (AvgMPG >= 35) */
data fuel_efficient_cars;
    set merged_cars;
    if AvgMPG >= 35;
run;

/* Create a new column 'Fuel_Efficiency' */
data final_cars;
    set fuel_efficient_cars;
    if AvgMPG >= 35 then Fuel_Efficiency = "Efficient";
    else Fuel_Efficiency = "Not Efficient";
run;

/* Export the final dataset to an Excel file */
proc export data=final_cars
    outfile="C:\Users\aiden\Documents\Fuel_Efficient_Cars.xlsx"
    dbms=xlsx
    replace;
run;
