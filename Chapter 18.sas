********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/


%let path = F:\Data Sets;
*Chapter 18;
*Chapter 18 Question C1;
proc import datafile = "&path\wageprc.xls"
dbms = xls out = wageprc;
run;

*Part i;
proc reg data = wageprc;
model gprice = gwage gprice_1;
ods select ParameterEstimates;
run;
*The estimated impact propensity is .081 and the estimated LRP is .081/(1-.640) = .225;

*Part ii;
*The IP for the FDL model estimated in problem 11.5 was .119, which is substantially above the estimated IP 
for the GDL model. Further, the estimated LRP from the GDL model is much lower than that of the FDL model, which
we esimated as 1.172. We cannot think of the GDL model as a good approximation to the FDL model.;

*Part iii;
proc reg data = wageprc;
model gprice = gwage gprice_1 gwage_1;
ods select ParameterEstimates;
run;
*The coefficient on gwage_1 is not especially significant, but we compute the IP and LRP anyways. The estimated
IP is .09 while the LRP is (.090 + .055)/(1-.619) =~.381. These are both slightly higher than what we obtained for
the GDL, but the LRP is still well below what we obtained for the FDL.;



*Chapter 18 Question C2;
proc import datafile = "&path\hseinv.xls"
dbms = xls out = hseinv;
run;

*Part i;
data hseinv;
set hseinv;
ginvpc_1 = lag(ginvpc);
ginvpc_2 = lag(ginvpc_1);
gprice_1 = lag(gprice);
gprice_2 = lag(gprice_1);
run;

proc reg data = hseinv;
model ginvpc = linvpc_1 t ginvpc_1 ginvpc_2;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The t-statistic for the augmented Dickey-Fuller unit root test is -.956/.198 =~-4.83. The critical value for 
a unit root at the 5% level is -3.41. Since our value is well below this level we reject a unit root in log(invpc);

*Part ii;
proc reg data = hseinv;
model gprice = lprice_1 t gprice_1 gprice_2;
ods select ParameterEstimates;
run;
*Now our Dickey-Fuller t statistic is about -2.41, this is above -3.41 the 5% critical value. We cannot reject
the unit root at a small significance level;

*Part iii;
*Given that there is no evidence of a unit root in log(invpc) and log(price) may have a unit root, it makes no sense 
to test for cointegration between the two. If we take any nontrivial linear combination of an I(0) process
and an I(1) process the result will be an I(1) process.;




*Chapter 18 Question C3;
proc import datafile = "&path\volat.xls"
dbms = xls out = volat replace;
run;

*Part i;
data volat;
set volat;
pcip_4 = lag(pcip_3);
run;
proc reg data = volat;
model pcip = pcip_1 pcip_2 pcip_3;
model pcip = pcip_1 pcip_2 pcip_3 pcip_4;
ods select FitStatistics ParameterEstimates;
run;
*We see that the fourth lag has a t-statistic of .10 and is not significant;

*Part ii;
proc reg data = volat;
model pcip = pcip_1 pcip_2 pcip_3 pcsp_1 pcsp_2 pcsp_3;
ods select FitStatistics ParameterEstimates TestANOVA;
test pcsp_1, pcsp_2, pcsp_3 = 0;
run;
*We can reject the null that pcsp doesn't cause pcip based on the F-test. We obtain an F-value of 5.37 and see that
the three lags of pcsp are very jointly significant;

*Part iii;
data volat;
set volat;
ci3_3 = lag(ci3_2);
run;
proc reg data = volat;
model pcip = pcip_1 pcip_2 pcip_3 pcsp_1 pcsp_2 pcsp_3 ci3_1 ci3_2 ci3_3;
ods select FitStatistics ParameterEstimates TestANOVA;
test pcsp_1, pcsp_2, pcsp_3 = 0;
run;
*Now we obtain an F-value of 5.08 for the joint significance of the pcsp variables. We thus conclude that pcsp causes
pcip even conditional on past ci3;



*Chapter 18 Question C4;
proc import datafile = "&path\fertil3.xls"
dbms = xls out = fertil;
run;

proc reg data = fertil;
model gfr = pe t tsq;
output out = fertilx r = uhat;
ods select none;
run;

data fertilxx;
set fertilx;
uhat_1 = lag(uhat);
cuhat = uhat - uhat_1;
uhat_2 = lag(uhat_1);
cuhat_1 = uhat_1 - uhat_2;
run;

