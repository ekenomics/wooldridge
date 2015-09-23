********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/



%let path = F:\Data Sets;


*Chapter 2 Question C1;
proc import datafile="&path\401k.xls"
dbms=xls out=fourk;
run;

*Part i;
proc means data=fourk;
var prate mrate;
run;
*The average prate is about 87.36 and the average mrate is about .732;

*Part ii;
proc reg data=fourk;
model prate = mrate;
ods select FitStatistics ParameterEstimates NObs;
run;

*Part iii;
*We can interpret the intercept as saying that we would expect to have a prate of 83.07546 if the mrate was equal to 
zero. We can interpret the coefficient on mrate as saying that for each 1 unit increase in mrate, we would 
expect a 5.86108 unit increase in prate;

*Part iv;
data fourkv;
mrate=83.07546+3.5*5.86108;
put mrate;
run;
*This is not a reasonable prediction because 103.59 is greater than 100. Since prate is a percentage, this is an 
impossible value. We are extrapolating past the data, and thus are losing predictive power and the 
equation does not work very well;

*Part v;
*With an R^2 of only 7.47%, mrate only explains 7.47% of prate. This is not very much.;

***********************

*Chapter 2 Question C2;
proc import datafile="&path\ceosal2.xls"
dbms=xls out=ceosal2;
run;

*Part i;
proc means data=ceosal2;
var salary ceoten;
run;
*Average salary is 865.864, or $865,864. Average ceoten is 7.95;

*Part ii;
proc freq data=ceosal2;
table ceoten;
run;
*There are 5 ceos with ceoten = 0;

*Part iii;
proc reg data=ceosal2;
model lsalary=ceoten;
ods select ParameterEstimates;
run;

data percentchange;
pctchg=100*0.00972;
put pctchg;
run;

*One more year as CEO is predicted to increase salary by almost 1% (.97);

********************************

*Chapter 2 Question C3;
proc import datafile="&path\sleep75.xls"
dbms=xls out=sleep75;
run;

*Part i;
proc reg data=sleep75;
model sleep = totwrk;
ods select Nobs ParameterEstimates FitStatistics;
run;
*The intercept in this model (3586.37695) is the average number of hours of sleep people would get when 
totwrk is equal to zero.;

*Part ii;
data twoless;
twoless=-0.15075*120;
put twoless;
run;
*Losing 18 minutes of sleep per week is not a large effect at all;

***************************************

*Chapter 2 Question C4;
proc import datafile="&path\wage2.xls"
dbms=xls out=wage2;
run;

*Part i;
proc means data=wage2;
var wage IQ;
run;
*Average salary is about $957.95 and average IQ is about 101.28. The sample standard deviation of IQ is 15.05
which is pretty close to the population value of 15;

*Part ii;
proc reg data=wage2;
model wage = IQ;
ods select ParameterEstimates FitStatistics;
run;

data IQincrease;
increase=8.30306*15;
put increase;
run;
*With an R^2 of only 9.91%, IQ does not explain most of the variation in wage. With an increase in IQ of 15
we expect an increased monthly salary of $124.50;

*Part iii;
proc reg data=wage2;
model lwage=IQ;
ods select ParameterEstimates FitStatistics;
run;

data IQLogIncrease;
LogIncrease=0.00881*15*100;
put LogIncrease;
run;
*Now if we increase IQ by 15 we expect wage to increase by 13.2%;

*****************************

*Chapter 2 Question C5;

proc import datafile="&path\rdchem.xls"
dbms=xls out=rdchem;
run;

*Part i;
*Constant Elasticity Model implies a log-log model, so Log(RD) = Log(Sales), coefficient oflLog(Sales) is the elasticity;

*Part ii;
proc reg data=rdchem;
model lrd = lsales;
ods select ParameterEstimates;
run;

*Coefficient on Log(sales) is 1.07673, so a one percent increase in sales is equal to a 1.07673 percent increase in rd;

***************************

