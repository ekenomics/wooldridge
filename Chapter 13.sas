********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/


%let path = F:\Data Sets;
*Chapter 13;
%let path = F:\Econometrics Supplement\Data Sets;
*Chapter 13 Question C1;
proc import datafile = "&path\fertil1.xls"
dbms = xls out = fertil;
run;

*Part i & ii;
proc reg data = fertil;
model kids = educ age agesq black east northcen west farm othrural town smcity
			y74 y76 y78 y80 y82 y84;
test farm, othrural, town, smcity = 0;
test east, northcen, west = 0;
output out = fertilx r = uhat;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA;
run;
*The F-value is 1.16 with a resulting p-value of .3275, so the living
environment variables are jointly insignificant;
*The f-value of the region dummy variables is 3.01 with resulting p-value of
.0293, which shows the region dummies are significant at the 5% level;

*Part iii;
data fertilx;
set fertilx;
uhatsq = uhat**2;
run;

proc reg data = fertilx;
model uhatsq = y74 y76 y78 y80 y82 y84;
ods select FitStatistics ANOVA ParameterEstimates;
run;
*Our F-value is 2.90, giving us a resulting p-value of .0082. There is strong
evidence of heteroskedasticity that is a function of time at the 1% level;

*Part iv;
proc reg data = fertil;
model kids = educ age agesq black east northcen west farm othrural town smcity
			y74 y76 y78 y80 y82 y84 y74educ y76educ y78educ y80educ y82educ y84educ;
test y74educ, y76educ, y78educ, y80educ, y82educ, y84educ = 0;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA;
run;
*The F-value of the interaction terms is 1.48, giving a resulting p-value of .1803.
This shows the interaction terms are not jointly significant.
However, the y78, y82, and y84 interaction terms are all significant at the 5% level,
with large coefficients. It appears that fertility may become more linked to education as 
time passes, but not in the early seventies.

These terms represent a linkage between fertility and education that is able to change
each year.We add these coefficients to the coefficient on educ to get the slope for the
appropriate year.;


*Chapter 13 Question C2;
proc import datafile = "&path\cps78_85.xls"
dbms = xls out = cps;
run;

*Part i;
proc reg data = cps;
model lwage = y85 educ y85educ exper expersq union female y85fem;
ods select FitStatistics ANOVA ParameterEstimates;
run;
*Y85 is the change in wage for a male, with zero years of educ. This is not very useful;

*Part ii;
data cpsx;
set cps;
y85educ12 = y85*(educ - 12);
run;

proc reg data = cpsx;
model lwage = y85 educ y85educ12 exper expersq union female y85fem / clb;
ods select ParameterEstimates;
run;
*The coefficient on y85 is .339, so the change would be 33.9% for 12 years of education.
With a standard error of .034, we obtain a confidence limit of .273 - .406, or 
27.3% - 40.6%;

*Part iii;
data cpsxx;
set cpsx;
wage = exp(lwage);
if year = 78 then rwage = wage;
if year = 85 then rwage = wage/1.65;
lrwage = log(rwage);
run;

proc reg data = cpsxx;
model lrwage = y85 educ y85educ exper expersq union female y85fem;
ods select FitStatistics ANOVA ParameterEstimates;
run;
*Only the coefficient on y85 changed, going from .118 to -.383. This shows real wages
have fallen over the 7 year period.;

*Part iv;
*The R-squared for lrwage as the dependent variable is .356 compared with .426 
with lwage as the dependent variable. Since the sum of squared errors are the same,
it means that the total sum of squares has changed;

*Part v;
proc means data = cps;
var union;
where year = 78;
where year = 85;
run;
*Union participation fell from about 30.6% to 18.0% over the seven years;

*Part vi;
proc reg data = cps;
model lwage = y85 educ y85educ exper expersq union female y85fem y85union;
ods select FitStatistics ANOVA ParameterEstimates;
run;
*The t-statistic on y85union is -0.01, which is not significant. There has been no
change on the union premium over time;

