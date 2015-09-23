********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/


%let path = F:\Data Sets;
*Chapter 14;
%let path = F:\Econometrics Supplement\Data Sets;
*Chapter 14 Question C1;
proc import datafile = "&path\rental.xls"
dbms = xls out = rental;
run;

*Part i;
proc reg data = rental;
model lrent = y90 lpop lavginc pctstu;
ods select ParameterEstimates;
run;
*The coefficient on y90 means that nominal rents grew by 26% over 10 years. We obtain a coefficient of .005 on pctstu, 
meaning that a one percentage point increase in pctstu increases rent by .5%;

*Part ii;
*The standard errors are not valid, unless we think ai doesn't appear in the equation. If ai is in the error term, the 
errors across the two time periods are positively correlated, and this invalidates OLS standard errors;

*Part iii;
proc reg data = rental;
model clrent = clpop clavginc cpctstu;
ods select ParameterEstimates;
run;
*The estimate on pctstu is now .01120, with a one percent increase in pctstu increasing rents by 1.1%;

*Part iv;
proc panel data = rental;
id city year;
model lrent = y90 lpop lavginc pctstu /noint fixone;
ods select ParameterEstimates;
run;


*Chapter 14 Question C2;
proc import datafile = "&path\crime4.xls"
dbms = xls out = crime;
run;

*Part i;
proc panel data = crime;
id county year;
model lcrmrte = d82 d83 d84 d85 d86 d87 lprbarr lprbconv lprbpris lavgsen lpolpc / noint fixone;
ods select ParameterEstimates;
run;
*The first-differenced and fixed-effects slope estimates are broadly consistent. The signs are all the same,
and all the same variables are significant;

*Part ii;
proc panel data = crime;
id county year;
model lcrmrte = d82 d83 d84 d85 d86 d87 lprbarr lprbconv lprbpris lavgsen lpolpc
				lwcon lwtuc lwtrd lwfir lwser lwmfg lwfed lwsta lwloc/ noint fixone;
ods select ParameterEstimates TestResults;
test lwcon, lwtuc, lwtrd, lwfir, lwser, lwmfg, lwfed, lwsta, lwloc = 0;
run;
*The changes in these estimates are minor, even though the wages variables are jointly significant.;

*Part iii;
*The wage variables are all jointly significant, at the 1% level. All of the wage variables other than lwtuc, lwser, 
lwsta, and lwloc are negative, which we would expect. We would expect an increase in wages to lead to a decrease in crime.
Of these variables that have positive signs, only lwtuc is a significant variable.;



*Chapter 14 Question C3;
proc import datafile = "&path\jtrain.xls"
dbms = xls out = jtrain;
run;

*Part i;
proc panel data = jtrain;
id fcode year;
model hrsemp = d88 d89 grant grant_1 lemploy /noint fixone;
run;

*DATA ERRORS;

*Part ii;
*The coefficient on grant means that if a firm received a grant for the current year, it trained each worker
an average of 34.2 hours mroe than it would have otherwise. This is very statistically significant;

*Part iii;
*Since grant last year was used to pay for training last year, it's not surprising that the grant
does not carry over with time.;

*Part iv;
*The coefficient on the employees variable is very small: a 10% increase in employ increased predicted hours
per employee by only about .018. This is very small and statistically insignificant;



*Chapter 14 Question C4;
proc import datafile = "&path\ezunem.xls" 
dbms = xls out = ezunem;
run;

*Part i;
* log(uclms it) = ai + cit + B1ezit + uit
  log(uclms i,t-1) = ai ci(t-1) + B1 ez i,t-1 + u i,t-1
Subtract the second equation from the first: The ai are eliminated and for each t >= 2 we have:

	clog(uclms it) = ci + B1 cez it + u it;

*Part ii;
proc panel data = ezunem;
id city year;
model guclms = cez / noint fixone;
where year > 1980;
ods select ParameterEstimates;
run;
*We obtain an estimate for B1 of -0.251 with standard error .1212. This is significant at the 5% level;

