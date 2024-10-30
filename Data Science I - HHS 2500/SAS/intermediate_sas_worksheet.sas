**************************************************;
*  Creating an Accumulating Column               *;
**************************************************;
*  Demo                                          *;
*  Refer to the course notes for detailed steps. *;
**************************************************;
data houston_rain; set Dsclass.weather_houston;
	YTDRain + DailyRain;
	keep Date DailyRain YTDRain;
	proc print;
run;


***********************************************************;
*  Identifying the First and Last Row in Each Group       *;
***********************************************************;
*  Syntax                                                 *;
*                                                         *;
*    PROC SORT DATA=input-table                           *;
*        <OUT=output-table>;                              *;
*        BY <DESCENDING> col-name (s);                    *;
*    RUN;                                                 *;
*    DATA output-table;                                   *;
*        SET input-table;                                 *;
*        BY <DESCENDING> col-name (s);                    *;
*    RUN;                                                 *;
*    FIRST.bycol - identifies where the first row begins  *;
*    LAST.bycol - identifies where the last row ends      *;
***********************************************************;

proc sort data=DSclass.storm_2017 out=storm2017_sort(keep=Basin Name);
	by Basin;
run;

data storm2017_max; set storm2017_sort;
	by Basin;
	First_Basin=first.basin;
	Last_Basin=last.basin;
run;

***********************************************************;
*  Creating an Accumulating Column within Groups          *;
***********************************************************;
*    Subsetting IF statement:                             *;
*        IF expression;                                   *;
*    FIRST.bycol                                          *;
*    LAST.bycol                                           *;
***********************************************************;
proc sort data=DSclass.storm_2017 out=storm2017_sort;
	by Basin;
run;
data storm2017_max; set storm2017_sort;
    by Basin;
run;


***********************************************************;
*  Calculate month-to-date rainfall amount                *;
***********************************************************;
*  1) Highlight the DATA step and run the selected code.  *;
*     Notice that YTDRain is an accumulating column that  *;
*     creates a running total of DailyRain. Also notice   *;
*     that the data is sorted by Month and Date.          *;
*  2) Add a BY statement to process the rows by groups    *;
*     based on the values of Month.                       *;
*  3) Change the new accumulating column to MTDRain in    *;
*     the KEEP and sum statements.                        *;
*  4) Reset MTDRain to 0 each time that SAS reaches the   *;
*     first row within a new Month group. Highlight the   *;
*     DATA step and run the selected code.                *;
***********************************************************;

data houston_yeartodate; set DSclass.weather_houston;
	keep Date Month DailyRain YTDRain;
run;

data houston_monthtodate; set DSclass.weather_houston;
	by Month;
	keep Date Month DailyRain YTDRain MTDRain;

	*Student assignment;
	if first.Month then MTDRain=0; *reset MTDRain to 0 at the start of each month;
	MTDRain+DailyRain;
	if last.Month then output; *save only the last value of each month;
	proc print;
run;

***********************************************************;
*  Using Call Numeric Functions                           *;
***********************************************************;
*  Syntax                                                 *;
*                                                         *;
*    RAND ('distribution', parameter1, ...parameterk)     *;
*    LARGEST (k, value-1 <, value-2 ...>)                 *;
*    ROUND (number <,rounding-unit>)                      *;
***********************************************************;
*  1) Copy and paste the Quiz1st assignment statement     *;
*     twice and modify the statements to create columns   *;
*     named Quiz2nd and Quiz3rd.                          *;
*  2) Create a new column named Top3Avg that uses the     *;
*     MEAN function with the top three quiz scores as the *;
*     arguments.                                          *;
*  3) Add Name in the DROP statement.                     *;
*  4) Before the SET statement, create a new column named *;
*     StudentID. Use the RAND function with 'INTEGER' as  *;
*     the first argument. This generates random integers  *;
*     between the values specified in the second and      *;
*     third arguments. To create a four-digit number, use *;
*     1000 as the lower limit and 9999 as the upper       *;
*     limit. Highlight the DATA step and run the selected *;
*     code.                                               *;
*  5) Modify the Top3Avg assignment statement to use the  *;
*     ROUND function to round the values returned by the  *;
*     MEAN function to the nearest integer. Highlight the *;
*     DATA step and run the selected code.                *;
*  6) Add a second argument in the ROUND function to      *;
*     round values to the nearest .1                      *;
*                                                         *;
***********************************************************;

data quiz_analysis; StudentID=rand("integer", 1000, 9999); set DSclass.class_quiz;
/*	drop Quiz1-Quiz5 name;*/
    Quiz1st=largest(1, of Quiz1-Quiz5); *gets the 1st lastgest quiz of quiz1 to quiz5;

	*Sorts Quiz1 to Quiz5 from min to max and gets the average of the two largest;
	call sortn(of Quiz1-Quiz5);
	QuizAvg = mean(of Quiz4-Quiz5);
run;


***********************************************************;
*  Activity 3.04                                          *;
*  1) Notice that the INTCK function does not include the *;
*     optional method argument, so the default discrete   *;
*     method is used to calculate the number of weekly    *;
*     boundaries (ending each Saturday) between StartDate *;
*     and EndDate.                                        *;
*  2) Run the program and examine rows 8 and 9. Both      *;
*     storms were two days, but why are the values        *;
*     assigned to Weeks different?                        *;
*  3) Add 'c' as the fourth argument in the INTCK         *;
*     function to use the continuous method. Run the      *;
*     program. Are the values for Weeks in rows 8 and 9   *;
*     different?                                          *;
***********************************************************;
*  Syntax Help                                            *;
*     INTCK('interval', start-date, end-date, <'method'>) *;
*         Interval: WEEK, MONTH, YEAR, WEEKDAY, HOUR, etc.*;
*         Method: DISCRETE (D) or CONTINUOUS (C)          *;
***********************************************************;

data storm_length;
	set DSclass.storm_final(obs=10);
	keep Season Name StartDate Enddate StormLength Weeks;
	Weeks=intck('day', StartDate, EndDate, 'C');
run;


