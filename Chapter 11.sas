********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/


%let path = F:\Data Sets;
*Chapter 11;
%let path = F:\Econometrics Supplement\Data Sets;
*Chapter 11 Question C1;
proc import datafile = "&path\hseinv.xls"
dbms = xls out = hseinv;
run;

*Part i;
proc reg data = hseinv;
model linvpc = /dwprob;
ods select DWStatistic;
run;
*The 1st order autocorrelation is 0.594;

proc reg data = hseinv;
model linvpc = t;
output out = hseinvx r = detrend;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;

proc reg data = hseinvx;
model detrend = /dwprob;
ods select DWStatistic;
run;
*The detrended first order autocorrelation is .476, which shows
little evidence of a unit root;

proc reg data = hseinv;
model lprice = /dwprob;
ods select DWStatistic;
run;
*The first order autocorrelation is .896, so we cannot rule out a unit root;

*Part ii;
proc reg data = hseinv;
model linvpc = gprice t;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on B1 implies that a 1% increase in the growth rate in price
leads to a 3.88% increase in housing investment, above its trend;

*Part iii;
proc reg data = hseinvx;
model detrend = gprice t;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*If we detrend, the R^2 drops to .303 from .501;

*Part iv;
proc reg data = hseinv;
model ginvpc = gprice t;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on gprice has fallen significantly and is no longer significant 
at the 5% level. The R^2 is much lower. Since we differenced both variables, it is
not surprising that the time trend is not significant;


*Chapter 11 Question C2;
proc import datafile = "&path\earns.xls"
dbms = xls out = earns replace;
run;

*Part i;
proc reg data = earns;
model ghrwage = goutphr goutphr_1;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*The t-statistic for goutphr_1 is 2.76, so it is significant at the 5% level;

*Part ii;
data earnsx;
set earns;
goutphrd = goutphr_1 - goutphr;
run;

proc reg data = earnsx;
model ghrwage = goutphr goutphrd;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*We can compute t-statistic now that we have the se. Since we set theta = b1 + b2, the coefficient of theta is 
1.186. We found this by adding b1 and b2 in the previous model. We now know the se is 0.203. 
Thus the t-statistic is (1.186-1)/.203=~.916. This is not a very significant t-statistic;

*Part iii;
proc reg data = earns;
model ghrwage = goutphr goutphr_1 goutphr_2;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*When the second lag of goutphr is added, the t-statistic is only 0.41. Thus it doesn't need to be in the model;


*Chapter 11 Question C3;
proc import datafile = "&path\nyse.xls"
dbms = xls out = nyse replace;
run;

*Part i;
data nyse;
set nyse;
return1sq = return_1**2;
run;

proc reg data = nyse;
model return = return_1 return1sq;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;

*Part ii;
*The hypothesis is Ho: B1 = B2 = 0. We see that the F-value is 2.16, with p-value .116. Thus we 
cannot reject Ho at the 10% level;

*Part iii;
*Added a column into data set for return_2, easier to do in excel than in sas;
data nyse;
set nyse;
return_2 = lag(return_1);
return1return2 = return_1*return_2;
run;

proc reg data = nyse;
model return = return_1 return1return2;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*Now our F-Value is 1.80, giving us a p-value of .1658. Now we don't even reject Ho at the 15% level;

*Part iv;
*Predicting weekly returns based on past returns does not seem like a promising endeavor. 
We are not even significant at the 10% level, even with large numbers of observations. We also explain
less than one percent of the variation;


*Chapter 11 Question C4;
proc import datafile = "&path\phillips.xls"
dbms = xls out = phil;
run;

*Part i;
proc reg data = phil;
model cinf = cunem;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on B1 implies that there is a tradeoff between inflation and unemployment. This coefficient is
quite large as well. It has a t-statistic of -2.87, which is very significant.;

*Part ii;
*The model from part (i) has an R^2 of .1348 vs .108 from 11.19. This shows the model in part i is better.;



*Chapter 11 Question C5;
proc import datafile = "&path\fertil3.xls"
dbms = xls out = fertil;
run;

*Part i;
proc reg data = fertil;
model cgfr = cpe cpe_1 cpe_2 t;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*The time trend is insignificant so it is not needed;

*Part ii;
proc reg data = fertil;
model cgfr = cpe cpe_1 cpe_2 ww2 pill;
ods select NObs FitStatistics ANOVA ParameterEstimates TestANOVA;
test ww2, pill;
run;
*The ww2 and pill variables are jointly significant at the 10% level, but not
the 5% level;

