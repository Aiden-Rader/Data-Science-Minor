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

/* 5. Create a do loop to count the number of total number of cars. */
data cars; set cars;
	do_loop_count = 0;
	do i = 1 to _N_;  /* <-- from data science I!*/
		do_loop_count + 1;
	end;

	drop i;
run;

/* 6. Create a new dataset (named "new_data") that we will generate with no set statement.
 * "new_data" will have 5 observations (5 lines) and a single variable "var1" that increases
 * from 0 to 20 by 5 (e.g. 0,5,10,15,20). Do NOT use a loop to create the dataset
*/

/* + */

/* 7. Add a character variable (called "name") to new_data and create a name for each observation
 * (e.g. Tom, Mary, Susan...). Now add SAS code to change the values of "name" to upper case.
*/

/* creating the dataset and adding var1 and name using the datalines to hardcode the values in */
data new_data;
	input var1 name $;  /* I figured out the $ is for if the variable is of charcter type, you can also define the length if needed */
	datalines;
	0 Tom
	5 Mary
	10 Susan
	15 Bob
	20 John
	;
run;

/* now uppercase the charcter values (the names) */
data new_data; set new_data;
	array name_vars{*} name;
	do i = 1 to dim(name_vars);
		name_vars(i) = upcase(name_vars(i));
	end;

	drop i;
run;

/* 8. Write SAS code to uppercase all variables (meaning charcters) in the "cars" dataset your work libary. */
data cars; set cars;
	array cvars{*} _character_;
	do i = 1 to dim(cvars);
		cvars(i) = upcase(cvars(i));
	end;

	drop i;
run;

/* 9. Create a new dataset (named "new_data") that contains variable called "zz". Create a Write a do loop
 * that generates 21 observations to increment "zz" by 5 (from 0 to 100).
*/
data new_data;
	do i = 0 to 20 by 1;  /* goes from 0 to 20 and increments by 1 */
		zz = i *5;
		output;
	end;

	drop i;
run;