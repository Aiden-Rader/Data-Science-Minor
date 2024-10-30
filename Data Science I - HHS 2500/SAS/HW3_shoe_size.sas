proc import out=work.people
	datafile = "C:\Users\aiden\Downloads\people_xls.xlsx"
	dbms = xlsx replace;
	sheet = 'follow_instructions';
run;

data people2; 
set people; 

length shoe_size $ 20;

if (Height < 60) then
	shoe_size = 'small feet';
else if (Height > 60) and (Height < 65) then
	shoe_size = 'medium feet';
else
	shoe_size = 'giant feet';

data medium_people; 
set people2;
where shoe_size = 'medium feet';
run;

proc print data=people2;
run;

proc print data=medium_people;
run;
