use consolidated/monthly_data, clear nolabel

*observe quarters
*drop netax /*artax*/ iatax motax cotax cannabisprice cannabisprice1 cotax1

order  timeq timem 

*merge m:1 timeq state using saved_stata_files/bsample1copynew, nolabel
merge m:1 timeq state using consolidated/quarterly_nominalgdp_data, nolabel
drop _merge

*keep if state =="arkansas"
drop if state ~="kansas"
*drop if state ~="colorado"
*drop if state ~="iowa"
*drop if state ~="missouri"
*drop if state ~="nebraska"
*drop if state ~="oklahoma"
*drop if timem >= ym(2020,1)

*******************************FOR ESEI PAPER****************************

*replace GDPm_us =. if timeq >= yq(2020,1)
drop if GDPm_us ==.
*/

*******************************FOR ESEI PAPER****************************
tsset _state timem, monthly
tsfilter hp ctus = GDPq		  , trend (GDPm_trend) smooth(1600)
tsfilter hp us = GDPm_us		, trend (GDPm_us_trend) smooth(1600)
by _state:gen GDPm_us_gap = (GDPm_us - GDPm_us_trend) / GDPm_us_trend

sum GDPm_trend if _state ==4

by _state:gen GDPq_gap = (GDPq - GDPm_trend) / GDPm_trend

sort state timem 
gen trendm = 2	if timem ==tm(2005m1)		
replace trendm=trendm[_n-1]+1 if trendm==.
drop if state == ""


******************************************************************************************
merge m:m timeq state using saved_stata_files/bsample1copynew, nolabel

drop if state ~= "kansas"
drop  _state
egen _state = group(state)
sort _state timem
drop if state == ""

quietly by _state timem: gen dup = cond(_N==1,0,_n)
drop if dup >1

tsset _state timem, monthly
*drop u3_trend l_trend cte e_trend ctl y
gen workers = laborforce - unemployment
tsfilter hp cte = workers			, trend(e_trend) smooth(1000000)
tsfilter hp ctl = laborforce		, trend(l_trend) smooth(1000000)
gen u3_trend = 0.05
by _state:gen u3_gap = (u3 - u3_trend)

*tsfilter hp cty = GDPm_us , trend(GDPm_us_trend) smooth(1600)
*twoway line GDPm_trend GDPm_us timem if _state == 4

replace GDPm_trend=GDPm_trend[_n-1] if GDPm_trend==.

sort _state timem 

**********************************************************************************************************************
*Calculating GDP_estimate for each state
gen GDP_est = . 

*ARKANSAS*
*u3q_gap Wageq TaxAR GDPq_us_gap AGW BeefP OILq ChickenP RiceP trend
*gen GDP_est_gap =((a*u3_gap)+(b*wages)+(u*artax)+(gd*GDPm_us_gap)+(t*AGW)+(m*beefprice)+(op*oilprice)+(cp*chickenprice)+(rp*riceprice)+(tt*trend) +aa) if _state ==1
*replace GDP_est = ((((a*u3_gap)+/*(b*wages)+*/(u*artax)+/*(gd*GDPm_us_gap)+*/(t*AGW)+(m*beefprice)+(op*oilprice)+(cp*chickenprice)+(rp*riceprice)+(tt*trendm) +aa) * GDPm_trend) + GDPm_trend) if _state ==1
*twoway line GDPq GDP_est GDPm_trend timem if _state == 1

