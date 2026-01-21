/*=====================*/
/* Initial Setup */
/*=====================*/

/* First export the sashelp.cars dataset as an excel spreadsheet, I exported to desktop but ofc there are better options */
proc export
	data=sashelp.cars
	dbms=xlsx
	outfile="C:\Users\aiden\OneDrive\Desktop\cars.xlsx"
	replace;
run;

/* Now import the cars excel file back into SAS which will end up in the WORK library */
proc import
	out=cars
	datafile = "C:\Users\aiden\OneDrive\Desktop\cars.xlsx"
	dbms = xlsx replace;
run;

/*=====================*/
/* In-Class Assignment */
/*=====================*/

/* 1. create a copy of cars dataset named cars2 */
data cars2; set cars;
run;

/* 2. create bin var called fuel_effic that is assigned a value of 1 if mles per gallon in the city are greater than 17 */
data cars2; set cars2;
	fuel_effic = 0;
	if (MPG_City > 17) then fuel_effic = 1;
run;

/* 3. Delete all vehicles that are type "hybrid" from the cars2 dataset */
data cars2; set cars2;
	if (Type = "Hybrid") then delete;
run;

/* 4. run stats test (TTest in this case) to determine whether behicles that are fuel efficient have significantly fewer cylinders */
proc ttest data=cars2;
	class fuel_effic;
	var Cylinders;
run;

/* 5. identify which vehicle types to determine whether  */
proc freq data=cars2;
	tables Type / out=freq_res;
run;

/* 6. using proc means, identify which vehicle types get the highest mpg in the city */
proc means data=cars2 n mean max;
	class Type;
	var MPG_City;
run;

/* 7. run stats test (Anova in this case) to compare all vehicle types to determine whether they significantly differ in mpg_city */
proc anova data=cars2 plots=none;
	class Type;
	model MPG_City = Type;
	means Type / bon;
run;
quit;

/* 8. run a correlation test to determine whether there is a bivariate positive or negative relationship between mpg_city and horsepower as well as mpg_city and weight */
proc corr data=cars2;
	var MPG_City Horsepower Weight;

	/* I found out we could make it more explicit by doing this instead:
	* var MPG_City
	* with Horsepower Weight
	*/
run;

/* Now start using the cars dataset */

/* 9. run a regression to predict or model mpg_city as explained by both horsepower and weight together */
title "Regression With Horsepower & Weight";
proc reg data=cars;
	model MPG_City = Horsepower Weight;
run;
quit;

/* 10. determine whether the "cylinders" variable significantly imporves the regression model */
title "Regression With Prior + Cylinders";
proc reg data=cars;
	model MPG_City = Horsepower Weight Cylinders;
run;
quit;
title;

/* 11. create another copy of the "cars" dataset called "cars_dummy" */
data cars_dummy; set cars;
run;

/* 12. use an array of unspecified length along with a do loop to modify "cars_dummy" so that the data values in all character variables are converted to uppercase */
data cars_dummy; set cars_dummy;
	array cvars(*) _character_; /* only specific to char columns */
	do i = 1 to dim(cvars);
		cvars(i) = upcase(cvars(i));
	end;

	drop i;  /* don't keep i in the dataset, prevents new column */
run;
