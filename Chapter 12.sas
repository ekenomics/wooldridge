********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/


%let path = F:\Data Sets;
*Chapter 12;
%let path = F:\Econometrics Supplement\Data Sets;
*Chapter 12 C1;
proc import datafile = "&path\fertil3.xls"
dbms = xls out = fertil;
run;

proc reg data = fertil;
model cgfr = cpe cpe_1 cpe_2;
output out = fertilx r = uhat;
ods select NONE;
run;

data fertilxx;
set fertilx;
uhat_1 = lag(uhat);
run;

proc reg data = fertilxx;
model uhat = uhat_1;
ods select Nobs ParameterEstimates;
run;
*Regressing uhat on uhat_1 gives phat = 0.292, with standard error = .118. The t-statistic is 2.47 which shows
strong evidence of positive AR(1) serial correlation in the errors.;


*Chapter 12 Question C2;
proc import datafile = "&path\wageprc.xls"
dbms = xls out = wageprc;
run;

*Part i;
proc reg data = wageprc;
model gprice = gwage gwage_1 gwage_2 gwage_3 gwage_4 gwage_5 gwage_6 gwage_7 gwage_8 gwage_9
				gwage_10 gwage_11 gwage_12;
output out = wageprcx r = uhat;
ods select None;
run;

data wageprcxx;
set wageprcx;
uhat_1 = lag(uhat);
run;

proc reg data = wageprcxx;
model uhat = uhat_1;
ods select Nobs ParameterEstimates;
run;
*Running the test for serial correlation we get p = .502 (rho) with standard error = .052, 
giving a t-statistic of 9.6. There is strong evidence of positive AR(1) correlation;

*Part ii;
data wageprcco;
set wageprcxx;
int = 1 - .502;
gpriceco = gprice - .502*lag(gprice);
gwageco = gwage - .502*lag(gwage);
gwageco_1 = gwage_1 - .502*lag(gwage_1);
gwageco_2 = gwage_2 - .502*lag(gwage_2);
gwageco_3 = gwage_3 - .502*lag(gwage_3);
gwageco_4 = gwage_4 - .502*lag(gwage_4);
gwageco_5 = gwage_5 - .502*lag(gwage_5);
gwageco_6 = gwage_6 - .502*lag(gwage_6);
gwageco_7 = gwage_7 - .502*lag(gwage_7);
gwageco_8 = gwage_8 - .502*lag(gwage_8);
gwageco_9 = gwage_9 - .502*lag(gwage_9);
gwageco_10 = gwage_10 - .502*lag(gwage_10);
gwageco_11 = gwage_11 - .502*lag(gwage_11);
gwageco_12 = gwage_12 - .502*lag(gwage_12);
run;

proc reg data = wageprcco;
model gpriceco = int gwageco gwageco_1 gwageco_2 gwageco_3 gwageco_4 gwageco_5 gwageco_6
				gwageco_7 gwageco_8 gwageco_9 gwageco_10 gwageco_11 gwageco_12 / noint;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*Our estimated LRP is about 1.112;

*Part iii;
data wageprccoo;
set wageprcco;
gwaget_1 = gwage_1 - gwage;
gwaget_2 = gwage_2 - gwage;
gwaget_3 = gwage_3 - gwage;
gwaget_4 = gwage_4 - gwage;
gwaget_5 = gwage_5 - gwage;
gwaget_6 = gwage_6 - gwage;
gwaget_7 = gwage_7 - gwage;
gwaget_8 = gwage_8 - gwage;
gwaget_9 = gwage_9 - gwage;
gwaget_10 = gwage_10 - gwage;
gwaget_11 = gwage_11 - gwage;
gwaget_12 = gwage_12 - gwage;
run;

proc reg data = wageprccoo;
model gprice = gwage gwaget_1 gwaget_2 gwaget_3 gwaget_4 gwaget_5 gwaget_6 gwaget_7
				gwaget_8 gwaget_9 gwaget_10 gwaget_11 gwaget_12;
ods select ANOVA ParameterEstimates;
run;

