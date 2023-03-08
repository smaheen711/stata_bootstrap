clear all
/*
gen April ="."
gen May="."
gen June ="."
*/
gen October ="."
gen November="."
gen December ="."
/*
destring April, replace
destring May, replace
destring June, replace
*/
destring October, replace
destring November, replace
destring December, replace

save saved_stata_files/bsampleappendedgdp, replace

while _N<200{
clear all


*use consolidated/monthly_data,

*order timeq timem
******************************************BEGIN LOOP
use consolidated/quarterly_nominalgdp_data, clear

gen Employedq = Laborq - Uq

tsset _state timeq, quarterly

tsfilter hp cty = GDPq			  , trend(GDPq_trend) smooth(1600)
tsfilter hp ctus = GDPq_us	  	  , trend(GDPq_us_trend) smooth(1600)
tsfilter hp ctl = Laborq          , trend(Laborq_trend) smooth(1000000)
tsfilter hp cte = Employedq       , trend(Employedq_trend) smooth(1000000)
gen u3_trend = 0.05

*generate delta y and delta u
by _state:gen GDPq_gap = (GDPq -  GDPq_trend) /  GDPq_trend
by _state:gen u3q_gap =  (U3q - u3_trend)
gen lnu3 = ln(U3q)
by _state:gen GDPq_us_gap = (GDPq_us - GDPq_us_trend) / GDPq_us_trend

/*
sort state timem
gen trendm = 2	if timem ==tm(2005m1)		
replace trendm=trendm[_n-1]+1 if trendm==.

*/
*****droped ctus to regen this variable in section lower****
drop ctus

*******************kansas varaibles***************
*sort timeq timem
bysort timeq: replace Wageq 	= . if _n ~=1
bysort timeq: replace GDPq 		= . if _n ~=1
bysort timeq: replace Laborq 	= . if _n ~=1
bysort timeq: replace GDPq_us 	= . if _n ~=1
bysort timeq: replace Uq 		= . if _n ~=1
bysort timeq: replace U3q 		= . if _n ~=1
bysort timeq: replace AGW 		= . if _n ~=1
bysort timeq: replace CornP 	= . if _n ~=1
bysort timeq: replace BeefP 	= . if _n ~=1
bysort timeq: replace WheatP 	= . if _n ~=1
bysort timeq: replace OILq 		= . if _n ~=1
bysort timeq: replace ChickenP 	= . if _n ~=1
bysort timeq: replace RiceP 	= . if _n ~=1
bysort timeq: replace PorkP 	= . if _n ~=1
bysort timeq: replace TaxKS 	= . if _n ~=1
bysort timeq: replace timeq		= . if _n ~=1
************************************************************
/*
***************Arkansas variables*****************************
*bysort timeq: replace Wageq 	= . if _n ~=1
bysort timeq: replace GDPq 		= . if _n ~=1
bysort timeq: replace Laborq 	= . if _n ~=1
bysort timeq: replace GDPq_us 	= . if _n ~=1
bysort timeq: replace Uq 		= . if _n ~=1
bysort timeq: replace U3q 		= . if _n ~=1
bysort timeq: replace AGW 		= . if _n ~=1
bysort timeq: replace CornP 	= . if _n ~=1
bysort timeq: replace BeefP 	= . if _n ~=1
*bysort timeq: replace WheatP 	= . if _n ~=1
bysort timeq: replace OILq 		= . if _n ~=1
bysort timeq: replace ChickenP 	= . if _n ~=1
bysort timeq: replace RiceP 	= . if _n ~=1
bysort timeq: replace PorkP 	= . if _n ~=1
bysort timeq: replace TaxAR 	= . if _n ~=1
bysort timeq: replace timeq		= . if _n ~=1
****************************************************************
*/
/*
***************Colorado Variables************************
*bysort timeq: replace Wageq 	= . if _n ~=1
bysort timeq: replace GDPq 		= . if _n ~=1
bysort timeq: replace Laborq 	= . if _n ~=1
bysort timeq: replace GDPq_us 	= . if _n ~=1
bysort timeq: replace Uq 		= . if _n ~=1
bysort timeq: replace U3q 		= . if _n ~=1
*bysort timeq: replace AGW 		= . if _n ~=1
*bysort timeq: replace CornP 	= . if _n ~=1
bysort timeq: replace BeefP 	= . if _n ~=1
bysort timeq: replace WheatP 	= . if _n ~=1
bysort timeq: replace OILq 		= . if _n ~=1
bysort timeq: replace ChickenP 	= . if _n ~=1
bysort timeq: replace RiceP 	= . if _n ~=1
*bysort timeq: replace PorkP 	= . if _n ~=1
bysort timeq: replace TaxCO 	= . if _n ~=1
bysort timeq: replace timeq		= . if _n ~=1

*/




***doing alpha calc*********************************
/*
*gen Employedq = Laborq - Uq

*tsset _state timeq, quarterly

*tsfilter hp cty = GDPq			  , trend(GDPq_trend) smooth(1600)
*tsfilter hp ctus = GDPq_us	  	  , trend(GDPq_us_trend) smooth(1600)
*tsfilter hp ctl = Laborq          , trend(Laborq_trend) smooth(1000000)
*tsfilter hp cte = Employedq       , trend(Employedq_trend) smooth(1000000)
gen u3_trend = 0.05
*/
sort _state

*by _state:gen GDPq_gap = (GDPq - GDPq_trend) / GDPq_trend

*by _state:gen u3q_gap =  (U3q - u3_trend)
*gen lnu3 = ln(U3q)
*by _state:gen GDPq_us_gap = (GDPq_us - GDPq_us_trend) / GDPq_us_trend

by _state:gen trendq = _n*3

************************************kansas variables****************
gen a = .
gen b = .
gen gd = .
gen tx = .
gen m = .
gen z = .
gen op = .
gen tt = .
gen wp = .
gen kk = .
*********************************************************************
*/
/*
***********************arkansas variables***********************
gen a = .
gen u = .
gen t = . 
gen aa = .
gen m = .
gen op = .
gen cp = .
gen rp = .
gen tt = .
*************************************************************************
/*
*************************Colorado variables*******************
gen a = . 
gen m = .
gen op = .
gen cp = .
gen rp = .
gen tt = .
gen cb = .
gen wp = .
gen cb1 = . 
gen co1 = .
gen cc = .
gen co = .
*********************************************************************

***********************Iowa Variables**************************
gen a = . 
gen o = .
gen z = .
gen cp = .
gen rp = .
gen tt = .
gen wp = . 
gen ii = .
gen pp = .
gen m = .
************************************************

************************Mo Variables
gen a = . 
gen b = .
gen p = .
gen t = .
gen mm = .
gen cp = .
gen rp = . 
gen wp = .
gen pp = .
gen op = .
gen tt = .
gen m = .
gen z = .
*******************************************
******************NE variables
gen a = . 
gen b = .
gen gd = .
gen t = .
gen nn = .
gen pp = .
gen tt = .
gen z = .
gen n = .
gen op = .
***************************************

**********************OK variables

gen a = . 
gen b = .
gen gd = .
gen t = .
gen op = .
gen z = .
gen rp = .
gen wp = .
gen pp = .
gen tt = .
gen m = .
gen oo = .
*/

*/
gen u3_gap =.
gen GDP_est =.
sort timeq GDPq_gap 

replace trendq = . if Uq == . 

*************************************** 

order timeq
set obs `=_N+58'
gen sample1 = runiformint(1,59) if _n > 60
replace timeq = timeq[1] + sample1 -1 if _n >=61
*gen timeb =1 if _n==181
*replace timeb = timeb[_n-1] +3 if _n >181
sort timeq
by timeq: gen temp1 = _N-1
order timeq temp1 sample1
sort timeq
drop if temp1 ==0 & /*timeq ~= tq(2019q2) &*/ timeq ~= tq(2019q4)
*drop if temp1 ==1 & timem ==.
expand temp1 if temp1 >=2 & temp1 <58
*drop if temp1 ==3 & timem ==.
sort timeq
drop if u3 ==.
*drop if timem ==.
drop temp1 sample1

/*
order timeq
***Number of OBS = 58 - therefore set obs = -2
set obs `=_N+57'
gen sample1 = runiformint(1,58) if _n > 59
replace timeq = timeq[1] + sample1 -1 if _n >=60
*gen timeb =1 if _n==181
*replace timeb = timeb[_n-1] +3 if _n >181
sort timeq
by timeq: gen temp1 = _N-1
order timeq temp1 sample1
sort timeq
drop if temp1 ==0 & /*timeq ~= tq(2018q4) &*/ timeq ~= tq(2019q3)
*drop if temp1 ==1 & timem ==.
expand temp1 if temp1 >=2 & temp1 <57
*drop if temp1 ==3 & timem ==.
sort timeq
drop if u3 ==.
*drop if timem ==.
drop temp1 sample1
*/
save saved_stata_files/bsample1copy, replace


clear all
use saved_stata_files/bsample1copy,

do _alphacalculationbsamplecopy,

use saved_stata_files/alpha_estimate_b_sample_copy, 

*keep timeq trendq  GDPq GDPq_us_gap GDPq_us_trend a b d p u t o z n gd tx m q1 op tt wp aa cc ii kk mm nn oo co cb cp rp pp co1 cb1 state timeq GDPq_trend _state

sort _state timeq
quietly by _state timeq: gen dup = cond(_N==1,0,_n)

drop if dup >1
*drop dup

gen temp = timeq[_n+1] - timeq

expand temp if temp >1
expand timeq - tq(2004q4) if _n==1 & timeq ~=tq(2005q1)

sort trendq timeq
****************
gen test = trendq == trendq[1]

egen sum = total(test)

replace timeq = timeq[sum+1]-(sum-_n+1) if timeq~=tq(2005q1) & test ==1
*************************

by trendq: replace timeq = timeq+_n-1 if timeq[1] == timeq & _n~=1

drop dup temp test sum

save saved_stata_files/bsample1copynew, replace

sort timeq

do monthly_modelbsamplecopy

do Adjustmentbsamplecopy

*******************************GDP_est may need to be put back not GDP_adj
keep GDP_adj timeq timem GDP_est

drop if timeq < tq(2019q4)

sort timem
drop timeq timem
sxpose, clear force
/*
rename _var1 April
rename _var2 May
rename _var3 June
*/
rename _var1 October
rename _var2 November
rename _var3 December

destring October, replace
destring November, replace
destring December, replace
/*
destring April, replace
destring May, replace
destring June, replace
*/
save saved_stata_files/bsamplegdp, replace

clear

use saved_stata_files/bsampleappendedgdp

append using saved_stata_files/bsamplegdp, force

save saved_stata_files/bsampleappendedgdp, replace
}
