********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/


%let path = F:\Data Sets;
*Chapter 17;
%let path = F:\Econometrics Supplement\Data Sets;
*Chapter 17 Question C1;
proc import datafile = "&path\pntsprd.xls"
dbms = xls out = pntsprd;
run;

*Part i;
*If spread is zero, the team that is labeled the favorite should have a 50% chance of winning;

*Part ii;
proc reg data = pntsprd;
model favwin = spread / hcc;
ods select ParameterEstimates TestANOVA ACovTestANOVA;
test intercept = 0.5;
run;
*Under OLS standard errors we can reject Ho at the 1% level. Under robust standard errors 
we can reject Ho at the 2% level;

*Part iii;
*Spread is very statistically significant under either standard error;
data spread;
probwin = 0.577 + 0.0194*10;
put probwin;
run;
*The probability of a team winning when the spread = 10 is 0.771;

*Part iv;
proc logistic data = pntsprd descending;
model favwin = spread /link=probit;
contrast 'spread = 10' intercept 1 spread 10 /estimate = prob;
ods select ParameterEstimates ContrastEstimate;
run;
*The t-statistic for testing Ho: B0 = 0 is only .0104, so we do not reject Ho;
*In the probit model, P(favwin = 1|spread) = phi(B0 + B1spread)
where Phi() denotes the standard normal cdf, if Bo = 0 then:
P(Favwin = 1|spread) = phi(B1spread)
and in particular, P(favwin = 1|spread = 0) = Phi(0) = 0.5. This is the
analog of testing whether the intercept is 0.5 in the LPM model.;

*Part v;
*When spread = 10, the estimated probability of winning is .820. This is higher than the LPM model suggested;

*Part vi;
proc logistic data = pntsprd descending;
model favwin = spread favhome fav25 und25 /link=probit;
test favhome, fav25, und25 = 0;
ods select ParameterEstimates TestStmts;
run;
*The P-value from the test for joint significance of these new variables is .61. This test has 3 df. Therefore, once spread is controlled for, these new variables
offer no additional predictive power;




*Chapter 17 Question C2;
proc import datafile = "&path\loanapp.xls"
dbms = xls out = loan;
run;

*Part i;
proc logistic data = loan descending;
model approve = white / link = probit;
contrast 'white' intercept 1 white 1 /estimate = prob;
contrast 'nonwhite' intercept 1 white 0 / estimate=prob;
ods select ParameterEstimates ContrastEstimate;
run;
*The predicted probability for nonwhites is .708 and for whites is .908. 
Without rounding error these are identical to the estimates from the LPM. This must always be the case
when the independent variables in a binary response model are mutually exclusive and exhaustive binary variables.
Then, the predicted probabilities are simply the cell frequencies.;

*Part ii;
proc logistic data = loan descending;
model approve = white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr
				/ link = probit;
ods select ParameterEstimates;
run;
*There is statistically significant evidence of discrimination against nonwhites as the coefficient on white is .520;

*Part iii;
proc logistic data = loan descending;
model approve = white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr
				/ link = logit;
ods select ParameterEstimates;
run;
*Using logit, the coefficient on white is now .938, and is still significant;

*Part iv;
*estimate the sizes of the discrimination effects for probit and logit??;



*Chapter 17 Question C3;
proc import datafile = "&path\fringe.xls"
dbms = xls out = fringe;
run;

*Part i;
proc freq data = fringe;
table pension;
run;
*27.92% of the sample has pension = 0;
proc means data = fringe range max min;
var pension;
where pension ne 0;
run;
*The range is 2872.99, with a minimum of 7.28 and max of 2880.27;
*Tobit models are useful when there is a corner solution response. This means the variable is zero for a nontrivial 
fraction of the population but is roughly continuously distributed over positive values.;

*Part ii;
proc qlim data = fringe;
model pension = exper age tenure educ depends married white male;
endogenous pension ~ censored (lb=0);
ods select ParameterEstimates;
run;
*Both white and male increase pension benefits but only males is statistically significant;