*Chapter 2 Question C6;
proc import datafile="&path\meap93.xls"
dbms=xls out=meap93;
run;

*Part i;
*There should be a diminishing effect for dollars spent affecting the pass rate, as you would expect dollars to 
have a larger impact at lower pass rates;

*Part ii;
*Normally, if we increase the log form of an independent variable by 1%, we expect the dependent variable to 
change by B1/100. In this case increasing the indepdent variable by 10% would lead us to expect a change in the 
dependent variable by B1/10;

*Part iii;
Proc reg data=meap93;
model math10 = lexpend;
ods select ParameterEstimates Nobs FitStatistics;
run;

*Part iv;
data spendingeffect;
 effect = 11.16439/10;
 put effect;
 run;
 *The estimated increase in math10 is 1.12 for a 10% increase in lexpend;

*Part v;
*Obtaining values over 100 for math10 isn't a worry because the max in this data set is 66.7, and thus 
 we are not dealing with values close to the realistic max of 100;
 proc means data=meap93 max min range mean;
 var math10;
 run;

************************************

 *Chapter 2 Question C7;
proc import datafile="&path\charity.xls"
dbms=xls out=charity;
run;

*Part i;
proc means data=charity;
var gift;
run;
*The average gift is 7.45;

proc freq data=charity;
table gift;
run;
*60% gave no gift;

*Part ii;
proc means data=charity;
var mailsyear;
run;
*The average number of mailings per year is 2.05, with a max of 3.5 and min of 0.25;

*Part iii;
*The coefficient of 2.64955 on mailsyear tells us that for each additional mailing sent per year, we expect an increase in the gift size of 2.64955 guilders, 
thus if each mailing cost one guilder, the charity makes a net gain on each mailing;
proc reg data=charity;
model gift = mailsyear;
ods select ParameterEstimates Nobs FitStatistics;
run;

*Part v;
*The smallest predicted contribution would be 2.01408, or the value of the intercept. This means that with zero mailings sent out, we would still expect an average 
gift of 2.01408. This means we would never predict a zero gift;

*************************

*Chapter 2 Question C8;
*Part i & ii;
Data random;
do i = 1 to 500;
	x = ranuni(123);
	u = rannorm(123);
	output;
end;
run;

data randomi;
set random;
xi=x*10;
drop x;
rename xi = x;
ui = u * 6;
drop u;
rename ui = u;
run;

proc means data=randomi;
var x u;
run;
*The sample average of the errors is close enough to be considered equal to zero;

*Part iii;
data randomy;
set randomi;
y = 1 +2*x+u;
run;

proc reg data=randomy;
model y = x;
output out=randomr r = uhat;
ods select ParameterEstimates;
run;
*Our intercept value is very close to the 1.0 we hypothesized, and our B1 value is extremely close to the 
2.0 we hypothesized.;

*Part iv;
proc means data=randomr sum;
var uhat;
run;

data randomu;
set randomr;
xuhat=x*uhat;
run;

proc means data=randomu sum;
var xuhat;
run;
*We can see that both equations have values very close to zero, for the sums of the uhats and the sums of the uhats*x.;

*Part V;
proc means data=randomu sum;
var u;
run;

data randomz;
set randomu;
ux=u*x;
run;

proc means data=randomz sum;
var ux;
run;

*We can see that these values are definitely not zero as they should be, which means they are not following proper 
OLS guidelines. It means that our generated population equation is not correct;

*Part vi;
data randomnew;
do i = 1 to 500;
x = ranuni(123);
u = rannorm(123);
output;
end;
run;

data randomnewest;
set randomnew;
xi=x*10;
ui=u*6;
run;

*Average of the errors is close enough to be considered zero;
proc means data=randomnewest;
var ui;
run;

data randomnewy;
set randomnewer;
y = 1 + 2*xi + ui;
run;

proc reg data=randomnewy;
model y = xi;
ods select ParameterEstimates;
run;

*Our values are very close to what we hypothesized, within one standard deviation. These are slightly different
than our earlier results because we are randomly generating our data;
