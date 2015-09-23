********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/


%let path = F:\Data Sets;

*Chapter 7;
%let path = F:\Econometrics Supplement\Data Sets;
*Chapter 7 Question C1;
proc import datafile = "&path\gpa1.xls"
dbms = xls out = gpa1;
run;

*Part i;
proc reg data = gpa1;
model colGPA = PC hsGPA ACT mothcoll fathcoll;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The effect on PC has hardly changed, going from .157 to .151 and it is still significant with t stat of 2.59;

*Part ii;
proc reg data = gpa1;
model colGPA = PC hsGPA ACT mothcoll fathcoll;
test mothcoll, fathcoll;
ods select TestANOVA;
run;

*The f-value of the two parents college variables is about .24, with a p-value of .7834. 
They are not jointly significant;

*Part iii;
data gpa1x;
set gpa1;
hsgpasq = hsGPA**2;
run;

proc reg data = gpa1x;
model colGPA = PC hsGPA ACT mothcoll fathcoll hsgpasq;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The hsGPAsq variable is only significant at around the 12% significance level. It drops the coefficient of 
the main variable, PC, and it has a relatively large coefficient of .337. It would become the individuals 
choice with this variable, as it doesn't appear to harm the equation or provide much benefit in either way;

************************

*Chapter 7 Question C2;
proc import datafile = "&path\wage2.xls"
dbms = xls out = wage2;
run;

*Part i;
proc reg data = wage2;
model lwage = educ exper tenure married black south urban;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The difference between blacks and nonblacks is about 18.8% due to the coefficient on black being -.18835. 
The t-stat on the variable black is -5, so this is very significant;

*Part ii;
data wage2x;
set wage2;
expersq = exper**2;
tenuresq = tenure**2;
run;

proc reg data = wage2x;
model lwage = educ exper tenure married black south urban expersq tenuresq;
test expersq, tenuresq;
ods select TestANOVA;
run;
*The test for joint significance of the two new variables gives an F-value of 1.49, with a resulting p-value of .2260.
This means these variables are only significant at the 22.6% significance level;

*Part iii;
data wage2xx;
set wage2x;
blackeduc = black*educ;
run;

proc reg data = wage2xx;
model lwage = educ exper tenure married black south urban blackeduc;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The t-stat of the interaction variable is only 1.12, with a p-value of .2626, which means this is not 
significant enough to show that the return to education is different based on race;

*Part iv;
data wage2xxx;
set wage2xx;
if married = 1 and black = 0 then marrnonblck = 1; else marrnonblck = 0;
if married = 0 and black = 1 then singblck = 1; else singblck = 0;
if married = 1 and black = 1 then marrblck = 1; else marrblck = 0;
run;

proc reg data = wage2xxx;
model lwage = educ exper tenure south urban marrnonblck singblck marrblck;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The difference between married nonblacks and married blacks is .18891 - .00945 = .17946. 
This means that a married black man earns about 18% less than a married nonblack man;

********************************

*Chapter 7 Queston C3;
proc import datafile = "&path\mlb1.xls"
dbms = xls out = mlb1;
run;

*Part i;
*Ho: B13(catcher) = 0. Hypothesis that the group catchers wouldn't differ from the base group, outfielders;

proc reg data = mlb1;
model lsalary = years gamesyr bavg hrunsyr rbisyr runsyr fldperc allstar frstbase scndbase thrdbase shrtstop catcher;
ods select Nobs FitStatistics ParameterEstimates;
run;
*We would reject the null at about the 5% significance level due to the p-value of .0543 on catcher;

*Part ii;
*Joint hypothesis where B9=B10=B11=B12=B13 = 0;
proc reg data = mlb1;
model lsalary = years gamesyr bavg hrunsyr rbisyr runsyr fldperc allstar frstbase scndbase thrdbase shrtstop catcher;
test frstbase, scndbase, thrdbase, shrtstop, catcher;
ods select TestANOVA;
run;
*We can only reject the null at around the 12% significance level due to the p-value of .1168;

*Part iii;
*The results are mostly consistent. The second test includes many variables with much less significance than catcher,
such as thrdbase and shrtstop with t-stats of less than .5 in absolute value.;

*************************

*Chapter 7 Question C4;
proc import datafile = "&path\gpa2.xls"
dbms = xls out = gpa2;
run;

