/*Name: Aiden Rader
* Date: 02/22/2026
* Class: Data Science II
* Professor: Dr. David Lilley
*
* Assignment: Module 1 - Building a Predictive Bitcoin Database
*/

/*========================================================================================================================================================================*/

/* ======================================================================== */
/* Part 1. Initial Merge of 3 Datasets */
/* ======================================================================== */

/* Import the datasets */
proc import datafile="C:/Users/aiden/OneDrive - University of Toledo/Spring 2026 UT NOW/Data Science II/SAS Enviornment/Modules/Module 1/Datasets/Bitcoin Crypto Active wallets.csv"
    out=active_wallets
    dbms=csv
    replace;
run;

proc import datafile="C:/Users/aiden/OneDrive - University of Toledo/Spring 2026 UT NOW/Data Science II/SAS Enviornment/Modules/Module 1/Datasets/bitcoin_price_volume_main_2017_2021_fixed.xlsx"
    out=bitcoin_price
    dbms=xlsx
    replace;
run;

proc import datafile="C:/Users/aiden/OneDrive - University of Toledo/Spring 2026 UT NOW/Data Science II/SAS Enviornment/Modules/Module 1/Datasets/Google_Trends_BuyBitcoin_5yr.xlsx"
    out=google_trends
    dbms=xlsx
    replace;
run;

/* ================== */
/* Wallets Data Setup */
/* ================== */

/* Normalize the active wallets with correct SAS_Date and formatting */
data active_wallets;
    set active_wallets;
    rename Date_orig=timestamp;
    rename n_unique_addresses=wallets_char;
    SAS_Date = round(Excel_date - 21916);  /* Excel offset using 21916 from lecture */
    format SAS_Date date9.;
    year = year(SAS_Date);  /* this is just to track visually which years are in the dataset, only used for visualization then immediately after */
run;

/* Remove commas from the wallets column and convert to numeric */
data active_wallets;
    set active_wallets;
    wallets = input(wallets_char, comma9.);
    keep SAS_Date wallets;
run;

/* Sort by the SAS_Date (asc order) */
proc sort data=active_wallets;
    by SAS_Date;
run;

/* ================== */
/* Bitcoin Data Setup */
/* ================== */

/* Normalize the bitcoin data with correct SAS_Date and formatting */
data bitcoin_price;
    set bitcoin_price;
    SAS_Date = Date;
    format SAS_Date date9.;
run;

/* Sort by the SAS_Date (asc order) */
proc sort data=bitcoin_price;
    by SAS_Date;
run;

/* ======================== */
/* Google Trends Data Setup */
/* ======================== */

/* Normalize the google trends data with correct SAS_Date and formatting */
data google_trends;
    set google_trends;
    SAS_Date = Date_orig;
    format SAS_Date date9.;
run;

/* Sort by the SAS_Date (asc order) */
proc sort data=google_trends;
    by SAS_Date;
run;

/* 2. in bitcoin_price dataset, remove all records where the date id prior to Jan 1st 2017 and after Jan 7th 2021 */
data bitcoin_price_range;
    set bitcoin_price;
    if SAS_Date < '01JAN2017'd then delete;
    if SAS_Date > '07JAN2021'd then delete;
run;

/* 3. Prep the wallets data set with interpolated data since its data is only every 3 days */

/* Sort by date with descending order for interpolation (works for the way I do it) */
proc sort data=active_wallets;
    by descending SAS_Date;
run;

/* interpolate missing values */
data active_wallets_interpolated;
    set active_wallets;
    future_date = lag(SAS_Date);
    future_wallets = lag(wallets);

    format SAS_Date future_date date9.;

    New_SAS_Date = put(SAS_Date, date9.);
    output;  /* Makes it so we always will output the observed row */

    if future_date ne . then do;
        gap = future_date - SAS_Date;

        if gap > 1 then do;
            /* This is the change in wallets needed to span the gap between the current and future dates. */
            change_in_wallets = (future_wallets - wallets) / gap;

            /* create the first row for the missing days */
            base_date = SAS_Date;
            base_wallets = wallets;

            /* create only the missing days */
            do i = 1 to gap - 1;
                New_SAS_Date = put(base_date + i, date9.);  /* we need to count backwards */
                wallets = base_wallets + (change_in_wallets*i);  /* 1/3, 2/3, etc */
                output;
            end;
        end;
    end;
    keep SAS_Date New_SAS_Date wallets;