*Part iii;
proc panel data = ezunem;
id city year;
model guclms = cez d81 d82 d83 d84 d85 d86 d87 d88 / noint fixone;
where year > 1980;
ods select ParameterEstimates;
run;
*The estimate of B1 is now -.192 with standard error .085. This is very comparable to what we obtained without cit 
in the model. These estimates are very similar to those without the city-specific trends;



*Chapter 14 Question C5;
proc import datafile = "&path\wagepan.xls"
dbms = xls out = wagepan;
run;

*Part i;
*Different occupations are unionized at different rates, and wages also differ by occupation.;

*Part ii;
*No, because the differential from union would be exclusive to each industry since people are not changing jobs;

*Part iii;
proc panel data = wagepan;
id nr year;
model lwage = educ black hisp exper expersq married union occ1 occ2 occ3 occ4 occ5 
				occ6 occ7 occ8 / fixtwo;
ods select ParameterEstimates;
run;
*The coefficient on union is now .0804 with standard error .0194. This is virtually the same as without the 
occupational controls where Bunion = .0800 with standard error .0193;



*Chapter 14 Question C6;
proc import datafile = "&path\wagepan.xls"
dbms = xls out = wagepanc6;
run;

data wagepanc6;
set wagepanc6;
if year = 1980 then t = 1;
if year = 1981 then t = 2;
if year = 1982 then t = 3;
if year = 1983 then t = 4;
if year = 1984 then t = 5;
if year = 1985 then t = 6;
if year = 1986 then t = 7;
if year = 1987 then t = 8;
if year = 1988 then t = 9;
uniont = union*t;
run;
*Fixed Effects;
proc panel data = wagepanc6;
id nr year;
model lwage = educ black hisp exper expersq married union uniont / fixtwo;
ods select ParameterEstimates;
run;
*Random Effects;
proc panel data = wagepanc6;
id nr year;
model lwage = educ black hisp exper expersq married union uniont /rantwo;
ods select ParameterEstimates;
run;

*The random effects coefficient on uniont is -0.0143 with standard error .00563.
The fixed effects coefficient on uniont is -.0157 with standard error .0057;



*Chapter 14 Question C7;
proc import datafile = "&path\murder.xls"
dbms = xls out = murder;
run;

*Part i;
*If there is a deterrent effect then B1 < 0. The sign of B2 is not obvious, but one possibility is that
a better economy means less crime, implying B2 > 0;

*Part ii;
proc reg data = murder;
model mrdrte = d93 exec unem;
where year ne 87;
ods select ParameterEstimates;
run;
*There is no evidence of a deterrent effect as exec is positive and insignificant;

*Part iii;
proc reg data = murder;
model cmrdrte = cexec cunem;
where year = 93;
ods select ParameterEstimates;
run;
*There is now evidence of a deterrent effect of approximately 1.04 fewer murders per 100,000 people
per 10 additional executions. This doesn't seem large, but murder rates are not especially high to begin with.;

*Part iv;
proc reg data = murder;
model mrdrte = d93 exec unem /hcc;
where year ne 87;
ods select ParameterEstimates;
run;

*Part v;
proc freq data = murder;
table state*exec;
where year = 93;
run;
*The highest state was Texas with 34 executions, and the next highest was Virginia with 11;

*Part vi;
proc reg data = murder;
model cmrdrte = cexec cunem /hcc;
where year = 93 and state ne "TX";
ods select ParameterEstimates;
run;
*Now the estimated deterrent effect is smaller. The standard error on cexec has also increased substantially. 
When we dropped Texas, we lose much of the variation in the variable cexec.;

*Part vii;
proc panel data = murder;
id state year;
model mrdrte = d90 d93 exec unem /noint fixone;
run;
*Now the deterrent effect is no longer statistically significant, making the earlier finding of a deterrent effect
not seem to be very robust;



