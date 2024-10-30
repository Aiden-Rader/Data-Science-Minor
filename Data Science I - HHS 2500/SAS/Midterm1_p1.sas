/* Import storm damage sheet as a table */
proc import out=work.storm_damage
	datafile="C:\Users\aiden\Downloads\storm.xlsx"
	dbms = xlsx replace;
	sheet = 'Storm_Damage';
	getnames=yes;
run;

/* Import storm summary sheet as a table */
proc import out=work.storm_summary
	datafile="C:\Users\aiden\Downloads\storm.xlsx"
	dbms = xlsx replace;
	sheet = 'Storm_Summary';
	getnames=yes;
run;

/* Import storm detail sheet as a table */
proc import out=work.storm_detail
	datafile="C:\Users\aiden\Downloads\storm.xlsx"
	dbms = xlsx replace;
	sheet = 'Storm_Detail';
	getnames=yes;
run;

/* Import basin codes sheet as a table */
proc import out=work.basin_codes
	datafile="C:\Users\aiden\Downloads\storm.xlsx"
	dbms = xlsx replace;
	sheet = 'Basin_Codes';
	getnames=yes;
run;

/* Import type codes sheet as a table (This was not given in the file so added it manually) */ 
proc import out=work.type_codes
	datafile="C:\Users\aiden\Downloads\storm.xlsx"
	dbms = xlsx replace;
	sheet = 'Type_Codes';
	getnames=yes;
run;

proc contents data=storm_detail; *Gives you the details of your data;
run; 

/*display the first 10 storms after 01mar2010 in the month/day/year format */
proc print data=storm_summary (obs=10);
	format startdate mmddyy.;
	where startdate > '01mar2010'd;
run;

*********************************************************************************;
* Data Cleaning and Preparation   (Storm_details)                               *;
*********************************************************************************;
*	The storm details are measured every 6hrs, so there may be some	duplicates	*;
*	1. Sort by all columns (_all_) so duplicate values are next to each other.  *;
*	   Save the data with no duplicates and the one with duplicate separately.  *;
*	2. Create one row per storm that identifies minimum pressure.               *;
*	   -Sort the data without duplicates by Season, Basin, Name, and Pressure.  *;
*	   -Remove the rows where Pressure or Name is missing.                      *;
*	   -Observe that the first row of each storm has the minimum pressure value *;
*	3. Use "proc sort data=__ nodupkey" to keep one entry for each storm        *;
*      with the minimum pressure.   											*;
*********************************************************************************;
* Now compare the Pressure column in your output with the min_pressure column   *;
* in the storm_summary datafile. The numbers in the two files should be similar *;
* Note: they are not the same, but if a storm is listed in both files, the      *;
* MinPressure value should be the same as the Pressure value in your file.      *;
* Here on, we will work with Storm_summary                                      *;
*********************************************************************************;

/*Sort by all columns (_all_) so duplicate values are next to each other.*/
proc sort data=storm_detail out=storm_nodup nodupkey dupout=storm_dup;
   by _all_;
run;

/*Remove the rows where Pressure or Name is missing.*/
data min_pressure; set storm_nodup;
   if not missing(Pressure) and not missing(Name);
run;

/*Sort the data without duplicates (nodup) by Season, Basin, Name, and Pressure*/
proc sort data=min_pressure;
	by descending Season Basin Name Pressure;
run;

/*Use "proc sort data=__ nodupkey" to keep one entry for each storm with the minimum pressure.*/
proc sort data=min_pressure out=min_pressure nodupkey;
   by descending Season Basin Name;
run;

/*Final sort*/
proc sort data=storm_summary;
   by descending Season Basin Name;
run;

/*Merge min_pressure with storm_summary*/
data pressure_comparison;
	merge min_pressure(in=a) storm_summary (in=b);
	by descending Season Basin Name;
	if a and b;
run;

