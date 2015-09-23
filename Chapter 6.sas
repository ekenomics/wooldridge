*Chapter 6;
%let path = F:\Econometrics Supplement\Data Sets;
*Chapter 6 Question C1;
********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/


%let path = F:\Data Sets;
proc import datafile = "&path\kielmc.xls"
dbms = xls out = kielmc;
run;
data kielmc;
set kielmc;
if year ne '1981' then DELETE;
run;
*Part i;
proc reg data = kielmc;
model lprice = ldist;
ods select Nobs FitStatistics ParameterEstimates;
run;
*We'd expect that as the distance increases (ldist goes up) the value of the house goes up as well. 
We see this in the model;

*Part ii;
proc reg data = kielmc;
model lprice = ldist lintst larea lland rooms baths age;
ods select Nobs FitStatistics ParameterEstimates;
run;
*In this model the effect of the incinerator is not strong at all. It has gone from a t stat of over 6 to just .53. 
This reduced significance could be explained because we are adding so many other variables to the equation. It could be
caught up in the fact that nicer homes (more rooms, baths, land, etc) are also more likely to be farther 
from the incinerator;

*Part iii;
proc reg data = kielmc;
model lprice = ldist lintst larea lland rooms baths age lintstsq;
ods select Nobs FitStatistics ParameterEstimates;
run;
*When we add this additional variable, every variable becomes more significant. This tells us that 
the form that we choose for our model is very important;

*Part iv;
data kielmc2;
set kielmc;
ldistsq = ldist*ldist;
run;

proc reg data = kielmc2;
model lprice = ldist lintst larea lland rooms baths age lintstsq ldistsq;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Adding this variable has made each variable less significant than before. The variable itself is not very significant, 
having a p-value of only .2703;

*********************************

*Chapter 6 Question C2;
proc import datafile = "&path\wage1.xls"
dbms = xls out = wage1;
run;

*Part i;
proc reg data = wage1;
model lwage = educ exper expersq;
ods select Nobs FitStatistics ParameterEstimates;
run;

*Part ii;
*Expersq is statistically significant at the 1% level with a p-value of <.0001;

*Part iii;
data approx;
approxfive = 100*(.041 - 2*(.000714)*4);
put approxfive;
approxtwenty = 100*(.041 - 2*(.000714)*19);
put approxtwenty;
run;
*We get 3.53% for 5th year and 1.39% for the 20th year;

*Part iv;
data turnaround;
tap = .041 / (2*.000714);
put tap;
run;
*The turnaround point is about 28.7 years of experience;

proc means data = wage1;
var wage;
where exper >= 29;
run;
*There are 121 observations with at least 29 years of experience;

*****************************

*Chapter 6 Question C3;
proc import datafile = "&path\wage2.xls"
dbms = xls out = wage2;
run;

*Part i;
*Holding Exper fixed gives us the change in lwage with respect to educ is equal to (B1 + B3exper). This is just
rearranging of the equation;

*Part ii;
*The null would be B3 = 0. The alternative would be B3>0;

*Part iii;
data wage2x;
set wage2;
exeduc = exper*educ;
run;

proc reg data = wage2x;
model lwage = educ exper exeduc;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Exper*Educ has a t stat of 2.09 and p-value of .0365, so we can reject the Null in favor of the alternative B3 > 0 
at the 4% level.;

*Part iv;
data wage2xx;
set wage2x;
exper10 = exper - 10;
exper10educ = exper10*educ;
run;

proc reg data = wage2xx;
model lwage = educ exper exper10educ / clb;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The theta coefficient is 0.0761 and the confidence limit is 0.063 - 0.089;

******************************

*Chapter 6 Question C4;
proc import datafile = "&path\gpa2.xls"
dbms = xls out = gpa2;
run;

*Part i;
proc reg data = gpa2;
model sat = hsize hsizesq;
ods select Nobs FitStatistics ParameterEstimates;
run;

*Hsize sq is significant with a p-value of 0.0001.;

*Part ii;
data opt;
opt = 19.81 / (2*2.13);
put opt;
run;
*Since this is in hundreds, the optimal size is 465 students;

*Part iii;
*It is only representative of those students who took the SAT, so not all high school seniors.;

*Part iv;
data gpa2x;
set gpa2;
lsat = log(sat);
run;

proc reg data = gpa2x;
model lsat = hsize hsizesq;
ods select Nobs FitStatistics ParameterEstimates;
run;

data opt2;
opt2 = 0.0196 / (2*0.00209);
put opt2;
run;
*This gives an optimal class of about 469 students, which is almost the same as we obtained earlier;

