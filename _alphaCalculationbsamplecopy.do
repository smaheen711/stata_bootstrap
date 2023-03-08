use saved_stata_files/bsample1copy, clear


*drop if timeq > tq(2019q4)

*gen Employedq = Laborq - Uq

*tsset _state timeq, quarterly

*tsfilter hp cty = GDPq			  , trend(GDPq_trend) smooth(1600)
*tsfilter hp ctus = GDPq_us	  	  , trend(GDPq_us_trend) smooth(1600)
*tsfilter hp ctl = Laborq          , trend(Laborq_trend) smooth(1000000)
*tsfilter hp cte = Employedq       , trend(Employedq_trend) smooth(1000000)
*gen u3_trend = 0.05

*generate delta y and delta u
*by _state:gen GDPq_gap = (GDPq -  GDPq_trend) /  GDPq_trend
*by _state:gen u3q_gap =  (U3q - u3_trend)
*gen lnu3 = ln(U3q)
*by _state:gen GDPq_us_gap = (GDPq_us - GDPq_us_trend) / GDPq_us_trend 


*twoway line GDPq GDPq_trend timeq if _state ==4

*drop if timeq >= yq(2019,4)

*drop if timem >= ym(2019,10)
*sort state timeq
*by state:gen trendq = _n*3

****************************************************FOR ESEI PAPER**********************************************
replace trendq = . if Uq == . 
****************************************************FOR ESEI PAPER***********************************************

// gen z = . 

/*
gen a = .
gen b = .
gen d = .
gen p = .
gen u = .
gen co = . 
gen t = . 
gen o = . 
gen n = . 
gen gd = .
gen tx = .
gen m = . 
gen q1 = .
gen op = .  
gen tt = . 
gen wp = . 
gen cb = .
gen cb1 = .
gen co1 = .

gen aa = .
gen cc = .
gen ii = .
gen kk = .
gen mm = .  
gen nn = .
gen oo = .
gen cp = .
gen rp = .
gen pp = .

*/
/*
reg GDPq_gap u3q_gap /*Wageq*/ TaxAR /*GDPq_us_gap*/ AGW BeefP OILq ChickenP RiceP trendq if _state == 1

replace a = _b[u3q_gap]			if _state == 1
*replace b = _b[Wageq]			if _state == 1
replace u = _b[TaxAR]			if _state == 1
*replace gd = _b[GDPq_us_gap]	if _state == 1
replace t = _b[AGW]      		if _state == 1
replace aa = _b[_cons] 			if _state == 1
replace m  = _b[BeefP]    		if _state == 1
replace op = _b[OILq]    		if _state == 1
replace cp = _b[ChickenP]   	if _state == 1
replace rp = _b[RiceP]    		if _state == 1
replace tt = _b[trendq]  		if _state == 1
/*
*bootstrap Ricep=r(RiceP): mean RiceP

*gen temp = ((((a*u3q_gap)+(b*Wageq)+(u*TaxAR)+(gd*GDPq_us_gap)+(t*AGW)+(m*BeefP)+(op*OILq)+(cp*ChickenP)+(rp*RiceP)+(tt*trend) +aa))) if _state ==2
*twoway line temp GDPq_gap timeq if _state == 1

reg GDPq_gap u3q_gap /*Wageq GDPq_us_gap AGW*/ BeefP OILq ChickenP RiceP TaxCO CanbP WheatP trendq TaxCO1 CanbP1 if _state == 2 /*& timeq >= tq(2014q1)*/

replace a = _b[u3q_gap]			if _state == 2
*replace b = _b[Wageq]			if _state == 2
*replace gd = _b[GDPq_us_gap]    if _state == 2
*replace t = _b[AGW]      		if _state == 2
replace cc = _b[_cons] 			if _state == 2
replace m  = _b[BeefP]    		if _state == 2
replace op = _b[OILq]    		if _state == 2
replace cp = _b[ChickenP]   	if _state == 2
replace rp = _b[RiceP]    		if _state == 2
replace co = _b[TaxCO]			if _state == 2
replace cb = _b[CanbP]  		if _state == 2
replace wp = _b[WheatP] 		if _state == 2
replace tt = _b[trendq]  		if _state == 2
replace co1 = _b[TaxCO1]  		if _state == 2
replace cb1 = _b[CanbP1]  		if _state == 2


reg GDPq_gap u3q_gap /*Wageq*/ TaxIA /*GDPq_us_gap AGW*/ CornP BeefP /*OILq*/ ChickenP RiceP WheatP PorkP trendq if _state == 3

replace a = _b[u3q_gap]			if _state == 3
*replace b = _b[Wageq]			if _state == 3
replace o = _b[TaxIA]			if _state == 3
*replace gd = _b[GDPq_us_gap]   	if _state == 3 
*replace t = _b[AGW]      		if _state == 3
replace z = _b[CornP]       	if _state == 3
replace ii = _b[_cons] 			if _state == 3
replace m  = _b[BeefP]    		if _state == 3
*replace op = _b[OILq]    		if _state == 3
replace cp = _b[ChickenP]   	if _state == 3
replace rp = _b[RiceP]    		if _state == 3
replace wp = _b[WheatP] 		if _state == 3
replace pp = _b[PorkP]			if _state == 3
replace tt = _b[trendq]  		if _state == 3



