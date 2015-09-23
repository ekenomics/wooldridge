********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/


%let path = F:\Data Sets;
*Chapter 10;
%let path = F:\Econometrics Supplement\Data Sets;
*Chapter 10 Question C1;
proc import datafile = "&path\intdef.xls"
dbms = xls out = intdef;
run;

data intdef;
set intdef;
if year > 1979 then post79 = 1; else post79 = 0;
run;

proc reg data = intdef;
model i3 = inf def post79;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on post79 is 1.56, with a t-statistic of 3.08. This is very significant.
This means that on average and accounting for inflation and deficits, i3 was about 1.56 points
higher after 1979.;


*Chapter 10 Question C2;
proc import datafile = "&path\barium.xls"
dbms = xls out = barium;
run;

*Part i;
proc reg data = barium;
model lchnimp = lchempi lgas lrtwex befile6 affile6 afdec6 t;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA;
test lchempi, lgas, lrtwex, befile6, affile6, afdec6;
run;
*No variables other than the trend are significant;

*Part ii;
*The F-Value for the joint significance of all variables other than the time trend is
0.54 with a resulting p-value of .7767. This means they are jointly insignificant;

*Part iii;
proc reg data = barium;
model lchnimp = lchempi lgas lrtwex befile6 affile6 afdec6 t feb mar apr may jun jul aug sep 
	oct nov dec;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA;
test lchempi, lgas, lrtwex, befile6, affile6, afdec6;
test feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec;
run;
*Nothing of importance changes in the model. The time trend is still the only significant
variable. The test for the joint significance for all variables other than the time trend
and the monthly dummies is still very insignificant, and the dummies alone are very 
insignificant as well;



*Chapter 10 Question C3;
proc import datafile = "&path\prminwge.xls"
dbms = xls out = prminwage;
run;

proc reg data = prminwage;
model lprepop = lmincov lusgnp t lprgnp;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on log(prgnp) is very significant with a t-statistic of 3.54. Since both
lprgnp and lprepop are in logs, the coefficient is the elasticity between the two. For each 
1% increase in lprgnp lprepop will increase by 0.285%. Including lprgnp increases the size
of the minimum wage effect: the coefficient on lmincov is now -.212 compared to -.169.;


*Chapter 10 Question C4;
proc import datafile = "&path\fertil3.xls" 
dbms = xls out = fertil;
run;

proc reg data = fertil;
model gfr = pe cpe_1 cpe_2 ww2 pill;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;

*We see that the standard error on pe in this equation is 0.2936, which is sufficiently
close to our .030 from the problem;


*Chapter 10 Question C5;
proc import datafile = "&path\ezanders.xls"
dbms = xls out = ez replace;
run;

*Part i;
data ez;
set ez;
t = _n_;
run;

proc reg data = ez;
model luclms = t feb mar apr may jun jul aug sep oct nov dec;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA;
test feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec;
run;
*The Time trend variable has a t-statistic of -11.14, meaning that is it very significant.
It has a coefficient of -.0139 meaning that on average unemployment claims fell by about 1.4%
per month. There is strong seasonality present with 6 of the monthly dummy variables having
a t-statistic over 2 in absolute value. The F-test for the joint significance of the dummy
variables is 3.24, showing strong proof that they are all jointly significant;

*Part ii;
proc reg data = ez;
model luclms = t ez feb mar apr may jun jul aug sep oct nov dec;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*When ez is added, its coefficient is about -0.51, with a t-stat of -3.49. This is very
significant. Using equation 7.10: 100*exp(-.508) = 39.8%;

*Part iii;
*We must assume that there weren't other factors acting on unemployment claims around the time
of EZ designation;

 
*Chapter 10 Question C6;
proc import datafile = "&path\fertil3.xls"
dbms = xls out = fertil replace;
run;

*Part i;
proc reg data = fertil;
model gfr = t tsq;
output out = fertilx r = gfdot;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;

*Part ii;
proc reg data = fertilx;
model gfdot = pe ww2 pill t tsq;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The R^2 from this equation is .602, whereas in 10.35 it was .727. This shows that the 
equation still explains quite a bit of variability even after being detrended.;

*Part iii;
proc reg data = fertilx;
model gfr = pe ww2 pill t tsq tcu;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The cubed time term is very significant with a t-stat of -6.81;


*Chapter 10 Question C7;
proc import datafile = "&path\consump.xls"
dbms = xls out = consump;
run;

*Part i;
proc reg data = consump;
model gc = gy;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on gy is .571 meaning that for each 1% increase in income growth, 
consumption growth increases by .571%. This coefficient is very significant with t-stat of 
8.47;

*Part ii;
proc reg data = consump;
model gc = gy gy_1;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on gy_1 is only .096, and the t-statistic is only 1.39. There is not 
much evidence of adjustment lags in consumption;