*Part i;
*We would expect B3 < 0 since the smaller the number the better the student, and we would expect B4 > 0. 
The others we cannot be certain about;

*Part ii;
proc reg data = gpa2;
model colgpa = hsize hsizesq hsperc sat female athlete;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The estimated difference is athletes tend to be .17 points better than non athletes. This has a t-stat of 4.0, 
so this is very significant;

*Part iii;
proc reg data = gpa2;
model colgpa = hsize hsizesq hsperc female athlete;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Now the effect of being an athlete is only .00055 and this has a t-stat of .12 which is not significant at all. 
This happens because we're no longer accounting for student quality via SAT, and on average athletes have lower 
SAT scores;

*Part iv;
data gpa2x;
set gpa2;
if female = 1 and athlete = 1 then femaleath = 1; else femaleath = 0;
if female = 0 and athlete = 0 then malenoath = 1; else malenoath = 0;
if female = 0 and athlete = 1 then maleath = 1; else maleath = 0;
femalesat = female*sat;
run;

proc reg data = gpa2x;
model colgpa = hsize hsizesq hsperc sat femaleath malenoath maleath;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Using non athlete females as a basegroup, female athletes have a coefficient of .17511. With a t-stat of 2.08 this is 
significant at the 5% level. Thus there is about a .18 increase in GPA of female athletes vs female non athletes;

*Part v;
proc reg data = gpa2x;
model colgpa = hsize hsizesq hsperc sat femaleath malenoath maleath femalesat;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Introducing an interaction variable between female and sat gives a coefficient of effectively zero that is not 
statistically significant. Thus we can say that the effect of SAT on colGPA does not vary by gender;

****************************

*Chapter 7 Question C5;
proc import datafile = "&path\ceosal1.xls"
dbms = xls out = ceosal1;
run;

data ceosal1x;
set ceosal1;
if ros < 0 then rosneg = 1; else rosneg = 0;
run;

proc reg data = ceosal1x;
model lsalary = lsales roe rosneg;
ods select Nobs FitStatistics ParameterEstimates;
run;
*We get a coefficient of -.23 on rosneg. This is very statistically significant at the 5% level. This is 
expected since a negative return on stock over a multi year period would look poorly on the CEO, and thus we 
would expect lower pay. In this case that pay decrease would be about 22.6%;

***********************

*Chapter 7 Question C6;
proc import datafile = "&path\sleep75.xls"
dbms = xls out = sleep75;
run;

*Part i;
data sleepmen;
set sleep75;
if male = 0 then DELETE;
run;

data sleepwomen;
set sleep75;
if male = 1 then DELETE;
run;
title "Men";
proc reg data = sleepmen;
model sleep = totwrk educ age agesq yngkid;
ods select Nobs FitStatistics ParameterEstimates;
run;
title;
title "Women";
proc reg data = sleepwomen;
model sleep = totwrk educ age agesq yngkid;
ods select Nobs FitStatistics ParameterEstimates;
run;
title;
*There are several differences. The R^2 is much higher for men than women, roughly 15.6% vs 9.8%. Women are 
greatly effected negatively by a young child, while men are affected positively. The coefficients on age 
are also very different, being positive for men and negative for women, although these effects are changed 
by the quadratic terms, in which the women's quadratic term is much more negative than the mens;

*Part ii;
data sleep75x;
set sleep75;
maletotwrk = male*totwrk;
maleyngkid = male*yngkid;
maleeduc = male*educ;
maleage = male*age;
maleagesq = male*agesq;
run;

proc reg data = sleep75x;
model sleep = totwrk educ age agesq yngkid male maletotwrk maleyngkid maleeduc maleage maleagesq;
test male, maletotwrk, maleyngkid, maleeduc, maleage, maleagesq = 0;
test maletotwrk, maleyngkid, maleeduc, maleage, maleagesq = 0;
ods select Nobs FitStatistics ParameterEstimates TestANOVA;
run;
*The F-statistic is about 2.12 with p-value ~.05, so we reject the null that the sleep equations
are the same at the 5% level;

*Part iii;
*Testing only the 5 male interaction terms and leaving male unspecified, the resulting F-value is 1.26, 
with a p-value of .28;