*Chapter 14 Question C8;
proc import datafile = "&path\mathpnl.xls"
dbms = xls out = mathpnl;
run;

*Part i;
proc reg data = mathpnl;
model math4 = y94 y95 y96 y97 y98  lrexpp lrexpp_1 lenroll lunch;
ods select ParameterEstimates;
output out = mathpnlx r = uhat;
run;
*The effects of the spending variables are both positive, although only the lagged variable is statistically
significant;

*Part ii;
*Lunch has a negative coefficient, and this is what we would expect since lunch is a measure of poverty in the 
school district. A one percent increase in students eligible for a free lunch leads to a .41% reduction in the pass
rate;

*Part iii;
data mathpnlx;
set mathpnlx;
uhat_1 = lag(uhat);
run;

proc reg data = mathpnlx;
model uhat = uhat_1;
ods select ParameterEstimates;
where year >= 1994 and year <= 1998;
run;
*The coefficient on uhat_1 gives us p = .504. With a t-value of 29.88 there is very strong evidence of 
serial correlation. In this case, serial correlation indicates the presence of a time constant unobserved effect
ai;

*Part iv;
proc panel data = mathpnl;
id distid year;
model math4 = y94 y95 y96 y97 y98 lrexpp lrexpp_1 lenroll lunch /noint fixone;
ods select ParameterEstimates;
where year ne 1992;
run;
*The lagged term is still significant even at the 1% level;

*Part v;
*Both enroll and lunch are slow to change with time, which means their effects would largely be captured by
the unobserved effect ai.;

*Part vi;
data mathpnlxx;
set mathpnl;
z = lrexpp_1 - lrexpp;
run;

proc panel data = mathpnlxx;
id distid year;
model math4 = y94 y95 y96 y97 y98 lrexpp z lenroll lunch /noint fixone;
ods select ParameterEstimates;
where year ne 1992;
run;
*The estimated long-run spending effect is Theta1 = 6.59 with standard error 2.64.;



*Chapter 14 Question C9;
proc import datafile = "&path\pension.xls"
dbms = xls out = pension;
run;

*Part i;
proc reg data = pension;
model pctstck = choice prftshr female age educ finc25 finc35 finc50 finc75 finc100 finc101 wealth89 stckin89 irain89;
ods select ParameterEstimates TestANOVA;
test wealth89, stckin89, finc25, finc35, finc50, finc75, finc100, finc101, irain89 = 0;
run;
*Investment choice is associated with 11.7% more in stocks. It is significant at the 10% level;

*Part ii;
*The F-Value for the joint significance of all of these variables is only 1.03, resulting in a p-value of .42.
These variables are not jointly significant;

*Part iii;
proc freq data = pension;
table id;
run;

*There are 171 families in the sample;

*Part iv;
proc surveyreg data = pension;
cluster id;
model pctstck = choice prftshr female age educ finc25 finc35 finc50 finc75 finc100 finc101 wealth89 stckin89 irain89;
ods select ParameterEstimates;
run;
*The standard error for choice is 6.20. This is essentially the same as the OLS estimated error. This is
not surprising since 171 of the 194 are independent of each other;

*Part v;
data pensionx;
set pension;
if id = 152 then spouse = 1;
else if id = 233 then spouse = 1;
else if id = 460 then spouse = 1;
else if id = 490 then spouse = 1;
else if id = 888 then spouse = 1;
else if id = 910 then spouse = 1;
else if id = 953 then spouse = 1;
else if id = 1549 then spouse = 1;
else if id = 1658 then spouse = 1;
else if id = 1810 then spouse = 1;
else if id = 2082 then spouse = 1;
else if id = 2190 then spouse = 1;
else if id = 2204 then spouse = 1;
else if id = 2382 then spouse = 1;
else if id = 2512 then spouse = 1;
else if id = 2539 then spouse = 1;
else if id = 3381 then spouse = 1;
else if id = 3829 then spouse = 1;
else if id = 3846 then spouse = 1;
else if id = 3917 then spouse = 1;
else if id = 3931 then spouse = 1;
else if id = 4485 then spouse = 1;
else if id = 5014 then spouse = 1;
else spouse = 0;
if spouse = 0 then DELETE;
run;

