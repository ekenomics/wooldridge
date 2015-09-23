********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/


%let path = F:\Data Sets;
*Chapter 9;

*Chapter 9 Question C1;
%let path = F:\Econometrics Supplement\Data Sets;
proc import datafile = "&path\ceosal1.xls"
dbms = xls out = ceosal;
run;

*Part i;
data ceosal;
set ceosal;
if ros < 0 then rosneg = 1;
else rosneg = 0;
run;

proc reg data = ceosal;
model lsalary = lsales roe rosneg;
output out = ceosalx p = yhat;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;

data ceosalxx;
set ceosalx;
yhatsq = yhat**2;
yhatcube = yhat**3;
run;

proc reg data = ceosalxx;
model lsalary = lsales roe rosneg yhatsq yhatcube;
test yhatsq, yhatcube;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA;
run;
*The Reset F-stat is 1.33, with a p-value of .2658. This does not cause us much concern about functional form
misspecification;

*Part ii;
proc reg data = ceosalxx;
model lsalary = lsales roe rosneg yhatsq yhatcube / hcc;
test yhatsq, yhatcube;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA ACovTestANOVA;
run;
*The Robust RESET Chi-Square statistic is 4.48 with p-value of .1066. This provides more evidence of 
functional form misspecification than the standard RESET F-value. However, it is still not even at the 10% level,
so it is not enough to worry about;

*Chapter 9 Question C2;
proc import datafile = "&path\wage2.xls"
dbms = xls out = wage;
run;

*Part i;
data wage;
set wage;
educIQ = educ*IQ;
run;

proc reg data = wage;
model lwage = educ exper tenure married south urban black KWW educIQ;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on education is .024 vs .018 compared to the model with IQ instead of KWW.;

*Part ii;
proc reg data = wage;
model lwage = educ exper tenure married south urban black KWW IQ educIQ;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA;
test KWW, IQ;
run;
*With both KWW and IQ in the model, the coefficient on educ is .009, which is much smaller than when just one
of the variables is used;

*Part iii;
*KWW is significant at the 5% level with a t-stat of 2.12. IQ is not significant in the model.
Jointly the variables are significant at the 15% level but not strong enough that we would include them in 
our model;

*Chapter 9 Question C3;
proc import datafile = "&path\jtrain.xls"
dbms = xls out = jtrain replace;
run;

*Part i;
*If the grants were awarded based on anything that isn't random, the errors may be correlated with grant.
This could include demographic information, financial information, productivity, etc;

*Part ii;
proc reg data = jtrain;
model lscrap = grant / hcc;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
where year = 1988;
run;

*Part iii;
data jtrainx;
set jtrain;
lscrap87 = lag(lscrap);
run;
proc reg data = jtrainx;
model lscrap = grant lscrap87 /hcc;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
where year = 1988;
run;

*Part iv;
data t;
t = (.831 - 1)/.04444;
put t;
run;
*The T-statistic is -3.8, which is a strong rejection of Ho;

*Part v;
*The t-statistic on grant in part iii becomes even larger in magnitutde, and the t-statistic on lscrap87 becomes
smaller in magnitude;


*Chapter 9 Question C4;
proc import datafile = "&path\infmrt.xls"
dbms = xls out = infomart;
run;

*Part i;
proc reg data = infomart;
model infmort = lpcinc lphysic lpopul DC;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
where year = 1990;
run;
*DC has a t-stat of 9.06, so it is extremely significant. It has a coefficient of 16.03 
which means that the infant mortality rate is 16.03% higher if you are in Washington DC;

*Part ii;
*The intercept and other coefficients in this model are exactly the same when DC is dropped compared to when it is 
included. We can see that for predicting in all cases, the single observation from DC is not needed because it is 
only active for the single observation where DC would = 1;


*Chapter 9 Question C5;
proc import datafile = "&path\rdchem.xls"
dbms = xls out = rdchem;
run;

*Part i;
data rdchem;
set rdchem;
salesbil = sales / 1000;
salesbilsq = salesbil**2;
run;

proc reg data = rdchem;
model rdintens = salesbil salesbilsq profmarg;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;

proc reg data = rdchem;
model rdintens = salesbil salesbilsq profmarg;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
where salesbil < 39;
run;
*With the largest firm in the model, the quadratic sales term is significant at the 10% level. Without the largest
firm in the model, the quadratic term is not significant. This large firm greatly increases the variation in sales
which could explain why the quadratic term is significant;

