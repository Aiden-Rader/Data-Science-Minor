/* From "Data Science II - HHS 4500/SAS/In-Class & Homework/SAS_Basics_Aiden_Rader.sas":
 * 1. Create a copy of the "cars" dataset in the SAS work directory.
 * 2. Create a variable called "var1" that is equal to 7 for all cars.
 * 3. Create a binary variable called "small_engine" based on the number of engine cylinders
 *    (If the number of engine cylinders is less than 5, the value "small_engine"=1)
 * 4. Create a variable ("count") that counts the total number of cars.
 */

/* 1. Create a copy of the "cars" dataset in the SAS work directory. */
data cars; set sashelp.cars;
run;

/* 2. Create a variable called "var1" that is equal to 7 for all cars. */
data cars; set cars;
	var1 = 7;
run;

/* 3. Create a binary variable called "small_engine" based on the number of engine cylinders
 * (If the number of engine cylinders is less than 5, the value "small_engine"=1)
*/
data cars; set cars;
	small_engine = 0;
	if (Cylinders < 5) then small_engine = 1;
run;

/* 4. Create a variable ("count") that counts the total number of cars. */
data cars; set cars;
	count + 1;
run;

proc print data=cars(obs=10);
	var Make Model Cylinders var1 small_engine count;
run;

proc freq data=cars;
	tables small_engine;
run;