data t;
t = (1.172-1)/.11073;
put t;
run;
*T-statistic = 1.55 which is not significant at the 5% level;



*Chapter 12 Question C3;
proc import datafile = "&path\inven.xls"
dbms = xls out = inven;
run;

*Part i;
proc reg data = inven;
model cinven = cGDP /dwprob ;
output out = invenx r = uhat;
ods select DWStatistic;
run;

data invenx;
set invenx;
uhat_1 = lag(uhat);
run;

proc reg data = invenx;
model uhat = uhat_1;
ods select ParameterEstimates;
run;
*Both our DW statistic and our phat tell us that AR(1) serial correlation isn't likely to exist in the data;

*Part ii;
*There is no need to reestimate the equation using Cochrane-Orcutt, since AR(1) serial correlation
wasn't found to exist;


*Chapter 12 Question C4;
proc import datafile = "&path\NYSE.xls"
dbms = xls out = nyse;
run;

*Part i;
proc reg data = nyse;
model return = return_1;
ods select ParameterEstimates;
output out = nysex r = uhat p = pred;
run;

data nysex;
set nysex;
uhatsq = uhat**2;
uhat_1sq = lag(uhat)**2;
return_1sq = return_1**2;
run;

proc reg data = nysex;
model uhatsq = return_1;
ods select ParameterEstimates;
output out = nysexx p = hhat;
run;

proc freq data = nysexx;
table hhat;
where hhat < 0;
run;
*12 values of hhat are negative;

*Part ii;
proc reg data = nysex;
model uhatsq = return_1 return_1sq;
ods select ParameterEstimates;
output out = nysexxx p = hhat;
run;

proc freq data = nysexxx;
table hhat;
where hhat < 0;
run;
*No values of hhat are negative;

*Part iii;
data nysev;
set nysexxx;
weight = 1/hhat;
run;

proc reg data = nysev;
model return = return_1;
weight weight;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*After using WLS the significance of B1 has dropped from a t-statistic of 1.55 to one of 0.85;

*Part iv;
proc reg data = nysex;
model uhatsq = uhat_1sq;
ods select ParameterEstimates;
output out = nyset p = hhat;
run;

data nysett;
set nyset;
weight = 1/hhat;
run;

proc reg data = nysett;
model return = return_1;
weight weight;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*Using the ARCH model to obtain our weights for WLS does not change our results. Our coefficient and t-statistic 
of B1 get even smaller. We can conclude that once we account for heteroskedasticity via WLS there is no evidence
that return depends linearly on return_1;


*Chapter 12 Question C5;
proc import datafile = "&path\fair.xls"
dbms = xls out = fair;
run;

*Part i;
proc reg data = fair;
model demwins = partywh incum pwhgnews pwhinf /dwprob;
where year <= 1992;
output out = fairx p = fitted r = uhat;
ods select Nobs FitStatistics ANOVA ParameterEstimates DWStatistic;
run;
*In this case, incum has the largest t-statistic and p-value. However, incum = 1 if a 
democrat incumbent is running and -1 for a republican. Partywh is equal to 1 if a democrat 
is currently in white house, and -1 for a republican. Thus we must add up those coefficients,
which gives us approximately zero. 

The other variables are not statistically significant given their t-statistics and our low
number of observations;

*Part ii;
proc freq data = fairx;
table fitted;
where fitted < 0 or fitted > 1;
run;
*There are two values less than 0 and two values greater than one.;

*Part iii;
data fairx;
set fairx;
if fitted > 0.5 then demwinspred = 1; else demwinspred = 0;
run;

proc freq data = fairx;
table demwins*demwinspred;
where year <= 1992;
run;
*Out of the 10 elections where demwins = 1, we predicted 8 of them correctly.
Out of the 10 where demwins = 0, we predicted 7 of them correctly. Overall we predicted
15/20 correctly. But, this is the same data we used to build the model, so we would expect
to do well;

*Part iv;
data ninetysix;
ninesix = .441 - .473 + .479 + .059*3 - .024*3.019;
put ninesix;
run;
*We get a value of ~.55, so we would predict a democrat victory, which is true;