/*We compare Pressure and MinPressure so we can see if they are the same or not using Boolean values (1/0)*/
data pressure_comparison; set pressure_comparison;
	Same = (Pressure = MinPressure);
	keep Season Basin Name Pressure MinPressure Same;
run;

/*Print a frequency of how many times a 1/0 (True/False) appear in our new dataset*/
proc freq data=pressure_comparison;
	title "Count How Many Matching Sets";
	tables Same;
run;

/* NOTE:
* In summery, there are 7 outcomes of mismatched data and 2835 outcomes 
* of matching data this is a good sign! 
* Its mostly matching which means its mostly cleaned up!
*/

***********************************************************************;
* Using Character Functions                                           *; 
***********************************************************************;
*  Character Functions:                                               *;
*    UPCASE(char)                                                     *;
*    PROPCASE(char, <delimiters>)                                     *;
*    CATS(char1, char2, ...)                                          *;
*    SUBSTR(char, position, <length>)                                 *;
*                                                                     *;
*  1. Capitalize the storm names (Name)                               *;
*  2. Check the number of unique values in Basin. Compare it with     *;
*     the Basin_Codes file. Do you notice any Problem? Fix it         *;
*  3. Use Merge to create a column, "BasinName" in your datafile      *;
*     - Note the order of the merge matters. Change the order if your *;
*       output is wrong.                                              *;
*     - For example:                                                  *;
*       merge by file1 file2 IS NOT THE SAME AS merge by file2 file1  *;
*  4. Use Merge to create a column, "Storm_Type" in your datafile     *;
*                                                                     *;
*  5. Concatenate Hem_NS and Hem_EW with a hyphen (-) between them to *;
*     create a new variable called Hemisphere.                        *;
*	  - For example, Hem_NS=N and Hem_EW=E becomes, Hemisphere=N-E    *;
*  6. Store the last character of the Basin as OceanCode              *;
***********************************************************************;

/*Capitalize the storm names*/
data storm_summary; set storm_summary;
	Name=upcase(Name);
run;

/*2.) Check the number of unique values in Basin. Compare it with the Basin_Codes file.*/

/*Count unique values in Storm Summary*/
proc freq data=storm_summary;
	title "Count unique values in Basin in Storm Summary Dataset";
   	tables Basin / out=basin_unique;
run;

/*Count unique values in Basin from Basin_Codes*/
proc freq data=basin_codes;
	title "Count unique values in Basin Codes Dataset";
	tables Basin / out=basin_codes_unique;
run;

/*Sort both datasets before merging*/
proc sort data=basin_unique; 
	by Basin; 
run;
proc sort data=basin_codes_unique; 
	by Basin; 
run;

/*Compare the two files by merging them together*/
data basin_comparison;
	merge basin_unique basin_codes_unique;
	by Basin;
run;

/* NOTE:
* After we did the merge its obvious that one dataset has na (Storm_Summary), 
* while the other has NA (Basin_Codes)
*/

/*2.5.) Fix the Problem...*/

/*Fix this by upcasing the Basin codes in storm summery*/
data storm_summary_fixed; set storm_summary;
	Basin = upcase(Basin);
run;

/*Count unique values in Storm Summary after the case fix!*/
proc freq data=storm_summary_fixed;
	title "Count unique values in Storm Summary Dataset (After the case fix)";
   	tables Basin / out=basin_unique_fixed;
run;

/*Again, sort both datasets before merging*/
proc sort data=basin_unique_fixed; 
	by Basin; 
run;
proc sort data=basin_codes_unique; 
	by Basin; 
run;

/*Compare the two files by merging them together*/
data basin_comparison_fixed;
	merge basin_unique_fixed basin_codes_unique;
	by Basin;
run;

/*3.) Now we are adding the BasinName column by merging Storm Summary Fixed Dataset & Basin Codes Dataset*/

/*Again, sort the two datasets before merging*/
proc sort data=storm_summary_fixed;
	By Basin;