*Part vii;
*The results from v and vi don't conflict. One simply suggests that union membership has fallen,
while the other suggests that the benefits from being in a union have stayed the same;


 *Chapter 13 Question C3;
proc import datafile = "&path\kielmc.xls" 
dbms = xls out = kiel replace;
run;

*Part i;
*All else equal, houses farther away from the incinerator should be worth more. 
If B1 > 0, then the incinerator is farther away from more expensive homes;

*Part ii;
proc reg data = kiel;
model lprice = y81 ldist y81ldist;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on y81*ldist is .048, which is the expected sign. However,
it is not significant with t-value of only .59;

*Part iii;
proc reg data = kiel;
model lprice = y81 ldist y81ldist age agesq rooms baths lintst lland larea;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on y81*ldist is .062, with a t-stat of .502. The t-stat is now 1.24,
which is still not significant;

*Part iv;
*Once the other controls for the quality of a house are in the model, the distance
from the incerator no longer seems to make any difference on the price. This could be
because the other controls already give that information, ie the nicer houses, 
those with more rooms, lower age, etc, are already located farther from the 
incinerator;


*Chapter 13 Question C4;
proc import datafile = "&path\injury.xls"
dbms = xls out = injury replace;
run;

*Part i;
data injuryky;
set injury;
if ky = 0 then DELETE;
run;

proc reg data = injuryky;
model ldurat = afchnge highearn afhigh male married head neck upextr trunk
				lowback lowextr occdis manuf construc;
ods select FitStatistics ParameterEstimates;
run;
*The coefficient and standard error on afhigh is now .231 and .070. The estimated
effect and t-statistic are now higher than when we omit the control variables.;

*Part ii;
*The R-squared is .0412, which means we are only explaining 4.1% of the variation in ldurat
with this set of variables. This does not mean our equation is useless, merely that 
prediction would be very difficult and likely inaccurate. There are some important factors
that we are not accounting for.;

*Part iii;
data injurymi;
set injury;
if mi = 0 then DELETE;
run;

proc reg data = injurymi;
model ldurat = afchnge highearn afhigh;
ods select ParameterEstimates;
run;
*The coefficient on the interaction term is very similar to the one for the kentucky data,
but the t-statistic is much lower. In this case the interaction term is not 
significant. This could be partially due to the sample sizes, for michigan there are only
1500 observations, versus 5600 for Kentucky;



*Chapter 13 Question C5;
proc import datafile = "&path\rental.xls"
dbms = xls out = rental;
run;

*Part i;
proc reg data = rental;
model lrent = y90 lpop lavginc pctstu;
ods select ParameterEstimates;
run;
*The positive and significant coefficient on y90 means that rents grew on average
26.2% over the ten year period. Bpctstu = .005, which means that a one percentage point
increase in pctstu increases rent by .5%. Pctstu is statistically significant;

*Part ii;
*The standard errors are not valid, unless we think that ai does not really appear
in the model. If ai is in the error term, then the errors are correlated across the 
two time periods, invalidating the OLS standard errors and t statistics;

*Part iii;
proc reg data = rental;
model clrent = clpop clavginc cpctstu / hcc;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Now a one percentage point increase in pctstu is estimated to increase rental rates by
1.1%, over twice as much as under the initial model.;

*Part iv;
*The heteroskedastic robust standard error for cpctstu is .00284, which is actually
much smaller than the OLS standard error. This increases the t-statistic and significance
of pctstu;



*Chapter 13 Question C6;
proc import datafile = "&path\crime3.xls"
dbms = xls out = crime;
run;

*Part i;
data crime;
set crime;
thetabeta = cclrprc1 + cclrprc2;
run;

proc reg data = crime;
model clcrime = cclrprc1 thetabeta;
ods select FitStatistics ParameterEstimates;
run;
*After rewriting the model in order to test Ho: B1 = B2, we define Theta1 = B1 - B2.
Thus we write B1 = theta1 + b2.