********************************

*Chapter 6 Question C5;
proc import datafile = "&path\hprice1.xls"
dbms = xls out = hprice1 replace;
run;

*Part i;
proc reg data = hprice1;
model lprice = llotsize lsqrft bdrms;
output out = hprice1x r = uhat p = yhat;
ods select Nobs FitStatistics ParameterEstimates;
run;

*Part ii;
data pred;
pred = -1.297+.168 * log(20000) + .700*log(2500) + .03696 * (4);
put pred;
run;
*We get a predicted value of 5.99;
data hprice1xx;
set hprice1x;
m = exp(yhat);
run;

proc reg data = hprice1xx;
model price = m / noint;
ods select Nobs FitStatistics ParameterEstimates;
run;

data price;
price = 1.023*exp(5.99);
put price;
run;
*This gives us 408.601, or a value of $408,601;

*Part iii;
proc reg data = hprice1;
model price = lotsize sqrft bdrms;
ods select Nobs FitStatistics ParameterEstimates;
run;

proc corr data = hprice1xx;
var m price;
run;
*We obtain a correlation (or r) between m and price of .859. The square of this is roughly .738, and this is a 
comparable goodness-of-fit measure for the model with log(price) as the dependent variable. Therefore,
the log model is noticeably better;


******************************

*Chapter 6 Question C6;
proc import datafile = "&path\vote1.xls"
dbms = xls out = vote1;
run;

*Part i;
*Holding all else fixed, DeltaVotaA / DeltaExpendB = B3 + B4expendA. We think B3 < 0 if increased spending by B lowers 
the vote received by A. The sign of B4 could be positive or negative. Is the effect of more spending by B smaller or 
larger for higher levels of spending by A?;

*Part ii;
data vote1x;
set vote1;
expendAB = expendA * expendB;
run;

proc reg data = vote1x;
model voteA = prtystrA expendA expendB expendAB;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The interaction term is not significant with a p-value of .3576;

*Part iii;
proc means data = vote1x mean;
var expendA;
run;

data fixedA;
VoteA = (-.0317 - .0000066*300)*100;
put VoteA;
run;
*-3.4% decrease in VoteA when expendA is fixed at 300 and expendB increases by 100. This is a fairly large effect;

*Part iv;

data fixedB;
voteA = (.0383 - .0000066*100)*100;
put voteA;
run;
*3.8% this makes sense, and is a large effect as well;


*Part v;
proc reg data = vote1x;
model voteA = prtystrA expendA expendB shareA;
ods select Nobs FitStatistics ParameterEstimates;
run;
*IF ShareA is the fraction of the spending spend by A, it doesn't make logical sense to hold Expend A & B fixed and 
change ShareA. It wouldn't be possible to change the proportion of spending by A if the amount of spending
is staying fixed.;

*Part vi;
*The partial derivative becomes dvoteA / dExpendB = B3 + B4(dshareA / dexpendB).
dShareA / dExpendB = -100 [ expendA / (ExpendA + ExpendB)^2].
Evalutating this at ExpendA = 300 and expendB = 0 gives us -1/3. 
Plugging this into dVoteA / dExpendB = B3 + B4(dshareA / dexpendB) gives us ~-.164.

This result means that if A is spending 300 and B is spending 0, the first thousand in spending by B will 
decrease VoteA by .164%. This effect tapers off as B grows though;

*****************************

*Chapter 6 Question C7;
proc import datafile = "&path\attend.xls"
dbms = xls out = attend;
run;

*Part i;
*Holding all variables fixed except priGPA and using the approximation: Delta(priGPA)^2 ~= 2(priGPA)delta(priGPA) we get:
	delta(stndfnl) = B2delta(priGPA) + B4delta(priGPA)^2 + B6(delta(priGPA))atndrte
					~~ (B2 + 2B4priGPA + B6 atndrte)delta(priGPA)

dividing by delta(priGPA) gives us: delta(stndfnl) / delta(priGPA) = B2 + 2B4priGPA + B6 atndrte

When priGPA = 2.59 and atndrte = .82 we get:
	-1.63 + 2(.296)(2.59) + .0056(.82) ~~ -.092;

*Part ii;
data attendx;
set attend;
priminus = (priGPA - 2.59);
priminussq = priminus**2;
ACT2 = ACT**2.;
atndminus = priGPA * (atndrte - .82);
atndminus2 = priminus * (atndrte - .82);
run;

