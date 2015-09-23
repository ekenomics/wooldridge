********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/



%let path = F:\Data Sets;
*Chapter 4 Question C1;
proc import datafile="&path\vote1.xls"
dbms=xls out=vote1;
run;

*Part i;
*Holding other factors fixed, (B1/100) is the percentage point change in voteA when expendA increases by one percent;

*Part ii;
*H0: B1 = -B2 Also can write as Ho: B1 + B2 = 0;

*Part iii;
proc reg data=vote1;
model voteA = lexpendA lexpendB prtystrA;
ods select Nobs FitStatistics ParameterEstimates;
run;
*lexpendA has a coefficient of 6.08332, so a 10% increase in expendA will lead to a .61% increase in voteA;
*lexpendB has a coefficient of -6.61542, so a 10% increase in expendB will lead to a .66% decrease in voteA;
*We cannot test our hypothesis from Part ii because we do not have the standard error for B1 + B2;

*Part iv;
* We must solve for theta = B1 + B2;
data theta;
set vote1;
ldiff = lexpendB - lexpendA;
run;

proc reg data=theta;
model voteA = lexpendA ldiff prtystrA;
ods select Nobs FitStatistics ParameterEstimates;
run;
*We now know theta = -0.532 and has standard error = 0.53309 this gives us a t-stat of -0.998;
*Using a two-sided test, we can only reject the null at about a 60% confidence level, so we would fail to reject the null;

********************

*Chapter 4 Question C2;
proc import datafile="&path\lawsch85.xls"
dbms=xls out=lawsch85 replace;
run;

*Part i & ii;
*Ho: B5 = 0;
proc reg data=lawsch85;
model lsalary = LSAT GPA llibvol lcost rank;
test LSAT, GPA;
ods select Nobs ANOVA ParameterEstimates TestANOVA;
run;
*The t-stat for B5 is -9.54, so we know it is very significant if rank decreases by 10 (moving up 10 spots in the ranks), 
salary is predicted to increase by about 3.3%;

*LSAT is not statistically significant with a t-stat of 1.17. GPA is significant with a t-stat of 2.75. We know they will
be jointly significant because GPA is so significant. We get an F-stat of 9.95, and a very small p-value, 
so we know these are jointly significant;

*Part iii;
proc reg data=lawsch85;
model lsalary = LSAT GPA llibvol lcost rank clsize faculty;
test clsize, faculty;
ods select Nobs TestANOVA;
run;
*We get a F-stat of 0.95, and a p-value of 0.3902, so we know that these are not significant unless
we use a very large significance level;

*Part iv;
*Other factors could include things like gender or racial compositions of student bodies. If there are also 
salary differences based on racial or gender differences, this could effect starting salaries without relating to ranking.;

***********************

*Chapter 4 Question C3;
proc import datafile="&path\hprice1.xls"
dbms=xls out=hprice1;
run;

*Part i;
proc reg data=hprice1;
model lprice = sqrft bdrms;
ods select Nobs FitStatistics ParameterEstimates;
run;

data theta;
theta = 150*0.00037945+0.02888;
put theta;
run;
*Theta = 0.0857975 or about an 8.6% increase in price;

*Part ii;
*B2 = Theta - 150*B1;
data hprice;
set hprice1;
bdrms1 = 150*bdrms;
theta = sqrft - bdrms1;
run;

*Part iii;
proc reg data=hprice;
model lprice = theta bdrms / clb;
ods select Nobs FitStatistics ParameterEstimates;
run;

***************************

*Chapter 4 Question C4;
proc import datafile="&path\bwght.xls"
dbms= xls out=bwght replace;
run;

proc reg data=bwght;
model bwght = cigs parity faminc motheduc fatheduc; 
ods select Nobs FitStatistics;
run;
*R^2 = 0.0387;

proc reg data=bwght;
model bwght = cigs parity faminc;
ods select Nobs FitStatistics;
run;
*R^2 = 0.0348;

*********************************

*Chapter 4 Question C5;
proc import datafile= "&path\mlb1.xls"
dbms = xls out=mlb1;
run;

*Part i;
proc reg data=mlb1;
model lsalary = years gamesyr bavg hrunsyr;
ods select ParameterEstimates;
run;
*Hrunsyear is very statistically significant with t-stat ~4.96 and its coefficient has increased by about 2.5 times;