*Part v;
data fairxx;
set fairx;
uhat_1 = lag(uhat);
run;

proc reg data = fairxx;
model uhat = uhat_1 / hcc;
ods select ParameterEstimates;
run;
*There is little of evidence of AR(1) serial correlation, with a t-statistic of -1.45;

*Part vi;
proc reg data = fair;
model demwins = partywh incum pwhgnews pwhinf / hcc;
where year <= 1992;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*Using heteroskedastic robust standard errors causes all of the standard errors to decrease. 
However only pwhgnews gains any major significance, becoming significant at the 10% level.
However, with only 20 observations it is still not clear if we should use the robust errors
or not in the LPM;


*Chapter 12 Question C6;
proc import datafile = "&path\consump.xls"
dbms = xls out = consump;
run;

*Part i;
proc reg data = consump;
model gc = gy;
output out = consumpx r = uhat;
ods select NONE;
run;

data consumpx;
set consumpx;
uhat_1 = lag(uhat);
run;

proc reg data = consumpx;
model uhat = uhat_1;
ods select ParameterEstimates;
run;
*We get p (rho) = -.089, showing no evidence of serial correlation;

*Part ii;
proc reg data = consump;
model gc = gc_1;
output out = consumpxx r = uhat;
ods select NONE;
run;

data consumpxx;
set consumpxx;
uhatsq = uhat**2;
gc_1sq = gc_1**2;
run;

proc reg data = consumpxx;
model uhatsq = gc_1 gc_1sq;
ods select Nobs ANOVA FitStatistics ParameterEstimates;
run;
*In this regression our F-value is about 1.08 giving a p-value of .3516. This shows
little evidence of heteroskedasticity in the AR(1) model.;


*Chapter 12 Question C7;
proc import datafile = "&path\barium.xls"
dbms = xls out = barium replace;
run;

*Part i;
proc reg data = barium;
model lchnimp = lchempi lgas lrtwex befile6 affile6 afdec6;
output out = bariumx r = uhat;
where t > 1;
ods select ANOVA ParameterEstimates;
run;

data bariumx;
set bariumx;
uhat_1 = lag(uhat);
run;

proc reg data = bariumx;
model uhat = uhat_1;
ods select ParameterEstimates;
run;
* Cochrane-Orcutt: p(rho) = .27027;

data bariumxx;
set bariumx;
lchnimpco = lchnimp - .271*lag(lchnimp);
lchempico = lchempi - .271*lag(lchempi);
lgasco = lgas - .271*lag(lgas);
lrtwexco = lrtwex - .271*lag(lrtwex);
befile6co = befile6 - .271*lag(befile6);
affile6co = affile6 - .271*lag(affile6);
afdec6co = afdec6 - .271*lag(afdec6);
int = 1 - .27075;
run;

proc reg data = bariumxx;
model lchnimpco = int lchempico lgasco lrtwexco befile6co affile6co afdec6co / noint;
ods select ParameterEstimates;
run;

*Part ii;
*Not surprisingly, the PW and CO estimates are very similar.
The only difference is that PW uses t = 1, and CO does not.
However, with n = 131, this should not make a large difference;




*Chapter 12 Question C8;
proc import datafile = "&path\traffic2.xls"
dbms = xls out = traffic replace;
run;

*Part i;
proc reg data = traffic;
model prcfat = t feb mar apr may jun jul aug sep oct nov dec wkends unem spdlaw beltlaw;
output out = trafficx r = uhat;
ods select None;
run;

data traffict;
set trafficx;
uhat_1 = lag(uhat);
if t = 1 then DELETE;
run;

proc reg data = traffict;
model uhat = uhat_1;
ods select ParameterEstimates;
run;
*p (rho) = .281. The t-statistic is 2.99 which shows evidence of positive AR(1) serial
correlation.

For strict exogeneity, we do not need to worry about the monthly variables, time trend, or 
wkends, as these are all determined by a calendar. It is also safe to assume that 
unexplained changes in prcfat today do not cause future changes in state-wide unemployment 
rates. The policy changes were permanent once installed, so again strict exogeneity seems 
reasonable;

