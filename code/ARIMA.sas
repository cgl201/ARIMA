PROC IMPORT OUT= sh600368
            DATAFILE= 'C:\Users\Jason\Desktop\Stock Time Series\600368.SS.csv'
            DBMS=csv replace;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
data sh600368;
set sh600368;
t=_n_;
output;
run;

proc gplot data=sh600368;
plot close*t=2 high*t=3 low*t=4/ overlay ;
symbol2 v=plus i=spline c=red l=1 w=2;
symbol3 v=circle i=spline c=green l=2 w=1;
symbol4 v=circle i=spline c=blue l=2 w=1;
title 'stock';
run;
/*stationary test: ACF decays quickly*/
/*white noise test: null hypothesis: it is white noise*/
proc arima data=sh600368;
identify var=close nlag=22;
run;
proc arima data=sh600368;
where t>=240;
      identify var=close(2,2) nlag=24 minic p=(0:10) q=(0:10);
run;
quit;
proc arima data=sh600368;
where t>=240;
      identify var=close(2,2) minic p=(0:10) q=(0:10);
estimate p=2 q=1; 
run;
proc arima data=sh600368;
where t>=240;
      identify var=close(2,2) minic p=(0:10) q=(0:10);
estimate p=(2) q=1 noint; 
run;
forecast lead=10 id=t out=sh600368;   
run;
proc sgplot data=sh600368;
band upper=u95 lower=l95 x=t/ legendlabel="95% confidence";
scatter x=t y=close;
series x=t y=FORECAST;
refline 280 /axis=x lineattrs=(pattern=4);
run;