*Part iii;
proc reg data = consump;
model gc = gy r3;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on r3 is effectively zero. The t-statistic is also very insignificant;


*Chapter 10 Question C8;
proc import datafile = "&path\fertil3.xls"
dbms = xls out = fertilc8;
run;

*Part i;
proc reg data = fertilc8;
model gfr = pe pe_1 pe_2 pe_3 pe_4 ww2 pill;
ods select NObs FitStatistics ANOVA ParameterEstimates TestANOVA;
test pe_3, pe_4;
run;
*The F-value for the test of the joint significant of the 3rd and 4th lags is .06, showing that they are not
significant together;

*Part ii;
proc reg data = fertilc8;
model gfr = pe cpe cpe_1 cpe_2 cpe_3 ww2 pill;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on pe is .124 with standard error .030, which is above the LRP estimated in equation 10.19;

*Part iii;
data fertilc8x;
set fertilc8;
z0 = pe + pe_1 + pe_2 + pe_3 + pe_4;
z1 = pe_1 +2*pe_2 + 3*pe_3 + 4*pe_4;
z2 = pe_1 + 4*pe_2 + 9*pe_3 + 16*pe_4;
run;

proc reg data = fertilc8x;
model gfr = z0 z1 z2 ww2 pill;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*We obtain estimates for y0, y1, and y2 from this model. Y0 = .069 (coefficient on z0). 
Y1 = -.057 Y2 = .012. 

So, d0 = y0 = .069. 
d1 = .069 - .057 + .012 = .024.
d2 = .069 -2*(.057) + 4*(.012) = .003
d3 = .069 - 3*(.057) + 9*(.012) = .006
d4 = .069 - 4*(.057) + 16*(.012) = .033 

Therefore, the sum of these is the LRP of .135. This is slightly above the .124 obtained from the unrestriced model.;



*Chapter 10 Question C9;
proc import datafile = "&path\volat.xls"
dbms = xls out = vola;
run;

*Part i;
*We would expect B2 < 0, since as interest rates increase, stock prices fall. B1 is more unknown. While increased
growth is a good thing, it can also signal inflation;

*Part ii;
proc reg data = vola;
model rsp500 = pcip i3;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*A one percentage increase in pcip signals a .036% increase in the sp500 stock market return. 
A 1% increase in interest rates decreases the market returns by 1.36%;

*Part iii;
*I3 is statistically significant at the 5% level with a t-stat of -2.52;

*Part iv;
*No, our results say nothing about predicting the stock market. Since our results are timed at the same time as the 
return, we simultaneous changes, not changes as a result of a variable, which would have a time lag;



*Chapter 10 Question C10;
proc import datafile = "&path\intdef.xls"
dbms = xls out = intdefc10;
run;

*Part i;
proc corr data = intdefc10;
var def inf;
run;
*The correlation between inf and def is .097, which is very small. This implies almost zero multicollinearity.;

*Part ii;
proc reg data = intdefc10;
model i3 = inf inf_1 def def_1;
ods select NObs FitStatistics ANOVA ParameterEstimates TestANOVA;
test inf_1, def_1;
run;

*Part iii;
*The estimated LRP of i3 with respect to inf is .343 + .382  = .725, which is larger than .613 from 10.15;

*Part iv;
*The two lags have a joint significance F-Value of 5.22, and a resulting p-value of .0087. This shows
they are jointly significant at the 5% level;



*Chapter 10 Question C11;
proc import datafile = "&path\traffic2.xls"
dbms = xls out = traffic;
run;

*Part i;
proc print data = traffic (obs = 1);
where beltlaw = 1;
run;
*The beltlaw variable becomes 1 starting in Jan 1986;

proc print data = traffic (obs = 1);
where spdlaw = 1;
run;
*The speed law becomes 1 starting in May 1987;

*Part ii;
proc reg data = traffic;
model ltotacc = t feb mar apr may jun jul aug sep oct nov dec;
ods select NObs FitStatistics ANOVA ParameterEstimates TestANOVA;
test feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec;
run;
*.00275*100 gives us the resulting percentage increase in totacc from month
to month, after controlling for seasonality. 

There is very clear evidence of seasonality. Only feb has less accidents than Jan, 
the base month. The accidents peak in December, which is ~9.6% higher than January.

The F-Test for the joint significance of the monthly variables is 5.15,
showing they are very jointly significant;

*Part iii;
proc reg data = traffic;
model ltotacc = t feb mar apr may jun jul aug sep oct nov dec wkends unem spdlaw 
	beltlaw;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*The coefficient on unem is -.0212, which means that a 1% increase in unem 
means a decrease in accidents of 2.1%. This could mean that as unem decreases,
economic activity increases, meaning additional driving. Also, as unem increases,
money may get tighter, so people may cut costs by saving on fuel and thus drive less;

