/* From "Data Science I - HHS 2500/SAS/Do_loops_worksheet.sas":
 *  - retirement account with iterative DO loop, six years
 *  - inner DO loop adds quarterly compounded interest at an annual rate of 7.5%
 *  - format the Invest column as dollars
 */

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
title1 'Retirement Account Balance per Year (Quarterly Compounded)';
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
title1 'Retirement Account Balance per Year (Quarter Column Dropped)';
proc print data=retirement noobs;
    format Invest dollar12.2;
run;
title;