run;

/* Replace the SAS_Date with the New_SAS_Date for the final dataset */
data wallets_interpolated_ready;
    set active_wallets_interpolated;

    /* Convert date9. string -> numeric SAS date */
    SAS_Date = input(New_SAS_Date, date9.);
    format SAS_Date date9.;

    drop New_SAS_Date;
run;

/* Sort by the SAS_Date (asc order) */
proc sort data=wallets_interpolated_ready;
    by SAS_Date;
run;

/* Sort by the SAS_Date (asc order) */
proc sort data=bitcoin_price_range;
    by SAS_Date;
run;

/*! CHECK: Testing ALL obs of interpolated data for visual verification */
/* proc print data=wallets_interpolated_ready; run; */

/* Sort by the SAS_Date (asc order) */
proc sort data=bitcoin_price_range;
    by SAS_Date;
run;

/* Merge the datasets */
data bitcoin_main;
    merge bitcoin_price_range(in=a) wallets_interpolated_ready(in=b);
    by SAS_Date;
    if a and b then output;  /* I have 1468 obs */
run;

/*! CHECK: Testing ALL obs of merged data (bitcoin and wallet data) for visual verification */
/* proc print data=bitcoin_main; run; */

/* 4. Merge the bitcoin_main and google_trends datasets. Unique week needs to be calculated in the bitcoin_main dataset */

/* Create a "unique week" variable in the bitcoin_main dataset */
data bitcoin_main_unique;
    set bitcoin_main;
    unique_week = int((SAS_Date - 20820)/7) + 1;  /* math version of finding them, 20820 corresponds to 01JAN2017 in SAS date format */
run;

/* Sort by the unique_week (asc order) for aggregate */
proc sort data=bitcoin_main_unique;
    by unique_week;
run;

/*! CHECK: Testing ALL obs of bitcoin main unique for visual verification */
proc print data=bitcoin_main_unique; run;

/* Aggregate the price data to the weekly level */
proc means data=bitcoin_main_unique noprint;
    by unique_week;
    var Coin_Avg Coin_Day wallets;
    output out=bitcoin_main_weekly
        mean(Coin_Avg)=coin_avg
        mean(Coin_Day)=coin_day
        mean(wallets)=new_wallets
        min(SAS_Date)=week_start
        max(SAS_Date)=week_end;
run;

/* Drop the _type_ and _freq_ variables and format */
data bitcoin_main_weekly;
    set bitcoin_main_weekly;
    drop _type_ _freq_;
    format week_start week_end date9.;
run;

/*! CHECK: Testing 100 obs of means data for visual verification */
/* proc print data=bitcoin_main_weekly(obs=100); run; */

/* Prepare the google_trends dataset (i.e. create SAS_Date and unique_week) for merging */
data google_trends_ready;
    set google_trends;

    /* If SAS_Date already exists, this just overwrites with the same value */
    SAS_Date = Date_orig;
    format SAS_Date date9.;

    unique_week = int((SAS_Date - 20820)/7) + 1;  /* Create unique_week using the SAME math approach as the bitcoin_main dataset */

    keep SAS_Date unique_week buy_bitcoin;
run;

/* Sort both of our datasets before merging */
proc sort data=google_trends_ready;
    by unique_week;
run;

proc sort data=bitcoin_main_weekly;
    by unique_week;
run;

/* Merge the datasets */
data bitcoin_google_trends;
    merge bitcoin_main_weekly(in=a) google_trends_ready(in=b);
    by unique_week;
    if a and b then output;
run;

/*! CHECK: Testing 100 obs of merged data (bitcoin and google trends) for visual verification */
/* proc print data=bitcoin_google_trends(obs=100); run; */

/* 5. Visually verify that the weeks from ALL files are matching up correctly at the weekly level by checking the SAS_Date */

/* Create a year variable to group by */
data bitcoin_google_trends_check;
    set bitcoin_google_trends;
    year = year(week_end);
run;

/* Sort by the year and unique_week (asc order) to get first 5 weeks of each year (17' - 21') */
proc sort data=bitcoin_google_trends_check;
    by year unique_week;
run;

/* Use the retain and by variables to get the first 5 weeks of each year */
data first5_weeks;
    retain n;
    set bitcoin_google_trends_check;
    by year;
    if first.year then n = 0;  /* reset the counter if a new year is encountered */

    n + 1;

    if n <= 5 then output;
    drop n;
