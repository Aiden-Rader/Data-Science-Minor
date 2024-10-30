/* Creating/importing data files from cars2 csv and cars_half2 xlsx */
proc import out=work.cars2
	datafile="C:\Users\aiden\Downloads\cars.csv"
	dbms=csv
	replace;
	getnames=yes;
run;

proc import out=work.cars_half2
	datafile="C:\Users\aiden\Downloads\cars_half2.xlsx"
	dbms=xlsx
	replace;
	getnames=yes;
run;

/* Create a subset of cars2 that includes: make, model, type, and ID (should be incremenets of 10) */
data cars_half1;
	set cars2;
	ID=_N_ * 10; /* Going to use _N_ which is SUPPOSED to count how many instances there are increment it by 10s */
	keep ID make model type;
run;

/* Enforce sameness to the dataset(s) i.e. name data similarly */
data cars_half2_renamed;
	set cars_half2;
	ID=id2;
	drop id2;
run;

/* Sort the two datasets before merging together */
proc sort data=cars_half1;
	by ID;
run;

proc sort data=cars_half2_renamed;
	by ID;
run;

/* Merge the two datasets together using the equavalent to a JOIN function but in SAS */
data combo_cars;
	merge cars_half1 (in=a) cars_half2_renamed (in=b);
	by ID;
	if a and b;
run;

/* Visually inspect data by printing it, can limit the amount of observations if you really want to */
proc print data=combo_cars;
	title 'SAS Car Details';
run;

/* Set the combo_cars data to itself, and add corresponding types of cars to the type_levels3 variable */
data combo_cars;
	set combo_cars;
	if Type='SUV' then type_levels3='SUV';
	else if Type='Sedan' then type_levels3='Sedan';
	else if Type='Truck' then type_levels3='Truck';
run;

/* Run the ANOVA test using our combo data */
proc anova data=combo_cars;
	class type_levels3;
	model mpg_city=type_levels3 ;
	means type_levels3 / bon;
run;
