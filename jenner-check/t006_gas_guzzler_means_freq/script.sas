/* From "Data Science I - HHS 2500/SAS/data_wrangling_wSAS.sas":
 *  - load sashelp.cars and tag gas_guzzler = (Cylinders > 6)
 *  - get basic descriptives with PROC FREQ on the binary
 *  - compare MPG_city across the two gas_guzzler groups with PROC MEANS
 *  - split into 3 anova groups via DATA step logic
 */

/* load data from sashelp and create new variable */
data cars; set sashelp.cars; run;

data cars2; set cars;
if Cylinders>6 then
	gas_guzzler=1;
else
	gas_guzzler=0;
run;

/* get basic descriptives of our data file */
proc freq data=cars2;
tables gas_guzzler;
title "Gas guzzlers in the sashelp.cars sample (Cylinders > 6)";
run;

proc means data=cars2;
var mpg_city; class gas_guzzler;
title "MPG_city by gas_guzzler group";
run;

/* Create 3 groups and call the groups anvar, for anova variable */
data cars2; set cars2;
anvar = 1;
if Cylinders>4 & Cylinders<=6 then anvar=2;
if Cylinders>6 then anvar=3;
run;

proc freq data=cars2;
tables anvar;
title "Three-group cylinder bucket distribution (anvar)";
run;
title;
