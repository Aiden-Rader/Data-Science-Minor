*********************************************************************;
* Using the Bodyfat1.csv file and BodyFat2.xlsx file                *;
*********************************************************************;
* 1. Drop PctBodyFat2, density, Adiposity, FatFreeWt, and Hip.      *;
* 2. Merge the two files.                                           *;
* 3. Create a categorical variable for age 'Young': age<=40         *;
*    'Middle_age': age>40 and <=50, 'Aging': age>50 and <=60        *;
*    'Retired': age>65                                              *;
* 4. Check whether the average weight of 'Young' people is 178.5    *;
*    pounds. Use the appropriate test.                              *;
* 5. Does the average weight of people between the 4 age groups     *;
*    vary? Include a boxplot with lines connecting the means.       *;
* 6. Is there a difference between the age of people in the 'Young' *;
*    and 'Middle_age' category?                                     *;
* 7. Create a macros variable for:   'Age Weight Height Neck Chest  *;
*    Abdomen Hip Thigh Knee Ankle Biceps Forearm Wrist' variables.  *;
* 8. Use a scatter plot to explore association between the variables*;
*    with PctBodyFat1.                                              *;
* 9. Perform a correlation analysis between the variables and       *;
*    PctBodyFat1. Select only the 10 highest correlated variables.  *;
* 10. Perform a collinearity analysis on the 10 variables selected, *;
*     and drop one of them if two variables have correlation values *;
*     that are > 0.7 or < -0.7.                                     *;
* 11. Perform a simple linear regression between PctBodyFat1 and    *;
*     the variable with the highest correlation from (9.)           *;
* 12. Gradually include other variables until your R-square value   *;
*     is >= 0.8, or else stop when you have exactly 5 variables.    *;
* 13. Is the regression model significant?                          *;
* 14. Interpret the R_square value.                                 *;
*********************************************************************;
********************************************************************;
* - You may only use codes from previous classes or your own past  *;
*   submission.                                                    *;
* - You may also use codes provided in other worksheets.           *;
* - Your work should be clear (well spaced, with explanations)     *;
*                            GOOD LUCK                             *;
********************************************************************;

/* BY: AIDEN RADER */

/* Import the BodyFat data files */
proc import out=work.BodyFat1
	datafile="../BodyFat1.csv"
	dbms=csv
	replace;
	getnames=yes;
run;

proc import out=work.BodyFat2
	datafile="../Bodyfat2.xlsx"
	dbms=xlsx
	replace;
	getnames=yes;
run;

/*! Print first 10 rows (DEBUG STATEMENT)*/
proc print data=BodyFat1(obs=10);
	title "First 10 rows of BodyFat1 data";
run;
proc print data=BodyFat2(obs=10);
	title "First 10 rows of BodyFat2 data";
run;

/*! Check the data (DEBUG STATEMENT)*/
proc contents data=BodyFat1;
	title "Data Structure of BodyFat1";
run;
proc contents data=BodyFat2;
	title "Data Structure of BodyFat2";
run;

/*! Check for missing values or nulls (DEBUG STATEMENT)*/
proc means data=BodyFat1 n nmiss;
	title "Missing Values in BodyFat1";
run;
proc means data=BodyFat2 n nmiss;
	title "Missing Values in BodyFat2";
run;
title;

/*! Sort the data by Case and check for duplicates (DEBUG STATEMENT) */
proc sort data=BodyFat1 nodupkey;
	by Case;
run;
proc sort data=BodyFat2 nodupkey;
	by Case;
run;

/* START OF INSTRUCTIONS */

/* Create a categorical variable for age */
data body_fat1; set BodyFat1;
	length age_group $ 10;
	if (age<=40) then
		age_group='Young';
	else if (age>40 and age<=50) then
		age_group='Middle_age';
	else if (age>50 and age<=60) then
		age_group='Aging';
	else
		age_group='Retired';
run;

/* Dropping density, Adioposity (had to fix spelling), FatFreeWt, and Hip from BodyFat2 */
data body_fat2; set BodyFat2;
	drop density Adioposity FatFreeWt Hip;
run;

/* Merging body_fat1 and body_fat2 */
data combined_body_fat;
	merge body_fat1 (in=a) body_fat2 (in=b);
	by Case;
	if a and b; /* Keep only matching records */
run;

/* Check whether the average weight of 'Young' people is 178.5 pounds */
proc means data=combined_body_fat mean;
	title 'Average Weight of Young People Using Mean';
	var weight;
	where age_group = 'Young';
run;
title;

/* OR: We can also perform a hypothesis test using the ttest (optional)*/

/* ANSWER: No, while the average weight of young people is close to 178.5,
			it is just a bit lower reaching 176.374
*/

