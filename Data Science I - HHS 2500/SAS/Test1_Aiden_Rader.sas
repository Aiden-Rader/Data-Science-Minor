/* 1) Import census and prison data into SAS*/
proc import out=work.census_data
    datafile = "C:\Users\aiden\Downloads\Census_population_files_2000_2010 Clean.xlsx"
    dbms = xlsx replace;
    getnames = yes;
run;

proc import out=work.prison_data
	datafile = "C:\Users\aiden\Downloads\prisons_data_2000_2010.csv"
	dbms = csv replace;
	getnames = yes;
run;

/* 2) Create data file, store year 2000 census data only*/
/* 3) Create "population" column (rename Pop_2000 to population) and assign the year 2000 population for each state to it*/
/* 	  Also create a year column and assign the year 2000 to all the entries*/
data census_2000; set census_data;
	POPULATION = Pop_2000;
	YEAR = 2000;
    keep year state population region name;
run;

/* 4) Create data file, store year 2000 prision data only*/
data prison_2000; set prison_data;
    where RPTYEAR = 2000;
run;

/* 5) Get total number of people incarcerated by each state*/
proc means data=prison_2000;
class state;
output out=prison_incar_state;
run;

data prison_incar_state; set prison_incar_state;
where _STAT_ = 'N';
keep STATE _FREQ_ YEAR;
run;

/* 7) Merge the  prisons_2000 and  census_2000 data files by year and state.*/
proc sort data=census_2000;
by STATE;
run;

proc sort data=prison_incar_state;
by STATE;
run;

data merge_state_year;
merge census_2000 (in=a) prison_incar_state (in=b);
by STATE;
rename _FREQ_ = N_INCARCERATE;
if a ~= b then delete;
run;

/* 9) Create an incarceration rate variable that shows incarceration rate per 100,000 for each state in the year 2000*/
data incar_rate; set merge_state_year;
rate_100k = (YEAR / POPULATION) * 100000;
run;

/* CONTINUE FROM HERE */