/*
*************for ESEI PAPER********************************

*drop if timem > ym(2019,12)
egen ARavg     = mean(GDPq)         if _state == 1

gen  ARxf      = (GDP_est - ARavg)^2

egen ARxfsum   = sum(ARxf) 			if _state ==1

gen  ARxf2     = (GDPq - ARavg)^2   

egen ARxfsum2   = sum(ARxf2) 		if _state ==1


gen  ARxffinal = ARxfsum/ARxfsum2



*************for ESEI PAPER***********************************

*COLORADO*
*u3q_gap Wageq GDPq_us_gap /*AGW*/ BeefP OILq ChickenP RiceP TaxCO CanbP WheatP trend 
replace GDP_est = ((((a*u3_gap)+/*(b*wages)+(gd*GDPm_us_gap)+*/(m*beefprice)+(op*oilprice)+(cp*chickenprice)+(rp*riceprice)+(co*cotax)+(cb*cannabisprice)+(wp*wheatprice)+(cb1*cannabisprice1)+(co1*cotax1)+(tt*trendm)+ cc) * GDPm_trend) + GDPm_trend) if _state ==1
*gen GDP_est_gap = ((a*u3_gap)+(b*wages)+(gd*GDPm_us_gap)+(m*beefprice)+(op*oilprice)+(cp*chickenprice)+(rp*riceprice)+(co*cotax)+/*(cb*cannabisprice)+*/(wp*wheatprice)+(tt*trendm)+ cc) if _state ==2
*twoway line GDPq_us GDPm_us timem if _state == 2
*twoway line GDPq GDP_est GDPm_trend timem if _state == 2
*twoway line GDPq_us_trend GDPm_us_trend timem if _state == 2
*************for ESEI PAPER********************************


egen COavg     = mean(GDPq)         if _state == 2

gen  COxf      = (GDP_est - COavg)^2

egen COxfsum   = sum(COxf) 			if _state ==2

gen  COxf2     = (GDPq - COavg)^2   

egen COxfsum2   = sum(COxf2) 		if _state ==2


gen  COxffinal = COxfsum/COxfsum2



*************for ESEI PAPER***********************************

*IOWA*
*u3q_gap /*Wageq*/ TaxIA GDPm_us_gap /*AGW*/ CornP BeefP /*OILq*/ ChickenP RiceP WheatP PorkP trend
replace GDP_est = ((((a*u3_gap)+(o*iatax)/*+(gd*GDPm_us_gap)*/+(z*cornprice)+ (m*beefprice)+(cp*chickenprice)+(rp*riceprice)+(wp*wheatprice)+(pp*porkprice)+(tt*trendm)+ ii) * GDPm_trend) + GDPm_trend) if _state == 3*twoway line GDPq GDP_est GDPm_trend timem if _state == 1
*************for ESEI PAPER********************************


egen IAavg     = mean(GDPq)         if _state == 3

gen  IAxf      = (GDP_est - IAavg)^2

egen IAxfsum   = sum(IAxf) 			if _state ==3

gen  IAxf2     = (GDPq - IAavg)^2   

egen IAxfsum2   = sum(IAxf2) 		if _state ==3


gen  IAxffinal = IAxfsum/IAxfsum2



*************for ESEI PAPER***********************************


*KANSAS*
*/
*u3q_gap GDPq_us_gap Wageq TaxKS BeefP trend CornP WheatP OILq
replace GDP_est = ((((a*u3_gap)+/*(gd*GDPm_us_gap)+(b*wages)+*/(tx*kstax)+(m*beefprice)+(z*cornprice)+(op*oilprice)+(wp*wheatprice)+(tt*trendm)+kk)* GDPm_trend)+ GDPm_trend) if _state == 1
order GDP_est timeq timem
order timeq timem GDP_est