run;

proc sort data=basin_codes; 
	by Basin; 
run;

/*Merge the Storm Summary Fixed dataset with the Basin Codes to add the BasinName*/
data storm_with_basin_name;
   merge storm_summary_fixed basin_codes;
   by Basin;
run;

/*4.) Use Merge to create a column, "Storm_Type" in your datafile*/

/*Sort both datasets before merging the two*/
proc sort data=storm_with_basin_name;
    by Type;
run;

proc sort data=type_codes;
    by Type;
run;

/*Merge the two datasets based on type but keep all of a (basin_name dataset)*/
data storm_with_storm_type;
    merge storm_with_basin_name (in=a) type_codes (in=b);
    by Type;
    if a; 
run;

/*5.) Concatenate Hem_NS and Hem_EW with a hyphen (-) between them to create a new variable called Hemisphere*/

 /*Concatenate Hem_NS and Hem_EW with a hyphen (-)*/
data storm_with_horizon; set storm_with_storm_type;
    Hemisphere = cats(Hem_NS, Hem_EW);
run;

/*6.) Store the last character of the Basin as OceanCode*/

/*Just used substr to split Basin up so we get only the last character and store it as OceanCode*/
data storm_with_oceancode; set storm_with_horizon;
	OceanCode = substr(Basin, 2, 1);
run;

/* NOTE:
*  In summary, we merged many datasets together to create one final dataset with columns that 
*  cooralate with each correct observation! Our end dataset is storm_with_oceancode!
*/

**************************************************************************;
* Using IF condition THEN DO commands END to execute multiple commands   *;
**************************************************************************;
*  Instructions                                                          *;
*  1. Using your most current storm_summary datafile, create a column    *;
*     OceanCode="second letter in the Basin"                             *;
*     - For example: if Basin = NA, OceanCode = Atlantic                 *;
*  2. Keep the Season Name Basin BasinName MaxWindMPH MinPressure Type   *;
*     Storm_Type StartDate EndDate Hemisphere Latitude Longitude Ocean   *;
*     and OceanCode.                                                     *;
*     - If OceanCode=I then Ocean="Indian", and assign to Indian         *;
*     - If OceanCode=P then Ocean="Pacific" and assign to Pacific        *;
*     - If OceanCode=A then Ocean "Atlantic" and assign to Atlantic.     *;
*                                                                        *;
*  3. Create 3 new datatifles: Atlantic, Pacific, & Indian and store the *;
*     storms data for each of them.                                      *;
*     - If Ocean="Indian", then assign the data to Indian                *;
*     - If Ocean="Pacific" then assign the data to Pacific               *;
*     - If Ocean "Atlantic" then assign the data to Atlantic.            *; 
**************************************************************************;

/*2.) Keep the Season Name Basin BasinName MaxWindMPH MinPressure Type Storm_Type StartDate EndDate Hemisphere Latitude Longitude Ocean and OceanCode.
* 	  - If OceanCode=I then Ocean="Indian", and assign to Indian
*     - If OceanCode=P then Ocean="Pacific" and assign to Pacific
*     - If OceanCode=A then Ocean "Atlantic" and assign to Atlantic
*/
data storm_with_ocean; set storm_with_oceancode;
	length Ocean $10;
	if (OceanCode = "I") then
		Ocean = "Indian";
	else if (OceanCode = "P") then
		Ocean = "Pacific";
	else if (OceanCode = "A") then
		Ocean = "Atlantic";
	keep Season Name Basin BasinName MaxWindMPH MinPressure Type Storm_Type 
         StartDate EndDate Hemisphere Latitude Longitude Ocean OceanCode;
run;

/*3.) Create 3 new datatifles: Atlantic, Pacific, & Indian and store the storms data for each of them.                                      *;
*     - If Ocean="Indian", then assign the data to Indian
*     - If Ocean="Pacific" then assign the data to Pacific
*     - If Ocean "Atlantic" then assign the data to Atlantic
*/
data Atlantic; set storm_with_ocean;
    if Ocean = "Atlantic";