***********************************************************;
*  Shifting Date Values                                   *;
***********************************************************;
*  Syntax                                                 *;
*                                                         *;
*    INTNX (interval, start, increment <, 'alignment'>)   *;
*                                                         *;
*  1) Notice that the AssessmentDate column is created by *;
*     using the INTNX function to shift each Date value.  *;
*     Highlight the DATA step and run the selected code.  *;
*     Notice that each Date value has been shifted to the *;
*     first day of the same month.                        *;
*  2) To see the impact of the various arguments in the   *;
*     INTNX function, modify the arguments as directed.   *;
*     Highlight the DATA step, run the selected code, and *;
*     examine the results after each modification.        *;
*     a) Change the increment value to 2.                 *;
*     b) Change the increment value to -1. Add 'end' as   *;
*        the optional fourth argument to specify          *;
*        alignment.                                       *;
*     c) Change the alignment argument to 'middle'.       *;
*  3) Write an assignment statement to create a new       *;
*     column named Anniversary that is the date of the    *;
*     10-year anniversary for each storm. Add 'same' as   *;
*     the optional fourth argument to specify alignment.  *;
*     Keep the new column in the output table and use the *;
*     DATE9. format to display the values.                *;
***********************************************************;

/* Step 1 */
data storm_damage2;
	set DSclass.storm_damage;
	keep Event Date AssessmentDate;
	AssessmentDate=intnx('month', Date, 0);
    format Date AssessmentDate date9.;
run;

/* Step 2 */
data storm_damage2;
	set DSclass.storm_damage;
	keep Event Date AssessmentDate:;
	AssessmentDate=intnx('month', Date, 0);
	AssessmentDate_A=intnx('month', Date, 2);
	AssessmentDate_B=intnx('month', Date, -1, 'end');
	AssessmentDate_C=intnx('month', Date, -1, 'middle');
    format Date AssessmentDate: date9.;
run;

/* Step 3 */
data storm_damage2;
    set DSclass.storm_damage;
    keep Event Date AssessmentDate: Anniversary;
    AssessmentDate=intnx('month', Date, -1, 'middle');
    Anniversary=intnx('year', Date, 10, 'same');
    format Date AssessmentDate: Anniversary date9.;
run;



***********************************************************;
*  Using Character Functions to Extract Words             *;
*  from a String                                          *;
***********************************************************;
*  Syntax                                                 *;
*                                                         *;
*    SCAN (string, n <, 'delimiters'>)                    *;
*    PROPCASE (string, <, 'delimiters'>)                  *;
***********************************************************;
*  1) Notice that the DATA step creates the City and      *;
*     Prefecture columns by extracting the first or       *;
*     second word from Location. Highlight the step and   *;
*     run the selected code.                              *;
*  2) Examine row 8 in the output data. Notice that the   *;
*     city name should be MIYAKE-JIMA. However, the       *;
*     hyphen is a default delimiter, so MIYAKE is         *;
*     assigned to City and JIMA is assigned to            *;
*     Prefecture.                                         *;
*  3) In both SCAN functions, add a third argument to     *;
*     specify that the only delimiter is a comma.         *;
*     Highlight the step and run the selected code.       *;
*  4) Add an additional assignment statement to create a  *;
*     column named Country that reads the last word in    *;
*     Location.                                           *;
*  5) Use the PROPCASE function in the City assignment    *;
*     statement to capitalize the first letter of each    *;
*     word and convert the remaining letters to           *;
*     lowercase. Highlight the step and run the selected  *;
*     code.                                               *;
*  6) Examine row 8 again in the output data. Because the *;
*     hyphen is a delimiter, both Miyake and Jima are     *;
*     capitalized. The proper casing for this city name   *;
*     should be Miyake-jima. Use the optional second      *;
*     argument to specify that the only delimiter should  *;
*     be a space. Highlight the step and run the selected *;
*     code.                                               *;
***********************************************************;

data weather_japan_clean;
	set DSclass.weather_japan;
/*	len_1 = length(Location);*/
	Location2=compbl(Location); *removes multiple blanks/spaces;
/*	len_2 = length(Location2);*/
	City=scan(Location, 1); City2=scan(Location, 1, ','); *returns word at the specified index, using the delimiter as marker;
	Prefecture=scan(Location, 2); *Prefecture=scan(Location, 2, ',');
	Country=scan(Location, '-1')
	proc print data = weather_japan_clean(obs=10);
run;

data weather_japan_clean;
	set DSclass.weather_japan;
	Location=compbl(Location);
	City=propcase(scan(Location, 1, ','), ' ');
	Prefecture=scan(Location, 2, ',');
	*putlog Prefecture $quote20.;
	if Prefecture="Tokyo";
run;

/* Step 1 */
data weather_japan_clean;
	set DSclass.weather_japan;
	Location=compbl(Location);
	City=scan(Location, 1);
	Prefecture=scan(Location, 2);
run;

/* Step 3 */
data weather_japan_clean;
	set DSclass.weather_japan;
	Location=compbl(Location);
	City=scan(Location, 1, ',');
	Prefecture=scan(Location, 2, ',');
run;

/* Steps 4 andd 5 */
data weather_japan_clean;
	set DSclass.weather_japan;
	Location=compbl(Location);
	City=propcase(scan(Location, 1, ','));
	Prefecture=scan(Location, 2, ',');
	Country=scan(Location, -1);
run;

/* Step 6 */
data weather_japan_clean;
	set DSclass.weather_japan;
	Location=compbl(Location);
	City=propcase(scan(Location, 1, ','), ' ');
	Prefecture=scan(Location, 2, ',');
	Country=scan(Location, -1);
run;


***********************************************************;
*  Activity 3.08                                          *;
*  1) Notice that the assignment statement for            *;
*     CategoryLoc uses the FIND function to search for    *;
*     category within each value of the Summary column.   *;
*     Run the program.                                    *;
*  2) Examine the PROC PRINT report. Why is CategoryLoc   *;
*     equal to 0 in row 1? Why is CategoryLoc equal to 0  *;
*     in row 15?                                          *;
*  3) Modify the FIND function to make the search case    *;
*     insensitive. Uncomment the IF-THEN statement to     *;
*     create a new column named Category. Run the program *;
*     and examine the results.                            *;
***********************************************************;
*  Syntax Help                                            *;
*     FIND(string, substring <, 'modifiers'>)             *;
*         Modifiers:                                      *;
*             'I'=case insensitive search                 *;
*             'T'=trim leading and training blanks from   *;
*			     string and substring                     *;
***********************************************************;