*twoway line GDPq GDP_est timem if _state == 4
/*
**** Need to add GDPm_trend back to the twoway line/ took it out to run ESEI paper 10/30/2020******
*************for ESEI PAPER********************************


egen KSavg     = mean(GDPq)         if _state == 4

gen  KSxf      = (GDP_est - KSavg)^2

egen KSxfsum   = sum(KSxf) 			if _state ==4

gen  KSxf2     = (GDPq - KSavg)^2   

egen KSxfsum2   = sum(KSxf2) 		if _state ==4


gen  KSxffinal = KSxfsum/KSxfsum2



*************for ESEI PAPER***********************************
*MISSOURI*
*u3q_gap Wageq TaxMO GDPq_us_gap AGW ChickenP RiceP WheatP PorkP OILq trend
replace GDP_est = ((((a*u3_gap)+(b*wages)+(p*motax)+(gd*GDPm_us_gap)+(t*AgWages)+(cp*chickenprice)+(rp*riceprice)+(wp*wheatprice)+(pp*porkprice)+(op*oilprice)+(tt*trendm)+ mm) * GDPm_trend) + GDPm_trend ) if _state == 5
twoway line GDPq GDP_est GDPm_trend timem if _state == 5
 *************for ESEI PAPER********************************

egen MOavg     = mean(GDPq)         if _state == 5

gen  MOxf      = (GDP_est - MOavg)^2

egen MOxfsum   = sum(MOxf) 			if _state ==5

gen  MOxf2     = (GDPq - MOavg)^2   

egen MOxfsum2   = sum(MOxf2) 		if _state ==5


gen  MOxffinal = MOxfsum/MOxfsum2



*************for ESEI PAPER***********************************

*NEBRASKA*
*u3q_gap Wageq /*TaxNE*/ GDPq_us_gap AGW CornP /*ChickenP RiceP WheatP*/ PorkP /*OILq*/ trend /*BeefP*/
replace GDP_est = ((((a*u3_gap)+(b*wages)+(n*netax)+(gd*GDPm_us_gap)+/*(t*AgWages)+*/(op*oilprice)+/*(m*beefprice)+*/(z*cornprice)+(pp*porkprice)+(tt*trendm)+ nn) * GDPm_trend) + GDPm_trend) if _state == 1
*twoway line GDPq GDP_est GDPm_trend timem if _state == 6
*************for ESEI PAPER********************************

egen NEavg     = mean(GDPq)         if _state == 6

gen  NExf      = (GDP_est - NEavg)^2

egen NExfsum   = sum(NExf) 			if _state ==6

gen  NExf2     = (GDPq - NEavg)^2   

egen NExfsum2   = sum(NExf2) 		if _state ==6


gen  NExffinal = NExfsum/NExfsum2



*************for ESEI PAPER***********************************

*OKLAHOMA*
*u3q_gap Wageq GDPq_us_gap AGW OILq CornP /*ChickenP*/ RiceP WheatP PorkP trend BeefP

replace GDP_est = ((((a*u3_gap)+(b*wages)+(gd*GDPm_us_gap)+(t*AgWages)+(op*oilprice)+(z*cornprice)+(rp*riceprice)+(wp*wheatprice)+(pp*porkprice)+(m*beefprice)+(tt*trendm)+oo) * GDPm_trend) + GDPm_trend) if _state == 1
*gen temp        = /*(a*u3_gap)+*/(b*wages)/*+(gd*GDPm_us_gap)+(t*AgWages)+(op*oilprice)+(z*cornprice)+(rp*riceprice)+(wp*wheatprice)+(tt*trend)+oo*/ if _state == 7
*twoway line GDPq GDP_est GDPm_trend timem if _state == 7
*twoway line GDPq GDP_est GDPm_trend timem if _state == 7
*************for ESEI PAPER********************************
/*

egen OKavg     = mean(GDPq)         if _state == 7

gen  OKxf      = (GDP_est - OKavg)^2

egen OKxfsum   = sum(OKxf) 			if _state ==7

gen  OKxf2     = (GDPq - OKavg)^2   

egen OKxfsum2   = sum(OKxf2) 		if _state ==7


gen  OKxffinal = OKxfsum/OKxfsum2


*/

*************for ESEI PAPER***********************************

******************************************************************************************************************************

by _state:gen dgdp = (GDP - l3.GDP) / l3.GDP
by _state:gen dy = d.y / l.y

order timeq timem state GDPm_us GDP_est /*dgdp dy*/

export excel timem wages u3 u3_trend GDPm_trend using outputs/kansasinputs.xlsx 	if state == "kansas"   & timeq >= tq(2016q1), replace firstrow(variables)

