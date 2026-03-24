/* cd to Datasets directory */
libname datasets "C:\Users\aiden\OneDrive - University of Toledo\Spring 2026 UT NOW\Data Science II\SAS Enviornment\In-Class & Homework\Datasets";

/* Import both crime_predictors_1990_2015 & prison_3year_ncrp */
data file1; set datasets.file1;
run;
data file2; set datasets.file2;
run;

/* Sort our data by id and county */
proc sort data=file1;
    by id county;
run;
proc sort data=file2;
    by id county;
run;

/* Multi Merge */
data combo_file1_file2 file1_only file2_only file_none_only;
    merge file1(in=a) file2 (in=b);
    by id county;
    if a and b then output;
    if a and not b then output file1_only;
    if b and not a then output file2_only;
run;