proc reg data = attendx;
model stndfnl = atndrte priGPA ACT priminussq ACT2 atndminus;
ods select Nobs FitStatistics ParameterEstimates;
run;
*We see that the coefficient on priGPA or theta2 = -.091, with standard error .363. This shows a very
small t-statistic for Theta2;

*Part iii;
proc reg data = attendx;
model stndfnl = atndrte priGPA ACT priminussq ACT2 atndminus2;
ods select Nobs FitStatistics ParameterEstimates;
run;

********************************

*Chapter 6 Question C8;
proc import datafile = "&path\hprice1.xls"
dbms = xls out = hprice1c8;
run;

*Part i;
proc reg data = hprice1c8;
model price = lotsize sqrft bdrms;
ods select Nobs FitStatistics ParameterEstimates;
run;

data pred;
pred = -21.77031 + .00207*(10000) + .12278*(2300) + 13.85252*(4);
put pred;
run; 
*The predicted house price is $366,734;

*Part ii;
data hprice1x;
set hprice1;
lotsizei = lotsize - 10000;
sqrfti = sqrft - 2300;
bdrmsi = bdrms - 4;
run;

proc reg data = hprice1x;
model price = lotsizei sqrfti bdrmsi / clb;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The CI is about 322.042 - 351.372;

*Part iii;
*We can solve for se(e^0) using se(y^0) and sigmahat. se(y^0) = 7.37447 and sigmahat = 59,833.
Thus se(e^0) = [(7374.5)^2 + (59833)2]^(1/2) ~~ 50,285.8. 

Using 1.99 to approximate the 97.5th percentile of the t84 distribution gives the 95% CI for 
price^0 as 336,706.7 +/- 1.99(60,285.8)

Otherwise known as: 216,738 - 456,675. This is a very wide confidence interval, 
but we haven't used many factors in the regression;

*******************************************

*Chapter 6 Question C9;

proc import datafile = "&path\nbasal.xls"
dbms = xls out = nbasal;
run;

*Part i;
proc reg data = nbasal;
model points = exper expersq age coll;
ods select Nobs FitStatistics ParameterEstimates;
run;

*Part ii;
data tap;
tap = 2.33702 / (2*.07577);
put tap;
run;
*Turn around point is about 15.42 years in the league so from year 15 to 16 we'd expect a decrease in ppg. 
This makes sense because at this point people are reaching the ends of their career. In fact only 
2 players in the sample have 15+ years of experience;

*Part iii;
*Many of the highest quality players leave college early or come out of high school, so it would make sense 
that as the number of years of college increase it decreases the quality of the players relative to the top stars;

*Part iv;
proc reg data = nbasal;
model points = exper expersq age agesq coll;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Agesq is not significant in itself, having a p-value of .2699. It also makes age as a variable non significant, 
reducing its p-value from .0004 to .1362. Thus it shouldn't be included in the equation;

*Part v & vi;
proc reg data = nbasal;
model lwage = points exper expersq age coll;
test age, coll;
ods select ParameterEstimates FitStatistics TestANOVA;
run;

*The F-Value of the test is 1.23. With 2 and 263 df this gives a p-value of .295, showing that once points 
and exper are in the model, there isn't wage differences resulting from age or years of college.;

***************************

*Chapter 6 Question C10;
proc import datafile = "&path\bwght2.xls"
dbms = xls out = bwght2 replace;
run;

*Part i;
proc reg data = bwght2;
model lbwght = npvis npvissq;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The quadratic term is very significant, with a t stat of 3.57 in absolute value;

*Part ii;
data visits;
visit = .01892 / (2*.000429);
put visit;
run;
*Visits are 22.05;

proc freq data = bwght2;
table npvis;
where npvis >= 22;
run;
*21 women had at least 22 visits. This data set has 68 missing observations;

*Part iii;
*It would make sense that birth weight starts to decrease as greater than 22 visits could suggest an issue with
the baby;

*Part iv;
proc reg data = bwght2;
model lbwght = npvis npvissq mage magesq;
ods select Nobs FitStatistics ParameterEstimates;
run;

data mage;
mage = .02539 / (2*.00041187);
put mage;
run;
*Optimal mothers age is 30.82;

proc means data = bwght2;
var mage;
where mage >= 31;
run;
*746 women are greater than or equal to the optimal age of 31;

*Part v;
* I would say that mother's age and number of prenatal visits don't explain much of the variation
in lbwght since the R^2 is only .0256;

*Part vi;
proc reg data = bwght2;
model lbwght = npvis npvissq mage magesq;
output out = bwght2x p = pred;
ods select Nobs FitStatistics ParameterEstimates;
run;

