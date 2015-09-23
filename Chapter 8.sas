********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/


%let path = F:\Data Sets;
*Chapter 8;
%let path = F:\Econometrics Supplement\Data Sets;
*Chapter 8 Question C1;
proc import datafile = "&path\sleep75.xls"
dbms = xls out = sleep;
run;

*Part i;
*Var(u|totwrk, educ, age yngkid, male) = var(u|male) = d0 + d1 male.
Thus for women the variance is d0 and for men it is d0 + d1;

*Part ii;
proc reg data = sleep;
model sleep = totwrk educ age agesq yngkid male;
output out = sleepx r = uhat;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;

data sleepxx;
set sleepx;
uhatsq = uhat**2;
run;

proc reg data = sleepxx;
model uhatsq = male;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*Since the coefficient on male is negative, the variance is higher for women;

*Part iii;
*No, the t-stat on male is only -1.06, giving us a p-value of .2909 which is not significant;

*****************************

*Chapter 8 Question C2;
proc import datafile = "&path\hprice1"
dbms = xls out = hprice;
run;

*Part i;
proc reg data = hprice;
model price = lotsize sqrft bdrms / hcc;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The Heteroscedasticity consistent standard errors are higher for each variable except for bdrms. This causes lotsize to 
become much less significant, sqrft is still very significant, and bdrms is now just a bit more significant;

*Part ii;
proc reg data = hprice;
model lprice = llotsize lsqrft bdrms / hcc;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The robust standard error increased slightly for log(lotsize), but it is still significant. The same effect occured for log(sqrft).
The standard error increased slightly for bdrms. It wasn't significant before and is slightly less so now;

*Part iii;
*Using a log transformation often removes the issue of heteroskedasticity. This is the case here as the model does not depend on 
choosing a specific type of standard error;

****************************************

*Chapter 8 Question C3;
proc import datafile = "&path\hprice1.xls"
dbms = xls out = hprice1;
run;

proc reg data = hprice1;
model lprice = llotsize lsqrft bdrms;
output out = hprice1x r = uhat;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;

data hprice1xx;
set hprice1x;
uhatsq = uhat**2;
llotsizesq = llotsize**2;
lsqrftsq = lsqrft**2;
bdrmssq = bdrms**2;
llotsizesqrft = llotsize*lsqrft;
llotsizebdrms = llotsize*bdrms;
lsqrftbdrms = lsqrft * bdrms;
run;

proc reg data = hprice1xx;
model uhatsq = llotsize lsqrft bdrms llotsizesq lsqrftsq bdrmssq llotsizesqrft llotsizebdrms lsqrftbdrms;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;

data nR;
nR = 88*.109;
put nR;
run;
*We obtain the n-R^2 version of the white statistic of 9.59. This is from a X^2(9) variable. This gives us a 
resulting p-value of .385, providing little evidence against the homoskedastic assumption;

**********************************

*Chapter 8 Question C4;
proc import datafile = "&path\vote1.xls"
dbms = xls out = vote;
run;

*Part i;
proc reg data = vote;
model voteA = prtystrA democA lexpendA lexpendB;
output out = votex r = uhat p = fitted;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;

proc reg data = votex;
model uhat = prtystrA democA lexpendA lexpendB;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*Regressing uhat on all the variables gives an R^2 of zero because that is how OLS works. The Beta's are 
chosen to make the residuals uncorrelated with each independent variable;

*Part ii;
data votexx;
set votex;
uhatsq = uhat**2;
fittedsq = fitted**2;
run;

proc reg data = votexx;
model uhatsq = prtystrA democA lexpendA lexpendB;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*The F-value is 2.33 with a resulting p-value of .0581, showing that there is some evidence of heteroskedasticity;

*Part iii;
proc reg data = votexx;
model uhatsq = fitted fittedsq;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*This time the F-value is 2.79 with a p-value of .0645. Again some evidence exists but not quite enough for the
5% level. This is slightly less evidence than the B-P test;

****************************

*Chapter 8 Question C5;
proc import datafile = "&path\pntsprd.xls"
dbms = xls out = spread;
run;

*Part i;
proc reg data = spread;
model sprdcvr = ;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Using the coefficient .515 and standard error .0213 we get a t-stat of .704, which we know is not significant;

*Part ii;
proc freq data = spread;
table neutral;
run;
*35 neutral site games;

*Part iii;
proc reg data = spread;
model sprdcvr = favhome neutral fav25 und25 / hcc;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The variable neutral is by far the most significant, being the only variable with a t-stat greater than one in absolute value.
It also has by far the largest coefficient;

*Part iv;
*Under Ho: B1...B4 = 0 the dependent variable depends on none of the explanatory variables meaning the mean and variance depends
on the explanatory variables;