*Part iv;
*The coefficient on speedlaw is -.054. This means that accidents dropped by 5.4%
after the speed limit was increased to 65 on highways. One possible explanation for
this is that people may drive safer at higher speeds. 

*The coefficient on beltlaw is .095 meaning that accidents increased by about 9.5%
after the seat belt law was implemented. This may be because people drive less 
cautious when they have a seat belt on.;

*Part v;
proc means data = traffic;
var prcfat;
run;
*The average is .886, which means that less than 1% of accidents result in a
fatality;

*Part vi;
proc reg data = traffic;
model prcfat = t feb mar apr may jun jul aug sep oct nov dec wkends unem spdlaw 
	beltlaw;
ods select NObs FitStatistics ANOVA ParameterEstimates;
run;
*This time higher speeds account for a .067% increase in the number of fatal accidents.
This effect is statistically significant. Seat belt laws accounted for a decrease 
in fatal accidents by .0295%, but this is not a statistically significant effect.;


*Chapter 10 Question C12;
proc import datafile = "&path\phillips.xls"
dbms = xls out = phil;
run;

*Part i;
proc reg data = phil;
model inf = unem;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*There were 56 observations.;

*Part ii;
*Adding extra years does make the model better. The intercept estimate is now 1.054 instead of 1.42. The coefficient
on unem is .502 instead of .468. The t-statistic has also increased on unem. The total R^2 of the model has also gone
up.;

*Part iii;
proc reg data = phil;
model inf = unem;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
where year >= 1997 and year <= 2003;
run;
*Now the coefficient on unem is -.378 with a t-statistic of -1.13. This variable is no longer 
significant at the 10% level. This is not precise enough to be able to draw conclusions;

*Part iv;
*In this case, n2/n = 7/56. The coefficient on n2 = -.378.
N1/n = 49/56 The coefficient on n1 = .468. 

Thus we find the weighted average by doing: 

[(n1/n)*n1 + (n2/n)*n2] which gives us .362. 

While this may be considered close to our overall estimate of .502, in this situation this is not close enough 
to reasonably use. This is likely because the estimate when we only have n = 7 is not very strong, and thus the 
coefficient cannot be statistically considered different than zero at a high significance level;



*Chapter 10 Question C13;
proc import datafile = "&path\minwage.xls"
dbms = xls out = minwage replace;
run;

*Part i;
proc reg data = minwage;
model gwage232 = gmwage gcpi;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*The sign and magnitutde of gmwage makes good sense to me. It is positive, which you would expect from a positive growth
in the minimum wage. It is also extremely close to zero, most likely from the fact that the government doesn't change
the minimum wage often at all. Gmwage is very significant with a t-statistic of 15.59;

*Part ii;
proc reg data = minwage;
model gwage232 = gmwage gcpi gmwage_1 gmwage_2 gmwage_3 gmwage_4 gmwage_5 gmwage_6 gmwage_7
	gmwage_8 gmwage_9 gmwage_10 gmwage_11 gmwage_12;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA;
test gmwage_1, gmwage_2, gmwage_3, gmwage_4, gmwage_5, gmwage_6, gmwage_7, gmwage_8, gmwage_9, gmwage_10, gmwage_11, gmwage_12;
run;
*Individually, 6 of the 12 lags have a t-stat greater than one in absolute value. This is especially true for months 
8 - 12. These lags are picking up any activity in the minimum wage over the past year. The F-stat of the test for 
joint significance of all of the lags is 1.72, with a resulting p-value of .0582, so these are jointly significant 
at the 10% level.;

*Part iii;
proc reg data = minwage;
model gemp232 = gmwage gcpi;
ods select Nobs FitStatistics ANOVA ParameterEstimates;
run;
*While the coefficient on gmwage is negative, which we would expect, the t-stat is -.08, so it doesn't appear
that there is a contemporaneous effect between gemp232 and gmwage;

*Part iv;
proc reg data = minwage;
model gemp232 = gmwage gcpi gmwage_1 gmwage_2 gmwage_3 gmwage_4 gmwage_5 gmwage_6 gmwage_7
	gmwage_8 gmwage_9 gmwage_10 gmwage_11 gmwage_12;
ods select Nobs FitStatistics ANOVA ParameterEstimates TestANOVA;
test gmwage_1, gmwage_2, gmwage_3, gmwage_4, gmwage_5, gmwage_6, gmwage_7, gmwage_8, gmwage_9, gmwage_10, gmwage_11, gmwage_12;
run;
*Growth in the minimum wage doesn't seem to affect employment growth in any significant fashion. Only one of the wage 
growth variables is significant at the 10% level. The lagged variables also have a F-value of 1.09 with a resulting
p-value of .3618, which again is not significant;

