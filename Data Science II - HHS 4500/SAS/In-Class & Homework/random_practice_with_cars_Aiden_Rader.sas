/* Random thing he just said to do or try with the cars file */

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

/* Practice the concat function */
data type_count_sorted_cars;
    retain count;
    set sorted_cars;
    by type model;
    if first.type then count = 0;
        count = count + 1;
    if last.type then type_count=cats(type,count);
    keep count make model type type_count;
run;