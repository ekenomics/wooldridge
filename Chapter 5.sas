********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/


%let path = F:\Data Sets;
*Chapter 1 Question C1;
proc import datafile = "&path\wage1.xls"
dbms = xls out = wage1;
run;

*Part i;
ods graphics on;
proc reg data = wage1 plots = residualhistogram;
model wage = educ exper tenure;
output out = wage2 r = u;
run;

*Part ii;
proc reg data = wage1 plots = residualhistogram;
model lwage = educ exper tenure;
output out = wage3 r = u;
run;

*Part iii;
*It appears that MLR.6 is much closer to being satisfied for the log(wage) equation. The residuals form a much more normal
distribution with fewer extreme cases as well.;

******************************

*Chapter 5 Question C2;
proc import datafile = "&path\gpa2.xls"
dbms = xls out = gpa2;
run;

data gpa4small gpa3;
set gpa2 nobs = nobs;
if _n_ le 2070 then output gpa4small;
else output gpa3;
run;

*Part i;
proc reg data = gpa2;
model colgpa = hsperc sat;
ods select Nobs FitStatistics ParameterEstimates;
run;

*Part ii;
proc reg data = gpa4small;
model colgpa = hsperc sat;
ods select Nobs FitStatistics ParameterEstimates;
run;

*Part iii;
data ratio;
hs = .00072 / .00055;
fiveten = sqrt(4137/2070);
put hs;
put fiveten;
run;
*Ratio of Standard errors is 1.309;
*Ratio of standard errors from equation 5.10 is 1.41;


************************'

*Chapter 5 Question C3;
proc import datafile = "&path\bwght.xls"
dbms = xls out = bwght;
run;

data bwght2;
set bwght;
if motheduc >= 0 then output = bwght2; else DELETE;
if fatheduc >= 0 then output = bwght2; else DELETE;
run;

proc reg data = bwght2;
model bwght = cigs parity faminc;
output out = bwght3 r = r;
ods select Nobs FitStatistics ParameterEstimates;
run; 

proc reg data = bwght3;
model r = cigs parity faminc motheduc fatheduc;
ods select Nobs FitStatistics ParameterEstimates;
run;

*The R-Squared from this regression is .0024, with 1191 observations. This means our chi-squared statistic is
(1191)*(.0024) = ~2.86. The p-value from the X2^2 distribution is about .239, which is very close to .242 
the p-value for the comparable F Test;

***************************

*Chapter 5 Question C4;
proc import datafile = "&path\401ksubs.xls"
dbms = xls out=fourksubs;
run;

proc import datafile = "&path\bwght2.xls"
dbms = xls out = bwght2;
run;


*Part i;
data fourk;
set fourksubs;
linc = log(inc);
run;

proc means data = fourk skewness;
var inc linc;
where fsize = 1;
run;
*Inc has a higher skewness and is less likely to be normally distributed;

*Part ii;
proc means data = bwght2 skewness;
var bwght logbwght;
run;
*In this case the absolute value of bwght is much closer to zero than lbwght, so we can say that bwght is more likely
to be normally distributed;

*Part iii;
*While the log transformation is a good transformation to help correct non normally distributed data, it is not 
always going to be the correct answer or lead to better distributions;


*Part iv;
*since we are interested in the normality assumptions in the context of regression, it does not make much sense
to analyze the unconditional distributions of the dependent variables. We should analyze these distributions in 
the context of the other variables that are used in the regressions;

***************************

*Chapter 5 Question C5;
proc import datafile = "&path\htv.xls"
dbms = xls out = htv;
run;

*Part i;
proc freq data = htv;
table educ;
run;
*Educ has 15 different values: Its distribution is continuous from 6-20;

*Part ii;
proc univariate data = htv;
var educ;
histogram educ;
inset n normal;
run;
*Educ doesn't seem normal however, it seems to have twin peaks at 12 and 15 years of education;

*Part iii;
*We seem to be violating MLR.6, Normality;
*This would change all the regressions that we ran in Ch 4 C11, we would need to use robust tests
as the standard errors would not be very useful anymore;