data storm_damage2; set DSclass.storm_damage;
	drop Date Cost;
	CategoryLoc=find(Summary, 'category', 'I');
	if CategoryLoc > 0 then Category=substr(Summary,CategoryLoc, 10);
	proc print data=storm_damage2(obs=5);
run;

proc print data=storm_damage2;
	var Event Summary Cat:;
run;
***********************************************************;
*  TRANWRD (find and replace)                             *;
*                                                         *;
*  Replace the word, "hurricane" with the word, "storm"   *;
*  summary2 = tranword(summary, 'hurricane', 'storm')     *;
***********************************************************;
data storm_damage2; set storm_damage2;
	summary2 = ;
	proc print data=storm_damage2(obs=5);
run;



******************************************************************************************;
*  Using the INPUT and PUT Functions to Convert                                          *;
*  Column Types                                                                          *;
******************************************************************************************;
*  Syntax and Example                                                                    *;
*    INPUT converts string to numeric                                                    *;
*    PUT converts numeric to string                                                      *;
*                                                                                        *;
*    DATA output-table;                                                                  *;
*        SET input-table(RENAME=(current-col=new-col));                                  *;
*        ...                                                                             *;
*        column1 = INPUT (source, informat);                                             *;
*		 informat specifies the format of the data you want to convert to numeric        *;
*		 format specifies the format of the data you want to convert into from numeric   *;
*        column2 = PUT (source, format);                                                 *;
*        ...                                                                             *;
*    RUN;                                                                                *;
******************************************************************************************;
proc contents data=stocks2; run;
data work.stocks2;
   set DSclass.stocks2;
   Date2=input(Date,date9.);
   Volume=input(Volume,comma12.);
run;

data work.stocks2;
   set DSclass.stocks2(rename=(Volume=VolumeC));
   Date2=input(Date,date9.);
   Volume=input(VolumeC,comma20.);
/*   drop VolumeC;*/
run;

data work.stocks2;
   set DSclass.stocks2(rename=(Volume=VolumeC Date=DateC));
   Volume=input(VolumeC,comma12.);
   Date=input(DateC,date9.);
   Day=put(Date,downame9.); *downame: day_of_week_name, monname: month_name, year;
   drop VolumeC DateC;
run;

***********************************************************;
*  Demo                                                   *;
*  1) Open the DSclass.WEATHER_ATLANTA table and notice the   *;
*     following:                                          *;
*     * ZipCode is a numeric column.                      *;
*     * Date and Precip are character columns. A Precip   *;
*     value of T means that a trace value was recorded,   *;
*     which means a very small amount of precipitation    *;
*     that results in no measurable accumulation.         *;
*  2) Run the first DATA step.                            *;
*  3) View the SAS log. SAS attempts to convert the       *;
*     character Precip value to a numeric value using the *;
*     w. informat. SAS is successful when the character   *;
*     value is a legitimate numeric value such as .27.    *;
*     SAS is unsuccessful when the value is equal to a    *;
*     non-numeric value such as T. A value of T is        *;
*     converted to a missing numeric value.               *;
*  4) View the output table. Notice that TotalPrecip was  *;
*     accurately created for each row. The sum statement  *;
*     ignores the missing values for the Precip values of *;
*     T.                                                  *;
*  5) Add to the DATA step to create a new column named   *;
*     PrecipNum. Use PrecipNum in the assignment          *;
*     statement instead of Precip. Drop the Precip        *;
*     column.                                             *;
*  6) Run the DATA step. Notice that the SAS log no       *;
*     longer contains a note about character values being *;
*     converted to numeric values and no longer contains  *;
*     notes about invalid numeric data for Precip='T'.    *;
*  7) Add to the DATA step to create a numeric column     *;
*     Date from the character column Date. Also, format   *;
*     the numeric Date and drop the character Date.       *;
*  8) Run the DATA step. Confirm that you have a numeric  *;
*     precipitation column and a numeric date column.     *;
***********************************************************;

/*Step 2-4*/
data atl_precip;
	set DSclass.weather_atlanta;
	where AirportCode='ATL';
	drop AirportCode City Temp: ZipCode;
	TotalPrecip+Precip;
run;

/*Step 5-6*/
data atl_precip;
	set DSclass.weather_atlanta;
	where AirportCode='ATL';
	drop AirportCode City Temp: ZipCode Precip;
	if Precip ne 'T' then PrecipNum=input(Precip,6.);
	else PrecipNum=0;
	TotalPrecip+PrecipNum;
run;

/*Step 7-8*/
data atl_precip;
retain ziplast2;
	set DSclass.weather_atlanta(rename=(Date=CharDate));
	where AirportCode='ATL';
/*	drop AirportCode City Temp: ZipCode Precip CharDate;*/
	if Precip ne 'T' then PrecipNum=input(Precip,6.);
	else PrecipNum=0;
	TotalPrecip+PrecipNum;
	Date=input(CharDate,mmddyy10.);
	format Date date9.;
run;

***********************************************************;
*  9) Run the second DATA step and notice that            *;
*     CityStateZip was accurately created for each row.   *;
*     The CAT functions automatically convert numeric     *;
*     values to character values and remove leading       *;
*     blanks in the converted value. SAS does not write a *;
*     note to the log when values are converted with the  *;
*     CAT functions.                                      *;
* 10) Add to the DATA step to create a character column   *;
*     ZipCodeLast2 that contains the last two digits of   *;
*     the numeric column ZipCode.                         *;
* 11) View the SAS log. SAS converts the numeric ZipCode  *;
*     value to a character value.                         *;
* 12) View the output table. Notice that ZipCodeLast2 is  *;
*     not displaying the last two digits of the ZIP code. *;
*     When SAS automatically converts a numeric value to  *;
*     a character value, the BEST12. format is used, and  *;
*     the resulting character value is right-aligned. The *;
*     numeric value of 30320 becomes the character value  *;
*     of seven leading spaces followed by 30320.          *;
* 13) Modify the first argument of the SUBSTR function to *;
*     explicitly convert the numeric ZipCode value to a   *;
*     character value.                                    *;
* 14) View the output table. Notice that ZipCodeLast2 now *;
*     displays the last two digits of the ZIP code.       *;
***********************************************************;

