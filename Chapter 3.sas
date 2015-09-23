********************************************************************************;
/*These files supplement the textbook,"Introductory Econometrics: A Modern Approach" by Jeffrey Wooldridge. 
To run these files, simply replace the file directory after %let path= with your file directory.
For instance, if you extracted the zip file to C:\Public, then 
replace F: with C:\Public

Contact kenneth.sanford@sas.com if you have any difficulty using this file.*/



%let path = F:\Data Sets;
*Chapter 3 Question C1;
proc import datafile="&path\bwght.xls"
dbms=xls out=bwght;
run;

*Part i;
*We would expect a B2>0 since higher income would allow us to assume better nutrition and thus a higher birth weight.;

*Part ii;
*We could assume that a higher income would allow us to have a higher consumption of goods, leading us to believe we could have a positive correlation between
cigs and faminc. However, we also can assume that faminc and education would be highly correlated, leading us to believe that there could be a 
negative correlation between cigs and faminc.;

*Part iii;
proc reg data=bwght;
model bwght = cigs;
ods select Nobs FitStatistics ParameterEstimates;
run;

proc reg data=bwght;
model bwght = cigs faminc;
ods select Nobs FitStatistics ParameterEstimates;
run;

proc corr data=bwght;
var cigs faminc;
ods select PearsonCorr;
run;

*We can see that adding faminc to the model only leads to a small change in the effect from cigs. This is due to the fact that faminc and cigs are not very correlated, 
with a correlation of -.173. It is also due to the fact that faminc has a very slight effect on bwght.;

*****************************

*Chapter 3 Question C2;
proc import datafile="&path\hprice1.xls"
dbms=xls out=hprice1;
run;

*Part i;
proc reg data=hprice1;
model price = sqrft bdrms;
ods select Nobs FitStatistics ParameterEstimates;
run;

*Part ii;
*The coefficient on bdrms is 15.19819, so we would expect an increase in price of 15.19819 units from one additional bedroom.
In this case the units are thousands of dollars, so an increase of ~$15,200.;

*Part iii;
data sqrftbdrm;
newbdrm=0.12844*140+15.19819*1;
put newbdrm;
run;
*Result of 33.17979, or $33,180. Since the size of the house is increasing, this is a large effect than part ii;

*Part iv;
*According to our R^2 value, 63.19% of the variation in price is explained by sqrft and bdrms.;

*Part v;
data firsthouse;
firsthouse=-19.31500+0.12844*2438+15.19819*4;
put firsthouse;
run;
*Result of 354.61448, or $354,615;

*Part vi;
data residual;
residual = 300000-354615;
put residual;
run;
*Residual of -54,615. This suggests that the buyer underpaid for the house. But the difference in value could be due to
factors outside of sqrft and bdrms that haven't been accounted for;

*****************************

*Chapter 3 Question C3;
proc import datafile="&path\ceosal2.xls"
dbms=xls out=ceosal2;
run;

*Part i;
proc reg data=ceosal2;
model lsalary = lsales lmktval;
ods select Nobs FitStatistics ParameterEstimates;
run;

*Part ii;
proc means data=ceosal2 range max min;
var profits;
run;

proc reg data=ceosal2;
model lsalary = lsales lmktval profits;
ods select Nobs FitStatistics ParameterEstimates;
run;

*The profits variable can not be included in log form because it has several negative observations. These three variables together explain 29.93% of the variation in 
CEO salaries, which I would not consider most of the variation;

*Part iii;
proc reg data=ceosal2;
model lsalary = lsales lmktval profits ceoten;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The coefficient on ceoten is 0.01168 so that gives us a 1.168% increase in salary for each additional year of CEO tenure.;

*Part iv;
proc corr data=ceosal2;
var lmktval profits;
ods select PearsonCorr;
run;
*These variables have a correlation of 0.77690, which is fairly high. We know that this doesn't cause bias in the OLS estimators, but it does cause the variances to 
be fairly high.;

*********************************

*Chapter 3 Question C4;
proc import datafile="&path\attend.xls"
dbms=xls out=attend;
run;

*Part i;
proc means data=attend max min mean;
var atndrte priGPA ACT;
run;