*Part v;
proc reg data = spread;
model sprdcvr = favhome neutral fav25 und25 / hcc;
test favhome, neutral, fav25, und25;
ods select TestANOVA;
run;
*The F-Value for joint significance is .47 with a resulting p-value of .7597 meaning that these four variables are jointly 
insignificant and that we cannot reject Ho.;

*Part vi;
*Based on the information we are using in these models, it is not possible to predict whether the spread will be covered.
These variables have very little joint significance and their explanatory power is almost zero;

******************************

*Chapter 8 Question C6;
proc import datafile = "&path\crime1.xls"
dbms = xls out = crime replace;
run;

*Part i;
data crimex;
set crime;
if narr86 > 0 then arr86 = 1; else arr86 = 0;
run;

proc reg data = crimex;
model arr86 = pcnv avgsen tottime ptime86 qemp86 / hcc;
output out = crimexx p = fitted r = uhat;
ods select Nobs FitStatistics ParameterEstimates;
run;

proc means data = crimexx max min;
var fitted;
run;
*All fitted values are between zero and one. The smallest is .0066 and largest is .5577;

*Part ii;
data crimexxx;
set crimexx;
weights = 1/(fitted*(1-fitted));
run;

proc reg data = crimexxx;
model arr86 = pcnv avgsen tottime ptime86 qemp86 / hcc;
weight weights;
test avgsen, tottime;
ods select Nobs FitStatistics ParameterEstimates TestANOVA;
run;

*Part iii;
*The F-statistic for the joint significance of avgsen and tottime is .88
with a p-value of .41. They are not jointly significant;

*************************************

*Chapter 8 Question C7;
proc import datafile = "&path\loanapp.xls"
dbms = xls out = loan;
run;

*Part i;
proc reg data = loan;
model approve = white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr / hcc clb;
output out = loanx p = fitted;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*The regular 95% CI on white is 0.090 to 0.16752. The robust 95% CI is 0.07829 to 0.17935;

*Part ii;
proc freq data = loanx;
table fitted;
where fitted <= 0 or fitted >= 1;
run;
*There are zero obs less than 0, but there are 231 observations greater than one. We would need
to perform a transformation of these cases in order to use WLS;

****************************************

*Chapter 8 Question C8;
proc import datafile = "&path\gpa1.xls"
dbms = xls out = gpa;
run;

*Part i;
proc reg data = gpa;
model colGPA = hsGPA ACT skipped PC;
output out = gpax p = fitted r = uhat;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;

*Part ii;
data gpaxx;
set gpax;
uhatsq = uhat**2;
fittedsq = fitted**2;
run;

proc reg data = gpaxx;
model uhatsq = fitted fittedsq;
output out = gpaxxx p = hhat;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*The F-value in the White test is 3.58 with a p-value of .0305. There is evidence of heteroskedasticity at the 5% 
level;

*Part iii;
proc means data = gpaxxx;
var hhat;
run;
*All values are >0;

proc reg data = gpaxxx;
model colGPA = hsGPA ACT skipped PC / hcc;
weight hhat;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*The WLS estimates are very close to their OLS estimates in terms of coefficient and t-statistics;

*Part iv;
*The standard errors do not change very much at all when using robust errors vs OLS standard errors. None
of the variables changed in their significance;

**********************************

*Chapter 8 Question C9;
proc import datafile = "&path\smoke.xls"
dbms = xls out = smoke;
run;

*Part i;
proc reg data = smoke;
model cigs = lincome lcigpric educ age agesq restaurn;
output out = smokex p = yhat r = uhat;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;

*Part ii;
data smoke222;
set smokex;
usq = uhat**2;
logusq = log(usq);
run;
proc reg data = smoke222;
model logusq = lincome lcigpric educ age agesq restaurn;
output out = smoke333 p = ttt;
ods select none;
run;
data smoke333x;
set smoke333;
weighted = 1/(exp(ttt));
run;
proc reg data = smoke333x;
model cigs = lincome lcigpric educ age agesq restaurn;
weight weighted;
output out = smokeq p = yu r = uu;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
***are these unweighted residuals?****

*Part iii;
data smokeqq;
set smokeq;
usqu = uu / sqrt(weighted);
ysqu = yu / sqrt(weighted);
usqusq = usqu**2;
ysqusq = ysqu**2;
uusq = uu**2;
yusq = yu**2;
run;

proc reg data = smokeqq;
model uusq = yu yusq;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
**using the residuals we found from above regression, without weighting by 1/sqrt(hi)****;
**if we obtain unweighted residuals from the regression and then weight, we would have, model usqusq = ysqu ysqusq, above;