*/
*/
// sum GDPq_gap GDPq_us_gap timeq if _state ==4 & GDPq_gap ~=.


sum GDPq_gap u3q_gap GDPq_us_gap Wageq TaxKS BeefP trendq CornP WheatP OILq if _state == 4 & GDPq_gap ~= .

reg GDPq_gap u3q_gap GDPq_us_gap Wageq TaxKS BeefP trendq CornP WheatP OILq if _state == 4

replace a  = _b[u3q_gap] 		if _state == 4
replace b  = _b[Wageq]	 		if _state == 4
replace gd = _b[GDPq_us_gap]   	if _state == 4
replace tx = _b[TaxKS]  		if _state == 4
replace m  = _b[BeefP]    		if _state == 4
replace z  = _b[CornP]   		if _state == 4
replace op = _b[OILq]    		if _state == 4
replace tt = _b[trendq]  		if _state == 4
replace wp = _b[WheatP] 		if _state == 4
replace kk = _b[_cons] 			if _state == 4

/*
reg GDPq_gap u3q_gap /*Wageq*/ TaxMO /*GDPq_us_gap*/ AGW ChickenP RiceP WheatP PorkP OILq trendq BeefP CornP if _state == 5

replace a = _b[u3q_gap]			if _state == 5
*replace b = _b[Wageq]		    if _state == 5
replace p = _b[TaxMO]			if _state == 5
*replace gd = _b[GDPq_us_gap]    if _state == 5
replace t = _b[AGW]      		if _state == 5
replace mm = _b[_cons] 			if _state == 5
replace cp = _b[ChickenP]   	if _state == 5
replace rp = _b[RiceP]    		if _state == 5
replace wp = _b[WheatP] 		if _state == 5
replace pp = _b[PorkP]			if _state == 5
replace op = _b[OILq]    		if _state == 5
replace tt = _b[trendq]  		if _state == 5
replace m  = _b[BeefP]    		if _state == 5
replace z  = _b[CornP]   		if _state == 5


reg GDPq_gap u3q_gap Wageq TaxNE GDPq_us_gap /*AGW*/ CornP /*ChickenP RiceP WheatP*/ PorkP OILq trendq /*BeefP*/ if _state == 6
replace a = _b[u3q_gap] 		if _state == 6
replace b = _b[Wageq]	 		if _state == 6
replace n = _b[TaxNE]			if _state == 6
replace gd = _b[GDPq_us_gap]   	if _state == 6
*replace t = _b[AGW]      		if _state == 6
replace z = _b[CornP]       	if _state == 6
replace nn = _b[_cons] 	  		if _state == 6
*replace cp = _b[ChickenP]   	if _state == 6
*replace rp = _b[RiceP]    		if _state == 6
*replace wp = _b[WheatP] 		if _state == 6
replace pp = _b[PorkP]			if _state == 6
replace op = _b[OILq]    		if _state == 6
replace tt = _b[trendq]  		if _state == 6
*replace m  = _b[BeefP]    		if _state == 6


*list GDPq_gap u3q_gap Wageq GDPq_us_gap AGW OILq CornP /*ChickenP*/ RiceP WheatP PorkP trend BeefP  if _state == 7
reg GDPq_gap u3q_gap Wageq GDPq_us_gap AGW OILq CornP /*ChickenP*/ RiceP WheatP PorkP trendq BeefP  if _state == 7
replace a = _b[u3q_gap]			if _state == 7
replace b = _b[Wageq]	 		if _state == 7
*replace d = _b[CEq]	 		if _state == 7
replace gd = _b[GDPq_us_gap]    if _state == 7
replace t = _b[AGW]				if _state == 7
replace op = _b[OILq]    		if _state == 7
replace oo = _b[_cons]   		if _state == 7
replace z = _b[CornP]       	if _state == 7
*replace cp = _b[ChickenP]   	if _state == 7
replace rp = _b[RiceP]    		if _state == 7
replace wp = _b[WheatP] 		if _state == 7
replace pp = _b[PorkP]			if _state == 7
replace op = _b[OILq]    		if _state == 7
replace tt = _b[trendq]  		if _state == 7
replace m  = _b[BeefP]    		if _state == 7


drop if state ==""
*/
*keep timeq trendq u3q_gap GDPq GDPq_us_gap GDPq_us_trend a b /*d p u t o z n*/ gd tx m /*q1*/ op tt wp /*aa cc ii*/ kk /*mm nn oo co /*cb*/ cp rp pp*/ state timeq GDPq_trend
*******KS
keep a b gd tx m z op tt wp kk timeq state _state trendq


*********************************************************
***************AR
*keep a u t aa m op cp rp tt timeq state _state trendq 
***************************************************************
***********CO
*keep a m op cp rp cb wp cb1 co1 tt cc co timeq state _state trendq
**************************************************************
************IA
*keep a o z ii m cp rp wp pp tt timeq state _state trendq
*******************************************************************
*********MO
*keep a b p t mm cp rp wp pp op tt m z timeq state _state trendq
********************************************************************
***********NE
*keep a n op b gd t z nn pp tt timeq state _state trendq
***********************************************************************
***********OK
*keep a b gd t op oo z rp wp pp op tt m timeq state _state trendq
***************************************************************************
save saved_stata_files/alpha_estimate_b_sample_copy, replace