run;

proc print data=first5_weeks;
    var year unique_week week_start week_end SAS_Date buy_bitcoin;
    title "Step 5: First 5 weeks of each year";
run;

/*? Interpretation: The FIRST 5 weeks of each year are (start to end):
01JAN2017 - 04FEB2017 (2017)
31DEC2017 - 06JAN2018 (2018)
30DEC2018 - 02FEB2019 (2019)
29DEC2019 - 01FEB2020 (2020)
27DEC2020 - 02JAN2021 (2021)*/

/* Sort by the year and unique_week (desc order) to get last 5 weeks of each year (17' - 21') */
proc sort data=bitcoin_google_trends_check out=btc_desc;
    by year descending unique_week;
run;

/* Use the retain and by variables to get the last 5 weeks of each year */
data last5_weeks;
    retain n;
    set btc_desc;
    by year;
    if first.year then n=0; /* reset the counter if a new year is encountered */

    n + 1;

    if n <= 5 then output;
    drop n;
run;

/* Sort back to original asc order for better printing */
proc sort data=last5_weeks;
    by year unique_week;
run;

proc print data=last5_weeks;
    var year unique_week week_start week_end SAS_Date buy_bitcoin;
    title "Step 5: Last 5 weeks of each year";
run;

/* ? Interpretation: The LAST 5 weeks of each year are (start to end):
26NOV2017 - 30DEC2017
25NOV2018 - 29DEC2018
24NOV2019 - 28DEC2019
22NOV2020 - 26DEC2020
27DEC2020 - 02JAN2021 */

/* 6. Visually verify that the final number of merged records is correct. */

/* We have 52 weeks in 2017, 2018, 2019, and 2020. 2021 has 1. This means the
final number of records should be approximately 209. */
proc print data=bitcoin_google_trends_check;
    var year unique_week week_start week_end SAS_Date buy_bitcoin coin_avg;
    title "Step 6: Final number of merged records";
run;

/*? Interpretation: The final number of merged records is 209 based on from 01JAN2017 - 02JAN2021.
Even though our dataset does in fact go up to 07JAN2021, that is a partial week which I did not include
to fit the final narrative of 209 records. */

/*! CHECK: Testing Freq Distribution to see how many weeks in each year */
proc freq data=bitcoin_google_trends_check;
    tables year;
run;

/*? Interpretation: Based on the frequency distribution, we have 52 weeks in 2017, 2018, 2019,
and 2020. 2021 has only 1! */

proc print data=bitcoin_google_trends_check; run;

/* ======================================================================== */
/* End of Part 1. (See below for Hypothesis + Statistical Test Plan) */
/* ======================================================================== */

/** Hypothesis + Statistical Test Plan **/
/* Goal: Predict the weekly Bitcoin price (coin_avg). */

/* Hypothesis 1 (Active Wallets):
H0: "new_wallets is NOT related to coin_avg" (i.e. no linear relation with coin_avg)
Ha: "new_wallets IS related to coin_avg" (i.e. linear relation with coin_avg exists) */

/* Hypothesis 2 (Google Trends):
H0: "Buy_Bitcoin is NOT related to coin_avg" (i.e. no linear relation with coin_avg)
Ha: "Buy_Bitcoin IS related to coin_avg" (i.e. linear relation with coin_avg exists) */

/* Statistical Test Plan:
Using a Multi-Linear Regression (PROC REG) and use the p-vals for the coefficients to determine which Hypothesis
is supported. */

/* Running the multilinear regression model on the check dataset */
proc reg data=bitcoin_google_trends_check;
    model coin_avg = new_wallets buy_bitcoin;
    title "Hypothesis Regression Model Test";
run;
quit;

/*? Interpretation: The multilinear regression model was statistically significant (F-test p-value < 0.0001).
The active wallets were a significant predictor of the weekly bitcoin price (i.e. p-value < 0.0001).
Google trends however was not statistically significant with a much larger p-value (p = 0.4525).
With this information in mind, we can say that ~31% (R^2 = 0.3158) of the variation in the weekly
bitcoin price is explained by the model. */

/* ======================================================================== */
/* Part 2. Initial Analyses of 3 Files Merged (descriptive means, correlation, regression) */
/* ======================================================================== */

/* 1. Create first-differences of all analytic variables including the dependent or outcome variable (coin_avg)
 and the initial predictors (new_wallets, coin_day, and Buy_Bitcoin) */