*Part iii;
*PREDICTED TOBIT VALUES???;

*Part iv;
proc qlim data = fringe;
model pension = exper age tenure educ depends married white male union;
endogenous pension ~ censored (lb=0);
ods select ParameterEstimates;
run;
*The t-statistic for union is very large and significant;

*Part v;
proc qlim data = fringe;
model peratio = exper age tenure educ depends married white male union;
endogenous peratio ~ censored (lb=0);
ods select ParameterEstimates TestResults;
test male, white = 0;
run;
*Male and white are jointly and indvidually insignificant. Therefore, neither whites nor males seems to have 
different tastes for pension benefits as a fraction of earnings;



*Chapter 17 Question C4;
proc import datafile = "&path\crime1.xls"
dbms = xls out = crime replace;
run;

*Part i;
proc genmod data = crime;
model narr86 = pcnv avgsen tottime ptime86 qemp86 inc86 black hispan born60 pcnvsq pt86sq inc86sq 
				/ dist = poisson;
ods select ParameterEstimates ModelFit;
run;

*Part ii;
*Our variance is 1.3912, so there is no evidence of overdispersion. The maximum likelihood standard errors
should be multiplied by sigma, which would be about 1.179. Therefore the MLE standard errors would be increased by
about 18%;

*Part iii;
*From table 17.3 we have the log-likelihood value for the restricted model: -2,248.76. The log-likelihood value
for the model above is 2,168.87. Therefore the usual likelihood ratio statistic is 159.78. 
The quasi-likelihood ratio statistic is 159.78/1.39 =~114.95. In a X3^2 distribution this gives a p-value of essentially
zero. Not surprisingly, the quadratic terms are jointly very significant;




*Chapter 17 Question C5;
proc import datafile = "&path\fertil1.xls"
dbms = xls out = fertil;
run;

*Part i;
proc genmod data = fertil;
model kids = educ age agesq black east northcen west farm othrural town smcity y74 y76 y78 y80 y82 y84 
			/dist = poisson;
ods select ParameterEstimates ModelFit;
output out = fertilx p = yhat;
run;
*The coefficient on y82 means that, other factors in the model fixed, a woman's fertility was about
19.3% lower in 1982 than in 1972.;

*Part ii;
data black;
fert = exp(.360) - 1;
put fert;
run;
*A black woman has 43.3% more children than a comparable nonblack woman. Black is also very significant;

*Part iii;
*Sigma = sqrt(.8915) = .944. This shows there is actually underdispersion in the estimated model;

*Part iv;
proc corr data = fertilx;
var kids yhat;
run;
*Corr = .34770;

data corrsq;
corrsq = .34770**2;
put corrsq;
run;
*The squared correlation is .12090;

proc reg data = fertil;
model kids = educ age agesq black east northcen west farm othrural town smcity y74 y76 y78 y80 y82 y84;
ods select FitStatistics;
run;
*The R-Squared for the OLS model is .1295, very similar although OLS is slightly higher;



*Chapter 17 Question C6;
proc import datafile = "&path\recid.xls"
dbms = xls out = recid;
run;

proc reg data = recid;
where cens = 0;
model ldurat = workprg priors tserved felon alcohol drugs black married educ age;
ods select ParameterEstimates;
run;
*There are several differences between OLS estimates using the uncensored durations and estimates from the censored
regression in Table 17.4. For example, the binary indicator for drug usage, drugs, has become positive and 
insignificant, whereas it was negative and significant in 17.4. On the other hand, the work program dummy, becomes 
positive but is still insignificant. The remaining coefficients maintain the same sign, but they all head towards zero. 
The apparent bias of OLS on black is severe, where the coefficient changes from -.543 to -.0085. ;



*Chapter 17 Question C7;
proc import datafile = "&path\mroz.xls"
dbms = xls out = mroz;
run;

