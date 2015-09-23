********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/


%let path = F:\Data Sets;
*Chapter 16;
%let path = F:\Econometrics Supplement\Data Sets;
*Chapter 16 Question C1;
proc import datafile ="&path\smoke.xls"
dbms = xls out = smoke;
run;

*Part i;
*100*B1 is the approximate percentage change in income if a person smokes one more cig per day;

*Part ii;
*Since consumption and price are negatively related, we expect y5 < 0. Restaurant smoking restrictions 
should reduce cigarette smoking, so y6 < 0;

*Part iii;
*We need y5 or y6 to be different from zero. That is, we need at least one exogenous variable in the cigs equation
that is not also in the log(income) equation;

*Part iv;
proc reg data = smoke;
model lincome = cigs educ age agesq;
ods select ParameterEstimates;
run;
*The coefficient on cigs implies that smoking causes income to increase, but the coefficient is not statistically
different from zero;

*Part v;
proc reg data = smoke;
model cigs =educ age agesq lcigpric restaurn;
ods select nobs ANOVA FitStatistics ParameterEstimates;

run;
*Lcigpric is not significant at all, but restaurn is both negative and significant at the 5% level; 

*Part vi;
proc syslin data = smoke 2sls;
instruments restaurn educ age agesq;
model lincome = cigs educ age agesq;
ods select ParameterEstimates;
run;

*Part vii;
*Assuming that state level cigarette prices and restaurant smoking restrictions are exogenous in the income equation
is problematic. Incomes are known to vary by region, as do smoking restrictions. It could be that in states where
income is lower, after controlling for education and age, smoking restrictions are less likely to be in place;




*Chapter 16 Question C2;
proc import datafile = "&path\mroz.xls"
dbms = xls out = mroz replace;
run;

*Part i;
data mroz;
set mroz;
lhours = log(hours);
run;
proc syslin data = mroz 2sls;
instruments educ age kidslt6 nwifeinc exper expersq;
model lhours = lwage educ age kidslt6 nwifeinc;
ods select ParameterEstimates;
run;
*The model implies an elasticity of 1.99. This is even higer than the 1.26 we obtained from equation 16.24;

*Part ii;
proc syslin data = mroz 2sls out = mrozx;
instruments motheduc fatheduc age kidslt6 nwifeinc exper expersq;
model lhours = lwage educ age kidslt6 nwifeinc;
ods select ParameterEstimates;
output r = uhat;
run;

*Part iii;
proc reg data = mrozx;
model uhat = age kidslt6 nwifeinc exper expersq motheduc fatheduc;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The N-R-Squared statistic is 428*(.0010) = .428. We have two overidentifying restrictions, so the p-value is roughly
P(X2^2 > .43) ~~= .81. There is no evidence against the exogeneity of the IVs;




*Chapter 16 Question C3;
proc import datafile = "&path\openness.xls"
dbms = xls out = openness;
run;

*Part i;
proc reg data = openness;
model inf = open;
ods select ParameterEstimates;
run;

proc syslin data = openness 2sls;
instruments lland;
model inf = open;
ods select ParameterEstimates;
run;
*The OLS coefficient is the same, when lpcinc is in the model. The IV estimate with lpcinc is the equation is -.337, 
which is very close to -.333. Dropping lpcinc makes little difference;

*Part ii;
proc reg data = openness;
model open = land;
model open = lland;
model open = land lland;
ods select FitStatistics ParameterEstimates;
run;
*The regression of open on lland has a much higher R-Squared. In the equation with both land variables, 
land is not significant while log(land) is very significant;

*Part iii;
proc syslin data = openness 2sls;
instruments lland lpcinc oil;
model inf = open lpcinc oil;
ods select ParameterEstimates;
run;
*Being an oil producer is estimated to reduce average annual inflation by over 6.5%, but this effect is not
significant. This is not surprising since there are only 7 oil producers in the sample;




*Chapter 16 Question C4;
proc import datafile = "&path\consump.xls"
dbms = xls out = consump;
run;

*Part i;
proc syslin data = consump 2sls out = consumpx;
instruments gc_1 gy_1 r3_1;
model gc = gy r3;
ods select ParameterEstimates;
output r = uhat;
run;

proc reg data = consumpx;
model uhat = gc_1 gy_1 r3_1;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The N-R-Squared statistic is 35*(.0613) = ~ 2.15. The p-value is P(X1^2 > 2.15) =~.143 so the instruments
pass the overidentification test at the 10% level;

*Part ii;
proc syslin data = consump 2sls;
instruments gc_2 gy_2 r3_2;
model gc = gy r3;
ods select ParameterEstimates;
run;
*The coefficient on gy has doubled in size compared to equation 16.35, but it is not statistically significant.
The coefficient on r3 is small and insignificant;

*Part iii;
proc reg data = consump;
model gy = gc_2 gy_2 r3_2;
ods select ANOVA ParameterEstimates;
run;
*The F-Value of the model is .14, so there is no correlation between gy and the proposed IVs. Therefore, 
we should not use these variables as IVs in the previous model;




*Chapter 16 Question C5;

*Requires updating data from ERP 2005 or later;



