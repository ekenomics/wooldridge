********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/



%let path = F:\Data Sets;
*Chapter 1: Question C1;
*Import Data;
proc import datafile="&path\wage1 with variable names.xls" 
dbms=xls output=wage1;
run;

*Part i;
proc means data=wage1;
var educ;
run;
*The average education is 12.56 years, the lowest is 0 and the maximum is 18;

*Part ii;
proc means data=wage1;
var wage;
run;
*The wage seems extremely low, even below minimum wage;

*Part iii & Part iv;
*CPI Data Obtained From: 
http://www.usinflationcalculator.com/inflation/consumer-price-index-and-annual-percent-changes-from-1913-to-2008/;
data wage1withcpi;
set wage1;
CPI76=56.9;
CPI2010=218.056;
Currentwage = Wage*(CPI2010/CPI76);
run;

proc means data=wage1withcpi;
var currentwage;
run;
*The wage seems much more accurate and much closer to the country's median income when adjusting for the CPI;

*Part v;
proc freq data=wage1;
table Female;
run;
*The sample is 47.91% female and 52.09% male;

****************************

*Chapter 1 Question C2;
Proc import datafile="&path\bwght.xls" 
dbms=xls output=bwght;
run;

*Part i;
proc freq data=bwght;
table Male*Cigs;
run;
*There are 665 women in the sample. 112 report smoking during pregnancy;

*Part ii;
proc means data=bwght;
var Cigs;
run;
*The average is not indicative of the typical woman, because there are two distinct groups. One group will have 
some positive number of cigs, and the rest will have zeros. Those zeros will pull the average down dramatically.;

*Part iii;
proc means data=bwght;
var Cigs;
where Cigs > 0;
run;
*This average is much higher and seems much more likely, since this average excludes all the previous zero values;

*Part iv;
*Fatheduc is a Char variable so we add zero to convert to a numeric variable, N=1192 in the proc means shows
that we're not counting these as zeros in the average, they're just being left out;
data bwghtfathers;
set bwght;
Fathers = Fatheduc+0;
run;

proc means data=bwghtfathers;
var Fathers;
run;
*The average level of education among fathers is 13.19;

*Part v;
proc means data=bwght;
var Faminc;
run;
*The average family income is $29,027 and it's standard deviation is $18,739.;

********************************

*Chapter 1 Question C3;
Proc import datafile="&path\meap01.xls"
dbms=xls out=meap01;
run;

*Part i;
*The range makes sense because it is a percentage and thus goes from 0-100;
proc means data=meap01 max min;
var math4;
run;

*Part ii & Part iii;
proc freq data=meap01;
Table math4;
run;

*38 schools had a perfect pass rate.This was 2.08% of the sample.
17 schools had a pass rate of 50%. This was 0.93% of the sample. ;

*Part iv and v;
proc corr data=meap01;
var math4 read4;
run;
*We see that read4 and math4 have a correlation of 0.84273. This implies that these rise together, so schools
should be good at both tests or neither test. The average pass rate of math4 is 71.91 and the average pass
rate of read4 is 60.06. Read4 is the harder test to pass;

*Part vi;
proc means data=meap01;
var exppp;
run;
*It appears as if there is a large amount of variation in spending per pupil, suggested by the 
range and the standard deviation;

*Part vii;
data pctchange;
LogPct=100*((Log(6000))-(Log(5500)));
Pct=100*((6000-5500)/5500);
Diff=Pct-LogPct;
put LogPct Pct Diff;
run;
*The percentage difference is 9.09. The log difference is 8.70. The difference between these two is
0.39;

********************************

*Chapter 1 Question C4;
Proc import datafile="&path\jtrain2.xls"
dbms=xls out=jtrain2;
run;

*Bad data corrections: use best guess to fix formats in mosinex, re74, delete 6 huge outlier values in re75,
fix lre74 and lre75 and lre78 by taking log of re74 and inputting zero where needed, 

*Part i;
proc freq data=jtrain2;
table train;
run;
*41.57% of men received training;

*Part ii;
proc means data=jtrain2;
var re78;
where train=1;
run;

proc means data=jtrain2;
var re78;
where train=0;
run;
*The difference between the two is approximately 1791 in 1982 dollars, which is economically significant.;

*Part iii;
proc freq data = jtrain2;
table unem78*train;
run;
*Of those who received training 45/185 or 24.32% are unemployed. of those who did not receive training
92/260 or 35.38 are unemployed.;

*Part iv;
*It appears that the training program was succesful. The participants earned higher wages and suffered from
lower unemployment. We could make this conclusion more convincing by looking at the benefits to the companies from
training, or look at more than one year;

****************************************

*Chapter 1 Question C5;
proc import datafile="&path\fertil2.xls"
dbms=xls out=fertil2;
run;

*Part i;
proc means data=fertil2 mean max min;
var children;
run;
*The average number of children is 2.27. The max is 13 and min is 0;

*Part ii;
proc freq data=fertil2;
table electric;
run;
*14.02% of women have electricity in their homes;

*Part iii;
proc means data=fertil2;
var children;
where electric=1;
run;

proc means data=fertil2;
var children;
where electric=0;
run;
*The average number of children when there is electricity is 1.90 and without electricity is 2.33;

*Part iv;
*We can see that when electricity is present there are fewer children, but we can not necessarily say that
electricity "causes" less children to be born;

*Part iv;
*You can see that having electricity does on average have less children. However, due to the standard deviations being ~1.8 
and ~2.2, and the difference between the two averages only being ~0.50, I would not say that electricity causes 
women to have fewer children.;