proc reg data = fertilxx;
model cuhat = uhat_1 cuhat_1;
ods select Nobs FitStatistics ParameterEstimates;
run;
*We find that the t-statistic on uhat_1 is -2.76. This is much higher than the 5% critical value of -3.78. 
Therefore we cannot reject the null hypothesis of null cointegration,, so we conclude gfr and pe are not cointegrated 
even if we allow them to have different quadratic trends;




*Chapter 18 Question C5;
proc import datafile = "&path\intqrt.xls"
dbms = xls out = intqrt;
run;

*Part i;
data intqrt;
set intqrt;
chy3_2 = lag2(chy3);
hy3_3 = lag(hy3_2);
term1 = lag(hy6hy3_1);
term2 = lag2(hy6hy3_1);
run;

proc reg data = intqrt;
model hy6 = hy3_1 chy3 chy3_1 chy3_2;
ods select FitStatistics ParameterEstimates;
run;

data t;
t = (1.02707-1)/0.01571;
put t;
run;
*Testing Ho: B1 = 1 gives us a t-statistic of 1.723. We do not reject Ho: B1 = 1 at the 5% level;

*Part ii;
proc reg data = intqrt;
model chy6 = chy3_1 term1 chy3_2 term2;
ods select Nobs FitStatistics ParameterEstimates TestANOVA;
test term2, chy3_2 = 0;
run;
*These added terms are not jointly or individually significant. Therefore we would omit these terms and stick with
the model in 18.39;




*Chapter 18 Question C6;
proc import datafile = "&path\phillips.xls"
dbms = xls out = phillips;
run;

*Part i;
proc reg data = phillips;
model unem = unem_1;
model unem = unem_1 inf_1;
ods select Nobs FitStatistics ParameterEstimates;
where year <= 1997;
run;
*The parameter estimates do not change by much. This is not surprising since we only added one year of data;

*Part ii;
data forecast;
model1 = 1.549 + .734*(4.9);
model2 = 1.286 + .648*(4.9) + .185*(2.3);
put model1;
put model2;
run;
*We forecast unem 1998 to be 5.15 using model 1 and 4.89 using model 2. Actual unemployment was 4.5, so 
the model using lagged inflation produces better results;

*Part iii;
*The difference in the predicted unemployment is 4.89 vs 4.90. Adding an additional year only adds .01 in 
predictive power, so it is not necessary at all to use the additional year;

*Part iv;
data twostep;
pred = (1+.732)*(1.572) + (.732)**2 * (5.4);
put pred;
run;
*The two step predicted unemployment is 5.62. The one step predicted unemployment is 5.16. Thus it is better to use
the one step method in this case;



*Chapter 18 Question C7;
proc import datafile = "&path\barium.xls"
dbms = xls out = barium;
run;

*Part i;
proc reg data = barium;
model chnimp = t;
ods select Nobs FitStatistics ParameterEstimates;
where t <= 119;
run;
*The standard error of the regression is 288.33;

*Part ii;
data barium;
set barium;
chnimp_1 = lag(chnimp);
run;

proc reg data = barium;
model chnimp = chnimp_1;
ods select Nobs FitStatistics ParameterEstimates;
where t <= 119;
run;
*Since the standard error of the regression is lower for the first model (the linear trend model) it provides
the better fit. The R-Squared is also much higher for the first model;

*Part iii;
data bariumfore;
set barium;
fitted1 = 248.57882 + 5.15256*t;
error1 = chnimp - fitted1;
fitted2 = 329.17555 + 0.41624*chnimp_1;
error2 = chnimp - fitted2;
abse1 = abs(error1);
abse2 = abs(error2);
error1sq = error1**2;
error2sq = error2**2;
if t <= 119 then DELETE;
run;
proc means data = bariumfore mean;
var abse1 abse2;

proc means data = bariumfore sum;
var error1sq error2sq;
run;

data RSME;
rsme1 = sqrt(1194485.32/12);
rsme2 = sqrt(1812569/12);
put rsme1;
put rsme2;
run;

*For the linear trend model we get RSME = 315.5 and MAE = 201.9. For the lagged model we get RSME = 388.6 and 
MAE = 246.1. This again shows that the linear trend model is better for forecasting;