*Part iv;
*The tests in part ii and iii shows that once an intercept difference is allowed there is not strong evidence
of slope differences between men and women. Thus, we would include the original set of variables in part i for the 
full set of observations, and add the binary variable male;

*****************************

*Chapter 7 Question C7;
proc import datafile = "&path\wage1.xls"
dbms = xls out = wage1;
run;

*Part i;
data genderdifference;
difference125 = -0.227 - 0.0056*12.5;
difference0 = -0.227 - 0.0056*0;
put difference125 difference0;
run;

*The difference with 12.5 years of education is -.297 for women compared to men. With zero education the difference is
-.227;

*Part ii;
data wage1x;
set wage1;
femaleeduc125 = female * (educ - 12.5);
run;

proc reg data = wage1x;
model lwage = female educ femaleeduc125 exper expersq tenure tenursq;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The coefficient on female, -.297, is now the difference in wages at the 12.5 years of education mark;

*Part iii;
*The coefficient is very statistically significant, with a t-stat of -8.27. This is much more significant than in the 
initial model, and this is due to the fact that in the initial model the coefficient was the difference at zero years 
of education. There are not many people with zero years, especially compared to those with 12.5 years or ~~ the average 
years of education in the model;


*******************************

*Chapter 7 Question C8;
proc import datafile = "&path\loanapp.xls"
dbms = xls out = loanapp replace;
run;

*Part i;
*If there is discrmination in the loan market, we would expect B1 > 0 since whites would have a greater chance of 
having a loan approved than minorities;

*Part ii;
proc reg data = loanapp;
model approve = white;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The coefficient on white is .201, which signifies that a white person is 20.1% more likely to be approved. It is 
extremely significant with a t-stat of 10.11;

*Part iii;
proc reg data = loanapp;
model approve = white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Controlling for all these other variables we still have a coefficient of .129 on white, or about a 12.9% increased 
chance of approval for a white person. This has a t-stat of 6.53 and is still very significant;

*Part iv;
data loanappx;
set loanapp;
whiteobrat = white * obrat;
run;

proc reg data = loanappx;
model approve = white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr whiteobrat;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The coefficient of the interaction term is .00809 and its t-stat is 3.53. It is a significant variable. 
This interaction term shows that whites are penalized less than other races for having other obligations of income;

*Part v;
data loanappxx;
set loanapp;
whiteobrat32 = white * (obrat - 32);
run;

proc reg data = loanappxx;
model approve = white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr 
				whiteobrat32 / clb;
ods select Nobs FitStatistics ParameterEstimates;
run;
*By replacing the interaction term with the term white*(obrat-32) the coefficient on white becomes the race difference 
on approval when obrat = 32. The coefficient is .113 so that is the effect, and the confidence 
interval is 0.074 - 0.152;


*******************************

*Chapter 7 Question C9;
proc import datafile = "&path\401ksubs.xls"
dbms = xls out = fourksubs;
run;

*Part i;
proc freq data = fourksubs;
table e401k;
run;
*39.21% of the sample is eligible for a 401k.;

*Part ii;
proc reg data = fourksubs;
model e401k = inc incsq age agesq male;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;

*Part iii;
*401k Participation is clearly dependent on income and gender, as shown by all four related variables having very 
high t-statistics. However, male is very insignificant and shows that 401k participation doesn't vary with gender 
once age and income are controlled for;

*Part iv;
proc reg data = fourksubs;
model e401k = inc incsq age agesq male;
output out = fourksubsx p = fitted;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;

proc means data = fourksubsx max min;
var fitted;
run;
*No fitted values fall outside of [0,1];

*Part v;
data fourksubsxx;
set fourksubsx;
if fitted >= 0.5 then e401kx = 1; else e401kx = 0;
run;

proc freq data = fourksubsxx;
table e401kx;
run;
*26.52% are predicted to be eligible for a 401(k) plan;

*Part vi;
proc freq data = fourksubsxx;
table e401k*e401kx;
run;
*Of the 5638 that are not eligible, 4607 were predicted to not be eligible, or 81.7% correct;
*Of the 3637 that are eligible, 1429 were predicted to be eligible, or 39.3% correct;

*Part vii;
*I feel that the 64.9% overall correct prediction is not very valid due to the size and split of the sample.
Predicting no for everyone in the sample would give us a 60.79% success rate, so this model is really only 
~4% better than just putting no for everyone;