*Part iii;
proc reg data = fertil;
model cgfr = cpe cpe_1 cpe_2 t ww2 pill;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on t increased, and the variable is now significant at the 5% level.
*Pill is now much larger in magnitutde and much more significant as well;

*Part iv;
*The LRP is the coefficient and standard error of cpe: -0.062 and se: 0.032.
This means the LRP is now negative and significant, whereas in 10.19
it was positive. This is a good example of how differencing variables can provide
very different regression results than regressions in levels;



*Chapter 11 Question C6;
proc import datafile = "&path\inven.xls"
dbms = xls out = inven;
run;


*Part i;
proc reg data = inven;
model cinven = cgdp;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*B1 is significantly different from zero at the 1% level. A 1 billion dollar change in GDP will lead
to a 152 Million dollar change in inventory investment;

*Part ii;
proc reg data = inven;
model cinven = cgdp r3;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*The t-statistic on r3 is only -.81, so it tells us that it is not worth including in the model;

*Part iii;
proc reg data = inven;
model cinven = cgdp cr3;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*When we use the first difference of real interest rates, the t-statistic is only -.31, or even less than
the level version. Thus without more data we cannot conclude that the real interest rate is having an effect on 
inventory investment;



*Chapter 11 Question C7;
proc import datafile = "&path\consump.xls"
dbms = xls out = consump;
run;

*Part i;
proc reg data = consump;
model gc = gc_1;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*The null hypothesis is Ho: B1 = 0. The alternative is Ha: B1 != 0.
In this case the t-stat for gc_1 is 2.86, so we strongly reject the null at the 1% level;

*Part ii;
data consump;
set consump;
i3_1 = lag(i3);
inf_1 = lag(inf);
run;

proc reg data = consump;
model gc = gc_1 gy_1 i3_1 inf_1;
ods select NObs FitStatistics ANOVA ParameterEstimates TestANOVA;
test i3_1, inf_1, gy_1;
run;

*The variables are not jointly significant, even at the 20% level. None of the variables are individually 
significant either;

*Part iii;
*GC_1 is now insignificantly different from zero according to its t-value. This would tell us that PIH is now
supported;

*Part iv;
proc reg data = consump;
model gc = gc_1 gy_1 i3_1 inf_1;
ods select NObs FitStatistics ANOVA ParameterEstimates TestANOVA;
test i3_1, inf_1, gy_1, gc_1;
run;
*Our F-value is 3.27 with resulting p-value of .0243. This agrees with our conclusion from part (iii) that the PIH
is now supported.;


*Chapter 11 Question C8;
proc import datafile = "&path\phillips.xls"
dbms = xls out = phillips;
run;

*Part i;
proc reg data = phillips;
model unem = unem_1;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;

data pred;
pred = 1.48968 + 0.74238*6;
put pred;
run;
*The predicted 2004 inflation rate is 5.944. According to the Economic report of the President 2005,
p. 331, the civilian unemployment rate for 2004 was 5.5%. Our model is overpredicting by a large margin;

*Part ii;
proc reg data = phillips;
model unem = unem_1 inf_1;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*The lag of inflation is very significant with t-statistic of 4.72;

*Part iii;
data pred2;
pred2 = 1.29642 + 0.64948*6 + 0.18301*2.3;
put pred2;
run;
*The predicted value for 2004 unemployment is now 5.614223, which is closer than our original model, but is still
too large;

*Part iv;
*We have our standard error of the regression from part (ii) = 0.84340.;
data phillipsx;
set phillips;
unem_15 = unem_1 - 6.0;
inf_13 = inf_1 - 2.3;
run;

proc reg data = phillipsx;
model unem = unem_15 inf_13;
ods select ParameterEstimates;
run;

data pred3;
pred = ((.1363)**2 + (.883)**2)**0.5;
put pred;
run;

*Our intercept of this equation is 5.614 and standard error is 0.1364;
*From equation 6.36: se(y0) = [(.1364)^2 + (.883)^2]^(1/2)= 0.8935;
*Using the 97.5th percentile from the t distribution with 50 df, we get a critical value of 2.009.
Thus our 95% confidence interval is 5.614 +/- 2.009*(0.8935) or 3.82 to 7.41.
The unemployment rate in 2004 of 5.5% is comfortably in this interval;




*Chapter 11 Question C9;
proc import datafile = "&path\traffic2.xls"
dbms = xls out = traffic;
run;

*Part i;
proc reg data = traffic;
model prcfat = /dwprob;
ods select DWStatistic;
run;

