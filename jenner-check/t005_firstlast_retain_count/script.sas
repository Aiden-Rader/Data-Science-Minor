/* From "Data Science II - HHS 4500/SAS/In-Class & Homework/random_practice_with_cars_Aiden_Rader.sas":
 *  - sort by Type Model
 *  - use first.Type / last.Type with retain to count models within each type
 *  - emit one row per Type with the running count
 */

data cars; set sashelp.cars;
    dummy_code = 1;
run;

proc sort data=cars out=sorted_cars;
    by type model;
run;

data count_sorted_cars;
    retain count;
    set sorted_cars;
    by type model;
    if first.type then count = 0;
        count = count + 1;
    if last.type then output;
run;

proc print data=count_sorted_cars;
    var Type count;
    title "Number of models per car Type";
run;
title;