*Part viii;
proc reg data = fourksubs;
model e401k = inc incsq age agesq male pira;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*If a family has a personal IRA account, they are only 1.98% more likely to be eligible for a 401(k) account.
Pira has a t-stat of 1.62, and is not significant at the 10% level;


********************************

*Chapter 7 Question C10;
proc import datafile = "&path\nbasal.xls"
dbms = xls out = nbasal;
run;

*Part i;
proc reg data = nbasal;
model points = exper expersq guard forward;
ods select Nobs FitStatistics ParameterEstimates;
run;

*Part ii;
*The intercept acts as the last dummy variable, so we do not need to include the centers dummy variable.;

*Part iii;
*A guard is expected to score about 2.34 points per game more than a center, and this is significant at the 5% level;

*Part iv;
proc reg data = nbasal;
model points = exper expersq guard forward marr;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The marr is not a significant variable once its added to the equation so we can not say that married 
players score more than non married players;

*Part v;
data nbasalx;
set nbasal;
marrexper = marr*exper;
marrexpersq = marr*expersq;
run;

proc reg data = nbasalx;
model points = exper expersq guard forward marr marrexper marrexpersq;
test marr, marrexper, marrexpersq;
ods select TestANOVA ParameterEstimates;
run;
*The test for the joint significance of the married variables gives an f-value of 1.44 and a p-value of .2304, so 
we can say that these variables are not jointly significant and thus there is not strong evidence that marrital 
status affects points per game;

*Part vi;
proc reg data = nbasalx;
model assists = exper expersq guard forward marr;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Using assists as the dependent variable the coefficient on marr becomes .345 with a t-stat of 1.51. This is significant 
at the 15% level, which shows that there is some evidence but not overwhelmingly strong evidence that marrital 
status affects assists per game;

*************************

*Chapter 7 Question C11;
proc import datafile = "&path\401ksubs.xls"
dbms = xls out = fourksubs;
run;

*Part i;
proc means data = fourksubs mean std min max;
var nettfa;
run;

*Part ii;
proc reg data = fourksubs;
model nettfa = e401k;
ods select Nobs FitStatistics ParameterEstimates;
run;
*e401k has a t-stat of about 14.01 and a coefficient of 18.86 which we can use to strongly reject the 
hypothesis that there is no difference in nettfa based on 401k eligibility status. The dollar amount difference is 
estimated to be 18,858;

*Part iii;
proc reg data = fourksubs;
model nettfa = e401k inc incsq age agesq;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Accounting for these variables e401k has a coefficient of 9.704 and is very significant. The estimated 
dollar difference is 9,704;

*Part iv;
data fourksubsx;
set fourksubs;
e401kage41 = e401k*(age - 41);
e401kage41sq = e401k * ((age - 41)**2);
run;

proc reg data = fourksubsx;
model nettfa = e401k inc incsq age agesq e401kage41 e401kage41sq;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The interaction variable of e401k * (age - 41) is significant with a t-stat of 4.98. The other interaction
variable is not significant;

*Part v;
*From part iii we saw that e401k had a difference of 9.704 at all ages. In part iv we see that at age 41 
e401k predicts a difference of 9.959. There is clearly a difference but it is not a very large difference at this age.;

*Part vi;
data fourksubsxx;
set fourksubs;
if fsize = 1 then fsize1 = 1; else fsize1 = 0;
if fsize = 2 then fsize2 = 1; else fsize2 = 0;
if fsize = 3 then fsize3 = 1; else fsize3 = 0;
if fsize = 4 then fsize4 = 1; else fsize4 = 0;
if fsize >= 5 then fsize5 = 1; else fsize5 = 0;
run;

proc reg data = fourksubsxx;
model nettfa = e401k inc incsq age agesq fsize2 fsize3 fsize4 fsize5;
test fsize2, fsize3, fsize4, fsize5;
ods select ParameterEstimates TestANOVA;
run;
*Fsize4 and fsize5 are significant at the 1% level. The others are not individually. Together the four family size 
dummy variables have an f-value of 5.44 and a resultant p-value of .0002. So the family variables are jointly 
significant at the 1% level;