*Part i;
proc reg data = mroz;
where inlf = 1;
model lwage = educ exper expersq nwifeinc age kidslt6 kidsge6;
ods select ParameterEstimates Nobs;
run;
*The coefficient on educ is .0999 with standard error .01510;

*Part ii;
*HECKITT TWO STEP TRANSFORMATION;

*Part iii;
*HECKITT CONTINUED;

*Part iv;



*Chapter 17 Question C8;
proc import datafile = "&path\jtrain2.xls"
dbms = xls out = jtrain replace;
run;

*Part i;
proc freq data = jtrain;
table train;
run;
proc means data = jtrain max;
var mostrn;
run;
*185/445 men participated in the job training program. The longest amount of time in the program was 24 months;

*Part ii;
proc reg data = jtrain;
model train = unem74 unem75 age educ black hisp married;
ods select ANOVA Parameterestimates;
run;
*With an F-value of 1.43, these variables are insignificant even at the 15% level.;

*Part iii;
proc logistic data = jtrain;
model train = unem74 unem75 age educ black hisp married / link = probit;
ods select GlobalTests;
run;
*Under a probit model, the likelihood ratio test for joint significance is 10.18 giving a p-value of .18. 
This is similar to that obtained from the LPM in part ii;

*Part iv;
*Training eligibility was randomly assigned among the participants, so it is not surprising that train appears
to be independent of the other factors.;

*Part v;
proc reg data = jtrain;
model unem78 = train;
ods select ParameterEstimates;
run;
*Participating in the job training program lowers the probability of being unemployed in 1978 by .111 or 11.1%. 
This effect is significant at the 2% level. 

*Part vi;
proc logistic data = jtrain descending;
model unem78 = train /link = probit;
ods select ParameterEstimates ContrastEstimate;
contrast 'train 1' intercept 1 train 1 /estimate = prob;
contrast 'train 0' intercept 1 train 0 /estimate = prob;
run;
*It doesn't make sense to compare the coefficient on train for the probit, -.321, with the LPM estimate. 
The probabilities have different functional forms.;

*Part vii;
*There are only two fitted values in each case, and they are the same. .354 when train = 1 and .243 when train = 0.
This has to be the case, because either method simply delivers the cell frequencies as the estimated probabilities.;

*Part viii;
proc reg data = jtrain;
model unem78 = train unem74 unem75 age educ black hisp married;
ods select ParameterEstimates;
output out = jtrainols p = fitted;
run;

proc logistic data = jtrain descending;
model unem78 = train unem74 unem75 age educ black hisp married /link = probit;
ods select ParameterEstimates;
output out = jtrainolsx p = probitfit;
run;

data jtrainolsxx;
merge jtrainols jtrainolsx;
run;

proc corr data = jtrainolsxx;
var fitted probitfit;
run;
*The fitted values are no longer identical because the model is not saturated. As in, the explanatory variables
are not an exhaustive, mutally exclusive set of dummy variables. The fitted values have a correlation of .993 however.;

*Part IX;
*average partial effecct of train?;




*Chapter 17 Question C9;
proc import datafile = "&path\apple.xls"
dbms = xls out = apple;
run;


*Part i;
proc freq data = apple;
table ecolbs;
run;
*248 want zero ecolbs;

*Part ii;
*The distribution is not continuous: there are clear focal points, and rounding. This violates the latent error
assumption of the Tobit model, where the latent error has a normal distribution. We should still view Tobit in this 
context as a way to possibly improve functional form.;

*Part iii;
proc qlim data = apple;
model ecolbs = ecoprc regprc faminc hhsize;
endogenous ecolbs ~ censored (lb=0);
test faminc, hhsize = 0;
test -ecoprc = regprc;
output expected out = applex;
ods select ParameterEstimates TestResults;
run;
*Ecoprc and recprc are significant at the 1% level;