data pensionxx;
set pensionx;
cpctstck = pctstck - lag(pctstck);
cchoice = choice - lag(choice);
cprftshr = prftshr - lag(prftshr);
cfemale = female - lag(female);
cage = age - lag(age);
ceduc = educ - lag(educ);
if _n_ = 1 then DELETE;
if _n_ = 3 then DELETE;
if _n_ = 5 then DELETE;
if _n_ = 7 then DELETE;
if _n_ = 9 then DELETE;
if _n_ = 11 then DELETE;
if _n_ = 13 then DELETE;
if _n_ = 15 then DELETE;
if _n_ = 17 then DELETE;
if _n_ = 19 then DELETE;
if _n_ = 21 then DELETE;
if _n_ = 23 then DELETE;
if _n_ = 25 then DELETE;
if _n_ = 27 then DELETE;
if _n_ = 29 then DELETE;
if _n_ = 31 then DELETE;
if _n_ = 33 then DELETE;
if _n_ = 35 then DELETE;
if _n_ = 37 then DELETE;
if _n_ = 39 then DELETE;
if _n_ = 41 then DELETE;
if _n_ = 43 then DELETE;
if _n_ = 45 then DELETE;
run;

proc print data = pensionxx;
run;

proc reg data = pensionxx;
model cpctstck = cchoice cprftshr cfemale cage ceduc;
ods select Nobs ANOVA FitStatistics ParameterEstimates;
run;
*All the other variables drop out because they are defined at the family level, and so are the same 
for spouses;

*Part vi;
*None of the variables are significant. We have only 23 variables and we are removing most of the variation
in the explanatory variables by using within-family differences;



*Chapter 14 Question C10;
proc import datafile = "&path\airfare.xls"
dbms = xls out = airfare;
run;

*Part i;
proc reg data = airfare;
model lfare = y98 y99 y00 concen ldist ldistsq /clb hcc;
ods select ParameterEstimates;
run;
*For a change in concen by .10, we would expect a change in lfare of 100 * .360 * .10 = 3.60%;

*Part ii;
*The 95% confidence interval for B1 is .303 - .423. The robust confidence interval is .299 - .427. 
In this case the OLS standard errors are not valid unless we believe that the ai term doesn't appear in the model,
otherwise the errors are linked across time periods;

*Part iii;
data tp;
tp = .90188 / 2*(0.10305);
dist = exp(tp);
put tp;
put dist;
run;

proc means data = airfare range max min;
var dist;
run;
*The value where dist becomes a positive effect on lfare is at 1.05. This is well outside the range of the data
for dist;

*Part iv;
proc panel data = airfare;
id id year;
model lfare = y98 y99 y00 concen ldist ldistsq / ranone;
ods select ParameterEstimates;
run;
*The coefficient on concen is now .207 instead of .363;

*Part v;
proc panel data = airfare;
id id year;
model lfare = y98 y99 y00 concen ldist ldistsq /fixone;
ods select ParameterEstimates;
run;
*The coefficient on B1 is now .169. This is fairly close to the RE B1 value of .208;

*Part vi;
*Time of route and number of competitors on route may be included in the ai term. Competitors would more than likely
be correlated with concen, and time of route may be correlated but it is tough to be sure;

*Part vii;
*I do believe that concen increases airfare prices. The higher the fraction of the market dominated by one carrier,
the more of a monopoly in that fare is present and we would then expect higher prices;



*Chapter 14 Question C11;
proc import datafile = "&path\jtrain.xls"
dbms = xls out = jtrain;
run;

*Part i;
proc reg data = jtrain;
model lscrap = d88 d89 grant grant_1;
ods select ParameterEstimates;
output out = jtrainx r = uhat;
run;

