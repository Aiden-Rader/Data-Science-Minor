/*Name: Aiden Rader
* Date: 02/11/2026
* Class: Data Science II
* Professor: Dr. David Lilley
*
* Assignment: Interpolation Exercise
*/

/*========================================================================================================================================================================*/

/* Make the dummy date data file */
data dummy_date;
    do SAS_Date = '01JAN2018'd to '31DEC2018'd;  /* using SAS date format begin Jan 1st 2018 and end Dec 31st 2018 */
        Date_Excel = SAS_Date + 21916;  /* Excel offset using 21916 from lecture */
        ID + 1;  /* tracks the row number */
        format SAS_Date mmddyy10.;
        output;
    end;
run;

/* import the dataset */
proc import datafile="C:/Users/aiden/OneDrive - University of Toledo/Spring 2026 UT NOW/Data Science II/SAS Enviornment/Modules/Module 1/Datasets/Bitcoin Crypto Active wallets.csv"
    out=wallets
    dbms=csv
    replace;
run;

/* Original sort of our imported data */
proc sort data=wallets;
    by Date_orig;
run;

/* setting up stuff */
data wallets_clean;
    set wallets;
    rename Date_orig=timestamp;
    rename n_unique_addresses=wallets_char;
    SAS_Date = round(Excel_date) - 21916;  /* Excel offset using 21916 from lecture */
    format SAS_Date date9.;
    year = year(SAS_Date);  /* this is just to track visually which years are in the dataset */
run;

/* Sort by the datetime */
proc sort data=wallets_clean;
    by timestamp;
run;

/* 2. write code to interpolate the missing days so you can merge with the dummy_date file by date */
data wallets_num;
    set wallets_clean;
    wallets = input(wallets_char, comma9.);
    keep SAS_Date wallets;
run;

/* sort by date with descending order for interpolation */
proc sort data=wallets_num out=wallets_num_desc;
    by descending SAS_Date;
run;

/* interpolate missing values */
data wallet_interpolated;
    set wallets_num_desc;
    future_date = lag(SAS_Date);
    future_wallets = lag(wallets);

    format SAS_Date future_date date9.;

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
                wallets = round(base_wallets + (change_in_wallets*i), 1);  /* 1/3, 2/3, etc, also round to whole number */
                output;
            end;
        end;
        else if missing(gap) then do;
            New_SAS_Date = SAS_Date;
            output;
        end;
    end;
    keep SAS_Date New_SAS_Date wallets;
run;

/* Back to chronological order */
proc sort data=wallet_interpolated;
    by SAS_Date;
run;

/* Print only in betweeen 2017 */
proc print data=wallet_interpolated;
    where SAS_Date between '01JAN2017'd and '31DEC2017'd;
    var SAS_Date wallets;
run;

/* 3. Use SAS to merge both files together for all days Jan 1st - March 31st in 2018 */
/* sort the dummy date file */
proc sort data=dummy_date;
    by SAS_Date;
run;

/* make dummy data only have Jan 1st 2018 to March 31st 2018 */
data dummy_date;
    set dummy_date;
    if SAS_Date < '01JAN2018'd or SAS_Date > '31MAR2018'd then delete;
run;

/* merge the two files */
data wallet_calendar_final;
    merge dummy_date(in=a) wallet_interpolated(in=b);
    by SAS_Date;
    if a;  /* keep only the days in dummy_date, so 01/1/2018 to 03/31/2018 */
    keep ID SAS_Date Date_Excel wallets;
run;

/* 4. After merging the two files, use SAS to create a "SAS_Date" variable. */
/* Sort the data to identify the days with the highest and lowest number of active wallets. */

/* Sort to find the 5 lowest */
proc sort data=wallet_calendar_final out=lowest_by_wallets;
    by wallets;
run;
proc print data=lowest_by_wallets(obs=5);
    var SAS_Date wallets;
    title "Lowest 5 Active Wallet Days (January 1st - March 31st, 2018)";
run;

/* Sort to find the 5 highest */
proc sort data=wallet_calendar_final out=highest_by_wallets;
    by descending wallets;
run;
proc print data=highest_by_wallets(obs=5);
    var SAS_Date wallets;
    title "Highest 5 Active Wallet Days (January 1st - March 31, 2018)";
run;

/* Interpretation:
* Lowest 5 Active Wallet Days are 02/23, 02/24, 03/22, 02/02, and 03/23.
* Highest 5 Active Wallet Days are 01/09, 01/06, 01/07, 01/15, and 01/10.
* The interesting thing here is actually that the highest 5 days are in the same month of
* January! They are all pretty close together as well!
*/