/* PUT Function */
/*Step 9*/
data atl_precip;
	set DSclass.weather_atlanta;
	CityStateZip=catx(' ',City,'GA',ZipCode);
run;

/*Step 10-12*/
data atl_precip;
	set DSclass.weather_atlanta;
	CityStateZip=catx(' ',City,'GA',ZipCode);
	ZipCodeLast2=substr(ZipCode, 4, 2);
run;

/*Step 13-14*/
data atl_precip;
	set DSclass.weather_atlanta;
	CityStateZip=catx(' ',City,'GA',ZipCode);
	ZipCodeLast2=substr(put(ZipCode, z5.), 4, 2);
run;





***********************************************************;
*  Activity 3.13                                          *;
*  1) Add to the RENAME= option to rename the input       *;
*     column Date as CharDate.                            *;
*  2) Add an assignment statement to create a numeric     *;
*     column Date from the character column CharDate. The *;
*     values of CharDate are stored as 01JAN2018.         *;
*  3) Modify the DROP statement to eliminate all columns  *;
*     that begin with Char from the output table.         *;
*  4) Run the program and verify that Volume and Date are *;
*     numeric columns.                                    *;
***********************************************************;

data stocks2;
   set DSclass.stocks2(rename=(Volume=CharVolume));
   Volume=input(CharVolume,comma12.);
   
   drop CharVolume;
run;

proc contents data=stocks2;
run;




***********************************************************;
*  LESSON 3, PRACTICE 5                                   *;
*  a) Notice that the DATA step creates a table named     *;
*     PARKS and reads only those rows where ParkName ends *;
*     with NP.                                            *;
*  b) Modify the DATA step to create or modify the        *;
*     following columns:                                  *;
*     1) Use the SUBSTR function to create a new column   *;
*        named Park that reads each ParkName value and    *;
*        excludes the NP code at the end of the string.   *;
*        Note: Use the FIND function to identify the      *;
*        position number of the NP string. That value can *;
*        be used as the third argument of the SUBSTR      *;
*        function to specify how many characters to read. *;
*     2) Convert the Location column to proper case. Use  *;
*        the COMPBL function to remove any extra blanks   *;
*        between words.                                   *;
*     3) Use the TRANWRD function to create a new column  *;
*        named Gate that reads Location and converts the  *;
*        string Traffic Count At to a blank.              *;
*     4) Create a new column names GateCode that          *;
*        concatenates ParkCode and Gate together with a   *;
*        single hyphen between the strings.               *;
***********************************************************;

data parks;
	set DSclass.np_monthlytraffic;
	where ParkName like '%NP';
	Park=substr(ParkName, 1, find(ParkName,'NP')-2);
	Location=compbl(propcase(Location));
	Gate=tranwrd(Location, 'Traffic Count At ', ' ');
	GateCode=catx('-', ParkCode, Gate);
run;

proc print data=parks;
	var Park GateCode Month Count;
run;




***********************************************************;
*  LESSON 3, PRACTICE 6                                   *;
*  a) Run the program. Notice that the Column1 column     *;
*     contains raw data with values separated by various  *;
*     symbols. The SCAN function is used to extract the   *;
*     ParkCode and ParkName values.                       *;
*  b) Examine the PROC CONTENTS report. Notice that       *;
*     ParkCode and ParkName have a length of 200, which   *;
*     is the same as Column1.                             *;
*     Note: When the SCAN function creates a new column,  *;
*     the new column will have the same length as the     *;
*     column listed as the first argument.                *;
*  c) The ParkCode column should include only the first   *;
*     four characters in the string. Add a LENGTH         *;
*     statement to define the length of ParkCode as 4.    *;
*  d) The length for the ParkName column can be optimized *;
*     by determining the longest string and setting an    *;
*     appropriate length. Modify the DATA step to create  *;
*     a new column named NameLength that uses the LENGTH  *;
*     function to return the position of the last         *;
*     non-blank character for each value of ParkName.     *;
*  e) Use a RETAIN statement to create a new column named *;
*     MaxLength that has an initial value of zero.        *;
*  f) Use an assignment statement and the MAX function to *;
*     set the value of MaxLength to either the current    *;
*     value of NameLength or MaxLength, whichever is      *;
*     larger.                                             *;
*  g) Use the END= option in the SET statement to create  *;
*     a temporary variable in the PDV named LastRow.      *;
*     LastRow will be zero for all rows until the last    *;
*     row of the table, when it will be 1. Add an IF-THEN *;
*     statement to write the value of MaxLength to the    *;
*     log if the value of LastRow is 1.                   *;
***********************************************************;


data parklookup;
    set DSclass.np_unstructured_codes end=lastrow;
    length ParkCode $ 4 ParkName $ 83;
    ParkCode=scan(Column1, 2, '{}:,"()-');
    ParkName=scan(Column1, 4, '{}:,"()');
    retain MaxLength 0;
    NameLength=length(ParkName);
    MaxLength=max(NameLength,MaxLength);
    if lastrow=1 then putlog MaxLength=;
run;

proc print data=parklookup(obs=10);
run;

proc contents data=parklookup;
run;



***********************************************************;
*  LESSON 5, PRACTICE 1                                   *;
*  a) Complete the SET statement to concatenate the       *;
*     DSclass.NP_2015 and DSclass.NP_2016 tables to create a new  *;
*     table, NP_COMBINE.                                  *;
*  b) Use a WHERE statement to include only rows where    *;
*     Month is 6, 7, or 8.                                *;
*  c) Create a new column named CampTotal that is the sum *;
*     of CampingOther, CampingTent, CampingRV, and        *;
*     CampingBackcountry. Format the new column with      *;
*     commas.                                             *;
***********************************************************;