run;

data Pacific; set storm_with_ocean;
    if Ocean = "Pacific";
run;

data Indian; set storm_with_ocean;
    if Ocean = "Indian";
run;

*********************************************************************;
* Using Date Functions                                              *; 
*********************************************************************;
*  Suntax:                                                          *;
*    Month(SASdate)                                                 *;
*    Year(SASdate)                                                  *;
*    Day(SASdate)                                                   *;
*    Weekday(SASdate)                                               *;
*    Qtr(SASdate)                                                   *;
*    Today()                                                        *;
*    MDY(Month, day, year)-create the date using month,day,year     *;
*    YRDIF(Startdate, enddate, 'AGE')- gives age                    *;
*                                                                   *;
*  1. Create a variable, Age that calculates the number of years    *;
*     from the StartDate of the storm to Today.                     *;
*  2. Create an Anniversary variable for each storm this year       *;
*     - For example if StartDate=08/16/1980, Anniversary=08/16/2024 *;
*     - Use the "mmddyy10." format for the Anniversary and display  *;
*       the Age as 4 characters with 2 decimal place                *;
*********************************************************************;

/*1.) Create a variable, Age that calculates the number of years from the StartDate of the storm to Today.*/
data storm_with_age; set storm_with_ocean;
	Age = YRDIF(StartDate, Today(), 'Age');
run;

/*2.) Create an Anniversary variable for each storm this year
*     - For example if StartDate=08/16/1980, Anniversary=08/16/2024
*     - Use the "mmddyy10." format for the Anniversary and display the Age as 4 characters with 2 decimal place
*/
data storm_with_anniversary; set storm_with_age;
    Anniversary = mdy(month(StartDate), day(StartDate), year(Today()));
    format Anniversary mmddyy10.;
    format Age 4.2;
run;

**************************************************************************;
* Create and Enhance the Report for this Data                            *;
**************************************************************************;
*  Instructions:                                                         *;
*  Category 5 storms are storms with maxwind speed >156 mph              *;
*  1. Create a title called "Category 5 storms" for your report          *;  
*  2. Using the storm_summary datafile, sort data by MaxMindMPH          *;
*  3. Create a datafile of category 5 storms called StormCat5            *;
*     - Sort your data by BasinName and descening order of MaxWindMPH    *;
*  4. Print Season BasinName Name MaxWindMPH MinPressure StartDate and   *;
*     Stormlength BY BasinName. Create the Stormlength variable if it    *;
*     doesnt exist.StormLength should be time from StartDate to EndDate  *;
*                                                                        *;
*  5. Generate a frequency report for BasinName and Season to find out   *;
*     the number of storms that happened in the different Basins and     *;
*     different seasons                                                  *;
*     - add order=freq to the dataline to order by highest frequency     *;
*     - add nlevels to the dataline to get the number of levels of each  *;
*       table                                                            *;
*     - add / nocum to the table line to remove cumulative frequencies   *;
*     - get an additional table from StartMonth. Create it if it doesn't *;
*       already exist. Which month has the most storms?                  *;
*       Alternatively, you can use StartDate, and add a format           *;
*       "format StartDate monname." to get the StartMonth                 ;
*     - add frequency plots with orientation=horizontal & scale=percent  *;
*       use plots=freqplot(orient=horizontal scale=percent)              *;
*                                                                        *;
*  6. Create a two-way frequency report with BasinName and StartMonth    *;
*     - after the tables, use "/ crosslist" to get a different view      *;
*     - after the "/ crosslist" add norow nocol to remove row and column *;
*       percentages. You may remove crosslist if you don't like the view *;
*                                                                        *;
*  7. Create Summary statistics for the BasinName and Stormtype          *;
*     - Summary statistics should include mean, median, mode, std.       *;
**************************************************************************;