**HOW TO OBTAIN FULL ROBUST STANDARD ERRORS?;



*Chapter 14 Question C12;
proc import datafile = "&path\elem94_95.xls"
dbms = xls out = elem;
run;

*Part i;
*help needed;

*Part ii;
proc reg data = elem;
model lavgsal = bs lenrol lstaff lunch;
ods select ParameterEstimates;
run;
*The coefficient on bs is negative .516 with standard error .110;

*Part iii;
proc surveyreg data = elem;
cluster distid;
model lavgsal = bs lenrol lstaff lunch / ;
run;

proc genmod data = elem;
class distid;
model lavgsal = bs lenrol lstaff lunch;
repeated subject = distid / type = ind;
run;

*Two different stanard errors?;



*Chapter 14 Question C13;
proc import datafile = "&path\driving.xlsx"
dbms = xlsx out = driving;
run;

*Part i;
*Totfatrte is total fatalities per 100,000 population.;
proc means data = driving;
var totfatrte;
where year = 1980;
run;
*1980 average = 25.50;
proc means data = driving;
var totfatrte;
where year = 1992;
run;
*1992 average = 17.16;
proc means data = driving;
var totfatrte;
where year = 2004;
run;
*2004 average = 16.73;

proc reg data = driving;
model totfatrte = d81 d82 d83 d84 d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04;
ods select ParameterEstimates;
run;
*It does appear that the overall trend was towards driving becoming more safe over the period of 1981 - 2004;

*Part ii;
proc reg data = driving;
model totfatrte = d81 d82 d83 d84 d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04
					bac08 bac10 perse sbprim sbsecon sl70plus gdl perc14_24 unem vehicmilespc;
ods select ParameterEstimates;
run;
*Both of the bac variables have negative coefficients, that are statistically significant. This shows
that having a bac law has a positive impact on making driving safer. 

The primary seat belt law has a negative coefficient, but isn't statistically significant so we cannot say
that it makes driving safer;

*Part iii;
proc panel data = driving;
id state year;
model totfatrte = d81 d82 d83 d84 d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04
					bac08 bac10 perse sbprim sbsecon sl70plus gdl perc14_24 unem vehicmilespc / fixone;
ods select ParameterEstimates;
run;
*Using fixed effects the coefficients on bac08, bac10, perse and sbprim are -1.44, -1.06, -1.15 and -1.23.
Under OLS these coefficients were -2.50, -1.42, -0.62, and -0.08. The fixed effects estimates are likely more
reliable because they can correct for state-wide effects.;

*Part iv;
*If vehicmilespc increases by 1000, we would expect totfatrte to increase by 2.93 fatalities per 100,000 people;

*Part v;
proc surveyreg data = driving;
cluster state;
model totfatrte = d81 d82 d83 d84 d85 d86 d87 d88 d89 d90 d91 d92 d93 d94 d95 d96 d97 d98 d99 d00 d01 d02 d03 d04
					bac08 bac10 perse sbprim sbsecon sl70plus gdl perc14_24 unem vehicmilespc;
ods select ParameterEstimates;
run;
*Using cluster robust standard errors, all of these variables go from being highly significant to not significant
even at the 10% levels;



*Chapter 14 Question C14;
proc import datafile = "&path\airfare.xls"
dbms = xls out = airfare replace;
run;

*Part i;
data airfarex;
set airfare;
concenbar = (lag3(concen)+lag2(concen)+lag1(concen)+concen)/4;
run;

proc means data = airfarex max min n;
var concenbar;
run;
*There are 1149 different time averages, with a max of .9997 and min of .1862;

*Part ii;
proc panel data = airfarex;
id id year;
model lfare = y98 y99 y00 concen ldist ldistsq concenbar /rantwo;
ods select ParameterEstimates;
where id > 1;
run;
*Does not match B1 from C10 Fixed effects;

*Part iii;


