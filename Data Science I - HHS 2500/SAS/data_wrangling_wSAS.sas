* This is a single line comment. It ends with a semi-colon;

/* This is a multiline comment
Below, we load data from the sashelp folder
*/
data cars; set sashelp.cars; run;

/* 
We create a new data file from the previous file and make updates.
We create a new variable called gas_guzzler to identify large cylinder engines
*/
data cars2; set cars;
if Cylinders >= 6
	then gas_guzzler=1;
else gas_guzzler=0; 
run;

data cars2; set cars2;
* We can create new variables using arithmetic;
guzzler_cylinder = Cylinders*gas_guzzler;
* We can create new variables while allowing missing values;
if gas_guzzler then guzzler_make=Make;
run;

/* Note:
A column with strings can accept numeric, but a variable with numeric cannot accept string
*/
data cars2; set cars2;
* We can modify existing varibles in their place;
if guzzler_cylinder=6 then guzzler_cylinder=1000;
if guzzler_make='shitty' then guzzler_make=1;
run;

/*========================================================================================
This code generage a frequency table for our data.
We need to specify the variable (column) for which we want the frequency table
We can also use "_all_" to get frequency tables for all the variables (not a good idea!)
"proc" means procedure. Then we specify the procedure we want, and the data to perform
this procedure on.
*/
proc freq data=cars2;
tables gas_guzzler;
run;

/*
Compare the means of the two gas_guzzler groups using the proc means command:
find average mpg (city) for gas_guzzlers and non-gas guzzlers.
if you compute overall mean, you don't need to sort, but if you compute mean by groups,
you need to sort first.
*/
proc means data=cars2;
var mpg_city; by gas_guzzler;
run; *this will yield an error because we need to sort  the first;

proc sort data=cars2; by gas_guzzler; run;
/*After sorting, we now run the proc means function*/
proc means data=cars2;
var mpg_city; by gas_guzzler;
run;

/*Next, perform a ttest*/
proc ttest data=cars2;
var mpg_city; class gas_guzzler; run;

* Create 3 groups and call the groups 'anvar', for anova variable;
data cars2; set cars2;
anvar = 1;
if Cylinders>4 & Cylinders<=6 then anvar=2;
if Cylinders>6 then anvar=3;
run;

/*Next, perform the anova test*/
proc anova data=cars2;
class anvar;
model mpg_city=anvar;
run;


* We can drop variables we don't need;
data cars3; set cars2; drop gas_guzzler; run;
* We can also keep the variables we need instead;
data cars3; set cars3; keep Cylinders guzzler_cylinder Make guzzler_make; run;
* We can delete rows we don't like too;
data cars3; set cars3;
if guzzler_make='' then delete; run;

/*load data from sashelp and create new variable*/
data cars; set sashelp.cars; run;

data cars2; set cars;
if Cylinders>6 then
	gas_guzzler=1;
else
	gas_guzzler=0;
run;

/*get basic descriptives of our data file*/
proc freq data=cars2;
tables gas_guzzler;
run;

proc means data=cars2;
var mpg_city; class gas_guzzler;
run;

/*perform ttest on mpg using the newly defined variable as classes*/
proc ttest data=cars2;
var mpg_city; class gas_guzzler;
run;

/*create 2 id variables - getting ready to split the data*/
data cars2; set cars2;
id+1;
id2=id;
run;

data cars_half1; set cars2;
keep make model type id;
run;

data cars_half2; set cars2;
drop make model type id;
run;
/* Merge the 2 datasets by id (rename to makesure there is a common variable)*/
data combo1;
merge Cars_half1 Cars_half2(rename=(id2=id));
by id;
run;

proc print data=combo1;
title 'combined dataset';
run;

/*Change order of merging variable.
  Check if the sort still works as expected.
*/
proc sort data=cars_half2;
by mpg_city;
run;

data combo2;
merge Cars_half1 Cars_half2(rename=(id2=id));;
by id;
run;

/*Sort to match the order of merging variable.
  Check if the sort still works as expected.
*/
proc sort data=cars_half2;
by id2;
run;

data combo3;
merge Cars_half1 Cars_half2(rename=(id2=id));
by id;
run;
