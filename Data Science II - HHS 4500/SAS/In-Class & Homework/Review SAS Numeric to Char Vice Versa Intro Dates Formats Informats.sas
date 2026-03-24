data newfile;
    input id $ name $ gender $ height weight date date2 $12.;
    datalines;
    01 David M 72 175 100 04/10/1960
    02 Suzy F 64 110 2500 11/05/1966
    03 Mary F 66 125 17500 11/30/2007
    04 Tom M 69 150 22000 3/26/2020
    ;
run;

data fix;
    set newfile;
    new_date = input(date2, MMDDYY10.);
    format new_date date9.;
    month = month(new_date);
    week = week(new_date);
run;


/* Change ID to numeric using math expression.  INPUT for char to numeric.  */
data newfile2;
    set newfile;
    id2=id+0;
    id_num=input(id, 3.);
run;


/* PUT: for num to char, can't rename same var, format, informat doesn't matter, just length */
data newfile3;
set newfile2;
idstr=put(id_num,3.);
* idstr2=put(id_num,z2.);
keep id name id_num idstr idstr2;
run;




/* INPUT: for char to numeric, put for num to char, can't rename same var, format, informat doesn't matter, just length */
data newfile3;
set newfile;
idnum=input(id,3.);
/* z5. adds zeros to numeric, like in a FIPS code  */
id_zerochar=put(idnum,z5.);
idstr=put(idnum,$5.);
iddoll=put(idnum,dollar5.2);

/* Intro to dates in SAS  SASDATE, Excel Date  */
newdate=put(date,mmddyy10.);   * Dates;
newdate2=put(date2,date9.);
mnth=month(date2);
day=day(date);
week=week(date2);
year=year(date2);
run;



/* Input for char to numeric, put for num to char, can't rename same var, format, informat doesn't matter, just length */
data newfile3;
set newfile;
idnum=input(id,3.);
idstr=put(idnum,$5.);
id_newnum=input(idstr,5.);  * Or: idstr=put(idnum,5.);
keep id name idnum idstr id_newnum;
run;