data work.np_combine;
    set DSclass.np_2015 DSclass.np_2016;
    CampTotal=sum(of Camping:);
    where Month in(6, 7, 8);
    format CampTotal comma15.;
    drop Camping:;
run;



***********************************************************;
*  Merging Tables with Non-matching Rows                  *;
***********************************************************;
*  Syntax and Examples                                    *;
*                                                         *;
*    DATA output-table;                                   *;
*        MERGE input-table1(IN=variable1)                 *;
*              input-table2(IN=variable2) ...;            *;
*        BY by-variable;                                  *;
*        IF expression;                                   *;
*    RUN;                                                 *;
***********************************************************;

/*Include matching rows only*/
data class2;
    merge DSclass.class_update(in=inUpdate) 
          DSclass.class_teachers(in=inTeachers);
    by name;
    if inUpdate=1 and inTeachers=1;
run;

***********************************************************;
*  Demo                                                   *;
*  1) Highlight the first PROC SORT step and run the      *;
*     selected code. A table named STORM_FINAL_SORT is    *;
*     created, arranged by Season and Name. Because some  *;
*     storm names have been used more than once, unique   *;
*     storms are identified by both Season and Name.      *;
*  2) Open DSclass.STORM_DAMAGE. Notice that it does not      *;
*     include the columns Season and Name, which are in   *;
*     STORM_FINAL_SORT. Season and Name must be derived   *;
*     from the Date and Event columns.                    *;
*  3) Examine the DATA step that creates a temporary      *;
*     table named STORM_DAMAGE. SAS functions are used to *;
*     create Season and Name with values that match the   *;
*     values in the STORM_FINAL_SORT table. Highlight the *;
*     DATA step and the PROC SORT step that follows it,   *;
*     and run the selection.                              *;
*  4) Complete the final DATA step to merge the sorted    *;
*     tables by Season and Name. Highlight the DATA step  *;
*     and run the selection. Notice in the output table   *;
*     that row 4 is storm Allen, which is included in the *;
*     STORM_DAMAGE table. Therefore, each of the columns  *;
*     has values read from both input tables. Most of the *;
*     values in the Cost column are missing because those *;
*     storms are not found in the STORM_DAMAGE table.     *;
*  5) Use the IN= data set option after the STORM_DAMAGE  *;
*     table to create a temporary variable named inDamage *;
*     that flags rows where Season and Name were read     *;
*     from the STORM_DAMAGE table. Add a subsetting IF    *;
*     statement to write the 38 rows from STORM_DAMAGE    *;
*     and the corresponding data from STORM_FINAL_SORT to *;
*     the output table. Highlight the DATA step and run   *;
*     the selection.                                      *;
***********************************************************;

proc sort data=DSclass.storm_final out=storm_final_sort;
	by Season Name;
run;

data storm_damage;
	set DSclass.storm_damage;
	Season=Year(date);
	Name=upcase(scan(Event, -1));
	format Date date9. Cost dollar16.;
run;

proc sort data=storm_damage;
	by Season Name;
run;

data damage_detail;
	merge storm_final_sort storm_damage;
	keep Season Name BasinName MaxWindMPH MinPressure Cost;
run;



*************************************************;
* DO index-col = start to stop by increment;    *;
*	  execute-commands-here                     *;
* END;                                          *;
*                                               *;
* For example:                                  *;
* do year = 2000 to 2010;                       *;
* 	  execute-commands-here;                    *;
* end;                                          *;
*           OR                                  *;
* do year = 2000 to 2010 by 1;                  *;
* 	  execute-commands-here;                    *;
* end;                                          *;
*************************************************;
data forecast; set sashelp.shoes;
	do year = 1 to 3;
		projectedsales = sales*1.05;
		output;
	end;
run;

***********************************************************;
*  LESSON 6, PRACTICE 1                                   *;
*  a) Add an iterative DO loop around the sum statement   *;
*     for Invest.                                         *;
*     1) Add a DO statement that creates the column Year  *;
*        with values ranging from 1 to 6.                 *;
*     2) Add an OUTPUT statement to show the value of the *;
*        retirement account for each year.                *;
*     3) Add an END statement.                            *;
*  b) Run the program and review the results.             *;
*  c) Add an inner iterative DO loop between the sum      *;
*     statement and the OUTPUT statement to include the   *;
*     accrued quarterly compounded interest based on an   *;
*     annual interest rate of 7.5%.                       *;
*     1) Add a DO statement that creates the column       *;
*        Quarter with values ranging from 1 to 4.         *;
*     2) Add a sum statement to add the accrued interest  *;
*        to the Invest value.                             *;
*            Invest+(Invest*(.075/4));                    *;
*     3) Add an END statement.                            *;
*  d) Run the program and review the results.             *;
*  e) Drop the Quarter column. Run the program and review *;
*     the results.                                        *;
***********************************************************;

data retirement;
    do Year = 1 to 6;
       Invest+10000;
       output;
    end;
run;

title1 'Retirement Account Balance per Year';
proc print data=retirement noobs;
    format Invest dollar12.2;
run;
title;

/* d. */
data retirement;
    do Year = 1 to 6;
       Invest+10000;
       do Quarter = 1 to 4;
          Invest+(Invest*(.075/4));
       end;
       output;
    end;
run;

title1 'Retirement Account Balance per Year';
proc print data=retirement noobs;
    format Invest dollar12.2;
run;
title;

/* f. */
data retirement;
    do Year = 1 to 6;
       Invest+10000;
       do Quarter = 1 to 4;
          Invest+(Invest*(.075/4));
       end;
       output;
    end;
    drop Quarter;
run;

title1 'Retirement Account Balance per Year';
proc print data=retirement noobs;
    format Invest dollar12.2;
run;
title;