*Part iv;
*Hhsize and faminc are significant at the 10% level, but not the 5% level;

*Part v;
*The signs of the price coefficients accord with basic demand theory: the own-price effect is negative, 
the cross price effect for the substitute good (regular apples) is positive;

*Part vi;
*When testing -ecoprc = regprc we get a p-value of .78, so we do not reject the null;

*Part vii;
proc means data = applex max min range;
var expct_ecolbs;
run;
*The expected values range from .798 to 3.327;

*Part viii;
proc corr data = applex;
var expct_ecolbs ecolbs;
run;

data corrsq;
corrsq = .19201**2;
put corrsq;
run;
*The squared correlation is .0369;

*Part ix;
proc reg data = apple;
model ecolbs = ecoprc regprc faminc hhsize;
ods select FitStatistics ParameterEstimates;
run;
*The OLS estimates are smaller because the OLS estimates are estimated partial effects on E(ecolbs|X), whereas
Tobit coefficients must be scaled by the term in equation 17.27. The scaling factor is always between zero and one,
and often substantially less than one. The Tobit model doesn't fit better: the R-Squared for the linear odel is .0393 
vs .0369 for the Tobit model;

*Part x;
*This is not a correct statement. We have another case where we have confidence in the ceteris paribus price effects
yet we cannot explain much of the variation in ecolbs. The fact that demand for a fictitious product is hard to 
explain is not surprising;




*Chapter 17 Question C10;
proc import datafile ="&path\smoke.xls"
dbms = xls out = smoke;
run;

*Part i;
proc freq data = smoke;
table cigs;
run;
*467 people do not smoke at all. 101 people smoke 20 cigs a day. This is 12.52% of the sample. A pack of cigs is
20 cigs so it makes sense to be a focal point;

*Part ii;
*The poisson distribution does not allow for the kinds of focal points that characterize cigs. Looking at the
full frequency distribution there are focal points at half a pack, two packs, etc. The probabilities in the Poisson
distribution have a much smoother transition. However, the Poisson regression model does have nice robustness properties;

*Part iii;
proc genmod data = smoke;
model cigs = lcigpric lincome white educ age agesq /dist = poisson;
ods select ParameterEstimates ModelFit;
output out = smokex p = yhat;
run;
*Estimated price elasticity is -.355 and income elasticity is .085;

*Part iv;
*Both Lcigpric and lincome are significant at the 5% level under our unmodified standard errors;

*Part v;
*Variance = 20.61 and sigma = 4.54. This is evidence of overdispersion, and means all of the standard errors for the 
Poisson regression should be multiplied by 4.54. The T-statistics should be divided by 4.54;

*Part vi;
*The robust t-statistics for lcigpric is about -.54, making it very insignificant. The robust t-statistic for
lincome is about .94, making it also insignificant;

*Part vii;
*The education and age variables are still significant under the modified standard errors. The robust t-statistic on 
educ is still over three in absolute value, and the robust t-statistic on age is over five. The coefficient on educ
implies that one more year of education reduces the expected number of cigarrettes smoked by about 6.0%;

*Part viii;
proc means data = smokex range max min;
var yhat;
run;
*Max: 18.83 Min: .515. The fact that we predict smoking for everyone in the model is al imitation with using
the expected value for prediction. We do not predict anyone will smoke even one pacck a day, even though over 25% 
of the sample smokes at least 20 cigs a day. This shows that smoking, and especially heavy smoking, is difficult to
predict with our set of variables;

*Part ix;
proc corr data = smokex;
var yhat cigs;
run;

data corrsq;
corrsq = .20786**2;
put corrsq;
run;
*The squared correlation is .0432;

*Part x;
proc reg data = smoke;
model cigs = lcigpric lincome white educ age agesq;
ods select FitStatistics ParameterEstimates;
run;
*The OLS model provides slightly better fit with an R-Squared of .0451 vs .0432 for the Poisson. Both R-Squareds are
very small;