*Part ii & iii;
proc reg data=mlb1;
model lsalary = years gamesyr bavg hrunsyr runsyr fldperc sbasesyr;
test bavg, fldperc, sbasesyr;
ods select ParameterEstimates TestANOVA;
run;

*Of the new variables, only runsyr is very significant with a t-stat of ~3.43.;
*They jointly have a F-value of 0.68, and a p-value of 0.5617, so these new variables are not jointly significant;

*******************************

*Chapter 4 Question C6;
proc import datafile="&path\wage2.xls"
dbms=xls out=wage2;
run;

*Part i;
proc reg data=wage2;
model lwage = educ exper tenure;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Ho: B2 = B3;

*Part ii;
*theta = B2 - B3;
data wage21;
set wage2;
theta = tenure + exper;
run;

proc reg data = wage21;
model lwage = educ exper theta / clb;
ods select ParameterEstimates;
run;
*In this case theta is B2, or the coefficient on exper. Thus we have a confidence interval of -0.00736 - 0.01126.
This interval includes zero, so we cannot reject Ho at the 5% level;

********************************

*Chapter 4 Question C7;
proc import datafile = "&path\twoyear.xls"
dbms= xls out=twoyear;
run;

*Part i;
proc means data = twoyear max min mean;
var phsrank;
run;

*Part ii;
proc reg data=twoyear;
model lwage = jc totcoll exper phsrank;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Phsrank has a t-stat of 1.27, so it is not very statistically significant;
*10 percentage points of high school rank only increases salary by .3%;

*Part iii;
*The t-stat on jc gets even smaller in absolute value. Howveer, the coefficient does not change by a large amount. 
*Totcoll is still very statistically significant, and it's coefficient does not change by much either.
This means that the effects of college on wage are not changed by adding phsrank;

*Part iv;
*The variable ID is just an assigned ID number, so we would not expect it to have any effect on the equation;
proc reg data=twoyear;
model lwage = jc totcoll exper phsrank id;
ods select ParameterEstimates;
run;
*We see ID has a t-stat of about 0.66, showing it is very insignificant;

***************************

*Chapter 4 Question C8;
proc import datafile= "&path\401ksubs.xls"
dbms = xls out=fourksubs;
run;

*Part i;
proc freq data = fourksubs;
table fsize;
run;
*2017 single household families in sample;

data singleksubs;
set fourksubs;
if fsize ne 1 then DELETE;
run;

*Part ii;
proc reg data = singleksubs;
model nettfa = inc age;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The slope coefficients in this case are 0.79932 for inc and 0.84266 for age. For every $1000 increase in income, 
we'd expect netffa to increase by ~$799. For each additional year of age, we'd expect netffa to increase by ~$843.
Both of these make sense, because we would expect
net financial assets to increase with age and income (and usually higher ages have higher incomes);

*Part iii;
*The meaning of the intercept is if someone has 0 income and is 0 years old, they would be expected to have 
-$43,000 of net financial assets. There is nobody even close to those values, so it is not very interesting;

*Part iv;
data  ttest;
tstat = (0.84266-1)/0.09202;
put tstat;
p = probt(tstat, 2016);
put p;
run;
*We obtain a t-stat of -1.71 and this gives us a p-value of 0.044. So we do not reject at the 1% level but can at the 5% level;

proc reg data = singleksubs;
model nettfa = inc;
ods select ParameterEstimates;
run;

proc corr data = singleksubs;
var inc age;
run;
*The coefficient is not very different, being .821 vs 0.799. This is likely due to the fact that in this sample
the correlation between inc and age is only .039, so inc provides almost all the same information regardless of if age 
is in the equation;

*******************************

*Chapter 4 Question C9;
proc import datafile = "&path\discrim.xls"
dbms = xls out= discrim;
run;

*Part i;
proc reg data = discrim;
model lpsoda = prpblck lincome prppov;
run;
*B1 is statistically different from 0 at the 5% level due to its p-value of 0.0181. However, it is not significant at the 
1% level. ;

*Part ii;
proc corr data = discrim;
var lincome prppov;
run;
*The correlation is -0.83847. Lincome is significant with a t-stat of 5.12 and p-value of .0001. Prppov is significant
with a t-stat of 2.86 and p-value of 0.0044.;