*Chapter 16 Question C6;
proc import datafile = "&path\cement.xls"
dbms = xls out = cement replace;
run;
*Several errors in data. Needed to recalculate values for gprc, gcem, gprcpet, grdefs, grres, grnon etc;

*Part i;
proc reg data = cement;
model gprc = gcem gprcpet feb mar apr may jun jul aug sep oct nov dec;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Several dummies are very significant, while several are not significant at all. The estimated supply curve
slopes down, not up, and the coefficient on gcem is very significant;

*Part ii;
proc reg data = cement;
model gcem = grdefs gprcpet feb mar apr may jun jul aug sep oct nov dec;
ods select ParameterEstimates;
run;
*We need grdefs to have a nonzero coefficient in the reduced form for gcem. 
We cannot reject Ho: pi1 = 0 at any reasonable significant level since the t-statistic for grdefs is so low. 
We cannot use grdefs as a IV for gcem;

*Part iii;
proc reg data = cement;
model gcem = grres grnon gprcpet feb mar apr may jun jul aug sep oct nov dec;
ods select ParameterEstimates;
run;
*We need either pi1 or pi2 to be different than zero now. In this grnon has a coefficient of 1.15, which is very 
significant so we can proceed with IV estimation;

*Part iv;
proc syslin data = cement 2sls;
instruments grres grnon gprcpet feb mar apr may jun jul aug sep oct nov dec;
model gprc = gcem gprcpet feb mar apr may jun jul aug sep oct nov dec;
ods select ParameterEstimates;
run;
*While the coefficient on gcem is still negative, it is only about 1/4 the size of the OLS coefficient, and is 
now very insignificant. At this point we could conclude that the static supply function is horizontal.;



*Chapter 16 Question C7;
proc import datafile = "&path\crime4.xls"
dbms = xls out = crime;
run;

