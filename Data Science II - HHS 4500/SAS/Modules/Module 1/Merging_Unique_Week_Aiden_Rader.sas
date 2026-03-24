/*Name: Aiden Rader
* Date: 02/16/2026
* Class: Data Science II
* Professor: Dr. David Lilley
*
* Assignment: Exercise Merging via "Unique Week"
*/

/*========================================================================================================================================================================*/

/* Import the datasets */
proc import datafile="C:/Users/aiden/OneDrive - University of Toledo/Spring 2026 UT NOW/Data Science II/SAS Enviornment/Modules/Module 1/Datasets/Bitcoin Crypto Active wallets.csv"
    out=wallets
    dbms=csv
    replace;
run;

proc import datafile="C:/Users/aiden/OneDrive - University of Toledo/Spring 2026 UT NOW/Data Science II/SAS Enviornment/Modules/Module 1/Datasets/bitcoin_price_volume_main_2017_2021_fixed.xlsx"
    out=bitcoin_details
    dbms=xlsx
    replace;
run;

proc import datafile="C:/Users/aiden/OneDrive - University of Toledo/Spring 2026 UT NOW/Data Science II/SAS Enviornment/Modules/Module 1/Datasets/Google_Trends_BuyBitcoin_5yr.xlsx"
    out=google_trends
    dbms=xlsx
    replace;
run;

/* Original sort of our imported data */
proc sort data=wallets;
    by Date_orig;
run;

proc sort data=bitcoin_details;
    by Date;
run;

proc sort data=google_trends;
    by Date_orig;
run;

/* Now we can find unique week inside the google trends data */
data google_trends_unique;
    set google_trends;
    SAS_Date = Date_orig;
    unique_week = int((Date_orig - 20820)/7) + 1;  /* the math version of finding it */
    format SAS_Date date9.;
run;