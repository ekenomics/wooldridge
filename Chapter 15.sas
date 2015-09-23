********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/


%let path = F:\Data Sets;
*Chapter 15;
%let path = F:\Econometrics Supplement\Data Sets;
*Chapter 15 Question C1;
proc import datafile = "&path\wage2.xls"
dbms = xls out = wage replace;
run;

*Part i;
proc reg data = wage;
model lwage = sibs;
ods select ParameterEstimates;
run;
*The coefficient on sibs is -.0279, showing that one additional sibling is associated with a monthly salary 
lower by about 2.8%. Sibs has a t-statistic of -4.72 and is very significant;

*Part ii;
proc reg data = wage;
model educ = brthord;
ods select ParameterEstimates;
run;
*It could be that families hit budget constraints after additional children, and thus cannot afford higher education
for later children. The coefficient on brthord is -.2826 and is statistically significant;

*Part iii;
proc syslin data = wage 2sls;
instruments brthord;
model lwage = educ;
ods select ANOVA FitStatistics ParameterEstimates;
run;
*The result from IV is much higher than the OLS estimate and even above the estimate when sibs is used as an IV for
educ.;

*Part iv;
*We need pi2 =/= 0 for the Bj to be identified. We take the null to be Ho: pi2 = 0 and look reject Ho.;
proc reg data = wage;
model educ = sibs brthord;
ods select ParameterEstimates;
output out = wagex p = yhat;
run;
*The coefficient on brthord is -.15 with t-statistic -2.67. This is strong evidence rejecting Ho;

*Part v;
proc syslin data = wage 2sls;
instruments brthord sibs;
model lwage = educ sibs;
ods select ANOVA FitStatistics ParameterEstimates;
run;
*The standard error on Beduc is much larger than we obtained in part (iii). It is only significant at the 10% level. 
The standard error of Bsibs is very large, giving it a t-statistic of only .12, meaning it is not significant;

*Part vi;
proc corr data = wagex;
var yhat sibs;
run;
*The corr is -0.93 which is very strong negative correlation. This means for the purpose of using IV, 
multicollinearity is a serious problem and is not allowing us to estimate Beduc with much precision;



*Chapter 15 Question C2;
proc import datafile = "&path\fertil2.xls"
dbms = xls out = fertil replace;
run;

*Part i;
proc reg data = fertil;
model children = educ age agesq;
ods select ParameterEstimates;
run;
*Another year of education, holding age fixed, results in .091 fewer children. If 100 women receive an additional year
of education, they collectively will have about 9 fewer children;

*Part ii;
proc reg data = fertil;
model educ = age agesq frsthalf;
ods select ParameterEstimates;
run;
*We need pi3 =/= 0. From the regression we get pi3 = -.85229, with t-statistic -7.55. Women born in the first
half of the year are predicted to have almost one year less of education, holding age fixed.;

*Part iii;
proc syslin data = fertil 2sls;
instruments frsthalf age agesq;
model children = educ age agesq;
ods select ParameterEstimates;
run;
*The estimated effect of education on fertility is now much larger. The standard error is also much larger, 
producing a large confidence interval;

*Part iv;
proc syslin data = fertil 2sls;
instruments frsthalf age agesq electric tv bicycle;
model children = educ age agesq electric tv bicycle;
ods select ParameterEstimates;
run;

proc reg data = fertil;
model children = educ age agesq electric tv bicycle;
ods select ParameterEstimates;
run;
*The coefficient on educ under OLS is -.0767 and under IV it is -.164. Adding these binary varibles reduced
the coefficient on educ in both cases. Under OLS the coefficient on tv is -.25, and under IV it is -.0026. 
This says that a family with a tv will have on average .25 or .0026 children less than a family with a tv.
Tv is a significant variable under OLS, but not under IV. TV may be acting as a proxy for different things such 
as income or region, or it may be representative of an alternative form of recreation;



*Chapter 15 Question C3;
proc import datafile = "&path\card.xls"
dbms = xls out = card replace;
run;

*Part i;
*IQ scores are known to vary by geographic region, and so does the availability of four year colleges. It could
be that people with higher abilities grow up in areas with four year colleges;

*Part ii;
proc reg data = card;
model iq = nearc4;
ods select ParameterEstimates;
run;
*IQ scores are 2.60 points higher for those that grew up near a 4 year college. This is a statistically significant
effect;