*Part ii;

proc model data = traffic;
parms b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16;
prcfat = b0 + b1*t + b2*feb + b3*mar + b4*apr + b5*may + b6*jun + b7*jul + b8*aug + b9*sep + b10*oct + b11*nov + b12*dec + b13*wkends + b14*unem + b15*spdlaw +b16*beltlaw;
fit prcfat / gmm kernel = (bart,5,0) vardef = n;
ods select ParameterEstimates;
run;
quit;
*Using Newey-West estimation with four lags, our standard error on speedlaw becomes .0245, giving us a t-statistic of 2.74. This is still a significant variable.
Our standard error on beltlaw becomes .0304, giving us a t-statistic of -.97, showing little evidence that beltlaw has an effect on prcfat;

*Part iii;
data trafficpw;
set trafficx;
uhat_1 = lag(uhat);
run;

proc autoreg data = trafficpw;
model prcfat = t feb mar apr may jun jul aug sep oct nov dec wkends spdlaw beltlaw /nlag=1 ITER ITPRINT method=yw;
run;
***IN PROGRESS NOT QUITE A MATCH ON PW STATISTICS;


*Chapter 12 Question C9;
proc import datafile = "&path\fish.xls"
dbms = xls out = fish;
run;

*Part i;
proc reg data = fish;
model lavgprc = t mon tues wed thurs;
ods select ParameterEstimates TestANOVA;
test mon, tues, wed, thurs = 0;
run;
*The F-test for the joint significance of the dummy variables gives a f-value of .23, so there is little evidence of seasonality within a week;

*Part ii;
proc reg data = fish;
model lavgprc = t mon tues wed thurs wave2 wave3;
ods select ParameterEstimates;
output out = fishx r = uhat;
run;
*Both of the wave variables are statistically significant. You could argue that bad weather will reduce the supply of fish due to the difficulty of fishing
in the severe weather, and this would result in a higher price for fish;

*Part iii;
*The time trend became insignificant. This seems to be a result of omitted variable bias in the original model. Since the time trend was initially negative,
it is a sign that it is negatively correlated with wave2 and wave3. As in, seas tended to be rougher towards the beginning of our sample.

*Part iv;
*All the variables are strictly exogenous because the time trend and daily variables are set by a calendar, and the wave variables 
are not influenced by any past changes in log(avgprc);

*Part v;
data fishx;
set fishx;
uhat_1 = lag(uhat);
run;

proc reg data = fishx;
model uhat = uhat_1;
ods select ParameterEstimates;
run;
*We obtain a t-statistic of 7.62, showing very strong evidence of serial correlation;

*Part vi;
proc model data = fishx;
parms b0 b1 b2 b3 b4 b5 b6 b7;
lavgprc = b0 + b1*t + b2*mon + b3*tues + b4*wed + b5*thurs + b6*wave2 + b7*wave3;
fit lavgprc / gmm kernel = (bart,5,0) vardef = n;
ods select ParameterEstimates;
run;
quit;
*We obtain se(wave2) = .0224, and se(wave3) = .0187. It is surprising that these are not much larger than their incorrect OLS standard errors given the amount
of serial correlation. In fact, se(wave3) is smaller than its OLS standard error;

*Part vii;
proc autoreg data = fishx;
model lavgprc = t mon tues wed thurs wave2 wave3 /nlag=1 ITER ITPrint method=yw;
test wave2, wave3 = 0;
run;
**Estimates not perfect;
*F-Test for joint significant of wave2 and wave3 is 5.27, showing they are strongly jointly significant;



*Chapter 12 Question C10;
proc import datafile = "&path\phillips.xls"
dbms = xls out = phillips;
run;

*Part i;
proc reg data = phillips;
model inf = unem;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
output out = philx r = uhat;
run;

*Part ii;
data philx;
set philx;
uhat_1 = lag(uhat);
run;

proc reg data = philx;
model uhat = uhat_1;
ods select ParameterEstimates;
run;
*We obtain a value of p = .572, with a t-statistic of 5.28. This is very strong evidence of serial correlation;