*Part iii;
proc reg data = discrim;
model lpsoda = prpblck lincome prppov lhseval;
test lincome, prppov;
ods select ParameterEstimates TestANOVA;
run;
*The coefficient is 0.12131. This means for each 1% change in hseval, we'd expect the price of soda to increase by 0.12131%.;

*Part iv;
*The t-value of lincome dropped significantly to -1.41, with a p-value of 0.1587. Prppov's t-value dropped to 0.39 with 
a p-value of 0.6986. These variables are jointly mildly significant with a 3.52 F-value and p-value of 0.0304.;
*It seems that lhseval does a better job of predicting than both lincome and prppov, since they all are similar variables.
However, together lincome and prppov are still significant at the 5% level.;

*Part v;
*Both models have similar coefficients for prpblck. It has a higher t-stat in the second model however. I would use the 
second regression as the most reliable one, given that it seems lhseval is a better predicting variable 
than lincome and prppov.;

*************************************

*Chapter 4 Question C10;
proc import datafile = "&path\elem94_95.xls"
dbms = xls out = elem;
run;

*Part i;
proc reg data = elem;
model lavgsal = bs;
ods select Nobs FitStatistics ParameterEstimates;
run;

data ttest;
tstat = (-0.79512 + 1)/0.14965;
put tstat;
p = probt(tstat, 1847 , -1);
put p;
run;

*The slope coefficient is significantly different than zero with a t-stat of -5.31 and p-value of .0001. However, it 
is not significantly different than -1 with a t-stat of 1.36 and we are not able to reject the hypothesis that B1 = -1;

*Part ii;
proc reg data = elem;
model lavgsal = bs lenrol lstaff;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The coefficient on bs goes from -.79 to -.61;

*Part iii;
proc corr data = elem;
var lenrol lstaff bs;
run;
*The standard errors are smaller than in part ii because we have added additional information to the equation. 
However, this additonal information is not correlated with bs, so the standard error will decrease due to the much
higher R^2.

*Part iv;
*The coefficient on lstaff is negative because as staff per 1000 students increases, avgsal would naturally decrease. 
This is due to more people to pay. The avg sal will decrease by 0.71% for each additional 1% of staff per 1000 students;

*Part v;
proc reg data = elem;
model lavgsal = bs lenrol lstaff lunch;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Teachers are not being compensated for teaching students with a disadvantaged background. 
The effect is extremely small, and is slightly negative.;

*Part vi;
*The results are consistent of the pattern in table 4.1;

**************************************

*chapter 4 Question C11;
proc import datafile = "&path\htv.xls"
dbms = xls out = htv replace;
run;

data htv1;
set htv;
abil2 = abil*abil;
run;
*Part i;
proc reg data = htv1;
model educ = motheduc fatheduc abil abil2;
ods select Nobs FitStatistics ParameterEstimates;
run;

*Part ii;
data htv3;
set htv1;
educjoint = motheduc + fatheduc;
run;

proc reg data = htv3;
model educ = educjoint fatheduc abil abil2;
ods select Nobs FitStatistics ParameterEstimates;
run;
*By setting theta = B2 - B1 we can solve for the t-stat of Ho: B1 = B2. We get a t-stat of 6.77 and a p-value of .0001;

*Part iii;
proc reg data = htv3;
model educ = motheduc fatheduc abil abil2 tuit17 tuit18;
test tuit17, tuit18;
ods select FitStatistics ParameterEstimates TestANOVA;
run;
*The two college tuition variables do not appear to be jointly significant, with a f-value of 0.84 and p-value of 0.4322;

*Part iv;
proc corr data = htv3;
var tuit17 tuit18;
run;
*The correlation is 0.98083. Using the average of the two years may be better because it appears that
tuit 17 directly predicts tuit18. This would be expected, as one would expect the prices to rise only due to inflation or 
other college related costs;

data htv4;
set htv3;
avgtuit = (tuit17 + tuit18)/2;
run;

proc reg data = htv4;
model educ = motheduc fatheduc abil abil2 avgtuit;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Using the average of the tuition is better than using both separately. The average has a p-value of 0.1973, compared with 
the p-value for the joint significance of the two variables of 0.43. However, it is still not statistically significant;

*Part v;
*One would expect tuit prices to have a roll in the number of years of education obtained. However, 
this information could already be accounted for in other ways. We've already accounted for natural ability, 
and parents education. Students with higher ability would be more likely to have scholarships and other aid, 
and students with more educated parents are more likely to be a part of wealthier families.;