*Part iii;
proc reg data = card;
model iq = nearc4 smsa66 reg662 reg663 reg664 reg665 reg666 reg667 reg668 reg669;
ods select ParameterEstimates;
run;
*Now once we control for regional and environment when growing up, there is no link between IQ and nearc4. The 
nearc4 variable is statistically insignificant;

*Part iv;
*The findings in the two previous parts show it is important to control for differences in access to colleges
taht might also be correlated with ability in the wage equation;




*Chapter 15 Question C4;
proc import datafile = "&path\intdef.xls"
dbms = xls out = intdef;
run;

*Part i;
proc reg data = intdef;
where year > 1948;
model i3 = inf;
ods select ParameterEstimates;
run;

*Part ii;
proc syslin data = intdef 2sls;
instruments inf_1;
model i3 = inf;
ods select ParameterEstimates;
where year > 1948;
run;
*The estimate on inf is no longer statistically different than one;

*Part iii;
proc reg data = intdef;
model ci3 = cinf;
ods select ParameterEstimates;
run;
*This is a much lower estimate than either part prior;

*Part iv;
data intdef;
set intdef;
cinf_1 = inf_1 - lag(inf_1);
run;
proc reg data = intdef;
model cinf = cinf_1;
ods select ParameterEstimates;
run;
*This regression shows that cinf and cinf_1 are virtually uncorrelated, and thus cannot be used as an instrument
for each other;



*Chapter 15 Question C5;
proc import datafile = "&path\card.xls"
dbms = xls out = cardc5;
run;

*Part i;
proc reg data = cardc5;
model educ = nearc4 exper expersq black smsa south smsa66 reg662 reg663 reg664 reg665 reg666 reg667 reg668 reg669;
ods select none;
output out = cardc5x p = v;
run;

proc reg data = cardc5x;
model lwage = educ exper expersq black smsa south smsa66 reg662 reg663 reg664 reg665 reg666 reg667 reg668 reg669 v;
ods select ParameterEstimates;
run;
*We get a coefficient on v of .057, with a t-statistic of 1.08. This is not significant;

*Part ii;
proc syslin data = cardc5 2sls out = cardc5xx;
instruments nearc2 nearc4 exper expersq black smsa south smsa66 reg662 reg663 reg664 reg665 reg666 reg667 reg668 reg669;
model lwage = educ exper expersq black smsa south smsa66 reg662 reg663 reg664 reg665 reg666 reg667 reg668 reg669;
ods select ParameterEstimates;
output r = uhat;
run;
*The 2SLS coefficient for educ is .157, with standard error .053. The estimate is now even larger;

*Part iii;
proc reg data = cardc5xx;
model uhat = nearc2 nearc4 exper expersq black smsa south smsa66 reg662 reg663 
				reg664 reg665 reg666 reg667 reg668 reg669;
ods select FitStatistics Nobs ParameterEstimates;
run;
*The n-R-Squared statistic is (3010)(.0004) = 1.20. There is one over-identifying restriction so we compute
the p-value from the X1^2 distribution. p-value = P(X1^2 > 1.20) ~=.55, so the overidentifying restriction
is not rejected;



*Chapter 15 Question C6;
proc import datafile = "&path\murder.xls"
dbms = xls out = murder;
run;

*Part i;
proc freq data = murder;
table state*exec;
run;
*Sixteen states executed at least one prisoner. Texas has the most with 34 executions;

*Part ii;
proc reg data = murder;
model mrdrte = d93 exec unem;
where year ne 87;
ods select ParameterEstimates;
run;
*The coefficient on exec is positive so there is no sign of a deterrent effect from executions. However, it is
not statistically significant.;

*Part iii;
proc reg data = murder;
model cmrdrte = cexec cunem;
where year = 93;
ods select ParameterEstimates;
run;
*The coefficient on cexec is negative and significant, so it does appear that there is a deterrent effect.;

*Part iv;
data murder;
set murder;
exec_1 = lag(exec);
cexec_1 = exec_1 - lag(exec_1);
run;

proc reg data = murder;
model cexec = cexec_1;
ods select Nobs ParameterEstimates;
where year = 93;
run;
*This is evidence of strong negative correlation in the change in executions. This means that states appear to follow
policies where if executions were high in the preceding three-year period, they were lower, one-for-one in the next
three year period;