/* Does the average weight of people between the 4 age groups vary? */
proc means data=combined_body_fat mean;
	title 'Average Weight of People by Age Group';
	class age_group;
	var weight;
	output out=mean_weights mean=mean_weight;
run;
title;

/* ANSWER: Yes, the average weight of people between the 4 age groups varies with Middle_age people at the heaviest (184.31)!
			However the differences between these results are not very significant.
			Middle_age > Retired > Young > Aging
*/

/* Include a boxplot with lines connecting the means */
ods graphics on;
proc sgplot data=combined_body_fat;
	vbox weight / category=age_group connect=mean;
	title 'Boxplot of Weight of People by Age Group';
	xaxis label='Age Group(s)';
run;
title;

/* Is there a difference between the age of people in the 'Young' and 'Middle_age' category? */
proc ttest data=combined_body_fat;
	class age_group;
	var age;
	where age_group in ('Young', 'Middle_age');
	title 'Comparison of Age Between Young and Middle_age Groups';
run;
title;

/* ANSWER: The overall difference is around 12.8 from Middle Aged -> Young, this is as expected given the general age distribution
			I do want to mention that the Std Err for Young is higher at 0.71 compared to Middle_age at 0.61, I thought that was interesting
*/

/* Create a macros variable (using %let) for: Age Weight Height Neck Chest Abdomen Thigh Knee Ankle Biceps Forearm Wrist */
%let vars = Age Weight Height Neck Chest Abdomen Thigh Knee Ankle Biceps Forearm Wrist;

/* Use a scatter plot to explore association between the variables with PctBodyFat1 */
proc sgscatter data=combined_body_fat;
	plot PctBodyFat1*(&vars) / reg;
	title "Association of Variables with PctBodyFat1";
run;
title;

/** Question 9 though 11 are below **/

/* Perform correlation analysis */
proc corr data=combined_body_fat nosimple outp=corr_outp;
	var &vars;
	with PctBodyFat1;
	title "Correlation Analysis with PctBodyFat1 With All Variables";
run;
title;

/* Visualize the top 10 correlated variables (optional but helpful, won't be using this dataset though) */
proc corr data=combined_body_fat nosimple best=10 outp=corr_outp_best_10;
	var &vars;
	with PctBodyFat1;
	title "Correlation Analysis Showing Best 10 Correlated Variables";
run;
title;

/* Compute absolute correlation values and filter for top 10 */
data just_corr; set corr_outp;
	where _TYPE_ = "CORR";
run;

/* Transpose the top 10 correlated variables (optional step, makes it easier to read. Also drop the label column since its useless) */
proc transpose data=just_corr out=transposed_top_10_corr(drop=_LABEL_);
run;

/* Sort the top 10 correlated variables */
proc sort data=transposed_top_10_corr;
	by descending PctBodyFat1;
run;

/* Filter down to only the top 10 variables based on correlation value */
data transposed_top_10_corr; set transposed_top_10_corr;
	if _N_ <= 10;
run;

/* NOTE: So I did a transpose to just get the top 10 variables,
this is probably not the best approach but it does in fact work!
I do know there has to be a more optimal way to do this but I wasnt
sure what it was or how to do it.
*/

/* Perform correlation analysis on the top 10 variables */
proc corr data=combined_body_fat nosimple outp=corr_analysis;
	var Abdomen Chest Weight Thigh Knee Biceps Neck Forearm Wrist Age;
	title "Correlation Analysis for Top 10 Variables Found Previously";
run;
title;

/* Filter for correlation rows by _TYPE_ CORR*/
data corr_filtered; set corr_analysis;
	where _TYPE_ = "CORR";
run;

/* Sorts in alphabetical order for transposing step below */
proc sort data=corr_filtered out=sorted_corr_filtered;
	by _NAME_;
run;

/* Transpose correlation analysis to a table format that is easier to read, and we have to rename column 1 to Correlation */
proc transpose data=sorted_corr_filtered out=table_corr(rename=(col1=Correlation));
	by _NAME_;
run;

/* Filter correlations where |r| > 0.7 or |r| < -0.7 and exclude self-correlations (i.e. where something like Abdomen correlates with Abdomen) */
data high_corr_pairs; set table_corr;
	where Correlation > 0.7 or Correlation < -0.7 and _NAME_ ne _LABEL_;
run;

/* Now we have to drop the the aquired variables */
data reduced_data; set combined_body_fat;
	drop Chest Thigh Knee Biceps Neck;
run;