*Chapter 17 Question C11;
proc import datafile = "&path\cps91.xls"
dbms = xls out = cps;
run;

*Part i;
proc freq data = cps;
table inlf;
run;
*58.32% of the sample reports being in the labor force;

*Part ii;
proc reg data = cps;
model lwage = educ exper expersq black hispanic;
ods select ParameterEstimates Nobs;
run;
*Black and hispanic are both insignificant. This shows that once educ and exper are controlled for there isn't a difference
in women's wages based on race and ethnicity;

*Part iii;
proc logistic data = cps descending;
model inlf = educ exper expersq black hispanic nwifeinc kidslt6 /link = probit;
ods select ParameterEstimates;
run;

*Both nwficeinc and kidslt6 are significant. They both have the expected negative sign;

*Part iv;
*no idea;

*Part v;
*INVERSE MILLS RATIOS;

*Part vi;
*ANSWER QUESTION;



*Chapter 17 Question C12;
proc import datafile = "&path\charity.xls"
dbms = xls out = charity;
run;

*Part i;
proc freq data = charity;
table resplast;
run;
*33.48% of people responded to the most recent mailing;

*Part ii;
proc logistic data = charity;
model respond = resplast weekslast propresp mailsyear avggift /link = probit;
ods select ParameterEstimates;
run;
*Resplast, weekslast, propresp, and mailsyear are all significant at the 5% level;

*Part iii;
*average partial effect?;
proc reg data = charity;
model respond = resplast weekslast propresp mailsyear avggift;
ods select ParameterEstimates;
run;

*Part iv;
proc qlim data = charity;
model gift = resplast weekslast propresp mailsyear avggift;
endogenous gift ~ censored (lb = 0);
ods select ParameterEstimates;
run;
*Now all the variables other than resplast are significant at the 1% level;

*Part v;
*average partial effects?;

*Part vi;
*are ii and iv compatible with a tobit model?
;



*Chapter 17 Question C13;
proc import datafile = "&path\htv.xls"
dbms = xls out = htv;
run;

*Part i;
proc reg data = htv;
model lwage = educ abil exper nc west south urban;
ods select Nobs ParameterEstimates;
run;
*The estimated return to education is 10.4% for each additional year of education. The standard error 
on education is .00969;

*Part ii;
proc reg data = htv;
model lwage = educ abil exper nc west south urban;
ods select Nobs ParameterEstimates;
where educ < 16;
run;
*We go from 1230 observations to 1064. Now the estimated return to education is 11.8%;

*Part iii;
proc reg data = htv;
model lwage = educ abil exper nc west south urban;
ods select Nobs ParameterEstimates;
where wage < 20;
run;
*Now the return to education is 5.8%;

*Part iv;
data log20;
log20 = log(20);
put log20;
run;
proc qlim data = htv;
model lwage = educ abil exper nc west south urban;
endogenous lwage ~ censored (ub  = 2.9957322736);
ods select ParameterEstimates;
run;
*Now we obtain a return to education of 9.8%. This is close to what we obtained in part i, but still lower. ;



*Chapter 17 Question C14;
proc import datafile = "&path\happiness.xlsx"
dbms = xlsx out = happy;
run;

*Part i;
proc logistic data = happy;
model vhappy = occattend regattend y96 y98 y00 y02 y04 y06 / link = probit;
ods select ParameterEstimates;
run;

proc reg data = happy;
model vhappy = occattend regattend y96 y98 y00 y02 y04 y06;
ods select ParameterEstimates;
run;
*average partial effects?;

*Part ii;
data happy;
set happy;
if income = "$25000 or more" then highinc = 1; else highinc = 0;
run;

proc logistic data = happy;
model vhappy = occattend regattend highinc unem10 educ teens y96 y98 y00 y02 y04 y06 / link = probit;
ods select ParameterEstimates;
run;
*average partial effect?;
*RegAttend is still very significant;