*Part iii;
proc autoreg data = philx;
model inf = unem /nlag = 1 ITER ITPrint method = yw;
run;
*Our final estimate for unem was -.7104, which is very close to the value of -.716 estimated using the data only through 1996;

*Part iv;
proc autoreg data = philx;
model inf = unem /nlag = 1;
model inf = unem /nlag = 3;
model inf = unem /nlag = 5;
model inf = unem /nlag = 7;
run;

***how to run iterative CO?;


*Chapter 12 Question C11;
proc import datafile = "&path\nyse.xls"
dbms = xls out = nyse replace;
run;

*Part i;
proc reg data = nyse;
model return = return_1;
output out = nysex r = uhat;
ods select NONE;
run;

data nysexx;
set nysex;
uhat_1 = lag(uhat);
uhatsq = uhat**2;
return_1sq = return_1**2;
run;

proc means data = nysexx mean min max;
var uhatsq;
run;
*The average is 4.44, minimum is 7.354 x 10^-6 and max is 232.89;

*Part ii;
proc reg data = nysexx;
model uhatsq = return_1 return_1sq;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
output out = nysexxx p = fitted;
run;


*Part iii;
*Sketch on own;

*Part iv;
proc freq data = nysexxx;
table fitted;
where fitted < 0;
run;
*No values less than zero;

*Part v;
*It appears that the model we have here may be slightly better than the ARCH(1) model in 12.9. 
We have a slightly higher R-Squared and our variables are still very significant;


*Part vi;
data nysev;
set nysexxx;
uhat_2 = lag(uhat_1);
uhat_1sq = uhat_1**2;
uhat_2sq = uhat_2**2;
run;

proc reg data = nysev;
model uhatsq = uhat_1sq uhat_2sq;
ods select FitStatistics ANOVA ParameterEstimates;
run;
*This second lag is not important as it is not significant. The R-Squared is slightly worse than in part ii,
so it doesn't appear that ARCH(2) fits better, which we would expect;


*Chapter 12 Question C12;
proc import datafile = "&path\inven.xls"
dbms = xls out = inven;
run;

*Part i;
proc reg data = inven;
model cinven = cgdp;
output out = invenx r = uhat;
ods select ParameterEstimates;
run;

data invenx;
set invenx;
uhat_1 = lag(uhat);
run;

proc reg data = invenx;
model uhat = uhat_1;
ods select ParameterEstimates;
run;
*p = -.10995, with a t-statistic of -0.63. Serial correlation doesn't seem to be an issue;

*Part ii;
proc autoreg data = inven;
model cinven = cgdp /nlag = 1 method = yw;
ods select ParameterEStimates;
run;
*Our coefficients are very close B1 = .1523 under PW and .15245 under OLS. This is expected since we do not have serial correlation present;


*Chapter 12 Question C13;
proc import datafile = "&path\okun.xls"
dbms = xls out = okun;
run;

*Part i;
proc reg data = okun;
model pcrgdp = cunem;
output out = okunx r = uhat;
ods select ParameterEstimates;
run;

data okunx;
set okunx;
uhat_1 = lag(uhat);
uhatsq = uhat**2;
run;

proc reg data = okunx;
model uhat = uhat_1;
ods select ParameterEstimates;
run;
*We get p = .05804, with resulting t-value of .38, showing little evidence of serial correlation;

*Part ii;
proc reg data = okunx;
model uhatsq = cunem;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*We obtain an F Value of 4.27, resulting in p-value of .0447. There is evidence of heteroskedasticity at the 5% level;

*Part iii;
proc reg data = okun;
model pcrgdp = cunem / hcc;
ods select ParameterEstimates;
run;
*The heteroskedastic robust standard error for B1 is .21779 compared to .18202. However, this only lowers the t-statistic to
8.68 in absolute value, which doesn't change the significance of B1;


*Chapter 12 Question C14;
proc import datafile = "&path\minwage.xls"
dbms = xls out = minwage;
run;