After we plug that into the model we get a coefficient on theta1 = .0091 with standard
error .0085. This gives a t-statistic of 1.07, which is not statistically significant.
Thus we cannot reject B1 = B2;

*Part ii;
*With B1 = B2, the equation becomes:
	clcrime = d0 + B1(cclrprc1 + cclrprc2) + cu
			= d0 + d1[(cclrprc1 + cclrprc2)/2] + cu
where d1 = 2B1, but (cclrprc1 + cclrprc2) = cavgclr;

*Part iii;
proc reg data = crime;
model clcrime = cavgclr;
ods select FitStatistics ParameterEstimates;
run;
*Since we did not reject the hypothesis, we would be justified in using the simpler model
we found here. The adjusted R-squared in the model from part i is slightly higher. Ideally,
we would get more data to determine whether the fairly different unconstrained esimates
of B1 and B2 in equation 13.22 reveal true differences in B1 and B2;



*Chapter 13 Question C7;
proc import datafile = "&path\gpa3.xls"
dbms = xls out = gpa;
run;

*Part i;
proc reg data = gpa;
model trmgpa = spring sat hsperc female black white frstsem tothrs crsgpa season;
ods select ParameterEstimates;
run;
*The coefficient on season implies that all else fixed, an athlete's GPA is about .027
points lower when his/her sport is in season. However, the t-statistic is only -.56,
which is not significant;

*Part ii;
*If omitted ability is correlated with season then OLS is biased and inconsistent.;

*Part iii;
proc reg data = gpa;
model ctrmgpa = ctothrs ccrsgpa cseason;
ods select FitStatistics ParameterEstimates;
run;
*The variables sat, hsperc, female, black, white, and frstsem all drop out because
they do not vary by semester. 
Now the coefficient on season is -.065, with a t-statistic of -1.54, which is still
not significant;

*Part iv;
*One possible variable is a measure of course load. If athletes take a lighter course
load in season, this could make term GPA higher, all else fixed.;



*Chapter 13 Question C8;
proc import datafile = "&path\vote2.xls"
dbms = xls out = vote;
run;

*Part i;
proc reg data = vote;
model cvote = clinexp clchexp cincshr;
ods select ParameterEstimates TestANOVA;
test clinexp, clchexp = 0;
run;
*Only cincshr is significant at the 5% level;

*Part ii;
*The F-value is 1.51, with a p-value of .2236. These two variables are jointly
insignificant even at the 20% level;

*Part iii;
proc reg data = vote;
model cvote = cincshr;
ods select ParameterEstimates;
run;
*If the incumbent's share of spending increases by 10%, we would expect the vote to 
change by about 2.2%;

*Part iv;
proc reg data = vote;
model cvote = cincshr;
ods select Nobs ParameterEstimates;
where rptchall = 1;
run;
*The estimated effect is now much smaller, and the standard error is much larger.
Cincshr is no longer significant even at the 20% level;



*Chapter 13 Question C9;
proc import datafile = "&path\crime4.xls"
dbms = xls out = crimec9;
run;

*Part i;
data crimec9;
set crimec9;
clwcon = lwcon - lag(lwcon);
clwtuc = lwtuc - lag(lwtuc);
clwtrd = lwtrd - lag(lwtrd);
clwfir = lwfir - lag(lwfir);
clwser = lwser - lag(lwser);
clwmfg = lwmfg - lag(lwmfg);
clwfed = lwfed - lag(lwfed);
clwsta = lwsta - lag(lwsta);
clwloc = lwloc - lag(lwloc);
run;

proc reg data = crimec9;
model clcrmrte = d83 d84 d85 d86 d87 clprbarr clprbcon clprbpri clavgsen clpolpc
				clwcon clwtuc clwtrd clwfir clwser clwmfg clwfed clwsta clwloc;
