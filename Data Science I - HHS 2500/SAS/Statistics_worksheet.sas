proc print data=stat1.drug(obs=10); run;
proc contents data=stat1.ameshousing3; run;
proc print


*********************************************************************;
* Defining Macros variables  (You can learn more on youtube)        *;
*********************************************************************;
* Exploration of all variables that are available for analysis.     *;
* %let statements define macro variables containing lists of        *;
* dataset variables                                                 *;
*                                                                   *;
* In the code below, rather than list the names of all the          *;
* categorical variables, the word "&categorical" does that. So that *;
* you don't have to continually type all those variable names.      *;
*                                                                   *;
* Also, rather than list the names of all the numeric variables,    *;
* the word "&interval" does that. So that you don't have to         *;
* continually type all those variable names.                        *;
*********************************************************************;

%let categorical = House_Style Overall_Qual Overall_Cond Year_Built 
         Fireplaces Mo_Sold Yr_Sold Garage_Type_2 Foundation_2 
         Heating_QC Masonry_Veneer Lot_Shape_2 Central_Air;
%let interval=SalePrice Log_Price Gr_Liv_Area Basement_Area 
         Garage_Area Deck_Porch_Area Lot_Area Age_Sold Bedroom_AbvGr 
         Full_Bathroom Half_Bathroom Total_Bathroom ;


********************************************************************; 
* PROC FREQ is used with categorical variables to view the data    *;
********************************************************************;
ods graphics;

proc freq data=STAT1.ameshousing3;
    tables &categorical / plots=freqplot ;
    format House_Style $House_Style.
           Overall_Qual Overall.
           Overall_Cond Overall.
           Heating_QC $Heating_QC.
           Central_Air $NoYes.
           Masonry_Veneer $NoYes.
           ;
    title "Categorical Variable Frequency Analysis";
run; 

********************************************************************;
* PROC UNIVARIATE provides summary statistics and plots for        *;
* continuous variables.  The ODS statement specifies that only     *;
* the histogram be displayed.  The INSET statement requests        *;
* summary statistics without having to print out tables.           *;
* This helps us see the distribution of our data.                  *;
********************************************************************;
ods select histogram; *displays only the histogram;
proc univariate data=STAT1.ameshousing3 noprint;
    var &interval;
    histogram &interval / normal kernel;
    inset n mean std / position=NE; *ensures that the legend is in the north-east (top right) position;
    title "Interval Variable Distribution Analysis";
run;

title;

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
* PAIRED PairLists: specifies the PairLists to identify the        *;
* variables to be compared in paired comparisons. You can use one  *;
* or more PairLists.                                               *;
*                                                                  *;
* VAR: specifies numeric response variables for the analysis. If   *; 
* the VAR statement is not specified, PROC TTEST analyzes all      *;
* numeric variables in the input data set that are not listed in   *;
* a CLASS (or BY) statement.                                       *;
********************************************************************;
* Is the  average price of a house=$135,000?                       *;
*                                                                  *;
* p-value is the probablility of observing the value you observe   *;
* or anything extreme in your sample assuming that the claim of    *;
* average price of a house=$135,000 is true.                       *;
********************************************************************;
ods graphics;
proc ttest data=STAT1.ameshousing3 plots(shownull)=interval H0=135000 alpha=0.05;
    var SalePrice;
    title "One-Sample t-test testing whether mean SalePrice=$135,000";
run;
title;


********************************************************************;
* Two Sample T-Test (Compares whether two population means are equal) *;
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
* Does Masonry_Veneer affect the price of a house?                 *;
*                                                                  *;
* p-value is the probablility of observing the value you observe   *;
* or anything extreme in your sample assuming that the claim that  *;
* Masonry_Veneer does not affect the house price                   *;
********************************************************************;
ods graphics;
proc ttest data=STAT1.ameshousing3 plots(shownull)=interval;
    class Masonry_Veneer;
    var SalePrice;
    format Masonry_Veneer $NoYes.;
    title "Two-Sample t-test Comparing Masonry Veneer, No vs. Yes";
run;
title;

/*Defining Macros*/
%let interval=BodyTemp HeartRate;

/*Plot Distribution*/
ods graphics;
ods select histogram;
proc univariate data=STAT1.NormTemp noprint;
    var &interval;
    histogram &interval / normal kernel;
    inset n mean std / position=ne;
    title "Interval Variable Distribution Analysis";
run;
title;

/*Testing Whether the Mean Body Temperature = 98.6*/
proc ttest data=STAT1.NormTemp h0=98.6
           plots(only shownull)=interval;
   var BodyTemp;
   title 'Testing Whether the Mean Body Temperature = 98.6';
run;
title;

/*Compare Treatment to Control using Change*/
ods graphics;
proc ttest data=STAT1.German plots(shownull)=interval;
   class Group;
   var Change;
   title "German Grammar Training, Comparing Treatment to Control";
run;
title;


******************************************************************
* Explore associations using box and scatter plots              *;
******************************************************************
* Scatter plots are useful to accomplish the following:
* -explore the relationships between two variables
* -identify outliesr or unusual values
* -identify possible trends
* -identify a basic range of Y and X values
* -communicate data analysis results
******************************************************************;
/*PROC SGSCATTER is used to explore relationships among continuous variables*/
/*Using scatter plots*/
proc sgscatter data=STAT1.ameshousing3;
    plot SalePrice*Gr_Liv_Area / reg; * reg : include a regression line;
    title "Associations of Above Grade Living Area with Sale Price";
run;

/*Define a macros variable*/
%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

options nolabel; *tells sas to use variable names, not lable names;
proc sgscatter data=STAT1.ameshousing3;
    plot SalePrice*(&interval) / reg;
    title "Associations of Interval Variables with Sale Price";