*Part iii;
*discuss APE and significance of new variables;

*Part iv;
proc logistic data = happy;
model vhappy = occattend regattend highinc unem10 educ teens y96 y98 y00 y02 y04 y06 black female
				/ link = probit;
ods select ParameterEstimates;
run;
*There appears to be a higher level of happiness for blacks in the sample. The coefficient is .171 and is very
significant. Female is very insignificant so it appears gender does not play a role.;




*Chapter 17 Question C15;
proc import datafile = "&path\alcohol.xlsx"
dbms = xlsx out = alcohol;
run;

*Part i;
proc freq data = alcohol;
table employ;
table abuse;
run;
*89.82% of the saple is employed. 9.92% of the sample has abused alcohol;

*Part ii;
proc reg data = alcohol;
model employ = abuse / hcc;
ods select ParameterEstimates;
output out = alcoholx p = yhat;
run;
*If someone has abused alcohol they are 2.83% more likely to be unemployed. This is an expected relationship. 
Abuse is statistically significant;

*Part iii;
proc logistic data = alcohol descending;
model employ = abuse / link = probit;
ods select ParameterEstimates ContrastEstimate;
contrast 'abuse 1' intercept 1 abuse 1 /estimate = prob;
contrast 'abuse 0' intercept 1 abuse 0 /estimate = prob;
run;
*Average partial effects?;

*Part iv;
proc freq data = alcoholx;
table yhat*abuse;
run;
*When abuse = 1 under the LPM, the fitted value is .8727. This is the same as the probit model. 
When abuse = 0 under the LPM, the fitted value is .9010. This is the same as the probit model.
We see this because our independent variables are mutually exhaustive and exclusive, so the probabilities are 
simply the cell frequencies;

*Part v;
proc reg data = alcohol;
model employ = abuse age agesq educ educsq married famsize white northeast midwest south centcity outercity 
				qrt1 qrt2 qrt3/ hcc;
ods select ParameterEstimates;
run;
*Abuse's coefficient is now -.0203 which is lower in magnitude. It is slightly less significant at now is
not significant at the 5% level using robust standard errors;

*Part vi;
proc logistic data = alcohol descending;
model employ = abuse age agesq educ educsq married famsize white northeast midwest south centcity outercity 
				qrt1 qrt2 qrt3/link = probit;
ods select ParameterEstimates;
run;
*APE?
*The t-statistic on abuse is now -2.12.;
*Is this identical to the linear model?;

*Part vii;
*It is not obvious but it is worth examining. It could be the fact that abuse is not the reason that people are 
not employed, but the health deterioration that may result from abuse that could be the real reason;

*Part viii;
*It is likely that alcohol abuse is correlated with educ, age, and also where in the country you are located,
making it endogenous. It is likely that we could use mothalc and fathalc as IVs for abuse;

*Part ix;
proc syslin data = alcohol 2sls out = alcoholv;
instruments mothalc fathalc age agesq educ educsq married famsize white northeast midwest south centcity outercity
			qrt1 qrt2 qrt3;
model employ = abuse age agesq educ educsq married famsize white northeast midwest south centcity outercity 
				qrt1 qrt2 qrt3;
ods select ParameterEstimates;
output r = uhat;
run;
*The 2SLS coefficient on abuse is -.355 which is practically large compared to -.0203 under OLS.;

*Part x;
proc reg data = alcohol;
model abuse = mothalc fathalc age agesq educ educsq married famsize white northeast midwest south centcity outercity 
				qrt1 qrt2 qrt3;
ods select none;
output out = alcoholt r = uhat;
run;

proc reg data = alcoholt;
model employ = abuse age agesq educ educsq married famsize white northeast midwest south centcity outercity 
				qrt1 qrt2 qrt3 uhat / hcc;
ods select ParameterEstimates;
run;
*Since the variable uhat is significantly different than zero, we can conclude that abuse is endogenous;