export excel timem GDPq GDP_est using outputs/arkansas.xlsx 						if state == "arkansas" & timeq >= tq(2014q1), replace firstrow(variables) 
export excel timem GDPq GDP_est using outputs/colorado.xlsx 						if state == "colorado" & timeq >= tq(2014q1), replace firstrow(variables) 
export excel timem GDPq GDP_est using outputs/iowa.xlsx 							if state == "iowa" 	   & timeq >= tq(2014q1), replace firstrow(variables) 
export excel timem GDPq GDP_est using outputs/kansas.xlsx 							if state == "kansas"   						, replace firstrow(variables) 
export excel timem GDPq GDP_est using outputs/missouri.xlsx 						if state == "missouri" & timeq >= tq(2014q1), replace firstrow(variables) 
export excel timem GDPq GDP_est using outputs/nebraska.xlsx 						if state == "nebraska" & timeq >= tq(2014q1), replace firstrow(variables) 
export excel timem GDPq GDP_est using outputs/oklahoma.xlsx 						if state == "oklahoma" & timeq >= tq(2014q1), replace firstrow(variables)

export excel timem /*dgdp dy*/ using outputs/arkansas_growth.xlsx 					if state == "arkansas" & timeq >= tq(2016q1), replace firstrow(variables) 
export excel timem /*dgdp dy*/ using outputs/colorado_growth.xlsx 					if state == "colorado" & timeq >= tq(2016q1), replace firstrow(variables) 
export excel timem /*dgdp dy*/ using outputs/iowa_growth.xlsx 						if state == "iowa" 	   & timeq >= tq(2016q1), replace firstrow(variables) 
export excel timem /*dgdp dy*/ using outputs/kansas_growth.xlsx 					if state == "kansas"   & timeq >= tq(2016q1), replace firstrow(variables) 
export excel timem /*dgdp dy*/ using outputs/missouri_growth.xlsx 					if state == "missouri" & timeq >= tq(2016q1), replace firstrow(variables) 
export excel timem /*dgdp dy*/ using outputs/nebraska_growth.xlsx 					if state == "nebraska" & timeq >= tq(2016q1), replace firstrow(variables) 
export excel timem /*dgdp dy*/ using outputs/oklahoma_growth.xlsx 					if state == "oklahoma" & timeq >= tq(2016q1), replace firstrow(variables)
*/
*/
order timeq timem state GDPq GDP_est 

*drop if GDP_est == .
*drop if GDPq == .

*drop if state ==""

*rename GDPq gdp
*gen y = GDP_est

*rename GDP gdp
sort timeq
save saved_stata_files/monthly_model_preadjusted_b_samplecopy, replace
*outfile using output/monthly_gdp.csv, comma wide missing replace

*export excel timem u3q_gap Wageq GDPq_us TaxKS AGW CornP BeefP OILq WheatP GDP_est a b gd tx t z op wp m using outputs/kansas1.xlsx  								 	 if state == "kansas"   & timeq >= tq(2016q1), replace firstrow(variables)
*export excel timem u3_gap wages GDPm_us_gap kstax AgWages cornprice GDP_est beefprice oilprice wheatprice a b gd tx t z op wp m using outputs/kansas.xlsx 			 	 if state == "kansas"   & timeq >= tq(2016q1), replace firstrow(variables)
*export excel timem u3_gap wages kstax beefprice cornprice oilprice GDPm_trend wheatprice GDPm_us_gap kk a gd b tx m z q1 op tt wp GDP_est using outputs/newkansas.xlsx   if state == "kansas" 	& timeq >= tq(2016q1), replace firstrow(variables)
*export excel timem u3_gap artax a gd u GDP_est GDPq GDPm_us using outputs/newAR.xlsx   if state == "arkansas" 	& timeq >= tq(2016q1), replace firstrow(variables)
*((((a*u3_gap)+(gd*GDPm_us_gap)+(b*wages)+(tx*kstax)+(m*beefprice)+(z*cornprice)+(op*oilprice)+(wp*wheatprice)+kk)* GDPm_trend)+ GDPm_trend) if _state == 4
*delta_um wages kstax beefprice cornprice delta_us_m oilprice trendm wheatprice