data hetero;
f = ((.0257/2)/((1-.0257)/(807-2-1)));
put f;
run;
*Using K=2 and equation 8.15, and R-Squared (U^2) = .0257, we obtain an F-statistic of 10.6. Which will provide a p-value of near zero, which allows us to conclude
that heteroskedasticity is present;

**Given solution is F=11.15, using R-squared = .027, again possibly from NEEDING unweighted residuals from our regression so we can weight them 
manually by 1/sqrt(hi), with hi being obtained above as the variable WEIGHTED;

*Part iv;
*The results from part iii show us that feasible GLS does not eliminate heteroskedasticity. Therefore, our test statistics are all invalid.;

*Part v;
proc reg data = smoke333x;
model cigs = lincome lcigpric educ age agesq restaurn / hcc;
weight weighted;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*When we obtain heteroskedastic robust standard errors we see that there are large differences between the standard errors. This is another indication 
that the correction for heteroskedasticity did not do the trick.;

********************************

*Chapter 8 Question C10;
proc import datafile = "&path\401ksubs.xls"
dbms = xls out = foursubs;
run;

*Part i;
proc reg data = foursubs;
model e401k = inc incsq age agesq male / hcc;
output out = foursubsx p = fitted r = resid;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*There are no import differences in the standard errors;

*Part ii;
*Since Var(y|x) = p(x)[1-p(x)] we can say that: E[u^2|x] = p(x) - [p(x)]^2. 
Written in error form: u^2 = p(x) - [p(x)]^2 + v.
We can write this as a regression model: u^2 = d0 + d1*p(x)+d2*[p(x)]^2 + v with the restrictions
d0 = 0, d1 = 1, and d2 = -1. 
For the LPM, the fitted values are estimates of p(xi) = B0 + B1*xi1 + ... + Bk*xik. 
So when we regress ui^2 on yi yi^2(including an intercept), the intercept estimate should be close to zero,
the coefficient on yi should be close to one, and the coefficient on yi^2 should be close to -1.;

*Part iii;
data foursubsxx;
set foursubsx;
uhatsq = resid**2;
yhat = fitted;
yhatsq = fitted**2;
run;

proc reg data = foursubsxx;
model uhatsq = yhat yhatsq;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The white F-value is 310.32, which is very significant. The coefficient on yhat (yi) is 1.01, which is very close to 
the predicted value of 1.0. The coefficient on yhatsq (yi^2) is -.97, which is very close to the predicted -1.0.
The coefficient on the intercept is -0.0009, which is very close to the predicted value of 0.0;

*Part iv;
proc means data = foursubsx max min;
var fitted;
run;
*All observations are in the [0,1] interval;

data foursubsxxx;
set foursubsxx;
weight = 1/fitted;
run;

proc reg data = foursubsxxx;
model e401k = inc incsq age agesq male;
weight weight;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*There are no important differences from the OLS model. The largest change is on male, but this is a very 
insignificant variable in both models;

************************************

*Chapter 8 Question C11;
proc import datafile = "&path\401ksubs.xls"
dbms = xls out = four;
run;

data four;
set four;
if fsize ne 1 then DELETE;
ageterm = (age - 25)**2;
e401kinc = e401k*inc;
run;

*Part i;
proc reg data = four;
model nettfa = inc ageterm male e401k e401kinc / hcc;
output out = fourx p = fitted r = resid;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*Under OLS standard errors the interaction term is very significant with a t-stat of 2.78.
Under robust standard errors the interaction term is not significant, with a t-stat of 1.56;

*Part ii;
data fourxx;
set fourx;
weight = 1/fitted;
run;

proc reg data = fourxx;
model nettfa = inc ageterm male e401k e401kinc / hcc;
weight weight;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The interaction term is statistically significant using the robust standard errors
with a t-stat of 2.50 and a p-value of .0124;

*Part iii;
*The WLS coefficient on e401k is -6.68. This means that if an individual is eligible for a 
401k, their net financial assets are predicted to decrease by -6.68 or $6680. This is 
keeping income fixed at a zero level;

*Part iv;
data fourxxx;
set fourxx;
e401kinc30 = e401k*(inc - 30);
run;

proc reg data = fourxxx;
model nettfa = inc ageterm male e401k e401kinc30 / hcc;
weight weight;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*Now the coefficient on e401k is 3.84. This is keeping income fixed at the 30, which is near
the average level of income in the sample. This means that with income fixed, the predicted
result of being eligible for a 401k is an increase of 3.84, or $3844.;

************************

*Chapter 8 Question C12;
proc import datafile = "&path\meap00.xls"
dbms = xls out = meap;
run;

