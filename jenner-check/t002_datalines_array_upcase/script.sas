/* From "Data Science II - HHS 4500/SAS/In-Class & Homework/SAS_Basics_Aiden_Rader.sas":
 * 6. Create a new dataset (named "new_data") that we will generate with no set statement.
 *    "new_data" will have 5 observations (5 lines) and a single variable "var1" that increases
 *    from 0 to 20 by 5 (e.g. 0,5,10,15,20).
 * 7. Add a character variable (called "name") to new_data and create a name for each observation
 *    (e.g. Tom, Mary, Susan...). Now add SAS code to change the values of "name" to upper case.
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

proc print data=new_data;
run;

/* 9. Create a new dataset (named "new_data") that contains variable called "zz". Create a Write a do loop
 * that generates 21 observations to increment "zz" by 5 (from 0 to 100).
*/
data new_data2;
	do i = 0 to 20 by 1;  /* goes from 0 to 20 and increments by 1 */
		zz = i *5;
		output;
	end;

	drop i;
run;

proc print data=new_data2;
run;