*Part iv;
proc reg data = barium;
model chnimp = t feb mar apr may jun jul aug sep oct nov dec;
ods select Nobs FitStatistics ParameterEstimates TestANOVA;
test feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec = 0;
where t <= 119;
run;
*The month dummy variables are not jointly significant with F-value of 1.15 and p-value of .33;




*Chapter 18 Question C8;
proc import datafile = "&path\fertil3.xls"
dbms = xls out = fertilc8;
run;

*Part i;
proc sgplot data = fertilc8;
series x = year y = gfr;
run;
*There is no clear upward or downward trend during the entire sample.;

*Part ii;
data fertilc8;
set fertilc8;
tcube = t**3;
run;
proc reg data = fertilc8;
where year <= 1979;
model gfr = t tsq tcube;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The R-Squared is quite high at .74 indicating that this curve fitting exercise tracks gfr well at least through
1979;

*Part iii;
data fertil2c8;
set fertilc8;
fitted = 148.70823 - 6.90422*t + 0.24262*tsq - 0.00242*tcube;
error = gfr - fitted;
abserror = abs(error);
run;

proc means data = fertil2c8 mean;
var abserror;
where year >= 1980 and year <= 1984;
run;

*The MAE is about 43.20;

*Part iv;
proc reg data = fertilc8;
where year <= 1979;
model cgfr = ;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The intercept is not significant at the 10% level. It is legitimate to treat gfr as having no drift, 
if it is a random walk.;

*Part v;
data fertil3c8;
set fertilc8;
error2 = gfr - lag(gfr);
abse2 = abs(error2);
run;

proc means data = fertil3c8 mean;
var abse2;
where year >= 1980 and year <= 1984;
run;
*The MAE is now 0.84. This is much lower than the MAE obtained from the cubic trend model.;

*Part vi;
proc reg data = fertilc8;
model gfr = gfr_1 gfr_2;
ods select Nobs FitStatistics ParameterEstimates;
where year <= 1979;
run;
*The second lag is significant at the 5% level;

data fertil4c8;
set fertilc8;
fitted2 = 3.21566 + 1.27208*gfr_1 - 0.31139*gfr_2;
error3 = gfr - fitted2;
abse3 = abs(error3);
run;

proc means data = fertil4c8 mean;
var abse3;
where year >= 1980 and year <= 1984;
run;
*The MAE for the lagged model is .991. This is worse than the random walk model.;




*Chapter 18 Question C9;
proc import datafile = "&path\consump.xls"
dbms = xls out = consump;
run;

*Part i;
data consump;
set consump;
y_1 = lag(y);
t = _n_;
run;
proc reg data = consump;
where year <= 1989;
model y = t y_1;
ods select Nobs FitStatistics ParameterEstimates;
run;

*Part ii;
data fore90;
fore90 = 3186.04280 + 116.23768 * 32 + .63004*17804.09;
error90 = 17944.64 - fore90;
put error90;
run;
*The forecasting error was -178.30;

*Part iii;
data consump1;
set consump;
fore = 3186.04280 + 116.23768 * t + .63004*y_1;
error = y - fore;
abserror = abs(error);
run;

proc means data = consump1 mean;
var abserror;
where year >= 1990 and year <= 1999;
run;
*The MAE in the 1990s is 371.72;

*Part iv;
proc reg data = consump;
where year <= 1989;
model y = t;
ods select ParameterEstimates;
run;
data consump2;
set consump;
forec = 8143.10983 + 311.25508*t;
error1 = y - forec;
abse1 = abs(error1);
run;

proc means data = consump2 mean;
var abse1;
where year >= 1990 and year <= 1999;
run;
*The MAE for the linear trend model is 718.26. This is much worse than the model with the lagged variable. 
We should use the AR(1) with a linear trend to forecast;




*Chapter 18 Question C10;
proc import datafile = "&path\intqrt.xls"
dbms = xls out = intqrtc10;
run;

*Part i;
data intqrtc10;
set intqrtc10;
t = _n_;
run;
proc reg data = intqrtc10;
where t <= 108;
model cr6 = cr6_1;
ods select Nobs FitStatistics ParameterEstimates;
run;

data intqrt1c10;
set intqrtc10;
fit = 0.04701 - 0.17887*cr6_1;
error = cr6 - fit;
errorsq = error**2;
run;

