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
	projectedsales = sales;
	do year = 1 to 3;
		projectedsales = projectedsales*1.05;
		output;
	end;
	keep region product sales year projectedsales;
	format projectedsales dollar10.;
run;


* Notice that the projected sales in years 1 to 3 is the same;
* We modify our code below;
data forecast2; set sashelp.shoes;
	projectedsales = sales;
	do year = 1 to 3;
		projectedsales = projectedsales*1.05;
		output;
	end;
	format projectedsales dollar10.;
	proc print data=forecast2(obs=10);
run;

/* This will make a table with 12 rows because of the do loop */
data yearlysavings;
	do Month=1 to 12;
		savings+200;
		output;
	end;
	format savings 12.2;
run;

/* This will add a new column but only count up to as many rows as there are in the table */
data yearlysavings2; set yearlysavings;
	checkingaccount+50;
run;

/* This will add a new column 'year' and repeat the loop 3 times and loop through 12 months for each year making a total of 36 rows */
data yearlysavings3;
	do year = 1 to 3;
		do month = 1 to 12;
			savings+200;
			output;
		end;
	end;
	format savings 12.2;
run;

/* This will make a new table with 12 rows (each month) and then add the current months savings with a 5% interest
*  i.e. 200+200*0.05 for month 1
*/
data investment;
	do month=1 to 12;
		savings+200;
		savings=savings+(savings*0.05);
		output;
	end;
	format savings 12.2;
run;

/* CREATE AN ID COLUMN */
data forecast; set forecast;
	ID+10;
run;


* Create data;
data savings;
	input name $ amount;
	datalines;
	James 200
	Evans 250
	 Mary 300
	Holly 450
	;
run;


* Savings earns 2% annual interest, compounded monthly;
data oneyrsavings; set savings;
	*savings=0; *this line resets the value after each iteration to prevent compounding;
	do Month=1 to 12;
		Savings+amount;
		Savings+Savings*(.02/12); *output;
	end;
proc print;
run;


data fiveyrsavings; set savings;
	savings=0;
	do year=1 to 5;
		do Month=1 to 12;
			Savings+amount;
			Savings+Savings*(.02/12);
			output;
		end;
	end;
proc print;
run;

***********************************************************;
*  Using Conditional DO Loops                             *;
***********************************************************;
*    DATA output-table; *SET input-table;                 *;
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
data year3ysavings;
	do until (savings>=10000);
		month+1;
		savings+500; savings+savings*(0.05/12); output;
	end;
	format savings dollar12.2;
	proc print;
run;

data year4ysavings;
	do month=1 to 12 until (savings>=10000);
		savings+500; savings+savings*(0.05/12); output;
	end;
	format savings dollar12.2;
	proc print;
run;



***********************************************************;
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
/* a. */
data retirement;
	do Year=1 to 6;
		Invest+500;
		output;
	end;
run;

/* b. */
title1 'Retirement Account Balance per Year';
proc print data=retirement noobs; *noobs removes the observation column;
	format Invest dollar12.2;
run;


/* c. */
data retirement;
	do Year=1 to 6;
		Invest+500;
		do Quarter=1 to 4;
			Invest+(Invest*(.075/4));
		end;
		output;
	end;
run;

/* d. */
title1 'Retirement Account Balance per Year';
proc print data=retirement noobs;
    format Invest dollar12.2;
run;


/* e. */
data retirement;
	do Year=1 to 6;
		Invest+500;
		do Quarter=1 to 4;
			Invest+(Invest*(.075/4));
		end;
		output;
	end;
	drop Quarter;
run;

/* e. again */
title1 'Retirement Account Balance per Year';
proc print data=retirement noobs; *noobs removes the observation column;
    format Invest dollar12.2;
run;


***********************************************************;
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

/* a. */
data ForecastDayVisits;
run;


proc sort data=ForecastDayVisits;
	by Year;
run;


title 'Forecast of Recreational Day Visitors for Pacific West';
proc print data=ForecastDayVisits label;
run;
title;


/* d. */
data ForecastDayVisits; set DSclass.np_summary;
	NextYear = year(today()) + 1;
	 do i = 0 to 4;
		Year = NextYear + i;
	end;
	keep Year Forecast Visitors;
run;


proc sort data=ForecastDayVisits;
	by Year;
run;


title 'Forecast of Recreational Day Visitors for Pacific West';
proc print data=ForecastDayVisits label;
run;


/* e. */
data ForecastDayVisits; set DSclass.np_summary;
	NextYear = year(today()) + 1;
	 do i = 0 to 4;
		Year = NextYear + i;
		if i = 4 then output;
	end;
	keep Year Forecast Visitors;
run;


proc sort data=ForecastDayVisits;
	by Year;
run;


title 'Forecast of Recreational Day Visitors for Pacific West';
proc print data=ForecastDayVisits label;
run;



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

data IncMPG; set sashelp.cars;
run;


title 'Projected Fuel Efficiency with 3% Annual Increase';
proc print data=IncMPG;
    var Make Model Year MPG;
	format MPG 4.1;
run;


/* Step b */
data IncMPG; set sashelp.cars;
	MPG = mean(MPG_City, MPG_Highway);
	do Year = 1 to 5;
		MPG = MPG * 1.03;
		output;
	end;
	keep Make Model Year MPG;
run;


title 'Projected Fuel Efficiency with 3% Annual Increase';
proc print data=IncMPG;
    var Make Model Year MPG;
	format MPG 4.1;
run;


/* Step c */
data IncMPG; set sashelp.cars;
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
*  1) Open the DSclass.SAVINGS table. Notice there are four   *;
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

/* Step 2 - initial setup */
data YearSavings; set DSclass.savings;
run;


/* Step 3 */
data YearSavings; set DSclass.savings;
	Savings = 0;
run;


/* Step 4 */
data YearSavings; set DSclass.savings;
	Savings = 0;
	do Year = 1 to 5;
		do Month = 1 to 12;
			Savings = Savings + Amount;
		end;
	end;
run;


/* Step 5 */
data YearSavings; set DSclass.savings;
	Savings = 0;
	do Year = 1 to 5;
		do Month = 1 to 12;
			Savings = Savings + Amount;
		end;
		output;
	end;
run;


/* Step 6 */
data YearSavings; set DSclass.savings;
	Savings = 0;
	do Year = 1 to 5;
		do Month = 1 to 12;
			Savings = Savings + Amount;
			output;
		end;
	end;
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
data MonthSavings; set DSclass.savings2;
	do until (Savings = 3000);
		output;
	end;
run;


/* Step 3 */
data MonthSavings; set DSclass.savings2;
	Month = 0;
	do until (Savings > 3000);
		Month + 1;
		Savings = Savings + 200;
		output;
	end;
run;


/* Step 4 */
data MonthSavings; set DSclass.savings2;
    Month = 0;
    do until (Savings > 3000);
        Month + 1;
        Savings = Savings + 200;
        output;
    end;
run;


***********************************************************;
*  Using Conditional DO Loops                             *;
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

data MonthSavingsW; set DSclass.savings2;
	Month = 0;
	do i = 1 to 12 while (Savings <= 3000);
		Month + 1;
		Savings = Savings + 200;
		output;
	end;
	drop i;
run;


data MonthSavingsU; set DSclass.savings2;
	Month = 0;
	do i = 1 to 12 until (Savings > 3000);
		Month + 1;
		Savings = Savings + 200;
		output;
	end;
	drop i;
run;


title "DO WHILE Results";
proc print data=MonthSavingsW;
run;


title "DO UNTIL Results";
proc print data=MonthSavingsU;
run;