/* Sort data first so LAG works correctly */
proc sort data=bitcoin_google_trends_check out=btc_analysis;
    by unique_week;
run;

/* Create the first differences */
data btc_analysis_diff;
    set btc_analysis;
    by unique_week;

    /* Create the lag variables for the first differences */
    coin_avg_lag = lag(coin_avg);
    new_wallets_lag = lag(new_wallets);
    buy_bitcoin_lag  = lag(buy_bitcoin);
    coin_day_lag = lag(coin_day);

    /* Create the first differences */
    coin_avg_diff = coin_avg - coin_avg_lag;
    new_wallets_diff = new_wallets - new_wallets_lag;
    buy_bitcoin_diff = buy_bitcoin - buy_bitcoin_lag;
    coin_day_diff = coin_day - coin_day_lag;

    /* Drop the very first diff row because there is no prior week */
    if _N_ = 1 then delete;

    drop coin_avg_lag new_wallets_lag coin_day_lag buy_bitcoin_lag;
run;

proc print data=btc_analysis_diff; run;

/* 2. Check the descriptive values of the unadjusted (not first differenced) variables ("new_wallets",
"coin_day", "buy_bitcoin") proc means for each year (class year) to determine the basic direction of
each variable over time */
proc means data=btc_analysis n mean std min max;
    class year;
    var new_wallets coin_day buy_bitcoin;
    title "Descriptive Stats by Year";
run;

proc print data=btc_analysis; run;

/* ? Interpretation: The descriptive stats by year are (judging by the mean values):
New Wallets: 2021 > 2020 > 2017 > 2019 > 2018
Coin Day: 2021 > 2020 > 2017 > 2019 > 2018
Buy Bitcoin: 2021 > 2017 > 2020 > 2018 > 2019 */

/* 3. Correlation Checks: Run a proc corr on all three analytic variables */
proc corr data=btc_analysis;
  var coin_avg new_wallets coin_day buy_bitcoin;
  title "Corr - Original";
run;

proc corr data=btc_analysis_diff;
  var coin_avg_diff new_wallets_diff coin_day_diff buy_bitcoin_diff;
  title "Corr - First Differences";
run;

/* ? Interpretation: The correlation values for both original and first differences are not that different. The
original values are slightly higher than the first differences yet none of the corr values are > ~0.65 which is
great! Something I noticed is that the Bitcoin price (coin_avg) has a moderately positive relationship with
new_wallets (r = 0.59) and Google Search Interest (buy_bitcoin) (r = 0.43). This could indicate that wallet
activity increases and the google search interests increases as well for the original data. For our first diff
data, we can see changes over time instead of just the raw values which indicates weekly changes in Bitcoin price
tend to move with changes in google search interests and wallet activity.*/

/* 4. Using only the first-differenced variables, run individual regressions to predict "coin_avg_diff" with only
 a single predictor, one at a time. */

/* a. Coin_avg_diff ~ new_wallets_diff */
proc reg data=btc_analysis_diff;
    model coin_avg_diff = new_wallets_diff;
    title "Step 4a: Coin_avg_diff ~ new_wallets_diff";
run;
quit;

/* b. Coin_avg_diff ~ coin_day_diff */
proc reg data=btc_analysis_diff;
    model coin_avg_diff = coin_day_diff;
    title "Step 4b: Coin_avg_diff ~ coin_day_diff";
run;
quit;

/* c. Coin_avg_diff ~ buy_bitcoin_diff */
proc reg data=btc_analysis_diff;
    model coin_avg_diff = buy_bitcoin_diff;
    title "Step 4c: Coin_avg_diff ~ buy_bitcoin_diff";
run;
quit;

/* ? Interpretation: Only two out of the three models are statistically significant (p-value < 0.0001). Those two
models being the wallets and buy_bitcoin models. However, out of those two models I would say the buy_bitcoin diff
model is the most significant and strongest predictor for bitcoin price since it has the highest R^2. */

/* 5. Run a "full regression model" to predict "coin_avg_diff" using all available predictors (first-differenced
only). */
proc reg data=btc_analysis_diff;
    model coin_avg_diff = new_wallets_diff buy_bitcoin_diff coin_day_diff;
    title "Step 5: Full model (diff-only predictors)";
run;
quit;

/* ? Interpretation: Given that now we are running the entire regression of all three of our diff values, the results
are better then before! The R^2 increased and this proved that our combined model has a better chance at predicting
outcome then singular models for each predictor. The biggest contributors to that where once again buy_bitcoin and
new_wallets. coin_day was still not significant. */