proc means data = intqrt1c10 sum;
var errorsq;
where t >= 109;
run;

data rsme1;
rsme = sqrt(7.9358658/16);
put rsme;
run;
*The RSME is about .704;

*Part ii;
proc reg data = intqrtc10;
where t <= 108;
model cr6 = cr6_1 spr63_1;
ods select Nobs FitStatistics ParameterEstimates;
run;

data intqrt2c10;
set intqrtc10;
fit1 = 0.37172 - 0.17133*cr6_1 - 1.04469*spr63_1;
error1 = cr6 - fit1;
errorsq1 = error1**2;
run;

proc means data = intqrt2c10 sum;
var errorsq1;
where t >= 109;
run;

data rsme2;
rsme = sqrt(9.9404478/16);
put rsme;
run;
*The RSME is about .788, which is higher than the RSME without the error correction term.;

*Part iii;
*************************************************************
data intqrtx;
set intqrt2c10;
error1_1 = lag(error1);
cerror1 = error1 - lag(error1);
run;

proc reg data = intqrtxc10;
model cerror1 = error1_1;
where t <= 108;
ods select Nobs ParameterEstimates;
run;
*We obtain a cointegration parameter of 1.048;

***ISSUE WITH COINTEGRATION PARAMETER & model;
data intqrtxxc10;
set intqrtxc10;
r3_1co = 1.048*r3_1;
spr63_1co = r6_1 - r3_1co;
run;

proc reg data = intqrtxxc10;
where t <= 108;
model cr6 = cr6_1 spr63_1co;
ods select Nobs FitStatistics ParameterEstimates;
run;
*************************************************************

*Part v;
*The conclusions would be identical because, as shown in Problem 18.9, the one-step-ahead errors for forecasting
r6 N+1 are identical to those for cr6 N+1;




*Chapter 18 Question C11;
proc import datafile = "&path\volat.xls"
dbms = xls out = volatc11;
run;

*Part i;
data volatc11;
set volatc11;
lsp500 = log(sp500);
lip = log(ip);
lsp500_1 = lag(lsp500);
lip_1 = lag(lip);
clsp500 = lsp500 - lsp500_1;
clsp500_1 = lag(clsp500);
clsp500_2 = lag(clsp500_1);
clsp500_3 = lag(clsp500_2);
clsp500_4 = lag(clsp500_3);
clip = lip - lip_1;
clip_1 = lag(clip);
clip_2 = lag(clip_1);
clip_3 = lag(clip_2);
clip_4 = lag(clip_3);
t = _N_;
run;

proc reg data = volatc11;
model clsp500 = lsp500_1 clsp500_1 clsp500_2 clsp500_3 clsp500_4 ;
model clsp500 = lsp500_1 clsp500_1 clsp500_2 clsp500_3 clsp500_4 t;
ods select FitStatistics ANOVA Parameterestimates;
run;
*Without a trend varaible, our t-statistic is -.79. With the trend with have a t-statistic of -2.20. 
Both of these are well above their respective 10% critical values. ;

proc reg data = volatc11;
model clip = lip_1 clip_1 clip_2 clip_3 clip_4;
model clip = lip_1 clip_1 clip_2 clip_3 clip_4 t;
ods select FitStatistics ANOVA Parameterestimates;
run;
*Now we obtain a t-statistic of -1.37 without the trend and -2.52 with the trend. These do not reject at the 10%
critical value;


*Part ii;
proc reg data = volatc11;
model lsp500 = lip;
ods select ParameterEstimates FitStatistics;
output out = volatc11x r = uhat;
run;
*The t-statistic for lip is over 70, and the R-squared is over .90. These are marks of a spurious regression.;

*Part iii;
data volatc11xx;
set volatc11x;
uhat_1 = lag(uhat);
cuhat = uhat - uhat_1;
cuhat_1 = lag(cuhat);
cuhat_2 = lag(cuhat_1);
run;

proc reg data = volatc11xx;
model cuhat = uhat_1 cuhat_1 cuhat_2;
ods select ParameterEstimates;
run;
*The ADF statistic is -1.57 and the estimated root is over .99. There is no evidence of cointegration;

*Part iv;
proc reg data = volatc11;
model lsp500 = lip t;
ods select ParameterEstimates FitStatistics;
output out = volatc11v r = uhat;
run;