*Part ii;
proc reg data=attend;
model atndrte = priGPA ACT;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The intercept in this case means that for a student with a GPA of 0 and an ACT score of 0, we would predict them to 
have a attendance rate of 75.70041%. This is obviously not an interesting part of the population;

*Part iii;
*A one point increase in GPA, from 3.0 to 4.0, would increase attendance rate by 17.26059%. This is holding ACT fixed. 
The negative slope on ACT is surprising, but may lead us to believe that students who score highly on the ACT may 
believe that school will be easier, and thus will be more likely to skip lectures.;

*Part iv;
data predrate;
rate=75.70041+17.26059*3.65-1.71655*20;
put rate;
run;

proc print data=attend;
where priGPA=3.65 and ACT=20;
run;

*These values give us a result of 104.37%, which is higher than 100%, and thus obviously impossible. 
Student #569 had these values, and their attendance rate was only 87.5%;

*Part v;
data diff;
diff=17.26059*(3.1-2.1)-1.71655*(21-26);
put diff;
run;
*The difference between their predicted attendance rates would be 25.84334%;

*******************************

*Chapter 3 Question C5;
proc import datafile="&path\wage1.xls"
dbms=xls out=wage1;
run;

proc reg data=wage1;
model educ = exper tenure;
output out=wage3 r=resid;
ods select Nobs FitStatistics ParameterEstimates;
run;

proc reg data=wage3;
model lwage = resid;
ods select Nobs FitStatistics ParameterEstimates;
run;

*Below equation from Example 3.2;
proc reg data=wage1;
model lwage = educ exper tenure;
ods select Nobs FitStatistics ParameterEstimates;
run;

quit;

*As we would expect, the coefficient on the residuals and the coefficient on education in Example 3.2 are the exact same.
This shows that the regression on the residuals only uses the part of educ that is not correlated with tenure and exper.;

****************************************

*Chapter 3 Question C6;
proc import datafile="&path\wage2.xls"
dbms=xls out=wage2 replace;
run;

*Part i;
*obtain gamma1;
proc reg data=wage2;
model IQ = educ;
ods select ParameterEstimates;
run;

*Part ii;
*obtain B1;
proc reg data=wage2;
model lwage = educ;
ods select ParameterEstimates;
run;

*Part iii;
*Obtain B1hat B2hat;
proc reg data=wage2;
model lwage = educ IQ;
ods select ParameterEstimates;
run;

*Part iv;
data verify;
B1squiggle= 0.05984;
Verify = 0.03912 + 0.00586*3.53383;
put B1squiggle Verify;
run;
*Verify that the two numbers are equal;

***********************

*Chapter 3 Question C7;
proc import datafile="&path\meap93.xls"
dbms=xls out=meap93;
run;

*Part i;
proc reg data=meap93;
model math10 = lexpend lnchprg;
ods select Nobs FitStatistics ParameterEstimates;
run;
*I would expect the sign of lexpend to be positive and it is. However, it is surprisng that the coefficient of lnchprg 
is negative;

*Part ii;
proc means data=meap93 max min mean;
var lexpend;
run;
*The intercept makes sense when we consider that the minimum value of lexpend is ~8.11. This means that at minimum we 
will have a value of about 28% for any given school in math10, just from lexpend, without any data for lnchprg.;

*Part iii;
proc reg data=meap93;
model math10 = lexpend;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The spending effect is now even larger than part i;

*Part iv;
proc corr data= meap93;
var lexpend lnchprg;
run;
*This sign makes sense. As spending per student increases, it is more likely that the school will be in a wealthier area, 
thus requiring less students on a school lunch program;

*Part v;
*Since they are negatively correlated, we would expect that the coefficient of lexpend would be smaller in the 
presence of lnchprg. We found this to be true;

************************

*Chapter 3 Question C8;
proc import datafile="&path\discrim.xls"
dbms = xls out=discrim;
run;


*Part i;
proc means data=discrim;
var prpblck income;
run;
*Prpblck is measured as a proportion out of 1.0. Income is in dollars;

*Part ii;
proc reg data=discrim;
model psoda = prpblck income;
ods select Nobs FitStatistics ParameterEstimates;
run;