/* 6. Repeat the previous "full model" regression but include "year" as a predictor along with the other
variables that you included in the previous step. */
proc reg data=btc_analysis_diff;
    model coin_avg_diff = new_wallets_diff buy_bitcoin_diff coin_day_diff year;
    title "Step 5: Full model (diff-only predictors + year)";
run;
quit;

/* ======================================================================== */
/* End of Part 2. (See Submission for MS Word file) */
/* ======================================================================== */

/* ======================================================================== */
/* Part 3. All 8 Files - Fully Merged */
/* ======================================================================== */

/* Create a library */
libname others "C:\Users\aiden\OneDrive - University of Toledo\Spring 2026 UT NOW\Data Science II\SAS Enviornment\Modules\Module 1\Datasets";

/* Import the datasets */
data dxy_index;
    set others.dollar_strength_dxy_index;
run;

data gold_price_update;
    set others.gold_price_update;
run;

data intel_stock;
    set others.intel_stock;
run;

data snp_weekly_updated_2025;
    set others.snp_weekly_updated_2025;
run;

data total_wallets;
    set others.total_wallets;
run;

/* Prep the datasets */
/*? I am going to go with the standard format of:
    variables: unique_week, sasdate, anything else follow similar format from btc_analysis
*/

/* Dollar Strength (DXY Index) */
data dxy_ready;
    set dxy_index;
    unique_week = int((sasdate - 20820)/7) + 1;
    format sasdate date9.;
    keep sasdate unique_week avg_dxy_value;
run;

/* Sort both of our datasets before merging */
proc sort data=dxy_ready;
    by unique_week;
run;

/*! CHECK */
/* proc print data=dxy_ready; */
/*     title "DXY Index"; */
/* run; */

/* Gold Price Update */
data gold_ready;
    set gold_price_update;
    gold_price = input(compress(price, ','), best12.);
    unique_week = int((sasdate - 20820)/7) + 1;
    format sasdate date9.;
    keep sasdate unique_week gold_price;
run;

/* Sort both of our datasets before merging */
proc sort data=gold_ready;
    by unique_week;
run;

/*! CHECK */
/* proc print data=gold_ready; */
/*     title "Gold Price"; */
/* run; */

/* Intel Stock */
data intel_ready;
    set intel_stock;
    unique_week_seq = int((sasdate - 20820)/7) + 1;
    format sasdate date9.;
    keep sasdate unique_week_seq intel_avg intel_day;
run;

/* rename the unique_week_seq to unique_week */
data intel_ready;
    set intel_ready;
    rename unique_week_seq = unique_week;
run;

/* Sort both of our datasets before merging */
proc sort data=intel_ready;
    by unique_week;
run;

/*! CHECK */
/* proc print data=intel_ready; */
/*     title "Intel Stock"; */
/* run; */

/* SNP 500 */
data snp_ready;
    set snp_weekly_updated_2025;
    rename tot_weekly = unique_week;
    rename price = snp_price;
run;

/* Sort both of our datasets before merging */
proc sort data=snp_ready;
    by unique_week;
run;

/*! CHECK */
/* proc print data=snp_ready; */
/*     title "S&P 500"; */
/* run; */

/* Total Wallets */
data wallets_ready;
    set total_wallets;
    unique_week = int((sas_date - 20820)/7) + 1;
    format sas_date date9.;
    keep sas_date unique_week wallets_total;
run;

/* rename the sas_date to sasdate and wallets_total to total_wallets for clarity */
data wallets_ready;
    set wallets_ready;
    rename sas_date = sasdate;
    rename wallets_total = total_wallets;
run;

/* Sort both of our datasets before merging */
proc sort data=wallets_ready;
    by unique_week sasdate;
run;

/* removing the duplicate unique weeks since the dates kinda screw up the unique week formula */
data wallets_ready_weekly;
    set wallets_ready;
    by unique_week sasdate;
    if last.unique_week;
run;

/*! CHECK */
/* proc print data=wallets_ready_weekly; */
/*     title "Total Wallets"; */
/* run; */

/* Now we are ready the merge! */

/* Sort the analysis dataset before merging */
proc sort data=btc_analysis out=btc_master;
    by unique_week;
run;