*Part ii;
data rdchemx;
set rdchem;
cons = 1;
if salesbil > 39 then DELETE;
run;

data rdchemxx;
set rdchem;
cons = 1;
run;

proc iml ; /*Least absolute values*/
  use rdchemx;
  read all;
  a = cons || salesbil || salesbilsq || profmarg;
  b= rdintens;
  opt= { . 3  1 1 }; 
  call lav(rc,xr,a,b,,opt); /*print out the estimates*/
  
  opt= { . 0  0 1 }; 
  call lav(rc,xr,a,b,,opt); /*no print out but to create the xr*/
 
  pred = a*t(xr);
  resid = b - pred;
  create _temp_ var { rdintens cons salesbil salesbilsq profmarg pred resid};
  append;
quit;

proc iml ; /*Least absolute values*/
  use rdchemxx;
  read all;
  a = cons || salesbil || salesbilsq || profmarg;
  b= rdintens;
  opt= { . 3  1 1 }; 
  call lav(rc,xr,a,b,,opt); /*print out the estimates*/
  
  opt= { . 0  0 1 }; 
  call lav(rc,xr,a,b,,opt); /*no print out but to create the xr*/
 
  pred = a*t(xr);
  resid = b - pred;
  create _temp_ var { rdintens cons salesbil salesbilsq profmarg pred resid};
  append;
quit;
*Without the larger firm included our model is rdintens = 1.41 + 0.264 salesbil - .006 salesbilsq + 0.11 profmarg

*With the larger firm we get: rdintens = 2.61 -.222 salesbil + .017 salesbilsq + .076 profmarg

The major difference between these two equations is that the signs on salesbil and salesbilsq changed.;


*Part iii;
 *I would say that OLS is more resistant to outliers. The magnitude of the coefficients changed under OLS, but the signs didn't. This is a major change
that only happened under LAD.;

*Chapter 9 Question C6;
proc import datafile = "&path\meap93.xls"
dbms = xls out = meap;
run;

*Part i;
proc freq data = meap;
table bensal;
run;
*There are four examples where benefits are less than 1% of a teachers' salary;

*Part ii;
proc reg data = meap;
model lsalary = bensal lenroll lstaff droprate graduate;
ods select Nobs FitStatistics ParameterEstimates;
where bensal > .01;
run;
*The estimated tradeoff is reduced by a significant amount from .589 to .421. This is pretty large considering
we only removed four out of 408 observations;


*Chapter 9 Question C7;
proc import datafile = "&path\loanapp.xls"
dbms = xls out = loan;
run;

*Part i;
proc freq data = loan;
table obrat;
where obrat > 40;
run;
*There are 205 observations with obrat > 40 out of 1989 total observations;

*Part ii;
proc reg data = loan;
model approve = white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
where obrat <= 40;
run;
*We got a coefficient on white of .128. This is the same result that we got in 
the earlier exercise, and this is not altogether surprising since we only removed 205
of 1989 observations.

*Part iii;
*We showed in part ii that white doesn't seem very sensitive to the size of 
the sample used;


*Chapter 8 Question C8;
proc import datafile = "&path\twoyear.xls"
dbms = xls out = twoyear;
run;

*Part i;
proc means data = twoyear std mean;
var stotal;
run;

*Part ii;
proc reg data = twoyear;
model jc = stotal;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;

proc reg data = twoyear;
model univ = stotal;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;

*When JC is regressed on stotal, the t-statistic is only 1.02. This means that even
though the slope is positive, the relationship is very very weak and insignificant.

However, when univ is regressed on stotal the t-statistic is 39.68, meaning that 
the relationship is extremely significant. The coefficient is also positive at 1.17.

Both variables are positive correlated with stotal.;

*Part iii;
data twoyear;
set twoyear;
totcoll = jc + univ;
stotalsq = stotal**2;
run; 
proc reg data = twoyear;
model lwage = jc univ exper stotal;
ods select NObs FitStatistics ANOVA ParameterEstimates TestANOVA;
run;

proc reg data = twoyear;
model lwage = jc totcoll exper stotal;
ods select NObs FitStatistics ANOVA ParameterEstimates TestANOVA;
run;
*We add stotal to the model and then we can find the standard error of the difference.
We add a variable totcoll = jc + univ to the model, and this makes the coefficient on jc the 
difference in the estimated returns, with its standard deviation. As we can see from the 
second regression using totcoll, the coefficient on jc is the same as Bjc - Buniv in the first
model. Now we have the standard error of this difference. We get a t-statistic of -.80
compared to -1.48 in equation 4.27. This provides even weaker evidence against 
Bjc < Buniv;