data volatc11vv;
set volatc11v;
uhat_1 = lag(uhat);
cuhat = uhat - uhat_1;
cuhat_1 = lag(cuhat);
cuhat_2 = lag(cuhat_1);
run;

proc reg data = volatc11vv;
model cuhat = uhat_1 cuhat_1 cuhat_2;
ods select ParameterEstimates;
run;
*Now the ADF statistic is -1.88 and the estimated root is about .99. Even with a time trend there is no evidence
of cointegration;

*Part v;
*It appears that lsp500 and lip do not move together in the sense of cointegration, even if we allow them to have
unrestricted linear time trends. This analysis does not point to a long-run equilibrium relationship;




*Chapter 18 Question C12;
proc import datafile = "&path\volat.xls"
dbms = xls out = volatc12;
run;

*Part i;
proc reg data = volatc12;
model pcip = pcip_1 pcip_2 pcip_3;
ods select ParameterEstimates TestANOVA;
test pcip_2, pcip_3 = 0;
run;
*We see the p-value is .024 so the last two lags are significant at the 2.5% level;

*Part ii;
proc reg data = volatc12;
model pcip = pcip_1 pcip_2 pcip_3 pcsp_1 /hcc;
ods select ParameterEstimates;
run;
*The t-statistic on pcsp_1 is 2.40 so it is significant at the 5% level. Therefore we conclude that pcsp does
Granger cause pcip;

*Part iii;
*The robust t-statistic on pcsp_1 is 2.48, so the conclusion from part ii does not change;



*Chapter 18 Question C13;
proc import datafile = "&path\traffic2.xls"
dbms = xls out = traffic;
run;

*Part i;
data traffic;
set traffic;
ltotacc_1 = lag(ltotacc);
ctotacc = ltotacc - ltotacc_1;
ctotacc_1 = lag(ctotacc);
ctotacc_2 = lag(ctotacc_1);
run;

proc reg data = traffic;
model ctotacc = ltotacc_1;
ods select ParameterEstimates;
run;
*The DF statistic is about -3.31, which is below the 2.5% critical value (-3.12) and so using this test,
we can reject a unit root at the 2.5% level. The estimated root is about .81;

*Part ii;
proc reg data = traffic;
model ctotacc = ltotacc_1 ctotacc_1 ctotacc_2;
ods select ParameterEstimates;
run;
*When we add the two lags the DF statistic becomes -1.50 and the root is now about .915. Now there is little evidence
against a unit root;

*Part iii;
proc reg data = traffic;
model ctotacc = ltotacc_1 ctotacc_1 ctotacc_2 t;
ods select ParameterEstimates;
run;
*Adding a time trend the DF statistic becomes -3.67 and the estimated root is about .57. The 2.5% critical value is
-3.66 so we are back to fairly convincingly reject a unit root;

*Part iv;
*The best characterization seems to be an I(0) process about a linear trend. In fact, a stable AR(3) about a linear
time trend is suggested by the regression in part (iii);

*Part v;
data traffic1;
set traffic;
prcfat_1 = lag(prcfat);
cprcfat = prcfat - prcfat_1;
cprcfat_1 = lag(cprcfat);
cprcfat_2 = lag(cprcfat_1);
run;

proc reg data = traffic1;
model cprcfat = prcfat_1 cprcfat_1 cprcfat_2;
model cprcfat = prcfat_1 cprcfat_1 cprcfat_2 t;
ods select ParameterEstimates;
run;
*For prcfat the ADF statistic without a trend is -4.74 and the estimated root is .62. With a time trend the ADF 
statistic is -5.29 with an estimated root is .54. Here the evidence is strongly in favor of an I(0) process,
whether we include a trend or not;




*Chapter 18 Question C14;
proc import datafile = "&path\minwage.xls"
dbms = xls out = minwage;
run;

*Part i;
data minwage;
set minwage;
lwage232_1 = lag(lwage232);
gwage232_1 = lag(gwage232);
gemp232_1 = lag(gemp232);
lemp232_1 = lag(lemp232);
lrwage232 = lwage232 - lcpi;
run;

proc reg data = minwage;
model gwage232 = lwage232_1 gwage232_1 gemp232_1 t;
ods select ParameterEstimates;
run;

proc reg data = minwage;
model gemp232 = lemp232_1 gwage232_1 gemp232_1 t;
ods select ParameterEstimates;
run;
*In both of these cases there is little evidence against a unit root;