ods select ParameterEstimates TestANOVA;
test clwcon, clwtuc, clwtrd, clwfir, clwser, clwmfg, clwfed, clwsta, clwloc = 0;
run;
*The coefficients on the criminal justice variables change very modestly,
and the statistical significance of each variable is also essentially unaffected;

*Part ii;
*Since some of the wage signs are positive and some are negative, they cannot all have
the expected sign. The F-Test gives a result of 1.25, which shows they are not jointly
significant even at the 20% level;



*Chapter 13 Question C10;
proc import datafile = "&path\jtrain.xls"
dbms = xls out = jtrain;
run;

proc reg data = jtrain;
model chrsemp = d89 cgrant cgrant_1 clemploy;
ods select Nobs ParameterEstimates;
run;
*There are 124 firms with both years of data, and three firms with only one year,
for a total of 127 firms. 30 Firms have missing data in both years are are not used.

*Part ii;
*The coefficient on grant means that if a firm received a grant for the current year, 
it trained each worker for an average of 32.6 hours more than otherwise. The t-statistic
is 10.98, making it very significant;

*Part iii;
*Since a grant last year would pay for training last year, it is not surprising
that cgrant_1 is insignificant;

*Part iv;
*The coefficient on the employees variable is very small. A 10% increase in employ increases
hours per employee by only .074. This is small, and the t-statistic is very small;



*Chapter 13 Question C11;
proc import datafile = "&path\mathpnl.xls"
dbms = xls out = mathpnl;
run;

*Part i;
proc reg data = mathpnl;
model math4 = y93 y94 y95 y96 y97 y98 lrexpp lenroll lunch;
ods select ParameterEstimates;
run;
*Cmath4 = B1*clrexpp = (b1/100)*[100*clog(rexpp)] = (B1/100) * %Crexpp
So if %crexpp = 10, then cmath4 = (B1/100)*10 = B1/10;

*Part ii;
proc reg data = mathpnl;
model cmath4 = y94 y95 y96 y97 y98 grexpp genrol clunch;
ods select ParameterEstimates;
run;
*The spending coefficient implies that a 10% increase in real spending per pupil
decreases the math4 pass rate by about 3.45/10 = .35 percentage points;

*Part iii;
proc reg data = mathpnl;
model cmath4 = y95 y96 y97 y98 grexpp grexpp_1 genrol clunch /hcc;
ods select ParameterEstimates;
output out = mathpnlr r = uhat;
run;
*The current spending variable still has a negative coefficient, but it is not 
statistically significant any longer.
The lagged variable has a positive coefficient and is very significant. It implies that 
a 10% increase in spending increased the pass rate by about 1.1%;

*Part iv;
*For grexpp the standard error is 3.04 under OLS and 4.28 under robustness.
For grexpp_1 the OLS standard error is 2.79 and the robust error is 4.37. This still
makes the lagged spending variable significant at the 5% level;

*Part v;
proc model data = mathpnl;
parms b0 b1 b2 b3 b4 b5 b6 b7 b8;
cmath4 = b0 + b1*y95 + b2*y96 + b3*y97 + b4*y98 + b5*grexpp + b6*grexpp_1 + b7*genrol + b8*clunch;
fit cmath4 / gmm kernel = (bart, 12, 0) vardef = n;
ods select ParameterEstimates;
run;
quit;
*The significance of the lagged spending variable drops slightly from a t-statistic of 
2.52 under robust standard errors to 2.18 under fully robust standard errors;

*Part vi;
data mathpnlr;
set mathpnlr;
uhat_1 = lag(uhat);
run;

proc reg data = mathpnlr;
model uhat = uhat_1;
ods select ParameterEstimates;
run;
*We see that p = -.463, with t-statistic of -24.25, making there very strong evidence
of negative serial correlation;