*Part iv;
proc reg data = twoyear;
model lwage = jc univ exper stotal stotalsq;
ods select NObs FitStatistics ANOVA ParameterEstimates TestANOVA;
run;
*The quadratic does not seem necessary, with a t-statistic of only .40;

*Part v;
data twoyear;
set twoyear;
stotaljc = stotal*jc;
stotaluniv = stotal*univ;
run;

proc reg data = twoyear;
model lwage = jc univ exper stotal stotaljc stotaluniv;
ods select NObs FitStatistics ANOVA ParameterEstimates TestANOVA;
test stotaljc, stotaluniv;
run;
*The interactions terms are not jointly significant at the 10% level with a F Value of 1.96 
and a p-value of .1410;

*Part vi;
*I would use the model in Part iii. The other models were not any better and were using
additional variables that just complicated the model;


*Chapter 9 Question C9;
proc import datafile = "&path\401ksubs.xls"
dbms = xls out = four;
run;

*Part i;
proc reg data = four;
model nettfa = inc incsq age agesq male e401k;
output out = fourx r = uhat;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on e401k means that, all else held fixed, a family eligible for a 401k
has net financial assets of $9714 greater than a family that's not eligible for a plan;

*Part ii;
data fourx;
set fourx;
uhatsq = uhat**2;
run;

proc reg data = fourx;
model uhatsq = inc incsq age agesq male e401k;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*The F value from regression the squared residuals on all the independent variables is 59.97.
This gives a resulting p-value of <.001, which shows us strong evidence of heteroskedasticity;

*Part iii;
data fourxx;
set fourx;
cons = 1;
run;

proc iml ; /*Least absolute values*/
  use fourxx;
  read all;
  a = cons || inc || incsq || age || agesq || male || e401k;
  b=nettfa;
  opt= { 1000 3  1 1 }; 
  call lav(rc,xr,a,b,,opt); /*print out the estimates*/
  
  opt= { 1000 0  0 1 }; 
  call lav(rc,xr,a,b,,opt); /*no print out but to create the xr*/
 
  pred = a*t(xr);
  resid = b - pred;
  create _temp_ var { nettfa cons inc incsq age agesq male e401k pred resid};
  append;
quit;
**From LAD we get nettfa = 12.49 - .262 inc + .007 incsq - .723 age + .011 agesq + 1.018 male + 3.737 e401k;
*The coefficient on e401k is now 3.737, so nettfa is $3737 higher for families that are eligible for 401k's.;

*Part iv;
*The findings from part i and iii are not in conflict. We see that e401k has a much higher impact on mean wealth than median wealth.;


*Chapter 9 Question C10;
proc import datafile = "&path\jtrain2.xls"
dbms = xls out = jtrain2;
run;
proc import datafile = "E:\Econometrics Supplement\Data Sets\jtrain3.xls"
dbms = xls out = jtrain3 replace;
run;

*Part i;
proc freq data = jtrain2;
table train;
run;

proc freq data = jtrain3;
table train;
run;
*In jtrain3, only 6.92% received training, compared to 41.57% in jtrain2. This is most 
likely because in jtrain3, people had to seek out their own training, and are much less
likely to do so;

*Part ii;
proc reg data = jtrain2;
model re78 = train;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*Job training has a coefficient of 1.79, meaning that if one participates in training
they can expect to earn about $1,794 more than someone who doesn't receive training;

*Part iii;
proc reg data = jtrain2;
model re78 = train re74 re75 educ age black hisp;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The esimated effect is now 1.65, so training leads to an increase in earnings of about $1,647;

*Part iv;
proc reg data = jtrain3;
model re78 = train;
ods select ParameterEstimates;
run;

proc reg data = jtrain3;
model re78 = train re74 re75 educ age black hisp;
ods select ParameterEstimates;
run;
*bad data;

*Part v;
data jtrain2x;
set jtrain2;
avgre = (re74 + re75)/2;
run;
*bad data;

proc means data = jtrain2x mean std min max;
var avgre;
run;

proc means data = jtrain3 mean std min max;
var avgre;
run;
*bad data;

*Part vi;
proc reg data = jtrain2x;
model re78 = train re74 re75 educ age black hisp;
where avgre <= 10; **check if this is 10 or 10000;
ods select ParameterEstimates;
run;