*Part ii;
proc reg data = minwage;
model lemp232 = lwage232;
ods select none;
output out = minwagex r = uhat;
run;

proc reg data = minwage;
model lemp232 = lwage232 t;
ods select none;
output out = minwagev r = uhat;
run;

data minwagexx;
set minwagex;
uhat_1 = lag(uhat);
cuhat = uhat - uhat_1;
cuhat_1 = lag(cuhat);
cuhat_2 = lag(cuhat_1);
run;

data minwagevv;
set minwagev;
uhat_1 = lag(uhat);
cuhat = uhat - uhat_1;
cuhat_1 = lag(cuhat);
cuhat_2 = lag(cuhat_1);
run;

proc reg data = minwagexx;
model cuhat = uhat_1 cuhat_1 cuhat_2;
ods select ParameterEstimates;
run;

proc reg data = minwagevv;
model cuhat = uhat_1 cuhat_1 cuhat_2;
ods select ParameterEstimates;
run;
*Both with and without the time trend there is no evidence of cointegration;

*Part iii;
proc reg data = minwage;
model lemp232 = lrwage232 t;
ods select none;
output out = minwaget r = uhat;
run;

data minwagett;
set minwaget;
uhat_1 = lag(uhat);
cuhat = uhat - uhat_1;
cuhat_1 = lag(cuhat);
cuhat_2 = lag(cuhat_1);
run;

proc reg data = minwagett;
model cuhat = uhat_1 cuhat_1 cuhat_2;
ods select ParameterEstimates;
run;
*We now obtain a t-statistic of -3.09, which is much "closer" to being cointegrated than in part ii.;





*Chapter 18 Question C15;
proc import datafile = "&path\beveridge.xlsx"
dbms = xlsx out = beveridge replace;
run;

*Part i;
data beveridgeu;
set beveridge;
curate_1 = lag(curate);
curate_2 = lag(curate_1);
run;

proc reg data = beveridgeu;
model curate = urate_1;
model curate = urate_1 curate_1 curate_2;
ods select ParameterEstimates;
run;
*With both models we fail to reject the fact that a unit root exists, even at the 10% level;

*Part ii;
data beveridgev;
set beveridge;
cvrate_1 = lag(cvrate);
cvrate_2 = lag(cvrate_1);
run;

proc reg data = beveridgev;
model cvrate = vrate_1;
model cvrate = vrate_1 cvrate_1 cvrate_2;
ods select ParameterEstimates;
run;
*Again, we fail to reject the unit root, even at the 10% level;

*Part iii;
proc reg data = beveridge;
model urate = vrate;
ods select none;
output out = beveridgex r = uhat;
run;

data beveridgexx;
set beveridgex;
uhat_1 = lag(uhat);
cuhat = uhat - uhat_1;
cuhat_1 = lag(cuhat);
cuhat_2 = lag(cuhat_1);
run;

proc reg data = beveridgexx;
model cuhat = uhat_1;
ods select ParameterEstimates;
run;
*With a t-statistic of -3.23, vrate and urate are cointegrated at the 10% level, but not at the 5% level;

*Part iv;
proc expand data = beveridgev out = beveridge_v method = none;
convert cvrate = cvrate_0 /transformout =(lead 1);
run;

proc reg data = beveridge_v;
model cvrate = vrate_1 cvrate_1 cvrate_0 / clb;
ods select ParameterEstimates;
run;

proc model data = beveridge_v;
parms b0 b1 b2 b3;
cvrate = b0 + b1*vrate_1 + b2*cvrate_1 + b3*cvrate_0;
fit cvrate / gmm kernel = (bart, 5,0) vardef = n;
ods select ParameterEstimates;
run;

data ci;
ciplus = -0.07785 + .0362*1.96;
ciminus = -0.07785 - .0362*1.96;
put ciplus;
put ciminus;
run;
*The confidence interval for B using Newest-West standard errors is -.1488 to -.006898. This is wider than the
non robust standard errors;

*Part v;
proc reg data = beveridgexx;
model cuhat = uhat_1 cuhat_1 cuhat_2;
ods select ParameterEstimates;
run;
*Now our t-statistic is -1.05, showing little evidence of cointegration even at the 10% level. 
We can thus conclude that the claim that vrate and urate are cointegrated is not very robust;