/* NOTE: So here is what my written logic was for deciding which variables to drop:

Priority of the variable was very important when deciding which to drop. Variables that were kept were based on their relevance to PctBodyFat1 and overall interpretability in the analysis.
Also, when there was a tie among highly correlated variables, only one was kept to represent the shared information,this helped minimize the redundancy of certain variables.
And lastly, variables with similar meanings or measurements were compared, and the most interpretable variable was chosen to be kept.

Variables Dropped with Reasons:

- Chest: Highly correlated with Abdomen
- Thigh: Highly correlated with Weight and Knee
- Knee: Redundant with Thigh and Weight.
- Biceps: Highly correlated with Weight
- Neck: Highly correlated with Wrist
*/

/* Perform a simple linear regression between PctBodyFat1 and the variable with the highest correlation from question 9 */
proc reg data=combined_body_fat;
	model PctBodyFat1 = Abdomen; /* Abdomen is the variable with the highest correlation from question 9 so we are starting with it!*/
	title "Simple Linear Regression with Abdomen";
run;
quit;
title;

/* Gradually include other variables until your R-square value is >= 0.8, or else stop when you have exactly 5 variables. */
proc reg data=combined_body_fat;
	model PctBodyFat1 = Abdomen Weight;
	title "Multiple Regression with Abdomen and Weight";
run;

proc reg data=combined_body_fat;
	model PctBodyFat1 = Abdomen Weight Forearm;
	title "Multiple Regression with Abdomen, Weight, and Forearm";
run;

proc reg data=combined_body_fat;
	model PctBodyFat1 = Abdomen Weight Forearm Wrist;
	title "Multiple Regression with Abdomen, Weight, Forearm, and Wrist";
run;

proc reg data=combined_body_fat;
	model PctBodyFat1 = Abdomen Weight Forearm Wrist Neck;
	title "Best 5-Variable Model with Abdomen, Weight, Forearm, Wrist, and Neck";
run;
quit;
title;

/* ANSWER: The best 5-variable model is Abdomen, Weight, Forearm, Wrist, and Neck
			with a R-square value of 0.738 which is less than 0.8, I have a feeling
			that this is the best model given 5 variables but I am not sure.
			I did compare a lot of models and the best one was the 5-variable model.
*/

/*? Is the regression model significant? */

/* ANSWER: Yes, the regression model is significant, which seems good!

	Further Explanation:
	- The F-value of 138.59 indicates that the model explains a significant
	  amount of the variance in the dependent variable (i.e. PctBodyFat1).

	- The p-value of < 0.0001 indicates that the model is statistically
	  significant, which means the variables chosen contribute meaningfully
	  to the dependent variable (i.e. PctBodyFat1).
*/

/*? Interpret the R_square value. */

/* ANSWER: The R-square value is 0.738 which indicates that the model explains 73.8% of the variance in PctBodyFat1.
		   This is a good fit as it is close to 1 and the model is significant. The chosen variables for the model
		   provide a meaningful fit to the data and are useful for predicting the body fat percentage (i.e. PctBodyFat1).
*/

/* ========================================================================================================================== */

/*! HINTS AND NOTES BELOW !*/

********************************************************************;
* One Sample T-Test (Compares sample_mean to a hypothesized_mean)  *;
********************************************************************;
* PROC TTESTDATA=SAS-data-set;                                     *;
* CLASS variable;                                                  *;
* PAIRED variables;                                                *;
* VAR variables;                                                   *;
* RUN;                                                             *;
********************************************************************;
* CLASS: specifies the two level variable for the analysis. Only   *;
* one variable is allowed in the CLASS statement. If no CLASS      *;
* statement is included, a one sample t test is performed.         *;
*                                                                  *;
* VAR: specifies numeric response variables for the analysis. If   *;
* the VAR statement is not specified, PROC TTEST analyzes all      *;
* numeric variables in the input data set that are not listed in   *;
* a CLASS (or BY) statement.                                       *;
********************************************************************;
ods graphics;
proc ttest data=... H0=... alpha=0.05;
    var ...;
    title "One-Sample t-test testing whether ...";
run;
title;


********************************************************************;
* Two Sample T-Test(Compares whether two population means are equal) *;
********************************************************************;
* PROC TTESTDATA=SAS-data-set;                                     *;
* CLASS variable;                                                  *;
* PAIRED variables;                                                *;
* VAR variables;                                                   *;
* RUN;                                                             *;
********************************************************************;
* - Statistical Assumptions:                                       *;
*  - independent observations (no repeated measurements)           *;
*  - normally distributed population populations (examine plots)   *;
*  - equal population variances (Check this)                       *;
*                                                                  *;
* CLASS: specifies the two level variable for the analysis. Only   *;
* one variable is allowed in the CLASS statement. The CLASS is     *;
* used to perform the two sample t test.                           *;
*                                                                  *;
* PAIRED PairLists: specifies the PairLists to identify the        *;
* variables to be compared in paired comparisons. You can use one  *;
* or more PairLists.                                               *;
*                                                                  *;
* VAR: specifies numeric response variables for the analysis. If   *; 
* the VAR statement is not specified, PROC TTEST analyzes all      *;
* numeric variables in the input data set that are not listed in   *;
* a CLASS (or BY) statement.                                       *;
********************************************************************;
ods graphics;
proc ttest data=...;
    class ...;
    var ...;
    title "....";