proc means data=discrim max min mean;
var prpblck;
run;
*Given that the value for prpblck is always less than one, with a max of .98, the coefficient of 0.14604 means that this 
variable is not economically large. At most, with a proportion of .98, this variable will only contribute $0.14 to the 
price of a soda;

*Part iii;
proc reg data=discrim;
model psoda = prpblck;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The effect is much smaller when controlling for income, roughly half of its previous value.;

*Part iv;
proc reg data=discrim;
model lpsoda = prpblck lincome;
ods select Nobs FitStatistics ParameterEstimates;
run;

data pctchg;
pctchg =(.20*.10121)*100;
put pctchg;
run;

*For an increase of 20% in prpblck, we get an increase in psoda of 2.0242%.;

*Part v;
proc reg data=discrim;
model lpsoda = prpblck lincome prppov;
ods select Nobs FitStatistics ParameterEstimates;
run;

*The coefficient on prpblck decreases.;

*Part vi;
proc corr data=discrim;
var lincome prppov;
run;
*They are very highly uncorrelated, which is to be expected when comparing income to the poverty proportion;

*Part vii;
*Since we have multicollinearity present, the regression equation is not necessarily poor. It does have a roughly 2% 
better R^2 so as a whole it is predicting better. However, due to multicollinearity, 
it will not be a very useful equation for predicting specific values.;

***********************

*Chapter 3 Question C9;
proc import datafile="&path\charity.xls"
dbms=xls out=charity;
run;

*Part i;
proc reg data=charity;
model gift = mailsyear giftlast propresp;
ods select Nobs FitStatistics ParameterEstimates;
run;
proc reg data=charity;
model gift = mailsyear;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The R^2 is about 7% higher in the multiple regression model;

*Part ii;
*The mailsyear coefficient is larger in the simple regression model;

*Part iii;
*The coefficient on propresp means that for each additional percentage of people that responded to the mailing, 
the gift size went up $15.35 on average. Since this proportion is measured out of 1.0, the magnitude of this coefficient
is more believable.;

*Part iv;
proc reg data=charity;
model gift = mailsyear giftlast propresp avggift;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The coefficient on mailsyear decreased dramatically;

*Part v;
*The value of giftlast decreased and became negative. This could be due to many people having low numbers of gifts, 
so that the avggift value and lastgift value are very very close. Also, it could mean that people give more 
with their first few gifts, so the avggift value may be higher than the lastgift value.;

***************************

*Chapter 3 Question C10;
proc import datafile="&path\htv.xls"
dbms=xls out=htv;
run;

*Part i;
proc means data=htv max min range;
var educ;
run;

proc freq data=htv;
table educ;
run;
*56.75% of men completed no higher than 12th grade;

proc means data=htv;
var motheduc fatheduc educ;
run;
*The Men and their parents all have very similar average education, between 12.18-13.03 years of education in all groups;

*Part ii;
proc reg data=htv;
model educ = motheduc fatheduc;
ods select Nobs FitStatistics ParameterEstimates;
run;
*24.93% of the variation in educ is explained by motheduc and fatheduc. The coefficient on motheduc means that for each 
additional year of the mothers' education, the child will on average add 0.30 years of education to their own studies;

*Part iii;
proc reg data=htv;
model educ = motheduc fatheduc abil;
ods select Nobs FitStatistics ParameterEstimates;
run;
*The R^2 value of this equation goes up to 42.75% when adding abil to the equation. 
This is a significant jump and shows that abil is likely explaining ~20% of the variation.;

*Part iv;
data htv1;
set htv;
abil2 = abil**2;
run;

proc reg data=htv1;
model educ = motheduc fatheduc abil abil2;
ods select Nobs FitStatistics ParameterEstimates;
run;
*Requires calculus from this point on. Solving the first derivative of educ with respect to abil gives us abil*=-4.;

*Part v;
proc freq data=htv;
table abil;
where abil <=1-4;
run;
*This gives us a result of 44/1230 men have ability less than this minimum value, of ~3.5%. This is 
important because we solved for this value being the minimum value of ability;

*Part vi;
data htv2;
set htv1;
pred = 8.24 + 0.19013*12.18 + 0.10894*12.45 + 0.40146*abil + 0.05060*abil2;
run;

proc sgplot data=htv2;
scatter x=abil y = pred;
run;