/*1.) Create a title called "Category 5 storms" for your report*/
title "Catagory 5 Storms";

/*2.) Using the storm_summary datafile, sort data by MaxMindMPH*/
proc sort data=storm_with_anniversary;
    by descending MaxWindMPH;
run;

/*3.) Create a datafile of category 5 storms called StormCat5
*	  - Sort your data by BasinName and descending order of MaxWindMPH
*/
data cat_5_storms; set storm_with_anniversary;
	StormLength = EndDate - StartDate;
	if MaxWindMPH > 156 then output;
run;

proc sort data=cat_5_storms;
	by BasinName descending MaxWindMPH;
run;

/*4.) Print Season BasinName Name MaxWindMPH MinPressure StartDate and
*     Stormlength BY BasinName. Create the Stormlength variable if it
*     doesnt exist. StormLength should be time from StartDate to EndDate
*/
proc print data=cat_5_storms;
	var Season BasinName Name MaxWindMPH MinPressure StartDate StormLength;
	by BasinName;
run;

/*5.) Generate a frequency report for BasinName and Season to find out
*     the number of storms that happened in the different Basins and
*     different seasons 
*/
proc freq data=cat_5_storms order=freq nlevels;
	tables BasinName Season / nocum plots=freqplot(orient=horizontal scale=percent);
run;

/* Get an additional table from StartMonth. Create it if it doesn't already exist. Which month has the most storms?
*  Alternatively, you can use StartDate, and add a format "format StartDate monname." to get the StartMonth
*/
data cat_5_storms_with_month; set cat_5_storms;
	StartMonth = month(StartDate);
	format StartDate monname.;
run;

proc freq data=cat_5_storms_with_month order=freq;
	tables StartMonth / nocum plots=freqplot(orient=horizontal scale=percent);
run;

/*6.) Create a two-way frequency report with BasinName and StartMonth
*     - after the tables, use "/ crosslist" to get a different view
*     - after the "/ crosslist" add norow nocol to remove row and column
*       percentages. You may remove crosslist if you don't like the view
*/
proc freq data=cat_5_storms_with_month;
	tables BasinName*StartMonth / crosslist norow nocol;
run;

/*7.) Create Summary statistics for the BasinName and Stormtype 
*     - Summary statistics should include mean, median, mode, std.
*/
proc means data=cat_5_storms_with_month mean median mode std;
	class BasinName Storm_Type;
	var MaxWindMPH MinPressure;
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

* Add ODS statement;

/*Make the full Excel file and make the according sheet names with the appropriate procs!*/
ODS EXCEL FILE="C:\Users\aiden\Downloads\Storm_Report.xlsx" STYLE=ExcelBlue

	OPTIONS (SHEET_NAME='Category_5_Storms');
proc print data=cat_5_storms;
	var Season BasinName Name MaxWindMPH MinPressure StartDate StormLength;
	by BasinName;
run;

ODS EXCEL OPTIONS (SHEET_NAME='Frequency_Report');
proc freq data=cat_5_storms order=freq nlevels;
	tables BasinName Season / nocum plots=freqplot(orient=horizontal scale=percent);
run;

ODS EXCEL OPTIONS (SHEET_NAME='Start_Month_Report');
proc freq data=cat_5_storms_with_month order=freq;
	tables StartMonth / nocum plots=freqplot(orient=horizontal scale=percent);
run;

ODS EXCEL OPTIONS (SHEET_NAME='Basin_And_Month');
proc freq data=cat_5_storms_with_month;
	tables BasinName*StartMonth / crosslist norow nocol;
run;

ODS EXCEL OPTIONS (SHEET_NAME='Summary_Statistics');
proc means data=cat_5_storms_with_month mean median mode std;
	class BasinName Storm_Type;
	var MaxWindMPH MinPressure;
run;
ODS EXCEL CLOSE;
