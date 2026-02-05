/* cd to Datasets directory */
libname datasets "C:\Users\aiden\OneDrive - University of Toledo\Spring 2026 UT NOW\Data Science II\SAS Enviornment\In-Class & Homework\Datasets";

/* Import both crime_predictors_1990_2015 & prison_3year_ncrp */
data crime_pred_1990_2015; set datasets.crime_predictors_1990_2015;
run;
data prison_3year; set datasets.prison_3year_ncrp;
run;

/* We need to aggregate to the State County Level, print out new dataset */
proc means data=crime_pred_1990_2015 noprint;
    where POP100 >= 20000;  /* <-- Only with a population of 20,000 or more */
    class STATEFP CNTY YEAR;
    var violent_crime_rate;
    output out=crime_pred_1990_2015_agg;
run;

proc print data=crime_pred_1990_2015_agg(obs=20);
run;

/* Drop freq, and stat due to redundancy */
data crime_pred_1990_2015_agg;
    set crime_pred_1990_2015_agg;
    drop _FREQ_ _STAT_;
run;

proc print data=crime_pred_1990_2015_agg(obs=20);
run;


/* Calculate the percentage change for every agency */
/* use a first. and retain command! */


/* Here is a code what is this moment */
data weather1;
    retain sunlight temp summer randnum;

    do z = 0 to 1;
        summer = z;
        sunlight = -5;

        if summer = 1 then
            start_temp = 50;
        else
            start_temp = 20;

        temp = start_temp;

        do i = 1 to 21;
            randnum = rand("Integer", 1, 3);

            sunlight = sunlight + 5;
            temp = temp + randnum;

            if summer = 0 then do;
                if sunlight < 35 or sunlight > 65 then
                    temp = sum(start_temp, (randnum * 2));
            end;
        output;
    end;
end;
run;