run;

/*Box plot and connect their means*/
proc sgplot data=STAT1.ameshousing3;
    vbox SalePrice / category=Central_Air 
                     connect=mean;
    title "Sale Price Differences across Central Air";
run;


********************************************************************;
* ANOVA
********************************************************************;
* How does change in a Categorical variable affect changes in a    *;
* Continuous variable? In other words, are the means of the 
* Categorical variables the same?
*
* Assumptions for ANOVA
* - Observations are independent.
* - Errors are normally distributed.
* - All groups have equal error variances.
*
* The value of R2 is between 0 and 1. The value is:
* 	- close to 0 if the independent variables do not explain much
* 	  variability in the data
* 	- close to 1 if the independent variables explain a relatively
* 	  large proportion of variability in the data.
*
* Proc Anova data= dataset;
* 	Class Categorical_variable;
* 	Model Continuous_variable = Categorical_variable;
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
* LSMEANS produces Least Squared Means, which are means adjusted
*       for the outcome variable, broken out by the variable 
*       specified and adjusting for any other explanatory 
*       variables included in the MODEL statement.
* OUTPUT specifies an output data set that contains all 
*       variables from the input data set and variables that 
*       represent statistics from the analysis
* 
* HOVTEST= performs a test of homogeneity (equality) of variances. 
* The null hypothesis for this test is that the variances are equal.
* Levene�s test is the default.
* DIAGNOSTICS: produces a panel display of diagnostic plots for 
* linear models.
********************************************************************;


********************************************************************;
* Test whether housing price varies with heating quality of homes  *;
********************************************************************;
ods graphics;
proc glm data=STAT1.ameshousing3 plots=diagnostics; * creates panel display of diagnostic plots;
    class Heating_QC; *specifies categorical_variable;
    model SalePrice=Heating_QC; *specifies dependent and independent variables;
	means Heating_QC / hovtest=levene plots=none; *computes the means of saleprice for each level of heating quality and "hovtest=levene" to test the assumption of equal variances;
    format Heating_QC $Heating_QC.; * display desciptive labels;
    title "One-Way ANOVA with Heating Quality as Predictor";
run;
quit;
title;


********************************************************************;
* Post-hoc Test to determine where the differences exist           *;
********************************************************************;
ods graphics;
ods select lsmeans diff diffplot controlplot;
proc glm data=STAT1.ameshousing3 plots(only)=(diffplot(center) controlplot);
    class Heating_QC;
    model SalePrice=Heating_QC;
    lsmeans Heating_QC / pdiff=all adjust=tukey plots=none; *tukey isused by default if you don't specify "adjust";
    *lsmeans Heating_QC / pdiff=control('Average/Typical') adjust=dunnett; *I only use two here to show that you have options;
    format Heating_QC $Heating_QC.;
    title "Post-Hoc Analysis of ANOVA - Heating Quality as Predictor";
run;
quit;
title;


********************************************************************;
* Correlation
********************************************************************;
* PROC CORR DATA=SAS-data-set <options>;
* 	VAR variables;
* 	WITH variables;
* 	ID variables;
* RUN;
*
* Values of the Pearson product-moment correlation are;
* between 0 and 1
* - closer to either extreme if there is a high degree of linear
*   association between the two variables
* - close to 0 if there is no linear association between the two
*   variables
* - greater than 0 if there is a positive (upward-sloping) linear
*   association
* - less than 0 if there is a negative (downward-sloping) linear
*   association;
********************************************************************;
* RANK: orders the correlations from highest to lowest in absolute value.
* 
* PLOTS: creates scatter plots and scatter plot matrices using ODS GRAPHICS.
* Selected PROC CORR statement:
* 
* ID: when used in HTML output with IMAGEMAP, adds the listed variables
* to the information available with tooltips.
* 
* Suboptions for the PLOTS option:
* SCATTER: generates scatter plots for pairs of variables.
* Suboptions for the SCATTER suboption
* NVAR=<k>: specifies the maximum number of variables in the VAR list to be 
*   displayed in the matrix plot . If NVAR=ALL is specified, then all 
*   variables in the VAR list (up to a limit of 10) are 
* ELLIPSE=NONE suppresses the drawing of confidence ellipses on scatter plots.
*   The tabular output from PROC CORR is shown below. By default, the 
*   analysis generates a table of univariate statistics for the analysis 
*  variables and then a table of correlations and p values.
********************************************************************;
%let interval=Gr_Liv_Area Basement_Area Garage_Area Deck_Porch_Area 
         Lot_Area Age_Sold Bedroom_AbvGr Total_Bathroom;

ods graphics / reset=all imagemap; *imagemap allows tooltips to be used in html output;
proc corr data=STAT1.AmesHousing3 rank 
          plots(only)=scatter(nvar=all ellipse=none); *display plots of all the variables specified and suppresses the drawing of ellipses;
   var &interval;
   with SalePrice; *correlation of variables with saleprice
   id PID;
   title "Correlations and Scatter Plots with SalePrice";
run;
title;

/*Checking for Collinearity or Autocorrelation between predictors*/
ods graphics off;
proc corr data=STAT1.AmesHousing3 nosimple best=3;
   var &interval;
   title "Correlations and Scatter Plot Matrix of Predictors";
run;
title;


********************************************************************;
* Simple Linear Regression                                         *;
********************************************************************;
* PROC REGDATA=SAS-data-set <options>;
* MODEL dependent(s)=regressor(s) </ options>;
* RUN;
* QUIT;
********************************************************************;
ods graphics;
proc reg data=STAT1.ameshousing3;
    model SalePrice=Lot_Area;
    title "Simple Regression with Lot Area as Regressor";
run;
quit;
title;