run;
******************************************************************************************************************************;
* p-value=0.1039 means that average house prices are similar for houses with Masonry_Veneer and houses without Masonry_Veneer*;
******************************************************************************************************************************;



*****************************************************************;
* Activity: One and Two Sample T-Tests                          *;
*****************************************************************;
* 1. Get the data distribution for bodyTemp & heartRate         *;
* 2. Testing Whether the Mean Body Temperature = 98.6 and       *;
*    explain the p-values (use NormTemp dataset).               *;
* 3. Is Treatment = Control using Change in German dataset?     *;
* 4. Interpret the p-values.                                    *;
*****************************************************************;


/*Testing Whether the Mean Body Temperature = 98.6*/
proc ttest data=STAT1.NormTemp h0=98.6
           plots(only shownull)=interval;
   var BodyTemp;
   title 'Testing Whether the Mean Body Temperature = 98.6';
run;
**************************************************;
* explain the meaning of the p-value             *;
**************************************************;
title;


******************************************************************
* Explore associations using box and scatter plots              *;
******************************************************************
/*Box plot and connect their means*/
proc sgplot data=
    vbox ... / category=... connect=mean;
    title ".....";
run;


********************************************************************;
* ANOVA
********************************************************************;
* How does change in a Categorical variable affect changes in a    *;
* Continuous variable? In other words, are the means of the 
* Categorical variables the same?
*
* Proc Anova data= dataset;
* 	Class Categorical_variable;
* 	Model Continuous_variable = Categorical_variable;
*   Means Categorical_variable / bon; *this performs a Bonferoni posthoc test to identify where the differnce exist, if any;
* Run;
*
* PROC GLMDATA=SAS-data-set PLOTS=options;
* 	CLASS variables;
* 	MODEL dependents=independents </options>;
* 	MEANS effects </ options>;
* 	LSMEANS effects </ options>;
* 	OUTPUT OUT=SAS-data-set
* 	keyword=variable�;
* 	RUN;
* QUIT;
*
* CLASS specifies classification variables for the analysis.
* MODEL specifies dependent and independent variables for the 
* 	    analysis.
* MEANS computes unadjusted means of the dependent variable for
*       each value of the specified effect.
********************************************************************;

********************************************************************;
* Test whether housing price varies with heating quality of homes  *;
********************************************************************;

**********************************************************************;
* -p-value<0.0001 in the anova test means that house prices are      *;
*  different for different home heating_quality                      *;
* -(In 2ns table)R-square = 0.1579 means that heating_quality only   *;
*  accounts for 15.75% of the variation in house prices              *;
*                                                                    *;
* -p-value=0.6305 in the levene test means that the variation in     *;
*  house prices are similar withing each category of heating_quality *;
*  for homes.                                                        *;
**********************************************************************;



********************************************************************;
* Correlation (measures how well one variable can predict another) *;
********************************************************************;

********************************************************************;
* Checking for Collinearity or Autocorrelation between predictors  *;
* If two variables are collinear, there is no need in using both   *;
* of them to build a model for prediction.                         *;
********************************************************************;




*********************************************************************;
* SimpleLinearRegression-how change in one variable affects another *;
*********************************************************************;
* PROC REGDATA=SAS-data-set <options>;                              *;
* MODEL dependent(s)=regressor(s) </ options>;                      *;
* RUN;                                                              *;
* QUIT;                                                             *;
*                                                                   *;
* We will build a model to use variable_X to predict variable_Y.    *;
* Model: variable_Y = b0 + b1*variable_X                            *;
*********************************************************************;

******************************************************************;
* p-value < 0.001 in the Analysis of Variance table means that   *;
* the model is significant.                                      *;
* R-Square=0.0642 means lot_area account in this model accounts  *;
* for 6% of the house sale price.                                *;
*                                                                *;
* REGRESSION EQUATION:                                           *;
* SalePrice = 113740 + 2.86770*Lot_Area                          *;
* INTERPRETATION:  		                                         *;
* SalePrice increases $2.9 for a 1-square_ft Lot_Area increase.  *;
******************************************************************;




******************************************************************;
* Activity for ANOVA                                             *;
******************************************************************;



*********************************************************************;
* Multiple Linear Regression                                        *;
*********************************************************************;