*Part i;
proc reg data = meap;
model math4 = lunch lenroll lexppp / hcc;
output out = meapx p = fitted r = resid;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The robust standard errors are higher across the board. It only changes the significance of 
the log(exppp) variable, causing it to no longer be significant at the 10% level;

*Part ii;
data meapxx;
set meapx;
uhatsq = resid**2;
luhatsq = log(uhatsq);
yhat = fitted;
yhatsq = fitted**2;
run;

proc reg data = meapxx;
model uhatsq = yhat yhatsq;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The F-value of the White test is 132.71, which is very significant. We can strongly
conclude that there is heteroskedasticity present;

*Part iii;
proc reg data = meapxx;
model luhatsq = yhat yhatsq;
output out = meapxxx p = ghat;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;

data meapxxx;
set meapxxx;
hhat = exp(ghat);
weight = 1/hhat;
run;

proc reg data = meapxxx;
model math4 = lunch lenroll lexppp / hcc;
weight weight;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*Under WLS, the intercept coefficient has decreased by nearly half. 
Lunch has stayed the same. Log(enroll) has decreased by roughly half in absolute value.
Log(exppp) has increased by nearly half;

*Part iv;
*The robust standard errors are slightly lower for lunch, and roughly .20 higher for
log(enroll) and log(exppp). It doesn't affect the significance of any variables at the
5% level;

*Part v;
*I would argue that WLS provides better estimates of the effect of spending on math4. 
All variables are statistically significant under WLS, as opposed to log(exppp) not being
significant under OLS. The R^2 are within ~1% of each other.;

*******************************

*Chapter 8 Question C13;
proc import datafile = "&path\fertil2.xls"
dbms = xls out = fertil;
run;

*Part i;
proc reg data = fertil;
model children = age agesq educ electric urban / hcc;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The robust standard errors are larger for age, and age^2. They are the same for educ.
They are smaller for electric and urban;

*Part ii;
proc reg data = fertil;
model children = age agesq educ electric urban spirit protest catholic / hcc;
output out = fertilx p = yhat r = uhat;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA ACovTestANOVA;
test spirit, protest, catholic;
run;
*Under the robust F-Test, the p-value is .0904, and under the OLS F-Test the p-value is
0.864. This are not significantly different from each other;

*Part iii;
data fertilx;
set fertilx;
uhatsq = uhat**2;
yhatsq = yhat**2;
weight = 1/yhat;
run;

proc reg data = fertilx;
model uhatsq = yhat yhatsq;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA;
run;
*With an F-Value of 726.11, we can strongly conclude that heteroskedasticity is present;

*Part iv;
proc reg data = fertilx;
model children = age agesq educ electric urban spirit protest catholic / hcc;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA;
weight weight;
run;
*I would conclude that the heteroskedasticity is very important. Under WLS,
Urban is no longer significant at all. Also, protest and catholic become less significant by
a very wide margin.;

*************************************

*Chapter 8 Question C14;
proc import datafile = "&path\beauty.xls"
dbms = xls out = beauty;
run;

*Part i;
proc reg data = beauty;
model lwage = belavg abvavg female educ exper expersq;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA;
run;
*It is surprising that abvavg has a negative coefficient. The coefficient on female is 
-.453 and is very significant. This is very surprising. It is not surprising that females 
are paid a lower wage on average, but a 45.3% decrease compared to males when controlling
for educ, looks, and experience, is very shocking;

*Part ii;
data beautyx;
set beauty;
femalebelavg = female*belavg;
femaleabvavg = female*abvavg;
femaleeduc = female*educ;
femaleexper = female*exper;
femaleexpersq = female*expersq;
run;

proc reg data = beautyx;
model lwage = belavg abvavg female educ exper expersq femalebelavg femaleabvavg femaleeduc 
femaleexper femaleexpersq / hcc;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA ACovTestANOVA;
test femalebelavg, femaleabvavg, femaleeduc, femaleexper, femaleexpersq;
run;
*With OLS standard errors our f-value for the joint significance of the interaction terms is
3.43. Under robust standard errors our Chi-Square value is 19.32. Under both of these tests
the p-value is significant at the 1% level, so we know they are jointly significant;

*Part iii;
proc reg data = beautyx;
model lwage = belavg abvavg female educ exper expersq femalebelavg femaleabvavg femaleeduc 
femaleexper femaleexpersq / hcc;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA ACovTestANOVA;
test femalebelavg, femaleabvavg;
run;
*The two interaction variables dealing with attractiveness are not jointly significant
under either OLS or robust versions of the test. I would not say that the 
coefficients are practically small, being .044 and .082, (4.4% and 8.2% effect on lwage), 
but they are both statistically insignificant;

*******************************


