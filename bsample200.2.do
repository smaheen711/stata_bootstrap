clear all
use saved_stata_files/bsampleappendedgdp

set obs `=_N+2'
/*
sort April
replace April = April[6] if _n==201
replace April = April[195] if _n==202

sort May April
replace May = May[6] if _n==201
replace May = May[195] if _n==202

sort June April
replace June = June[6] if _n==201
replace June = June[195] if _n==202
*/
sort October October
replace October = October[6] if _n==201
replace October = October[195] if _n==202

sort November October
replace November = November[6] if _n==201
replace November = November[195] if _n==202

sort December October
replace December = December[6] if _n==201
replace December = December[195] if _n==202


drop if _n<201

save saved_stata_files/bsample201, replace

***************************************************JULY

// sort October
// *quietly by July : gen dup = cond(_N==1,0,_n)
// drop  November December
// *keep if dup==1
// *drop dup
// sxpose, clear force
// rename _var1 GDP_adj_LW
// rename _var2 GDP_adj_UP
// destring GDP_adj_LW, replace
// destring GDP_adj_UP, replace 
// di ym(2019, 10)
// di ym(2019, 12)
// set obs 3 
// gen mydate = ym(2019, 9) + _n
// format mydate %tm 
// rename mydate timem
// order timem
//
// save saved_stata_files/bsamplejuly, replace
/*
**********************************************************************************
clear all
************************************************AUGUST
use saved_stata_files/bsample201

sort May
*quietly by August : gen dup = cond(_N==1,0,_n)
drop  April June July August September
*keep if dup==1
*drop dup
sxpose, clear force
rename _var1 GDP_adj_LW
rename _var2 GDP_adj_UP
destring GDP_adj_LW, replace
destring GDP_adj_UP, replace 
di ym(2019, 5)
di ym(2019, 5)
set obs 1 
gen mydate = ym(2019, 4) + _n
format mydate %tm 
rename mydate timem
order timem

save saved_stata_files/bsampleaugust, replace
**********************************************************************************
clear all
*******************************September
use saved_stata_files/bsample201

sort June
*quietly by September : gen dup = cond(_N==1,0,_n)
drop April May July August September
*keep if dup==1 
*drop dup
sxpose, clear force
rename _var1 GDP_adj_LW
rename _var2 GDP_adj_UP
destring GDP_adj_LW, replace
destring GDP_adj_UP, replace 
di ym(2019, 6)
di ym(2019, 6)
set obs 1 
gen mydate = ym(2019, 5) + _n
format mydate %tm 
rename mydate timem
order timem

save saved_stata_files/bsampleseptember, replace
*********************************************************************************
****************************************October
*/
clear all
use saved_stata_files/bsample201
*sort July
*quietly by October : gen dup = cond(_N==1,0,_n)
*drop April May June August September
*keep if dup==1 
*drop dup
sxpose, clear force
rename _var1 GDP_adj_LW
rename _var2 GDP_adj_UP
destring GDP_adj_LW, replace
destring GDP_adj_UP, replace 
di ym(2019, 7)
di ym(2019, 7)
// set obs 1 
gen mydate = ym(2019, 6) + _n
format mydate %tm 
rename mydate timem
order timem

save saved_stata_files/bsampleoctober, replace
**********************************************************************************
**********************November

clear all
use saved_stata_files/bsample201

sort November
*quietly by November : gen dup = cond(_N==1,0,_n)
drop October December
*keep if dup==1 
*drop dup
sxpose, clear force
rename _var1 GDP_adj_LW
rename _var2 GDP_adj_UP
destring GDP_adj_LW, replace
destring GDP_adj_UP, replace 
di ym(2019, 11)
di ym(2019, 11)
set obs 1 
gen mydate = ym(2019, 10) + _n
format mydate %tm 
rename mydate timem
order timem

save saved_stata_files/bsamplenovember, replace
************************************************************************************
******************DECEMBER
clear all
use saved_stata_files/bsample201

sort December
*quietly by December : gen dup = cond(_N==1,0,_n)
drop October November
*keep if dup==1 
*drop dup
sxpose, clear force
rename _var1 GDP_adj_LW
rename _var2 GDP_adj_UP
destring GDP_adj_LW, replace
destring GDP_adj_UP, replace 
di ym(2019, 12)
di ym(2019, 12)
set obs 1 
gen mydate = ym(2019, 11) + _n
format mydate %tm 
rename mydate timem
order timem

save saved_stata_files/bsampledecember, replace
***************************************************************************************

use saved_stata_files/bsamplejuly

*merge 1:1 timem GDP_adj_LW using saved_stata_files/bsampleaugust
*drop _merge
*merge m:1 timem GDP_adj_LW using saved_stata_files/bsampleseptember
*drop _merge
merge m:1 timem GDP_adj_LW using saved_stata_files/bsampleoctober
drop _merge
merge m:1 timem GDP_adj_LW using saved_stata_files/bsamplenovember
drop _merge
merge m:1 timem GDP_adj_LW using saved_stata_files/bsampledecember
drop _merge

sort timem
drop if GDP_adj_LW ==.
rename GDP_adj_LW GDPm_adj_LW
rename GDP_adj_UP GDPm_adj_UP

save saved_stata_files/bsampleLW&UP, replace

clear all

use saved_stata_files/kansas_adjusted_bsample

merge m:1 timem using saved_stata_files/bsampleLW&UP
b
drop _merge

drop if timem >= ym(2020,1)

keep GDPq GDP_adj GDP_est timeq timem state GDPm_adj_UP GDPm_adj_LW

*rename gdp Actual
*rename GDP_adj Adjusted

*replace Actual = 172358.4  if timeq >= yq(2019,2)
replace GDPq = 135225 if timeq >= yq(2019,4) & timeq <=yq(2019,4)

twoway line GDPq GDP_adj GDPm_adj_UP GDPm_adj_LW timem if timem >=tm(2018m10) & timem <= tm(2019m12),lpattern(solid solid dash dash)

save saved_stata_files/bsampleLW&UP_final, replace