proc reg data = traffic;
model unem = /dwprob;
ods select DWStatistic;
run;
*1st order autocorrelation is .708 for prcfat, and .941 for unem. We don't need to worry about prcfat, but
we need to worry about unem;

*Part ii;
data trafficx;
set traffic;
unem_1 = lag(unem);
cunem = unem - unem_1;
cprcfat = prcfat - prcfat_1;
run;

proc reg data = trafficx;
model cprcfat = t feb mar apr may jun jul aug sep oct nov dec wkends cunem spdlaw beltlaw;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*This regression shows that changes in prcfat can't be explained by the change in unemployment or the policy 
variables. It does show that there is some seasonality however.;

*Part iii;
*Comparing our differenced equation to the one from CH10 C11 shows that our differenced unemployment rate is no longer
significant, and neither is our speedlaw variable. Our R^2 is also roughly half of that of the levels equation.
The time trend is no longer significant. Several of the dummy variables also lose their significance.

Overall we lose lots of valuable conclusions when we difference the variables, but it is always a very difficult
decision to make, and would need further analysis to explore if there is actually a unit root present;


*Chapter 11 Question C10;
proc import datafile = "&path\phillips.xls"
dbms = xls out = phillipsc10;
run;

*Part i;
proc reg data = phillipsc10;
model cinf = unem;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*Our intercept and slope is now 2.83 and -0.518 and in 11.19 they were 3.03 and -0.543.
There has been some changes but not a huge amount of variation after adding 7 more years 
of data;

*Part ii;
*The natural rate is u0 = B0/(-B1) = 2.83/(.518) =~ 5.46
This rate is slightly lower than the one computed in 11.5;

*Part iii;
proc reg data = phillipsc10;
model unem = /dwprob;
ods select DWStatistic;
run;
*The first order autocorrelation is 0.741. The correlation is large, but not
extremely close to zero to worry about a unit root;

*Part iv;
proc reg data = phillipsc10;
model cinf = cunem;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*Using Cunem we get an R^2 of .1348. This is higher than the model using just unem which
had an R^2 of .1037;


*Chapter 11 Question C11;
proc import datafile = "&path\okun.xls"
dbms = xls out = okun;
run;

*Part i;
proc reg data = okun;
model pcrgdp = cunem;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*We get an intercept of 3.34443 and a coefficient of -1.89092. 
These are both very close to their estimates of 3 and -2, but not exact. This is 
what is expected.;

*Part ii & iii;
data ttest;
tcunem = (-1.89092 + 2) / 0.18202;
tint = (3.34443 - 3) / 0.16267;
put tcunem;
put tint;
run;
*The t-statistic for B1 is 0.599 and the t-statistic for B0 is 2.117;
*The 95% two-tailed critical value is 2.021. Thus we can reject H0 B0 = 3 at
the 5% level. However, we cannot reject H0 B1 = -2 at any significance level;

*Part iv;
proc reg data = okun;
model pcrgdp = cunem;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA;
test cunem = -2, intercept = 3;
run;
*We obtain an F-value of 2.41, which is significant at the 15% level, but not the 10% level.
Thus we do not reject the null at the 10% level. I would say that the data mildly 
supports Okun's law, but not strongly;



*Chapter 11 Question C12;
proc import datafile = "&path\minwage.xls"
dbms = xls out = minwage replace;
run;

*Part i;
proc reg data = minwage;
model gwage232 = /dwprob;
ods select DWStatistic;
run;
*Because the first order correlation is essentially zero, we know that the
data is weakly dependent;

*Part ii;
data minwage;
set minwage;
gwage232_1 = lag(gwage232);
gemp232_1 = lag(gemp232);
run;
proc reg data = minwage;
model gwage232 = gwage232_1 gmwage gcpi;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*Holding all other factors fixed, there is a very small, non zero contemporaneous effect
from an increase in the federal minimum on gwage232. This effect is statistically 
significant;

*Part iii;
proc reg data = minwage;
model gwage232 = gwage232_1 gmwage gcpi gemp232_1;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*Gemp232_1 is statistically significant at the 1% level with a t-value of 3.90;

*Part iv;
proc reg data = minwage;
model gwage232 = gmwage gcpi;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*Adding the two variables only has any effect on the gmwage coefficient once you get to the 
9th or 10th decimal place, so a negligible effect;

*Part v;
proc reg data = minwage;
model gwage232 = gwage232_1 gemp232_1;
ods select FitStatistics ANOVA;
run;
*The R^2 of the model is .0161, so 1.61%. The lagged variables are jointly significant, 
but explain a very small amount of variation, so it makes sense that they have a small
effect on the coefficient of gmwage;