proc reg data = bwght2;
model bwght = npvis npvissq mage magesq;
ods select FitStatistics;
run;

data bwght2xx;
set bwght2x;
m = exp(pred);
run;

proc corr data = bwght2xx;
var m bwght;
run;

data calc;
square = .13621**(2);
put square;
run;
*This gives us an R^2 value of .0186 that we can compare to the level model. The level model had an R^2 of .0192,
so we would argue that the level model is better in this situation;

*********************************

*Chapter 6 Question C11;
proc import datafile = "&path\apple.xls"
dbms = xls out = apple;
run;

*Part i;
proc reg data = apple;
model ecolbs = ecoprc regprc;
output out = applex p = yhat;
ods select Nobs FitStatistics ParameterEstimates;
run;
*This regression shows that as the price of eco apples increase then the quantity decreases by about 2.92 for each 
additional dollar of price
It shows that for each increased dollar of regular apple price the quantity of eco label apples increases by about 3.03;

*Part ii;
*Both price variables are significant with p-values of <.0001;

*Part iii;
proc means data = applex range max min;
var yhat;
run;
*The range is 1.232. There is zero values where predicted ecolbs = 0. This is an issue since in our sample set
nearly 40% of the sample has ecolbs = 0;

*Part iv;
*Since the R^2 is only .0364 I would say that the variables don't explain much of the variation in ecolbs;

*Part v;
proc reg data = apple;
model ecolbs = ecoprc regprc faminc hhsize educ age;
test faminc, hhsize, educ, age;
ods select FitStatistics ParameterEstimates TestANOVA;
run;
*The F-Value for the four new variables is 0.65 with a p-value of .6286, so I would conclude that these four are not 
jointly significant;

*Part vi;
proc reg data = apple;
model ecolbs = ecoprc;
ods select Nobs FitStatistics ParameterEstimates;
run;
proc reg data = apple;
model ecolbs = regprc;
ods select Nobs FitStatistics ParameterEstimates;
run;

proc corr data = apple;
var ecoprc regprc;
run;
*Both coefficients have decreased significantly in absolute value, and have much less impact. They also are much less 
statistically significant. They each explain virtually none of the variation in ecolbs as well. 
This could be due to the fact that they are very highly correlated (0.83076);


*****************************

*Chapter 6 Question C12;
proc import datafile = "&path\401ksubs.xls"
dbms = xls out = fourk;
run;

data fourkx;
set fourk;
if fsize ne 1 then DELETE;
run;

*Part i;
proc freq data = fourkx;
table age;
run;
*The youngest age is 25 and there are 99 of those observations;

*Part ii;
*B2 is the increase in nettfa attributed to a one year increase in age, holding all else equal. By itself it probably 
isn't of much interest because we would naturally assume net financial assets to increase with age;

*Part iii;
proc reg data = fourkx;
model nettfa = inc age agesq;
ods select Nobs FitStatistics ParameterEstimates ANOVA;
run;

data tap;
tap = 1.32181 / (2*.02556);
put tap;
run;
*I am not really worried about the coefficient being negative. When you calculate the turnaround point, 
the quadratic term takes over at around age 25.86, thus giving a positive contribution from age. 
This may be due to student loans or other debt that is usually attributed to younger individuals;

*Part iv;
data fourkxx;
set fourkx;
ageterm = (age - 25)**2;
run;

proc reg data = fourkxx;
model nettfa = inc age ageterm;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The theta2 term is -0.04369, the coefficient on age, which is not significant with a p-value of .8932;

*Part v;
proc reg data = fourkxx;
model nettfa = inc ageterm;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*This model has the exact same R^2 value as the previous model and its adjusted R^2 is slightly higher, 
making this a better model in terms of goodness-of-fit;

*Part vi;
data fourkxxx;
set fourkxx;
nettfagraph = -18.48810 + 0.82357*30 + 0.02440*ageterm;
run;

proc sgplot data = fourkxxx;
series y = nettfagraph x = age;
where age >= 25;
run;
*We see that holding income fixed, net financial assets increase with age. The observations fall into a 
parabola type shape, underneath a roughly 45 degree line;

*Part vii;
proc reg data = fourkxx;
model nettfa = inc ageterm incsq;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*A quadratic term on inc doesn't appear necessary, as it decreases the adjusted r^2 compared 
to part v and the term itself is not significant;

******************************

*Chapter 6 Question C13;
proc import datafile = "&path\meap00.xls"
dbms = xls out = meap00;
run;