***********************************************************;
*  LESSON 6, PRACTICE 2                                   *;
*  a) Run the program and review the results. Notice that *;
*     the initial program is showing the forecasted value *;
*     for the next year. The next year is based on adding *;
*     one year to the year value of today's date.         *;
*     Depending on the current date, your NextYear value  *;
*     might be bigger than the NextYear value in the      *;
*     following results.                                  *;
*  b) Add an iterative DO loop around the conditional     *;
*     IF-THEN statements.                                 *;
*     1) The DO loop needs to iterate five times.         *;
*     2) In the DO statement, a new column named Year     *;
*        needs to be created that starts at the value of  *;
*        NextYear and stops at the value of NextYear plus *;
*        4.                                               *;
*     3) A row needs to be created for each year.         *;
*  c) Modify the KEEP statement to keep the column Year   *;
*     instead of NextYear.                                *;
*  d) Run the program and review the results.             *;
*  e) (Optional) Modify the OUTPUT statement to be a      *;
*     conditional statement that outputs only on the      *;
*     fifth iteration. Run the program and review the     *;
*     results.                                            *;
***********************************************************;

data ForecastDayVisits;  
    set DSclass.np_summary;
    where Reg='PW' and Type in ('NM','NP');
    ForecastDV=DayVisits;
    NextYear=year(today())+1;

    if Type='NM' then ForecastDV=ForecastDV*1.05;
    if Type='NP' then ForecastDV=ForecastDV*1.08;

    format ForecastDV comma12.;
    label ForecastDV='Forecasted Recreational Day Visitors';
    keep ParkName DayVisits ForecastDV NextYear;
run;

proc sort data=ForecastDayVisits;
    by ParkName;
run;

title 'Forecast of Recreational Day Visitors for Pacific West';
proc print data=ForecastDayVisits label;
run;
title;

/* d. */
data ForecastDayVisits;  
    set DSclass.np_summary;
    where Reg='PW' and Type in ('NM','NP');
    ForecastDV=DayVisits;
    NextYear=year(today())+1;
    do Year = NextYear to NextYear+4;
       if Type='NM' then ForecastDV=ForecastDV*1.05;
       if Type='NP' then ForecastDV=ForecastDV*1.08;
       output;
    end;
    format ForecastDV comma12.;
    label ForecastDV='Forecasted Recreational Day Visitors';
    keep ParkName DayVisits ForecastDV Year;
run;

proc sort data=ForecastDayVisits;
    by ParkName;
run;

title 'Forecast of Recreational Day Visitors for Pacific West';
proc print data=ForecastDayVisits label;
run;
title;

/* e. */
data ForecastDayVisits;  
    set DSclass.np_summary;
    where Reg='PW' and Type in ('NM','NP');
    ForecastDV=DayVisits;
    NextYear=year(today())+1;
    do Year = NextYear to NextYear+4;
       if Type='NM' then ForecastDV=ForecastDV*1.05;
       if Type='NP' then ForecastDV=ForecastDV*1.08;
       if Year=NextYear+4 then output;
    end;
    format ForecastDV comma12.;
    label ForecastDV='Forecasted Recreational Day Visitors';
    keep ParkName DayVisits ForecastDV Year;
run;

proc sort data=ForecastDayVisits;
    by ParkName;
run;

title 'Forecast of Recreational Day Visitors for Pacific West';
proc print data=ForecastDayVisits label;
run;
title;


***********************************************************;
*  LESSON 6, PRACTICE 3                                   *;
*  b) Add a DO loop to the DATA step to produce the       *;
*     following results. The MPG value is increasing      *;
*     by three percent per year.                          *;
*  c) Modify the DO statement to produce the following    *;
*     results. The DO statement will now be based on a    *;
*     list of values instead of a value that is           *;
*     incremented.                                        *;
***********************************************************;

data IncMPG;
    set sashelp.cars;
    MPG=mean(MPG_City, MPG_Highway);
run;

title 'Projected Fuel Efficiency with 3% Annual Increase';
proc print data=IncMPG;
    var Make Model Year MPG;
	format MPG 4.1;
run;
title;


/* Step b */
data IncMPG;
    set sashelp.cars;
    MPG=mean(MPG_City, MPG_Highway);
    do Year=1 to 5;
        MPG=MPG*1.03;
        output;
    end;
run;

title 'Projected Fuel Efficiency with 3% Annual Increase';
proc print data=IncMPG;
    var Make Model Year MPG;
	format MPG 4.1;
run;
title;

/* Step c */
data IncMPG;
    set sashelp.cars;
    MPG=mean(MPG_City, MPG_Highway);
    do Year='Year 1', 'Year 2', 'Year 3', 'Year 4', 'Year 5';
        MPG=MPG*1.03;
        output;
    end;
run;

title 'Projected Fuel Efficiency with 3% Annual Increase';
proc print data=IncMPG;
    var Make Model Year MPG;
	format MPG 4.1;
run;
title;


***********************************************************;
*  Using Iterative DO Loops                               *;
***********************************************************;
*  Syntax                                                 *;
*                                                         *;
*    DATA output-table;                                   *;
*        SET input-table;                                 *;
*        . . .                                            *;
*        DO index-column = start TO stop <BY increment>;  *;
*           . . . repetitive code . . .                   *;
*           OUTPUT;                                       *;
*        END;                                             *;
*        . . .                                            *;
*        OUTPUT;                                          *;
*    RUN;                                                 *;
***********************************************************;
*  Demo                                                   *;
*  1) Open the DSclass.SAVINGS table. Notice there are four*;
*     rows representing different people. The Amount      *;
*     value is a monthly savings value.                   *;
*  2) Run the program and notice that four rows are       *;
*     created due to four rows being read from the input  *;
*     table. Also, notice how the Savings value keeps     *;
*     increasing for each row.                            *;
*  3) Fix the issue by adding an assignment statement     *;
*     before the DO loop to set the value of Savings to   *;
*     0. Run the program and notice the correct values    *;
*     for Savings.                                        *;
*  4) Add an outer DO loop to iterate through five years  *;
*     per each of the 12 months. Run the program and      *;
*     notice that you have one row per each person. Each  *;
*     row represents the savings after five years,        *;
*     assuming that savings are added each month. The     *;
*     value of Year is 6 and the value of Month is 13, an *;
*     increment beyond each stop value.                   *;
*  5) Add an OUTPUT statement to the bottom of the outer  *;
*     DO loop. Run the program and notice that you now    *;
*     have 5 rows per each person (a total of 20 rows).   *;
*     Each row represents the savings at each of the five *;
*     years.                                              *;
*  6) Move the OUPUT statement to the bottom of the inner *;
*     DO loop. Run the program and notice that you now    *;
*     have 60 rows per each person (a total of 240 rows). *;
*     Each row represents the savings at each year and    *;
*     month combination.                                  *;
***********************************************************;