*Part v;
proc syslin data = murder 2sls;
instruments cexec_1 cunem;
model cmrdrte = cexec cunem;
ods select ParameterEstimates;
where year = 93;
run;
*This is very similar to what we obtained from the differenced equation by OLS. The most important change is that the 
standard error on B1 is now larger and thus B1 is less significant;



*Chapter 15 Question C7;
proc import datafile = "&path\phillips.xls"
dbms = xls out = phillips;
run;

*Part i;
*If unem is correlated with e, then OLS will be biased and inconsistent for estimating B1;

*Part ii;
*If E(e|inf_1, unem_1,...) = 0 then unem_1 is uncorrelated with e which means that unem_1 satisfies the first 
requirement for an IV in 
cinf = B0 + B1unem + e;

*Part iii;
proc reg data = phillips;
model unem = unem_1;
ods select Nobs ParameterEstimates;
run;
*There is strong, positive correlation between unem and unem_1;

*Part iv;
proc syslin data = phillips 2sls;
instruments unem_1;
model cinf = unem;
ods select ParameterEstimates;
run;
*The IV estimate of B1 is much lower in magnitude than the OLS estimate, and B1 is not statistically different
from zero. The OLS estimate was statistically significant;



*Chapter 15 Questoin C8;
proc import datafile = "&path\401ksubs.xls"
dbms = xls out = fourk;
run;

*Part i;
proc reg data = fourk;
model pira = p401k inc incsq age agesq;
ods select ParameterEstimates;
run;
*The coefficient on p401k implies that participation in a 401k plan is associated with a .054 higher probability of
having an individial retirement account;

*Part ii;
*While the equation in part i accounts for income and age, it does not account for the fact that people
have different tastes for savings, even within age and income categories. People that tend to be savers will have a 
401k and an IRA.;

*Part iii;
*We need e401k to be partially correlated with p401k. This is not an issue, as being eligible for a 401k is 
a requirement to participate in a 401k. The more difficult issue is whether e401k can be taken as exogenous in the
structural model. In other words, is being eligible for a 401k correlated with unobserved tase for saving?
If we think that workers that like to save for retirement will match up with employers that provide retirement saving
opportunities, then u and e401k will be correlated. Certainly we think that e401k is less correlated with u than
p401k. But this is not alone to ensure that the IV estimator has less asymptotic bias than the OLS estimator;

*Part iv;
proc reg data = fourk;
model p401k = e401k inc incsq age agesq / hcc;
ods select ParameterEstimates;
output out = fourkx r = uhat;
run;
*e401k has a t-statistic over 85, and with a coefficient of .69 there is definitely strong positive correlation;

*Part v;
proc syslin data = fourk 2sls;
instruments e401k inc incsq age agesq;
model pira = p401k inc incsq age agesq;
ods select ParameterEstimates;
run;
*The estimate on Bp401k is less than half as large as the OLS estimate, and p401k is not significant even at the
10% level. But we still do not estimate a tradeoff between participating in a 401k and an IRA;

*Part vi;
proc reg data = fourkx;
model pira = p401k inc incsq age agesq uhat / hcc;
ods select ParameterEstimates;
run;
*With a coefficient of .075 and t-statistic of 3.92 there is strong evidence that p401k is endogenous in the structural
equation;



*Chapter 15 Question C9;
proc import datafile = "&path\wage2.xls"
dbms = xls out = wagec9;
run;

*Part i;
proc syslin data = wagec9 2sls;
instruments sibs exper tenure black;
model lwage = educ exper tenure black;
ods select ParameterEstimates;
run;

*Part ii;
proc reg data = wagec9;
model educ = sibs exper tenure black;
output out = wagec9x p = yhat;
ods select none;
run;

proc reg data = wagec9x;
model lwage = yhat exper tenure black;
ods select ParameterEstimates;
run;
*We see that the Byhat = Beduc from part i. The standard error for Byhat is slightly higher at .03529.;

*Part iii;
proc reg data = wagec9;
model educ = sibs;
ods select none;
output out = wagec9xx p = educhat;
run;

proc reg data = wagec9xx;
model lwage = educhat exper tenure black;
ods select ParameterEstimates;
run;
*The coefficient on the educ fitted values now is .06997, and no longer is the correct .09363. The standard error is 
also .02638, which is also too low. The reduction in the estimated return to education from 9.4% to 7.0% is not trivial.
This demonstrates why it is best to avoid doing 2SLS manually;




