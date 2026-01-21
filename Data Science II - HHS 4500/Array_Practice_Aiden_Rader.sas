
/* 1. Download the two files off of onedrive */

/* 2. write code to import the excel file */
proc import
	out=array_practice
	datafile = "C:\Users\aiden\OneDrive - University of Toledo\Spring 2026 UT NOW\Data Science II\SAS Enviornment\Datasets\Dummy Array Practice Add1 to All Vars.xlsx"
	dbms = xlsx replace;
run;

/* 3. using an array and do loop, add 1 point to all numeric values */
data array_practice; set array_practice;
	array adddeci{8} v1-v8;
	do i = 1 to 8;
		adddeci(i) = adddeci(i) + 1;
	end;
run;

/* 4. write code to copy the downloaded SAS file into your work directory, using array of unspecified length {*} along with a do loop, add 1 point ot all numeric values */
libname mydata "C:\Users\aiden\OneDrive - University of Toledo\Spring 2026 UT NOW\Data Science II\SAS Enviornment\Datasets";

data array_practice_sas_ver; set mydata.dummy_array_practice;
run;

data array_practice_sas_ver; set array_practice_sas_ver;
	array adddeci{*} _numeric_;
	do i = 1 to dim(adddeci);
		adddeci(i) = adddeci(i) + 1;
	end;

	drop i;
run;