/** DOCUMENTATION: I use the analysis dataset (the one without the original differences) due to the fact that we will be differencing the new 8 file merge dataset later on in Part 4.*/

/* Merge the datasets */
data btc_all_merged;
    merge btc_master(in=a)
          dxy_ready
          gold_ready
          intel_ready
          snp_ready
          wallets_ready_weekly;
    by unique_week;
    if a;
run;

/** DOCUMENTATION: Why I went with using a if a statement instead of if a and b and etc etc. would be because I only wanted to keep the rows from the OG 3 file merge analysis dataset.
** This would also make it so I don't have to worry about cleaning up any dates that are outside of our 01JAN2017 - 07JAN2021 range. */

/* clean up the merge */
data btc_all_merged_clean;
    set btc_all_merged;
    drop sasdate;  /* I removed the sasdate column which is from my dxy_ready dataset because I don't need it since I already have week start and week end from original dataset */
    rename SAS_Date = Anchor_SAS_Date;  /* I renamed this as an anchor from the BTC/Google weekly dataset, its a good reminder of individual */
run;

/*! CHECK */
proc print data=btc_all_merged_clean;
    title "Merged Datasets";
run;

/* Export the dataset (Excel and CSV) */
proc export data=btc_all_merged_clean
    outfile="C:/Users/aiden/OneDrive - University of Toledo/Spring 2026 UT NOW/Data Science II/SAS Enviornment/Modules/Module 1/Misc/btc_all_merged_clean.xlsx"
    dbms=xlsx
    replace;
run;

proc export data=btc_all_merged_clean
    outfile="C:/Users/aiden/OneDrive - University of Toledo/Spring 2026 UT NOW/Data Science II/SAS Enviornment/Modules/Module 1/Misc/btc_all_merged_clean.csv"
    dbms=csv
    replace;
run;

/* ======================================================================== */
/* End of Part 3. */
/* ======================================================================== */

/* ======================================================================== */
/* Part 4. Bitcoin - Regression Tables */
/* ======================================================================== */

/* Sort the dataset before doing anything just in case */
proc sort data=btc_all_merged_clean;
    by unique_week;
run;

/* Create the first diffs for the regression */
data btc_all_diff;
    set btc_all_merged_clean;

    /* Create the lag variables for the first differences */
    coin_avg_lag = lag(coin_avg);
    new_wallets_lag = lag(new_wallets);
    coin_day_lag = lag(coin_day);
    buy_bitcoin_lag = lag(buy_bitcoin);

    avg_dxy_value_lag = lag(avg_dxy_value);
    gold_price_lag = lag(gold_price);
    intel_avg_lag = lag(intel_avg);
    intel_day_lag = lag(intel_day);
    snp_price_lag = lag(snp_price);
    total_wallets_lag = lag(total_wallets);

    /* Create the first differences */
    coin_avg_diff = coin_avg - coin_avg_lag;
    new_wallets_diff = new_wallets - new_wallets_lag;
    coin_day_diff = coin_day - coin_day_lag;
    buy_bitcoin_diff = buy_bitcoin - buy_bitcoin_lag;

    dxy_diff = avg_dxy_value - avg_dxy_value_lag;
    gold_diff = gold_price - gold_price_lag;
    intel_avg_diff = intel_avg - intel_avg_lag;
    intel_day_diff = intel_day - intel_day_lag;
    snp_diff = snp_price - snp_price_lag;
    total_wallets_diff = total_wallets - total_wallets_lag;

    if _N_ = 1 then delete;  /* Delete the first row because there is no prior week */
run;

/*! CHECK */
/* proc print data=btc_all_diff; */
/*     title "Differenced Datasets"; */
/* run; */

/* Run a "full regression model" to predict "coin_avg_diff" using all available predictors */
proc reg data=btc_all_diff;
    model coin_avg_diff = new_wallets_diff coin_day_diff buy_bitcoin_diff dxy_diff gold_diff
        intel_avg_diff intel_day_diff snp_diff total_wallets_diff;
    title "Full Bitcoin Model - All Predictors";
run;
quit;

/* Run a regression model with only the predictors that significantly predict Bitcoin price */
proc reg data=btc_all_diff;
    model coin_avg_diff = new_wallets_diff buy_bitcoin_diff gold_diff total_wallets_diff;
    title "Full Bitcoin Model - Significant Predictors Only";
run;
quit;

/* ======================================================================== */
/* End of Part 4. (See Submission for MS Word file) */
/* ======================================================================== */