*Part i;
proc reg data = meap00;
model math4 = lexppp lenroll lunch;
output out = meap00x p = fitted r = resid;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Lexppp is not significant at the 5% level but is at the 10% level;

*Part ii;
proc means data = meap00x range max min;
var fitted math4;
run;
*The range on the fitted values is 50.26, compared with 100 for math4. The fitted values only range from 42.41 to 
92.67, while the actual values range from 0 - 100. This is an issue;

*Part iii;
proc freq data = meap00x;
table resid;
run;

proc print data = meap00x;
where resid > 50;
run;
*The building code of the largest residual is 1141. When you look at the data for this observation, this bcode has
lunch = 100. This is why the predicted value is so low at 46.28, yet they have a math4 value of 97.7;

*Part iv;
data meap00quad;
set meap00;
lexpppsq = lexppp**2;
lenrollsq = lenroll**2;
lunchsq = lunch**2;
run;

proc reg data = meap00quad;
model math4 = lexppp lenroll lunch lexpppsq lenrollsq lunchsq;
test lexpppsq, lenrollsq, lunchsq;
ods select FitStatistics ParameterEstimates TestANOVA;
run;
*Jointly these new variables have an F-Value of about .52, and a p-value of .6699. None of them are significant on 
their own either. I would not leave them in the model;

*Part v;
proc means data = meap00;
var math4 lexppp lenroll lunch;
run;

data meap00sd;
set meap00;
math4sd = math4 / 19.3064118;
lexpppsd = lexppp / 0.1902992;
lenrollsd = lenroll / 0.4098605;
lunchsd = lunch / 26.3669423;
run;

proc reg data = meap00sd;
model math4sd = lexpppsd lenrollsd lunchsd;
ods select Nobs FitStatistics ParameterEstimates;
run;

*In terms of standard deviation units, lunch has the biggest effect on the math pass rate. It's coefficient is 
-0.61285, which is almost 0.5 larger in absolute value than the next highest. 
It also has the highest t stat in absolute value;

**************************************

*Chapter 6 Question C14;
proc import datafile = "&path\benefits.xlsx"
dbms = xlsx out = benefits;
run;

*Part i;
proc reg data = benefits;
model lavgsal = bs;
test bs = -1;
ods select FitStatistics ParameterEstimates TestANOVA;
run;
*We can reject that Bbs = 0 with a p- value of 0.0025 and we can reject that Bbs = -1 with a p-value of 0.0028;

*Part ii;
data benefitsx;
set benefits;
lbs = log(bs);
run;

proc means data = benefitsx range mean std;
var lbs bs;
run;
*The range of lbs is much larger than bs, the mean is much smaller, and the standard deviation is larger as well;

*Part iii;
proc reg data = benefitsx;
model lavgsal = lbs;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The regression on bs produced an R^2 of .0049, while the regression on lbs only produced R^2 of .0039. Thus
you could argue that the model was better using bs;

*Part iv;
proc reg data = benefitsx;
model lavgsal = bs lenroll lstaff lunch;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The coefficient on bs is now much smaller in absolute value, and it is only different from zero at the 15% significance level;

*Part v;
*The coefficient on lstaff means that for each 1% increase in staff / thousand students, the avg salary drops by .6907%. 
This makes sense because as the number of staff goes up, you would expect each person to get less money, although
not at a completely equal ratio due to schools with higher budgets having more staff;

*Part vi;
data benefitsxx;
set benefitsx;
lunchsq = lunch**2;
run;

proc reg data = benefitsxx;
model lavgsal = bs lenroll lstaff lunch lunchsq;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The variable lunchsq is significant with a t stat of 5.56 and p-value of <.0001;

data tap;
tap = .00360 / (2*.00003178);
put tap;
run;
*Turn around point is present at 56.64% of students eligible for free lunches;

proc freq data = benefitsxx;
table lunch;
where lunch >= 56.64;
run;
*There are 418 values of lunch higher than the turning point of 56.64%;

*Part vii;
data lunch123;
lunch0 = 13.83342 + 0*-0.00360 + 0*.00003178;
lunch50 = 13.83342 + 50*-0.00360 + 50*0.00003178;
lunch100 = 13.83342 + 100 * -.00360 + 100 * .00003178;
put lunch0 lunch50 lunch100;
run;
*Holding other factors fixed it is better to teach at a school where lunch = 0. Holding all other factors fixed 
and only using the intercept and lunch variables when lunch = 0, lavgsal = 13.83342, when lunch = 50 
lavgsal = 13.655009 and when lunch = 100 lavgsal = 13.476598;

****************************