*Part vii;
proc sort data = fourksubsxx;
by fsize1 fsize2 fsize3 fsize4 fsize5;
run;

proc print data = fourksubsxx;
run;

proc autoreg data = fourksubsxx;
model nettfa = inc incsq age agesq e401k / chow = (1241 3231 5060 7259);
ods select Nobs FitStatistics ParameterEstimates;
run;
*The chow test shows that in this case each set of family sizes has a high f-value and a p-value of essentially zero. 
This means that we would expect there to be slope changes present in the data for each family size subset. 
This would suggest that we should look at regressions of the data on each family size;

******************************

*Chapter 7 Question C12;
proc import datafile = "&path\beauty.xls"
dbms = xls out = beauty;
run;

*Part i;
proc freq data = beauty;
table female;
where abvavg = 1;
run;

proc freq data = beauty;
table belavg*abvavg;
run;
*383 people are rated as above average, and 155 are below average;

*Part ii;
proc reg data = beauty;
model abvavg = female;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The null hypothesis that there is no gender difference in the above average beauty population can not be 
denied based on this model. The variable female only has a coefficient of .04 with a p-value of .14.;

*Part iii;
proc reg data = beauty;
model lwage = belavg abvavg;
where female = 1;
ods select Nobs FitStatistics ParameterEstimates;
run;

proc reg data = beauty;
model lwage = belavg abvavg;
where female = 0;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The null Ho: B1 = 0 means that we would expect there to be no difference in wages based on being of below 
average beauty. Women have a p-value of .0716 on belavg and men have a p-value of .0010. For men this is 
very significant and for women this is significant at the 10% significance level. This means we can 
definitely reject the null for men and the data suggests we may be able to for women as well;

*Part iv;
*The data doesn't suggest that above average looking women earn more than average women. Abvavg has a 
coefficient of only .033 and a p-value of .5442 so this is not significant;

*Part v;
proc reg data = beauty;
model lwage = belavg abvavg educ exper expersq union goodhlth black married south bigcity smllcity service;
where female = 1;
ods select Nobs FitStatistics ParameterEstimates;
run;

proc reg data = beauty;
model lwage = belavg abvavg educ exper expersq union goodhlth black married south bigcity smllcity service;
where female = 0;
ods select Nobs FitStatistics ParameterEstimates;
run;
*For both men and women, both attractiveness variables became less significant when adding these additional variables. 
The coefficients also decreased in absolute value. Belavg is still very significant for men, and significant at the 
10% level for women. Abvavg is still insignificant for both parties;

*Part vi;
proc sort data = beauty;
by female;
run;

proc autoreg data = beauty;
model lwage = belavg abvavg educ exper expersq union goodhlth black married south bigcity smllcity service / chow = 825;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Running the chow test gives an F-value of 15.43, and a resulting p-value of <.0001 with 14 and 1232 df;

***************************

*Chapter 7 Question c13;
proc import datafile = "&path\apple.xls"
dbms = xls out = apple;
run;

*Part i;
data applex;
set apple;
if ecolbs > 0 then ecobuy = 1; 
if ecolbs = 0 then ecobuy = 0;
run;

proc freq data = applex;
table ecobuy;
run;
*62.42% would buy ecologically friendly apples;

*Part ii;
proc reg data = applex;
model ecobuy = ecoprc regprc faminc hhsize educ age;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on ecoprc is -.803. This means that if eco prices increase by a dollar, then the probabability of 
buying eco friendly apples decreases by .803 or 80.3%. The coefficient on regprc is .71927, meaning that if regular 
apples increase a dollar in price, then the probabability of buying eco apples increases by 71.9%;

*Part iii;
proc reg data = applex;
model ecobuy = ecoprc regprc faminc hhsize educ age;
test faminc, hhsize, educ, age;
ods select TestANOVA;
run;
*The other variables have an F-value of 4.43 and a p-value of .0015. They are jointly significant. Educ is the non 
price variable with the most impact on the decision to buy eco apples. This makes sense to me since as education 
increases (and income is held fixed) it becomes more likely to think that one could take courses in ecological
matters or become exposed to issues related to ecological matters;

*Part iv;
data applexx;
set applex;
lfaminc = log(faminc);
run;