data savings;
	input name $ amount;
	datalines;
	James 200
	Mary 300
	Taylor 400
	Zen 500
;
run;

/* Step 2 */
data YearSavings; set savings;
	do Month=1 to 12;
		Savings+Amount;
		Savings+(Savings*0.02/12);
		output;
	end;
	format Savings comma12.2;
run;

/* Step 3 */
data YearSavings; set savings;
	Savings = 0;
	do Month=1 to 12;
		Savings+Amount;
		Savings+(Savings*0.02/12);
		output;
	end;
	format Savings comma12.2;
run;

/* Step 4 */
data YearSavings; set savings;
	Savings = 0;
	do Year = 1 to 5;
		do Month=1 to 12;
			Savings+Amount;
			Savings+(Savings*0.02/12);
			output;
		end;
	end;
	format Savings comma12.2;
run;

/* Step 5 */
data YearSavings; set savings;
	Savings=0;
	do Year=1 to 5;
		do Month=1 to 12;
			Savings+Amount;
			Savings+(Savings*0.02/12);
		end;
	output;
	end;
	format Savings comma12.2;
run;

/* Step 6 */
data YearSavings; set savings;
	do Year=1 to 5;
		do Month=1 to 12;
			Savings+Amount;
			Savings+(Savings*0.02/12);
			output;
		end;
	end;
	format Savings comma12.2;
run;

***********************************************************;
*  Using Conditional DO Loops                             *;
***********************************************************;
*  Syntax                                                 *;
*                                                         *;
*    DATA output-table;                                   *;
*       SET input-table;                                  *;
*       . . .                                             *;
*       DO UNTIL | WHILE (expression);                    *;
*          . . . repetitive code . . .                    *;
*          OUTPUT;                                        *;
*       END;                                              *;
*       DO index-column = start TO stop <BY increment>    *;
*          UNTIL | WHILE (expression);                    *;
*          . . . repetitive code . . .                    *;
*          OUTPUT;                                        *;
*       END;                                              *;
*       . . .                                             *;
*       OUTPUT;                                           *;
*    RUN;                                                 *;
***********************************************************;

***********************************************************;
*  Demo                                                   *;
*  1) Open the DSclass.SAVINGS2 table. This table contains a  *;
*     column named Savings that is the current value of   *;
*     each person's savings account. Notice that Linda's  *;
*     value is already greater than 3000.                 *;
*  2) Notice the DO UNTIL expression is Savings equal to  *;
*     3000. Run the program. Because Savings is never     *;
*     equal to 3000, the program is in an infinite loop.  *;
*     Stop the infinite DO loop from running.             *;
*     * In SAS Enterprise Guide, click the Stop toolbar   *;
*       button on the Program tab.                        *;
*     * In SAS Studio, click Cancel in the Running pop-up *;
*       window.                                           *;
*  3) Make the following modifications to the DATA step.  *;
*     a) Replace the equal sign with a greater than       *;
*        symbol.                                          *;
*     b) Add a sum statement inside the DO loop to create *;
*        a column named Month that will increment by 1    *;
*        for each loop.                                   *;
*     c) Before the DO loop add an assignment statement   *;
*        to reset Month to 0 each time a new row is read  *;
*        from the input table.                            *;
*  4) Run the program. Notice that even though Linda      *;
*     began with 3600 for Savings, the DO LOOP executed   *;
*     once.                                               *;
*  5) Change the DO UNTIL expression to DO WHILE so that  *;
*     the condition will be checked at the top of the     *;
*     loop. Run the program and verify Linda's Savings    *;
*     amount is 3600.                                     *;
***********************************************************;

/* Step 2 */
data MonthSavings;
    set DSclass.savings2;
    do until (Savings=3000);
       Savings+Amount;
       Savings+(Savings*0.02/12);
    end;
    format Savings comma12.2;
run;

/* Step 3 */
data MonthSavings;
    set DSclass.savings2;
    Month=0;
    do until (Savings>3000);
       Month+1;
       Savings+Amount;
       Savings+(Savings*0.02/12);
    end;
    format Savings comma12.2;
run;

/* Step 4 */
data MonthSavings;
    set DSclass.savings2;
    Month=0;
    do while (Savings<3000);
       Month+1;
       Savings+Amount;
       Savings+(Savings*0.02/12);
    end;
    format Savings comma12.2;
run;


