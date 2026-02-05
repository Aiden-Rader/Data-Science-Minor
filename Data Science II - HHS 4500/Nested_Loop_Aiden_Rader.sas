/* Using nested SAS loops, create data that simulate the relationship between sunlight and temperature (during both winter and summer).
 * You will need to create at least 3 variables (sunlight, temperature, summer) as instructed during class.
 *
 * Note: The relationship during winter is non-linear.
*/

data is_summer;
	length sunlight summer temperature 8;  /* define the columns and the length */

	do summer = 1 to 0 by -1;  /* outer loop for summer (1) and winter (0) */
		do sunlight = 0 to 100 by 5;  /* inner loop for sunlight from 0 to 100 in increments of 5 */
			if (summer = 1) then do;
				/* summer relationship - linear straight line */
				temperature = 50 + (0.4 * sunlight);  /* 50 is the baseline then add .4 for every unit of sunlight */
			end;
			else do;
				/* winter relationship - non-linear curvey line */
				temperature = -0.005*(sunlight**2) + 0.8*sunlight;  /* quadratic formula to make it non-linear */

				temperature = max(0, temperature);  /* ensure temperature doesn't go below 0 (idealistically) */
			end;

			temperature = round(temperature, 1);  /* round the temps to whole numbers */
			output;
		end;
	end;
run;

/* print the results */
proc print data=is_summer;
run;