*Part i;
proc reg data = minwage;
model gwage232 = gmwage gcpi;
output out = minwagex r = uhat;
ods select ParameterEstimates;
run;

data minwagex;
set minwagex;
uhat_1 = lag(uhat);
uhatsq = uhat**2;
run;

proc reg data = minwagex;
model uhat = uhat_1;
ods select ParameterEstimates;
run;
*We get p (rho) = -0.09741, with t-value of -2.41. This shows evidence of negative serial correlation;

*Part ii;
proc model data = minwage;
parms b0 b1 b2;
gwage232 = b0 + b1*gmwage + b2*gcpi;
fit gwage232 / gmm kernel = (bart,13,0) vardef = n;
run;
quit;
*The NW estimated standard errors are slightly smaller for b0 and b2. The NW standard error for B1 is quite a bit larger however,
moving the t-value from 15.59 to 3.35. However, this doesn't change the significance;

*Part iii;
proc reg data = minwage;
model gwage232 = gmwage gcpi / hcc;
ods select ParameterEstimates;
run;
*The robust standard errors are smaller than OLS for b0, but larger than NW. 
For B1, the robust error is the same as the NW, and larger than OLS.
For B2, the robust error is larger than both OLS and NW.
It appears that heteroskedasticity is a larger issue;

*Part iv;
proc model data = minwage;
parms b0 b1 b2;
gwage232 = b0 + b1*gmwage + b2*gcpi;
fit gwage232 / pagan = (1 gmwage gcpi);
ods select HeteroTest;
run;
quit;
*The Breusch-Pagan statistic is 265.6, showing strong evidence of heteroskedasticity;

*Part v;
proc reg data = minwage;
model gwage232 = gmwage gcpi gmwage_1 gmwage_2 gmwage_3 gmwage_4 gmwage_5 gmwage_6 gmwage_7 gmwage_8 gmwage_9 gmwage_10 gmwage_11 gmwage_12 / acov;
Test gmwage_1, gmwage_2, gmwage_3, gmwage_4, gmwage_5, gmwage_6, gmwage_7, gmwage_8, gmwage_9, gmwage_10, gmwage_11, gmwage_12 = 0;
ods select ParameterEstimates TestANOVA ACovTestANOVA;
run;
*The robust standard errors increase the significance of each of the lagged variables other than gmwage_12;
*****need help computing heteroskedastic robust f test;

*Part vi;
*obtain p-value for above f-test using Newey - west;

*Part vii;
proc reg data = minwage;
model gwage232 = gmwage gcpi;
ods select ParameterEstimates;
run;
*If we leave out the lags, the LRP goes from about 1.98 x 10^-8 to 1.51 x 10^-8;
**is this correct LRP?;



*Chapter 12 Question C15;
proc import datafile = "&path\barium.xls"
dbms = xls out = bariumc15;
run;

*Part i;
*Comparing OLS and GLS standard errors is flawed because Prais-Winsten transformation (GLS) accounts for serial correlation, while OLS does not.;
*We know that OLS is understating the sample variation, and thus is not reliable when we discover serial correlation;

*Part ii;
proc model data = bariumc15;
parms b0 b1 b2 b3 b4 b5 b6;
lchnimp = b0 + b1*lchempi + b2*lgas + b3*lrtwex + b4*befile6 + b5*affile6 + b6*afdec6;
fit lchnimp / gmm kernel = (bart, 5, 0) vardef = n;
run;
quit;
*The standard error on lchempi is now .6360, which is higher than OLS and about the same as PW.
The standard error on afdec6 is now .2416, lower than OLS and PW;


*Part iii;
proc model data = bariumc15;
parms b0 b1 b2 b3 b4 b5 b6;
lchnimp = b0 + b1*lchempi + b2*lgas + b3*lrtwex + b4*befile6 + b5*affile6 + b6*afdec6;
fit lchnimp / gmm kernel = (bart, 13, 0) vardef = n;
run;
quit;
*The standard error on lchempi is now .7213, higher than both OLS and PW and higher than PW with g = 4.
The standard error on afdec is now .1893, lower than both OLS and PW and lower than our previous estimate with g = 4;