***********************************************************;
*  Using Conditional DO Loops                             *;
***********************************************************;
*  Syntax                                                 *;
*                                                         *;
*    DATA output-table;                                   *;
*       SET input-table;                                  *;
*       . . .                                             *;
*       DO UNTIL | WHILE (expression);                    *;
*          . . . repetitive code . . .                    *;
*          OUTPUT;                                        *;
*       END;                                              *;
*       DO index-column = start TO stop <BY increment>    *;
*          UNTIL | WHILE (expression);                    *;
*          . . . repetitive code . . .                    *;
*          OUTPUT;                                        *;
*       END;                                              *;
*       . . .                                             *;
*       OUTPUT;                                           *;
*    RUN;                                                 *;
***********************************************************;
***********************************************************;
*  1) The intent of both DATA steps is process the DO     *;
*     loop for each row in the DSclass.SAVINGS2 table. One    *;
*     DATA step uses DO WHILE and the other uses DO       *;
*     UNTIL. Each loop represents one month of savings.   *;
*     The loop should stop iterating when Savings exceeds *;
*     3000 or 12 months pass, whichever comes first.      *;
*  2) Run the demo program and view the 2 reports that    *;
*     are created. Notice that the values of Savings in   *;
*     the DO WHILE and DO UNTIL reports match, indicating *;
*     that the DO loops executed the same number of times *;
*     for each person.                                    *;
*  3) Observe that for the first row in both the DO WHILE *;
*     and DO UNTIL reports has Month equal to 13. Savings *;
*     did not exceed $5,000 after 12 iterations of the DO *;
*     loop. The Month index variable was incremented to   *;
*     13 at the end of the twelfth iteration of the loop, *;
*     which triggered the end of the loop in both DATA    *;
*     steps and an implicit output action to the output   *;
*     table.                                              *;
*  4) Observe that in rows 2, 3 and 4, the value of Month *;
*     in the DO WHILE results is one greater compared to  *;
*     the DO UNTIL results. This is because in the DO     *;
*     WHILE loop, the index variable Month increments     *;
*     before the condition is checked. Therefore, the     *;
*     Month column in the output data does not accurately *;
*     represent the number of times the DO loop iterated  *;
*     in either DATA step.                                *;
*  5) To create an accurate counter for the number of     *;
*     iterations of a DO loop, make the following         *;
*     modifications to both DATA steps:                   *;
*     a) Add a sum statement inside the loop to create a  *;
*        column named Month and add 1 for each iteration. *;
*     b) Before the DO loop add an assignment statement   *;
*        to reset Month to 0 each time a new row is read  *;
*        from the input table.                            *;
*     c) Change the name of the index variable to an      *;
*        arbitrary name, such as i.                       *;
*     d) Add a DROP statement to drop i from the output   *;
*        table.                                           *;
*  6) Run the program and examine the results. Notice the *;
*     values of Savings and Month match for the DO WHILE  *;
*     and DO UNTIL reports. Month represents the number   *;
*     of times the DO loop executed for each row.         *;
***********************************************************;

data MonthSavingsW;
    set DSclass.savings2;
	Month=0;
    do i=1 to 12 while (savings<=5000);
		Month+1;
	    Savings+Amount;
        Savings+(Savings*0.02/12);
    end;
    format Savings comma12.2;
	drop i;
run;

data MonthSavingsU;
    set DSclass.savings2;
	Month=0;
    do i=1 to 12 until (savings>5000);
		Month+1;
        Savings+Amount;
        Savings+(Savings*0.02/12);
    end;
    format Savings comma12.2;
	drop i;
run;

title "DO WHILE Results";
proc print data=MonthSavingsW;
run;

title "DO UNTIL Results";
proc print data=MonthSavingsU;
run;



***************************************************************;
*  Creating a Stacked Table with the DATA Step               *;
***************************************************************;
*  In the Census data file, we used a for loop                *;
*  Demo                                                       *;
*      View steps in the course notes to use the DATA step    *;
*      debugger.                                              *;
***************************************************************;
data class_test_wide; set DSclass.class_test_wide;
swimming = rand('integer', 25, 80);
proc print;
run;

data class_test_narrow; set class_test_wide;
	keep Name Subject Score;
	length Subject $ 10;
	Subject="Math"; Score=Math; output;
	Subject="Reading"; Score=Reading; output;
	Subject = 'Swimming'; Score = Swimming; output;
	proc print;
run;

data class_test_narrowtowide; set class_test_narrow;
	by name;
	retain Name Math Reading Swimming;
	if Subject="Math" then Math=Score;
	else if Subject="Reading" then Reading=Score;
	else Swimming=Score;
	if last.name=1 then output;
	keep Name Math Reading Swimming;
	proc print;
run;


***********************************************************;
*  Creating a Split Table with PROC TRANSPOSE             *;
***********************************************************;
*  Syntax                                                 *;
*                                                         *;
*    PROC TRANSPOSE DATA=input-table OUT=output-table     *;
*                   <PREFIX=column> <NAME=column>;        *;
*        <VAR columns(s)>;                                *;
*        <ID column>;                                     *;
*        <BY column(s)>;                                  *;
*    RUN;                                                 *;
***********************************************************;
proc transpose data=class_test_narrow out=transpose_grades_narrowtowide;
    var Score;
    id Subject;
    by Name;
run;

proc transpose data=transpose_grades_narrowtowide out=test_grades_widetonarrow;
    var Math-Swimming;
	by Name;
run;

***********************************************************;
*  1) Run the PROC TRANSPOSE step and examine the error   *;
*     in the log. The step fails because the values of ID *;
*     are not unique.                                     *;
*  2) Add a BY statement to transpose the values within   *;
*     the groups of Season, Basin, and Name. Run the      *;
*     program.                                            *;
*  3) Notice that the unique values of WindRank (1, 2, 3, *;
*     and 4) are assigned as the column names for the     *;
*     transposed values of WindMPH.                       *;
*  4) To give the transposed columns standard names, add  *;
*     the PREFIX=Wind option in the PROC TRANSPOSE        *;
*     statement. To rename the _name_ column that         *;
*     identifies the source column for the transposed     *;
*     values, add the NAME=WindSource option as well. Run *;
*     the step.                                           *;
*  5) Delete the NAME= option and add the DROP= data set  *;
*     option on the output table to drop the _name_       *;
*     column. Run the step.                               *;
***********************************************************;
proc print data=DSclass.storm_top4_narrow; run;

/* Step 1 */
proc transpose data=DSclass.storm_top4_narrow out=wind_rotate;
	var WindMPH;
	id WindRank;
run;

/* Step 2 */
proc transpose data=DSclass.storm_top4_narrow out=wind_rotate;
    var WindMPH;
    id WindRank;
    by Season Basin Name;
run;

/* Steps 3 and 4 */
proc transpose data=DSclass.storm_top4_narrow out=wind_rotate 
               prefix=Wind name=WindSource;
	var WindMPH;
    id WindRank;
    by Season Basin Name;
run;

/* Step 5 */
proc transpose data=DSclass.storm_top4_narrow 
               out=wind_rotate(drop=_name_) prefix=Wind;
    var WindMPH;
    id WindRank;
    by Season Basin Name;
run;