*Part vii;
proc reg data = mathpnl;
model cmath4 = y95 y96 y97 y98 grexpp grexpp_1 genrol clunch / acov;
ods select TestANOVA ACovTestANOVA;
test genrol, clunch = 0;
run;
**incorrect fully robust f-test results***;



*Chapter 13 Question C12;
proc import datafile = "&path\murder.xls"
dbms = xls out = murder;
run;

data murder;
set murder;
if year = 87 then DELETE;
run;

*Part i;
proc reg data = murder;
model mrdrte = d93 exec unem;
ods select ParameterEstimates;
run;
*We do not see a deterrent effect, in fact we see that exec has a coefficient of .127,
with a t-statistic of .49, so it is not very significant;

*Part ii;
proc reg data = murder;
model cmrdrte = cexec cunem;
ods select Nobs ParameterEstimates;
output out = murderx r = uhat p = yhat;
where year = 93;
run;
*Now we conclude that the deterrent effect is negative, with coefficient -.104,
and t-statistic of -2.39 making it significant at the 5% level;

*Part iii;
data murderx;
set murderx;
uhatsq = uhat**2;
yhatsq = yhat**2;
run;

proc reg data = murderx;
model uhatsq = cexec cunem;
ods select FitStatistics ANOVA ParameterEstimates;
run;
*F-value for Heteroskedasticity under Breusch-Pagan is 0.60;

proc reg data = murderx;
model uhatsq = yhat yhatsq;
ods select FitStatistics ANOVA ParameterEstimates;
run;
*Under the White test we obtain an F-value of 0.58. Both of these tests
confirm homoskedasticity;

*Part iv;
proc reg data = murder;
model cmrdrte = cexec cunem / hcc;
ods select Nobs ParameterEstimates;
output out = murderx r = uhat p = yhat;
where year = 93;
run;
*Our robust standard errors are all smaller than our OLS standard errors, causing
our variables to all become more significant;

*Part v;
*I feel more comfortable with the regular OLS standard error, as we do not have evidence
of heteroskedasticity, so there is no need to use robust standard errors. It is also 
more conservative in this case, but still gives a significant result;



*Chapter 13 Question C13;
proc import datafile = "&path\wagepan.xls"
dbms = xls out = wagepan;
run;
*Part i;
*We can estimate lwage, educ, and union by first differencing. The others are all either year
dummy variables or combinations of them, so they won't be affected by first differencing;

*Part ii;
data wagepan;
set wagepan;
d81educ = d81*educ;
d82educ = d82*educ;
d83educ = d83*educ;
d84educ = d84*educ;
d85educ = d85*educ;
d86educ = d86*educ;
d87educ = d87*educ;
clwage = lwage - lag(lwage);
ceduc = educ - lag(educ);
cunion = union - lag(union);
run;

proc reg data = wagepan;
model clwage = d81 d82 d83 d84 d85 d86 d87 d81educ d82educ d83educ d84educ d85educ
			d86educ d87educ ceduc cunion / hcc;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA ACovTestANOVA;
test d81educ, d82educ, d83educ, d84educ, d85educ, d86educ, d87educ =0;
run;
*The interaction variables of educ and time are not jointly significant, showing
little evidence of return to educ changes over time;

*Part iii;
****need to know how to do fully robust F Test;


*Part iv;
data wagepan;
set wagepan;
d81union = d81*union;
d82union = d82*union;
d83union = d83*union;
d84union = d84*union;
d85union = d85*union;
d86union = d86*union;
d87union = d87*union;
run;

proc reg data = wagepan;
model clwage = d81 d82 d83 d84 d85 d86 d87 d81educ d82educ d83educ d84educ d85educ
			d86educ d87educ ceduc cunion d81union d82union d83union d84union d85union
			d86union d87union;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA;
test d81union, d82union, d83union, d84union, d85union, d86union, d87union = 0;
run;
*In 1980, the return from being in a union was .08875, or 8.8%. 
In 1987, the difference is .08875 - .07964 = .00911, or .91%. The difference 
is significant at the 10% level since d87union has a t-statistic of -1.67;