proc reg data = jtrain3;
model re78 = train re74 re75 educ age black hisp;
where avgre <= 10;
ods select ParameterEstimates;
run;
*bad data;

*Part vii;
proc reg data = jtrain2x;
model re78 = train;
where unem74 = 1 and unem75 = 1;
ods select ParameterEstimates;
run;

proc reg data = jtrain3;
model re78 = train;
where unem74 = 1 and unem75 = 1;
ods select ParameterEstimates;
run;
*bad data;

*Part viii;
*discuss;


*Chapter 9 Question C11;
proc import datafile = "&path\murder.xls"
dbms = xls out = murder replace;
run;

data murder;
set murder;
lagmrate = lag (mrdrte);
if year ne 93 then DELETE;
run;

*Part i;
proc reg data = murder;
model mrdrte = exec unem;
ods select NOBS FitStatistics ANOVA ParameterEstimates;
run;
*Exec has a coefficient of .085, which means that for each person executed you can expect
an increase in murders of .085 per 100,000 people in that area. This means capital punishment
is having opposite of the expect deterrant effect;

*Part ii;
proc print data = murder;
var state exec;
run;
*We can see that Texas has 34 observations. The next highest is 11 in virginia;

data murder;
set murder;
if state = 'TX' then Texas = 1; else Texas = 0;
run;

proc means data = murder;
var Texas;
run;

proc reg data = murder;
model mrdrte = exec unem Texas;
ods select NOBS FitStatistics ANOVA ParameterEstimates;
run;
*The T-statistic on Texas is actually very small, at -.32. From this model Texas
does not appear as an outlier;

*Part iii;
proc reg data = murder;
model mrdrte = exec unem lagmrate;
ods select NOBS FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on exec is now -.07131 from .085. This is the sign that we would expect. Its
t-statistic is now -2.34 instead of .30, making it much more significant;

*Part iv;
proc reg data = murder;
model mrdrte = exec unem lagmrate Texas;
ods select NOBS FitStatistics ANOVA ParameterEstimates;
run;
*When we add Texas to the model with the lagged murder rate, it still doesn't appear
to be an outlier. Its t-stat is still only -.37.;

data murderx;
set murder;
if state = 'TX' then DELETE;
run;

proc reg data = murderx;
model mrdrte = exec unem lagmrate;
ods select NOBS FitStatistics ANOVA ParameterEstimates;
run;
*Dropping the observation for Texas from the data, the value of exec changes to -.0454 from 
-.07131. This is a large change. The t-stat on exec is also now -0.60 instead of -2.34. This
result would present evidence that Texas is an outlier.;


*Chapter 9 Question C12;
proc import datafile = "&path\elem94_95.xls"
dbms = xls out = elem;
run;

*Part i;
proc reg data = elem;
model lavgsal = bs lenrol lstaff lunch / hcc;
ods select NOBS FitStatistics ANOVA ParameterEstimates;
run;
*Bs is significant under regular standard errors, but is only significant at the 10% level 
under robust standard errors.;

*Part ii;
data elemx;
set elem;
if bs > .5 then DELETE;
run;

proc reg data = elemx;
model lavgsal = bs lenrol lstaff lunch / hcc;
ods select NOBS FitStatistics ANOVA ParameterEstimates;
run;
*Dropping the four large values of bs, we see that bs is no longer significant at the 10%
level under either OLS or Robust standard errors;

*Part iii;
proc print data = elem;
where bs > .5;
run;

data elemxx;
set elem;
if _n_ = 68 then d68 = 1; else d68 = 0;
if _n_ = 1127 then d1127 = 1; else d1127 = 0;
if _n_ = 1508 then d1508 = 1; else d1508 = 0;
if _n_ = 1670 then d1670 = 1; else d1670 = 0;
run; 

proc reg data = elemxx;
model lavgsal = bs lenrol lstaff lunch d68 d1127 d1508 d1670 / hcc;
ods select NOBS FitStatistics ANOVA ParameterEstimates;
run;
*d1508 is significant at the 5% level under OLS standard errors. All of the dummies are 
significant at the 5% level under robust standard errors;

*Part iv;
data elemxxx;
set elem;
cons = 1;
if _n_ = 1508 then DELETE;
run;

proc reg data = elemxxx;
model lavgsal = bs lenrol lstaff lunch / hcc;
ods select NOBS FitStatistics ANOVA ParameterEstimates;
run;
*Dropping obs 1508 changes the coefficient on bs from -.52 to -.20. The other coefficients
change much more slightly. This is a huge change for one observation out of 1848;