proc reg data = applexx;
model ecobuy = ecoprc regprc lfaminc hhsize educ age;
output out = applexxx p = pred;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The model with log(faminc) has slightly higher R^2 and adjusted R^2. The variable lfaminc is also more 
significant than just faminc, however neither is significant at even the 10% level;

*Part v;
proc freq data = applexxx;
table pred;
where pred <= 0 or pred >= 1;
run;
*Only two observations fall outside of the [0,1] interval. They are both >1 This would not concern me;

*Part vi;
data applexxxx;
set applexxx;
if pred >= .5 then predbuy = 1;
else predbuy = 0;
run;

proc freq data = applexxxx;
table ecobuy*predbuy;
run;
*We took our fitted values and set a predicted buy = 1 if the fitted values were >= 0.5. Out of the
248 families that would not buy eco apples, 102 were predicted to not buy, for a rate of 41.13%. Out of the 412
families that would buy eco apples, the model predicted 340 would, for a rate of 82.52%. 
This model was better at predicting those who would buy rather than those who would not buy eco apples;

***********************************

*Chapter 7 Question C14;
proc import datafile = "&path\charity.xls"
dbms = xls out = charity;
run;

*Part i;
proc reg data = charity;
model respond = resplast avggift;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The coefficient on resplast, .344, means that if a recipient responded to their last mailing, then  they are 34.4% 
more likely to respond to a new mailing;

*Part ii;
*The value of past gifts doesn't seem to have much impact on response rate. The coefficient is essentially zero, and 
it is significant at the 10% level;

*Part iii;
proc reg data = charity;
model respond = resplast avggift propresp;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The coefficient on propresp, .749, means that if propresp increases by 1 (ie a change from 0% response rate to 100%),
then the probabability of response would increase by 74.9%;

*Part iv;
*The coefficient on resplast fell from .344 to .095 when propresp was added to the model. This makes sense because 
propresp captures their rate on all of their responses, not just the most recent one. Both of these variables are 
very significant;

*Part v;
proc reg data = charity;
model respond = resplast avggift propresp mailsyear;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The coefficient on mailsyear is .062, meaning that for each additional mailer sent, someone is 6.2% more likely to 
respond with a gift. This likely isn't a causal effect because it is more likely the response is due purely to the 
fact that if you're constantly receiving mail then you're more likely to look at it eventually and possibly respond;

*******************************

*Chapter 7 Question C15;
proc import datafile = "&path\fertil2.xls"
dbms = xls out = fertil2;
run;

*Part i;
proc means data =fertil2 mean max min;
var children;
run;
*No woman will have exactly the average number of children because you cannot have .267 of a 
child;

*Part ii;
proc freq data = fertil2;
table electric;
run;
*14.02% of women have electricity;

*Part iii;
proc means data = fertil2;
var children;
where electric = 1;
run;
proc means data = fertil2;
var children;
where electric = 0;
run;
*The average for women with electricity is 1.90. For those without electricity it is 2.33;

proc reg data = fertil2;
model children = electric;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*This regression model confirms our means obtained above. With electric having such a large t-statistic,
this confirms that the population means are not the same for the two groups;

*Part iv;
*I don't think you can say that it causes women to have less children. I think it is just 
an indicator that women with electricity may be in more developed areas, and may have 
better resources to education or contraception;

*Part v;
proc reg data = fertil2;
model children = age educ electric agesq urban spirit protest catholic;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The effect of electricity is now much lower, with a coefficient of -.31 opposed to -.43.
It is still highly significant with a t-stat of -4.43 and p-value of <.0001;

*Part vi;
data fertil2x;
set fertil2;
electriceduc = electric*educ;
run;

proc reg data = fertil2x;
model children = age educ electric agesq urban spirit protest catholic electriceduc;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on the interaction term is not significant. The coefficient on 
electric decreases further from -.31 to -.13. Electric also loses its significance 
in the model;

*Part vii;
data fertil2xx;
set fertil2x;
electriceduc7 = electric * (educ - 7);
run;

proc reg data = fertil2xx;
model children = age educ electric agesq urban spirit protest catholic electriceduc7;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on electric is now -.280. This is compared to -.13 in part vi or -.31 
in part v. Electric in this case is the difference between having electricity or not 
at the average level of education as opposed to zero education. In this situation 
education could be a measure of standard of living rather than a rather than a measure 
of if there is access to education;

********************