*Chapter 15 Question C10;
proc import datafile = "&path\htv.xls"
dbms = xls out = htv;
run;

*Part i;
proc reg data = htv;
model lwage = educ / clb;
ods select ParameterEstimates;
run;
*The 95% confidence interval for the return to education is roughly 8.8% to 11.4%;

*Part ii;
proc reg data = htv;
model educ = ctuit;
ods select ParameterEstimates;
run;
*The t-statistic is only -.59, showing that there is no evidence of correlation between educ and college tuition.
Thus we cannot use ctuit as an IV for educ;

*Part iii;
proc reg data = htv;
model lwage = educ exper expersq ne nc west ne18 nc18 west18 urban urban18;
ods select ParameterEstimates;
run;
*Now the return to education is approximately 13.7%;

*Part iv;
proc reg data = htv;
model educ = ctuit exper expersq ne nc west ne18 nc18 west18 urban urban18;
ods select ParameterEstimates;
run;
*Now the coefficient on ctuit is -.165, t-statistic -2.77. So an increase in tuition of $1000 reduces years
of education by about .165;

*Part v;
proc syslin data = htv 2sls;
instruments ctuit exper expersq ne nc west ne18 nc18 west18 urban urban18;
model lwage = educ exper expersq ne nc west ne18 nc18 west18 urban urban18;
ods select ParameterEstimates;
run;
*The confidence interval is now very wide: 1.1% - 48.9%. While it does not include zero, it is too wide to be useful;

*Part vi;
*The very large standard error in part v shows that Iv is not very convincing in this case. This is as we expected
from part ii: that we could not use ctuit as an IV for educ;




*Chapter 15 Question C11;
proc import datafile = "&path\voucher.xlsx"
dbms = xlsx out = voucher replace;
run;

*Part i;
proc freq data = voucher;
table selectyrs;
table choiceyrs;
run;
*468 never received a voucher. 108 had a voucher for four years. 56 attended a choice school for four years;

*Part ii;
proc reg data = voucher;
model choiceyrs = selectyrs;
ods select ParameterEstimates;
run;
*They are related positively, as expected. The relationship is very strong with the coefficient on selectyrs = .767
with a t-statistic of 60.93. Selectyrs would be a reasonable IV candidate for choiceyrs;

*Part iii;
proc reg data = voucher;
model mnce = choiceyrs;
model mnce = choiceyrs black hispanic female;
ods select ParameterEstimates;
run;
*It is not the sign that is expected. Choiceyrs has a coefficient of -1.84, saying that each year at a choice school
decreased math scores by 1.8 points. Once we add the race and gender variables, the effect is no longer 
statistically significant;

*Part iv;
*There may be race or gender factors relating the number of years attending a choice school;

*Part v;
proc syslin data = voucher 2sls;
instruments selectyrs black hispanic female;
model mnce = choiceyrs black hispanic female;
ods select ANOVA ParameterEstimates;
run;
*Under IV, the coefficient on choiceyrs is still negative, at -.241, but it is not statistically significant.
The race variables are statistically significant and negative, but female is not significant;

*Part vi;
proc reg data = voucher;
model mnce = choiceyrs black hispanic female mnce90;
ods select Nobs ParameterEstimates;
run;

proc syslin data = voucher 2sls;
instruments selectyrs black hispanic female mnce90;
model mnce = choiceyrs black hispanic female mnce90;
ods select ParameterEstimates;
run;
*Under OLS the coefficient on choiceyrs is .41 and under IV it is 1.80. This variable is only significant
under IV. Under IV, each year at a choice school is worth 1.8 points on the math percentile score. This is a 
practically large effect;

*Part vii;
*It is not completely convincing because we went from 989 observations to only 328. Since many of the values
were missing for test scores, and Rouse hypothesized that these may be from students leaving the school district,
it makes sense that some of the poorer students may not be included in this sample;

*Part viii;
proc syslin data = voucher 2sls;
instruments selectyrs1 selectyrs2 selectyrs3 selectyrs4 black hispanic female;
model mnce = choiceyrs1 choiceyrs2 choiceyrs3 choiceyrs4 black hispanic female;
ods select ParameterEstimates;
run;
*Our results match those from part iv mostly. The choice variables are all insignificant, although this time all 
but choiceyrs3 are positive. Black and hispanic are both very negative and very significant. Female is still positive, 
but is not significant;
