data elemxxxx;
set elem;
if _n_ = 1670 then DELETE;
run;

proc reg data = elemxxxx;
model lavgsal = bs lenrol lstaff lunch / hcc;
ods select NOBS FitStatistics ANOVA ParameterEstimates;
run;

data elemv;
set elem;
if _n_ = 1127 then DELETE;
run;

proc reg data = elemv;
model lavgsal = bs lenrol lstaff lunch / hcc;
ods select NOBS FitStatistics ANOVA ParameterEstimates;
run;

data elemvv;
set elem;
if _n_ = 68 then DELETE;
run;

proc reg data = elemvv;
model lavgsal = bs lenrol lstaff lunch / hcc;
ods select NOBS FitStatistics ANOVA ParameterEstimates;
run;
*The other three variables only change the coefficient on bs by ~.02-.04 by themselves. 
This is significant but nothing compared to the outlier power of d1508;

*Part v;
*We can conclude that OLS still has sensitivity to outliers, even if the sample sizes 
are large. In this case we had a very large sample of n = 1848, and yet one observation
was able to sway a coefficient by over 60%. This is quite drastic, and shows that large 
samples are not the only thing we need for a good model;

*Part vi;
data elemtxx;
set elemxx;
cons = 1;
run;

proc iml ; /*Least absolute values*/
  use elemtxx;
  read all;
  a = cons || bs || lenrol || lunch || d68 || d1127 || d1508 || d1670 ;
  b=lavgsal;
  opt= { 1000 3  0 1 }; 
  call lav(rc,xr,a,b,,opt); /*print out the estimates*/
  
  opt= { 1000 0  . 1 }; 
  call lav(rc,xr,a,b,,opt); /*no print out but to create the xr*/
 
  pred = a*t(xr);
  resid = b - pred;
  create _temp_ var { lavgsal cons bs lenrol lunch d68 d1127 d1508 d1670 pred resid};
  append;
quit;
*Under LAD, the significance of d1508 is much lower than under OLS. The t-stat is only ~3.46 compared to over 11 under OLS. 
The coefficient is also smaller. This shows that LAD reacts much less to a single large observation;


*Chapter 9 Question C13;
proc import datafile = "&path\ceosal2.xls"
dbms = xls out = ceosalc13;
run;

data ceosalc13;
set ceosalc13;
cons = 1;
run;

*Part i;
proc reg data = ceosalc13;
model lsalary = lsales lmktval ceoten ceotensq;
output out = ceosalc13x student = stures;
ods select NOBS FitStatistics ANOVA ParameterEstimates;
run;

*Part ii;
proc freq data = ceosalc13x;
table stures;
where stures > 1.96 or stures < -1.96;
run;
*There are 9 observations that fall outside of the [-1.96,1.96] interval;
*Since 95% of observations fall within 2 standard deviations of the mean, we would
expect 8.85 observations out of 177 to be outside of 2 standard deviations. Our result
mirrors this;

*Part iii;
proc reg data = ceosalc13x;
model lsalary = lsales lmktval ceoten ceotensq;
ods select NOBS FitStatistics ANOVA ParameterEstimates;
where stures <= 1.96 and stures >= -1.96;
run;
*The coefficients on lmktval ceoten and ceotensq all increased in absolute value. The 
coefficient on lsales decreased slightly;

*Part iv;
proc iml ; /*Least absolute values*/
  use ceosalc13;
  read all;
  a = cons || lsales || lmktval || ceoten || ceotensq;
  b= lsalary;
  opt= { 1000 3  0 1 }; 
  call lav(rc,xr,a,b,,opt); /*print out the estimates*/
  
  opt= { 1000 0  . 1 }; 
  call lav(rc,xr,a,b,,opt); /*no print out but to create the xr*/
 
  pred = a*t(xr);
  resid = b - pred;
  create _temp_ var { lavgsal cons bs lenrol lunch d68 d1127 d1508 d1670 pred resid};
  append;
quit;
*The estimate of B1 is closer to the model using the restricted sample. B3 is closer to the model using the full sample.;

*Part v;
*In this case, each estimate other than B3 was closer using the OLS model that dropped the outliers based on studentized residuals. 
I would not say with 100% certainty that dropping studentized residuals makes the resulting OLS model closer to LAD, but it seems for 
most of the variables this is a true fact;
