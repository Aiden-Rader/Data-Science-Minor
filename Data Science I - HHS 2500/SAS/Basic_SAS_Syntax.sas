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


/*Create a copy of cars and call it mycars
  Compute average mpg for each car and call it AvgMPG
  Use the mean function: mean(var1, var2)
*/
data ; set ;
	AvgMPG= mean( , );
run;


title "Cars with Average MPG Over 35";
/*
  Create a new variable called fuel_eff for cars with average
  mpg over 35=1 and 0 otherwise. Use if statement.*/
 *Add IF-THEN statements;

data ; set ;

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
	var ;
	class ;
run;


/*Compute average MPG by Type and fuel efficiency for all cars*/
title "Average MPG by Car Type & Fuel_eff";
proc means data=mycars mean min max maxdec=1;
	var ;
	class ;
run;

/*Examine summary statistics for MPG_city and MPG_hwy*/
proc means data=;
	var ;
run;

/*examine extreme values for MPG_city and MPG_hwy*/
proc univariate data=;
	var ;
run;

/*list unique values and frequencies for different makes and types*/
proc freq data=;
	tables ;
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
data ; set ;
	Type=upcase(Type);
	P_model=propcase(Model);
	Name = cats(Make, Model);
	format MPG_Mean 4.1;
	keep Make Model MSRP Invoice MPG_Mean Type;
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

data underpriced overpriced;
    set sashelp.cars;
	
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

proc freq data=_____ order=freq nlevels;
	tables _____ / plots=freqplot;
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
ods excel file="path/filename.xlsx";

title "this is my title";
ods noproctitle;
proc means data=_____ min mean median max maxdec=0;
    class ______;
    var _____;
run;

title "this is the title for my plot";
proc sgplot data=_____;
    histogram _____;
    density _____;
run; 
title;  
ods proctitle;

ods excel close;


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