*Part i;
*If county administrators can predict when crime rates will increase, they may hire more police to counteract crime.
This would explain the estimated positive relationship between clog(crmrte and clog(polpc) in equation 13.33;

*Part ii;
*This may be reasonable, although tax collections depend in part on income and sales taxes, and revenues from these 
depend on the state of the economy, which can also influence crime rates;

*Part iii;
proc reg data = crime;
model clpolpc = d83 d84 d85 d86 d87 clprbarr clprbcon clprbpri clavgsen cltaxpc;
ods select ParameterEstimates;
run;
*We need pi10 =/= 0 for cltaxpc to be a reasonable IV candidate for clpolpc. When we run this equation we obtain a 
coefficient of .0052 with a t-statistic of only .08. Therefore cltaxpc is not a good IV candidate;

*Part iv;
*If grants were awarded randomly, then the grant amounts for dollar amount for county i and year t, will be 
uncorrelated with cu it, the change in unobservables that affect country crime rates. By definition, grant it should
be correlated with clpolpc across i and t. This means we have an exogenous variable that can be omitted from the 
crime equation and that is partially correlated with the endogenous explanatory variable. We could reestimate 
13.33 by IV;




*Chapter 16 Question C8;
proc import datafile = "&path\fish.xls"
dbms = xls out = fish;
run;

*Part i;
*We need at least one exogenous variable that appears in the supply equation;

*Part ii;
*For wave2t and wave3t to be valid IVs for lavgprc we need two assumptions. The first is that these can be 
properly excluded from the demand equation. This may not be entirely reasonable, and wave heights are determined
partly by weather, and demand at a local fish market could depend on demand. The second assumption is that at least
one of wave2 and wave3 appears in the supply equation. There is indirect evidence of this in part three, as the two 
variables are jointly significant in the reduced form for lavgprc;

*Part iii;
proc reg data = fish;
model lavgprc = mon tues wed thurs wave2 wave3;
test wave2, wave3 = 0;
ods select ParameterEstimates TestANOVA;
run;
*The two wave variables are jointly very significant with F-value 19.1;

*Part iv;
proc syslin data = fish 2sls out = fishx;
instruments wave2 wave3 mon tues wed thurs;
model ltotqty = lavgprc mon tues wed thurs;
ods select ParameterEstimates;
output r = uhat;
run;
*The 95% confidence interval is roughly - 1.46 to -.17. The point estimate, -.82 seems reasonable: a 10% increase
in price reduces quantity demanded by about 8.2%;

*Part v;
data fishx;
set fishx;
uhat_1 = lag(uhat);
run;

proc syslin data = fishx 2sls;
instruments wave2 wave3 mon tues wed thurs uhat_1;
model ltotqty = lavgprc mon tues wed thurs uhat_1;
ods select ParameterEstimates;
run;
*When we include uhat_1 back into the 2SLS model, using uhat_1 as its own instrument, we obtain a coefficient of 
.294 with standard error .103. There is strong evidence of positive serial correlation, although the estimate of p 
is not huge.;

*Part vi;
*To estimate the supply elasticity, we would have to assume that the day of the week dummies do not appear in the supply
equation, but they do appear in the demand equation. Part iii provides evidence that the day of the week dummies
are in the demand function. But we don't know about the supply function;

*Part vii;
proc reg data = fish;
model lavgprc = mon tues wed thurs wave2 wave3;
test mon, tues, wed, thurs = 0;
ods select ParameterEstimates TestANOVA;
run;
*In the estimation of the reduced form for lavgprc, the day of the week dummies are jointly insignificant with F-value 
0.53. This means that while some of these variables appear in the demand equation, things cancel out in a way that
they do not affect equilibrium price, once wave2 and wave3 are in the equation. So without more information we cannot
estimate the supply equation;





*Chapter 16 Question C9;
proc import datafile = "&path\airfare.xls"
dbms = xls out = airfare;
run;
data airfare;
set airfare;
if year ne 1997 then DELETE;
run;
*Part i;
*If this is a demand function a1 < 0 would be expected. As prices increase, you would expect less passengers to fly;

*Part ii;
proc reg data = airfare;
model lpassen = lfare ldist ldistsq;
ods select ParameterEstimates;
run;
*The estimated price elasticity is -.39%;

*Part iii;
*We must assume that concen is uncorrelated with the error terms, and at least partially correlated with 
oen of the endogenous variables;

*Part iv;
proc reg data = airfare;
model lfare = concen ldist ldistsq;
ods select ParameterEstimates;
run;
*Concen has a positive coefficient of .40 and is very significant with t-value 6.30;

*Part v;
proc syslin data = airfare 2sls;
instruments concen ldist ldistsq;
model lpassen = lfare ldist ldistsq;
ods select ParameterEstimates;
run;
*The price elasticity is now estimated at -1.17%. This is nearly 3 times greater than the OLS estimate;

*Part vi;
data tp;
tp = -2.17567 / 2*(.187029);
exp = exp(tp);
put tp;
put exp;
run;

proc means data = airfare range max min;
var dist;
run;
*Demand for seats decreases at low distances. But demand will increase as distances grow due to the quadratic 
distance term taking over. This take over happens at a distance of approximately 0.82, which is very low and well out
of the range of the data. This shows that essentially, demand increases with distance;





*Chapter 16 Question C10;
proc import datafile = "&path\airfare.xls"
dbms = xls out = airfarec10;
run;

*Part i;
proc panel data = airfarec10;
id id year;
model lpassen = y98 y99 y00 lfare / fixone;
ods select ParameterEstimates;
run;
*The esimated price elasticity is -1.16%;

*Part ii;
proc panel data = airfarec10;
id id year;
model lfare = y98 y99 y00 concen / fixone;
ods select ParameterEstimates;
run;
*For concen to be used as an IV for lfare, we need Bconcen =/= 0. In this case we get a coefficient of .169, but
standard error .0294, so that the t-statistic is 5.74. Thus we can use concen as an IV;

*Part iii;
proc syslin data = airfarec10 2sls;
instruments concen y98 y99 y00;
model lpassen = y98 y99 y00 lfare;
ods select ParameterEstimates;
run;
proc panel data = airfarec10;
id id year;


*FIXED EFFECTS 2SLS TRANSFORMATION;



*Chapter 16 Question C11;
proc import datafile = "&path\expendshares.xlsx"
dbms = xlsx out = expend;
run;

*Part i;
proc means data = expend range max min;
var sfood;
run;
*I'm not surprised that there are no zero values. One would expect every individual to have at least some food 
expenditures in their budget;

*Part ii;
proc reg data = expend;
model sfood = ltotexpend age kids / hcc clb;
ods select ParameterEstimates;
run;
*If ltotexpend increases by 10% we would expect sfood to decrease by -.015. This would be approximately 1.5% less
of their expenditure would go towards food as income increases by 10%;

*Part iii;
proc reg data = expend;
model ltotexpend = lincome age kids;
ods select ParameterEstimates;
output out = expendx r = v;
run;
*Lincome would be a good IV for ltotexpend. It has a positive coefficient and is very significant;

*Part iv;
proc syslin data = expend 2sls;
instruments lincome age kids;
model sfood = ltotexpend age kids;
ods select ParameterEstimates;
run;
*The coefficient on ltotexpend is similar to the OLS coefficient. It is -.1599 under 2SLS and -.149 under OLS.
The 95% confidence interval under 2SLS is about -.186 to -.134. Compared to -.158 to -.134 under OLS.;

*Part v;
proc reg data = expendx;
model sfood = ltotexpend age kids v /hcc;
ods select ParameterEstimates;
run;
*If the residuals from the reduced form of the ltotexpend equation are significantly different than zero, then 
the variable ltotexpend can be confirmed to be endogenous. In this case we cannot conclude that v is different than zero
and thus we conclude that ltotexpend is exogenous. The p-value on v is .2534 using robust standard errors.;

*Part vi;
proc reg data = expend;
model salcohol = ltotexpend age kids;
ods select ParameterEstimates;
run;

proc syslin data = expend 2sls;
instruments lincome age kids;
model salcohol = ltotexpend age kids;
ods select ParameterEstimates;
run;
*Now we have positive coefficients for ltotexpend under both OLS and 2SLS. It is also a significant variable under
both models. This could be due to alcohol being less than a need, and thus as budgets increase it may become 
a form of luxury good, and increase in proportion of the budget;