*Part v;
*The F-value for the test of return to union changing with time is .99, with a resulting
p-value of .44. This is conflicting with our resulting from part iv, because we say a 
significant difference that was statistically significant. This could be because only 
d86union and d87union were significant at even the 15% level.;



*Chapter 13 Question C14;
proc import datafile = "&path\jtrain3.xls"
dbms = xls out = jtrain replace;
run;

*Part i;
proc reg data = jtrain;
model re78 = train;
ods select ParameterEstimates;
run;
*The model shows that training had a negative impact on real earnings in 1978;

*Part ii;
data jtrain;
set jtrain;
cre = re78 - re75;
run;

proc reg data = jtrain;
model cre = train / hcc clb;
ods select ParameterEstimates;
run;
*Nowe we have an estimated positive effect as a result of train. It appears train increased the growth rate of wages,
but the effect on the dollar amount of wages is more difficult to determine;

*Part iii;
*Under OLS the confidence interval is .411 to 3.67. 
With robust errors it is .769 to 3.31394. 
This is an odd finding where the robust standard error is smaller than the OLS standard error;



*Chapter 13 Question C15;
proc import datafile = "&path\happiness.xlsx"
dbms = xlsx out = happiness replace;
run;

*Part i;
proc freq data = happiness;
table vhappy;
run;

proc freq data = happiness;
table year;
run;
*5260 report being very happy, 30.69%;
*2006 has the highest number of observations with 2986, 2004 has the smallest with 1337;

*Part ii;
proc reg data = happiness;
model vhappy = y96 y98 y00 y02 y04 y06 / hcc;
test y96, y98, y00, y02, y04, y06 = 0;
ods select ParameterEstimates TestANOVA ACovTestANOVA;
run;
*The p-value for the joint significance of all our dummy variables is about .20 under
robust F-Test. This shows happiness hasn't changed over time;

*Part iii;
proc reg data = happiness;
model vhappy = y96 y98 y00 y02 y04 y06 occattend regattend;
ods select ParameterEstimates;
run;
*Both occattend and regattend have positive coefficients, showing that church attendance
has a positive impact on happiness. Occattend is not significant with t-statistic 0.53, 
but regattend is very significant with a t-statistic of 10.37;

*Part iv;
data happiness;
set happiness;
if income = "$25000 or more" then highinc = 1;
else highinc = 0;
run;

proc reg data = happiness;
model vhappy = y96 y98 y00 y02 y04 y06 occattend regattend highinc unem10 educ teens;
ods select ParameterEstimates;
run;
*The coefficient on regattend drops very slightly, from .112 to .107. The t-statistic drops
from just over 10 to 8.13, but is still very significant;

*Part v;
*Highinc has a positive sign and is very significant. This makes good sense, because
it is saying more money increases happiness, which is a safe assumption.

Unem10 has a negative sign and is very significant. This makes sense, since being unemployed
would naturally have a negative impact on happiness.

Educ has a positive sign and is very significant. This makes sense, since more education is
usually not only a sign of higher income, but also of being able to pursue a passion, and thus
enjoy work more.

Teens has a negative sign but is only significant at the 10% level. This can be looked at in
a few ways. Some would argue that the teenage years are full of stress for the children and
the parents, and that this could decrease happiness. Others would argue that kids are always
going to increase happiness, and this is likely why this term is not as significant as others;

*Part vi;
proc reg data = happiness;
model vhappy = y96 y98 y00 y02 y04 y06 occattend regattend highinc unem10 educ teens
				female black;
ods select ParameterEstimates;
run;
*Adding female and black to our model gives us a near zero coefficient on female that is
not significant at all. 
Black has a negative coefficient, that is very significant with t=-4.24. This gives 
evidence that there is a negative happiness effect associated with being black;

