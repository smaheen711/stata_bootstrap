use saved_stata_files/monthly_model_preadjusted_b_samplecopy, clear

*create local variable name
gen gdp = GDPq
gen y = GDP_est


keep timeq timem state gdp GDPq y GDP_est u3 netax GDPm_us/*date*/

gen _state = 4
*tsset _state timem

sort _state timem
gen month = string(timem, "%tm")

// drop if _state !=4

*create local variable names
*drop if y == .

order timeq timem month

*define delta and gamma
by _state: gen gamma = (f2.y / f.y) / (f.y / y) if gdp == f.gdp & gdp == f2.gdp 


by _state: gen delta = (f.y / y) / (y / l.y )	if gdp == f.gdp & gdp == f2.gdp

*populate missing delta and gamma
by _state:replace gamma = l2.gamma if strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0  
by _state:replace gamma = l.gamma  if strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
by _state:replace delta = l2.delta if strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0  
by _state:replace delta = l.delta  if strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
*define delta gamma

gen dg = delta * gamma
*define delta gamma squared
gen dgg = delta * gamma * gamma
*define gamma delta squared
gen ddg = delta * delta * gamma

gen constant = (3 * gdp - (y+f.y+f2.y)) / 3 if _n == 1
replace constant = (3 * gdp - (y+l.y+f.y)) / 3 if _n == 2
replace constant = (3 * gdp - (y+l.y+l2.y)) / 3 if _n == 3

gen yi = y + constant if _n < 4 
gen byte month1 =  strpos(month, "m11") == 0 & strpos(month, "m12") == 0 & strpos(month, "m1") != 0 | strpos(month, "m4") != 0 | strpos(month, "m7") != 0 | strpos(month, "m10") != 0
gen byte month2 =  strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
gen byte month3 =  strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0
gen i = 1

egen j = count(y)
replace j = j /3

gen a = .
gen b = .
gen c = .
gen d = .

gen f = .
gen g = .
gen h = .
gen R = .
gen S = .
gen T = .
gen absT = .
gen U = .
gen X1 = .
gen yq = .
while i < j {

replace a = (ddg)/l.yi^2	if month1
replace b = delta/l.yi		if month1
replace c = 1				if month1
replace d = -(3*gdp)		if month1


replace f = [(3*c/a) - (b^2/a^2)]/3
replace g = [(2*b^3/a^3) - (9*b*c/a^2) + (27*d/a)] / 27
replace h = g^2/4 + f^3/27
replace R = -(g/2)+h^.5
replace S = R ^(1/3)
replace T = -(g/2)-h^.5
replace absT = abs(T)
replace U = absT ^ (1/3)
replace U = -U
replace X1 = (S+U) - (b/(3*a))
replace yi = X1									if month1 & yi == .
replace yi = delta *((l.yi*l.yi)/l2.yi)			if month2 & yi == .
replace yi = gamma * ((l.yi*l.yi)/l2.yi)		if month3 & yi == .

replace yq = round((yi + f.yi + f2.yi) / 3) if month1
replace i = i + 1
}
gen dy = d.y/l.y

replace yi = l.yi * dy + l.yi if yi == .

order timeq timem state gdp yq y yi 

rename yi GDP_adj
rename yq GDPq_est


*drop y gdp
*twoway line gdp GDP_est GDP_adj timem if timem > tm(2018m12)


********** ESEI paper********************************************************************************************


*rename GDPq Actual
*rename GDP_adj Adjusted
/*
twoway line Actual Adjusted timem  if timem >=tm(2019m1) & timem <= tm(2019m12), xline(2014.7867)

twoway line Actual Adjusted timem  if timem >=tm(2019m1) & timem <= tm(2019m12), xline(2017.7867)

twoway line GDPq GDP_adj timem if timem >=tm(2019m1) & timem <= tm(2019m12)
*/
*********ESEI paper**************************************************************************************

*twoway line GDPq GDP_est GDP_adj timem 

save saved_stata_files/kansas_adjusted_bsample, replace

*export excel timem gd GDP_adj using outputs/kansas12.xlsx  if state == "kansas"   & timeq >= tq(2016q1), replace firstrow(variables)

***************************************************
*use saved_stata_files/monthly_model_preadjusted, clear
/*
*create local variable name
gen gdp = GDPq
gen y = GDP_est

keep timeq timem state _state gdp GDPq y GDP_est u3 artax GDPm_us/*date*/
tsset _state timem

sort _state timem
gen month = string(timem, "%tm")
drop if _state !=1

drop if y == .

order timeq timem month
*define delta and gamma
by _state: gen gamma = (f2.y / f.y) / (f.y / y) if gdp == f.gdp & gdp == f2.gdp 
by _state: gen delta = (f.y / y) / (y / l.y )	if gdp == f.gdp & gdp == f2.gdp
*populate missing delta and gamma
by _state:replace gamma = l2.gamma if strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0  
by _state:replace gamma = l.gamma  if strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
by _state:replace delta = l2.delta if strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0  
by _state:replace delta = l.delta  if strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
*define delta gamma
gen dg = delta * gamma
*define delta gamma squared
gen dgg = delta * gamma * gamma
*define gamma delta squared
gen ddg = delta * delta * gamma


gen constant = (3 * gdp - (y+f.y+f2.y)) / 3 if _n == 1
replace constant = (3 * gdp - (y+l.y+f.y)) / 3 if _n == 2
replace constant = (3 * gdp - (y+l.y+l2.y)) / 3 if _n == 3

gen yi = y + constant if _n < 4 
gen byte month1 =  strpos(month, "m11") == 0 & strpos(month, "m12") == 0 & strpos(month, "m1") != 0 | strpos(month, "m4") != 0 | strpos(month, "m7") != 0 | strpos(month, "m10") != 0
gen byte month2 =  strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
gen byte month3 =  strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0
gen i = 1
egen j = count(y)
replace j = j /3

gen a = .
gen b = .
gen c = .
gen d = .

gen f = .
gen g = .
gen h = .
gen R = .
gen S = .
gen T = .
gen absT = .
gen U = .
gen X1 = .
gen yq = .
while i < j {

replace a = (ddg)/l.yi^2	if month1
replace b = delta/l.yi		if month1
replace c = 1				if month1
replace d = -(3*gdp)		if month1


replace f = [(3*c/a) - (b^2/a^2)]/3
replace g = [(2*b^3/a^3) - (9*b*c/a^2) + (27*d/a)] / 27
replace h = g^2/4 + f^3/27

replace R = -(g/2)+h^.5
replace S = R ^(1/3)
replace T = -(g/2)-h^.5
replace absT = abs(T)
replace U = absT ^ (1/3)
replace U = -U
replace X1 = (S+U) - (b/(3*a))
replace yi = X1									if month1 & yi == .
replace yi = delta *((l.yi*l.yi)/l2.yi)			if month2 & yi == .
replace yi = gamma * ((l.yi*l.yi)/l2.yi)		if month3 & yi == .

replace yq = round((yi + f.yi + f2.yi) / 3) if month1
replace i = i + 1
}
gen dy = d.y/l.y

replace yi = l.yi * dy + l.yi if yi == .

order timeq timem state gdp yq y yi 

rename yi GDP_adj
rename yq GDPq_est

twoway line GDPq GDP_est GDP_adj timem if timem >= tm(2011m1)


save saved_stata_files/arkansas_adjusted, replace

********************************************************************************
use saved_stata_files/monthly_model_preadjusted, clear
*create local variable name
gen gdp = GDPq
gen y = GDP_est


keep timeq timem state _state gdp GDPq y GDP_est u3 cotax /*cannabis*/ GDPm_us/*date*/
tsset _state timem

sort _state timem
gen month = string(timem, "%tm")
drop if _state !=2

drop if y == .

order timeq timem month
*define delta and gamma
by _state: gen gamma = (f2.y / f.y) / (f.y / y) if gdp == f.gdp & gdp == f2.gdp 
by _state: gen delta = (f.y / y) / (y / l.y )	if gdp == f.gdp & gdp == f2.gdp
*populate missing delta and gamma
by _state:replace gamma = l2.gamma if strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0  
by _state:replace gamma = l.gamma  if strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
by _state:replace delta = l2.delta if strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0  
by _state:replace delta = l.delta  if strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
*define delta gamma
gen dg = delta * gamma
*define delta gamma squared
gen dgg = delta * gamma * gamma
*define gamma delta squared
gen ddg = delta * delta * gamma


gen constant = (3 * gdp - (y+f.y+f2.y)) / 3 if _n == 1
replace constant = (3 * gdp - (y+l.y+f.y)) / 3 if _n == 2
replace constant = (3 * gdp - (y+l.y+l2.y)) / 3 if _n == 3

gen yi = y + constant if _n < 4 
gen byte month1 =  strpos(month, "m11") == 0 & strpos(month, "m12") == 0 & strpos(month, "m1") != 0 | strpos(month, "m4") != 0 | strpos(month, "m7") != 0 | strpos(month, "m10") != 0
gen byte month2 =  strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
gen byte month3 =  strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0
gen i = 1
egen j = count(y)
replace j = j /3

gen a = .
gen b = .
gen c = .
gen d = .

gen f = .
gen g = .
gen h = .
gen R = .
gen S = .
gen T = .
gen absT = .
gen U = .
gen X1 = .
gen yq = .
while i < j {

replace a = (ddg)/l.yi^2	if month1
replace b = delta/l.yi		if month1
replace c = 1				if month1
replace d = -(3*gdp)		if month1


replace f = [(3*c/a) - (b^2/a^2)]/3
replace g = [(2*b^3/a^3) - (9*b*c/a^2) + (27*d/a)] / 27
replace h = g^2/4 + f^3/27

replace R = -(g/2)+h^.5
replace S = R ^(1/3)
replace T = -(g/2)-h^.5
replace absT = abs(T)
replace U = absT ^ (1/3)
replace U = -U
replace X1 = (S+U) - (b/(3*a))
replace yi = X1									if month1 & yi == .
replace yi = delta *((l.yi*l.yi)/l2.yi)			if month2 & yi == .
replace yi = gamma * ((l.yi*l.yi)/l2.yi)		if month3 & yi == .

replace yq = round((yi + f.yi + f2.yi) / 3) if month1
replace i = i + 1
}
gen dy = d.y/l.y

replace yi = l.yi * dy + l.yi if yi == .

order timeq timem state gdp yq y yi 

rename yi GDP_adj
rename yq GDPq_est 
twoway line GDPq GDP_est GDP_adj timem if timem >= tm(2011m1)


save saved_stata_files/colorado_adjusted, replace


*****************************************************************************
use saved_stata_files/monthly_model_preadjusted, clear

*create local variable name
gen gdp = GDPq
gen y = GDP_est



keep timeq timem state _state gdp GDPq y GDP_est u3 iatax GDPm_us /*date*/
tsset _state timem

sort _state timem
gen month = string(timem, "%tm")
drop if _state !=3

drop if y == .

order timeq timem month
*define delta and gamma
by _state: gen gamma = (f2.y / f.y) / (f.y / y) if gdp == f.gdp & gdp == f2.gdp 
by _state: gen delta = (f.y / y) / (y / l.y )	if gdp == f.gdp & gdp == f2.gdp
*populate missing delta and gamma
by _state:replace gamma = l2.gamma if strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0  
by _state:replace gamma = l.gamma  if strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
by _state:replace delta = l2.delta if strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0  
by _state:replace delta = l.delta  if strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
*define delta gamma
gen dg = delta * gamma
*define delta gamma squared
gen dgg = delta * gamma * gamma
*define gamma delta squared
gen ddg = delta * delta * gamma


gen constant = (3 * gdp - (y+f.y+f2.y)) / 3 if _n == 1
replace constant = (3 * gdp - (y+l.y+f.y)) / 3 if _n == 2
replace constant = (3 * gdp - (y+l.y+l2.y)) / 3 if _n == 3

gen yi = y + constant if _n < 4 
gen byte month1 =  strpos(month, "m11") == 0 & strpos(month, "m12") == 0 & strpos(month, "m1") != 0 | strpos(month, "m4") != 0 | strpos(month, "m7") != 0 | strpos(month, "m10") != 0
gen byte month2 =  strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
gen byte month3 =  strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0
gen i = 1
egen j = count(y)
replace j = j /3

gen a = .
gen b = .
gen c = .
gen d = .

gen f = .
gen g = .
gen h = .
gen R = .
gen S = .
gen T = .
gen absT = .
gen U = .
gen X1 = .
gen yq = .
while i < j {

replace a = (ddg)/l.yi^2	if month1
replace b = delta/l.yi		if month1
replace c = 1				if month1
replace d = -(3*gdp)		if month1


replace f = [(3*c/a) - (b^2/a^2)]/3
replace g = [(2*b^3/a^3) - (9*b*c/a^2) + (27*d/a)] / 27
replace h = g^2/4 + f^3/27

replace R = -(g/2)+h^.5
replace S = R ^(1/3)
replace T = -(g/2)-h^.5
replace absT = abs(T)
replace U = absT ^ (1/3)
replace U = -U
replace X1 = (S+U) - (b/(3*a))
replace yi = X1									if month1 & yi == .
replace yi = delta *((l.yi*l.yi)/l2.yi)			if month2 & yi == .
replace yi = gamma * ((l.yi*l.yi)/l2.yi)		if month3 & yi == .

replace yq = round((yi + f.yi + f2.yi) / 3) if month1
replace i = i + 1
}
gen dy = d.y/l.y

replace yi = l.yi * dy + l.yi if yi == .

order timeq timem state gdp yq y yi 

rename yi GDP_adj
rename yq GDPq_est

twoway line GDPq GDP_est GDP_adj timem if timem >= tm(2011m1)

save saved_stata_files/iowa_adjusted, replace

********************************************************************************
use saved_stata_files/monthly_model_preadjusted, clear

*create local variable name
gen gdp = GDPq
gen y = GDP_est

keep timeq timem state _state gdp GDPq y GDP_est u3 motax GDPm_us /*date*/
tsset _state timem

sort _state timem
gen month = string(timem, "%tm")
drop if _state !=5

drop if y == .

order timeq timem month
*define delta and gamma
by _state: gen gamma = (f2.y / f.y) / (f.y / y) if gdp == f.gdp & gdp == f2.gdp 
by _state: gen delta = (f.y / y) / (y / l.y )	if gdp == f.gdp & gdp == f2.gdp
*populate missing delta and gamma
by _state:replace gamma = l2.gamma if strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0  
by _state:replace gamma = l.gamma  if strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
by _state:replace delta = l2.delta if strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0  
by _state:replace delta = l.delta  if strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
*define delta gamma
gen dg = delta * gamma
*define delta gamma squared
gen dgg = delta * gamma * gamma
*define gamma delta squared
gen ddg = delta * delta * gamma


gen constant = (3 * gdp - (y+f.y+f2.y)) / 3 if _n == 1
replace constant = (3 * gdp - (y+l.y+f.y)) / 3 if _n == 2
replace constant = (3 * gdp - (y+l.y+l2.y)) / 3 if _n == 3

gen yi = y + constant if _n < 4 
gen byte month1 =  strpos(month, "m11") == 0 & strpos(month, "m12") == 0 & strpos(month, "m1") != 0 | strpos(month, "m4") != 0 | strpos(month, "m7") != 0 | strpos(month, "m10") != 0
gen byte month2 =  strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
gen byte month3 =  strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0
gen i = 1
egen j = count(y)
replace j = j /3

gen a = .
gen b = .
gen c = .
gen d = .

gen f = .
gen g = .
gen h = .
gen R = .
gen S = .
gen T = .
gen absT = .
gen U = .
gen X1 = .
gen yq = .
while i < j {

replace a = (ddg)/l.yi^2	if month1
replace b = delta/l.yi		if month1
replace c = 1				if month1
replace d = -(3*gdp)		if month1


replace f = [(3*c/a) - (b^2/a^2)]/3
replace g = [(2*b^3/a^3) - (9*b*c/a^2) + (27*d/a)] / 27
replace h = g^2/4 + f^3/27

replace R = -(g/2)+h^.5
replace S = R ^(1/3)
replace T = -(g/2)-h^.5
replace absT = abs(T)
replace U = absT ^ (1/3)
replace U = -U
replace X1 = (S+U) - (b/(3*a))
replace yi = X1									if month1 & yi == .
replace yi = delta *((l.yi*l.yi)/l2.yi)			if month2 & yi == .
replace yi = gamma * ((l.yi*l.yi)/l2.yi)		if month3 & yi == .

replace yq = round((yi + f.yi + f2.yi) / 3) if month1
replace i = i + 1
}
gen dy = d.y/l.y

replace yi = l.yi * dy + l.yi if yi == .

rename yi GDP_adj
rename yq GDPq_est

order timeq timem state gdp GDPq_est y GDP_adj 

twoway line GDPq GDP_est GDP_adj timem if timem >= tm(2011m1)

save saved_stata_files/missouri_adjusted, replace

********************************************************************************

use saved_stata_files/monthly_model_preadjusted, clear
*create local variable name
gen gdp = GDPq
gen y = GDP_est

keep timeq timem state _state gdp GDPq y GDP_est u3 netax GDPm_us/*date*/
tsset _state timem

sort _state timem
gen month = string(timem, "%tm")
drop if _state !=6

drop if y == .

order timeq timem month
*define delta and gamma
by _state: gen gamma = (f2.y / f.y) / (f.y / y) if gdp == f.gdp & gdp == f2.gdp 
by _state: gen delta = (f.y / y) / (y / l.y )	if gdp == f.gdp & gdp == f2.gdp
*populate missing delta and gamma
by _state:replace gamma = l2.gamma if strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0  
by _state:replace gamma = l.gamma  if strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
by _state:replace delta = l2.delta if strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0  
by _state:replace delta = l.delta  if strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
*define delta gamma
gen dg = delta * gamma
*define delta gamma squared
gen dgg = delta * gamma * gamma
*define gamma delta squared
gen ddg = delta * delta * gamma


gen constant = (3 * gdp - (y+f.y+f2.y)) / 3 if _n == 1
replace constant = (3 * gdp - (y+l.y+f.y)) / 3 if _n == 2
replace constant = (3 * gdp - (y+l.y+l2.y)) / 3 if _n == 3

gen yi = y + constant if _n < 4 
gen byte month1 =  strpos(month, "m11") == 0 & strpos(month, "m12") == 0 & strpos(month, "m1") != 0 | strpos(month, "m4") != 0 | strpos(month, "m7") != 0 | strpos(month, "m10") != 0
gen byte month2 =  strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
gen byte month3 =  strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0
gen i = 1
egen j = count(y)
replace j = j /3

gen a = .
gen b = .
gen c = .
gen d = .

gen f = .
gen g = .
gen h = .
gen R = .
gen S = .
gen T = .
gen absT = .
gen U = .
gen X1 = .
gen yq = .
while i < j {

replace a = (ddg)/l.yi^2	if month1
replace b = delta/l.yi		if month1
replace c = 1				if month1
replace d = -(3*gdp)		if month1


replace f = [(3*c/a) - (b^2/a^2)]/3
replace g = [(2*b^3/a^3) - (9*b*c/a^2) + (27*d/a)] / 27
replace h = g^2/4 + f^3/27

replace R = -(g/2)+h^.5
replace S = R ^(1/3)
replace T = -(g/2)-h^.5
replace absT = abs(T)
replace U = absT ^ (1/3)
replace U = -U
replace X1 = (S+U) - (b/(3*a))
replace yi = X1									if month1 & yi == .
replace yi = delta *((l.yi*l.yi)/l2.yi)			if month2 & yi == .
replace yi = gamma * ((l.yi*l.yi)/l2.yi)		if month3 & yi == .

replace yq = round((yi + f.yi + f2.yi) / 3) if month1
replace i = i + 1
}
gen dy = d.y/l.y

replace yi = l.yi * dy + l.yi if yi == .

rename yi GDP_adj
rename yq GDPq_est

order timeq timem state gdp GDPq_est y GDP_adj 

twoway line GDPq GDP_est GDP_adj timem if timem >= tm(2011m1)


save saved_stata_files/nebraska_adjusted, replace

*******************************************************************************

use saved_stata_files/monthly_model_preadjusted, clear

*create local variable name
gen gdp = GDPq
gen y = GDP_est

keep timeq timem state _state gdp GDPq y GDP_est u3 GDPm_us /*date*/
tsset _state timem

sort _state timem
gen month = string(timem, "%tm")
drop if _state !=7

drop if y == .

order timeq timem month
*define delta and gamma
by _state: gen gamma = (f2.y / f.y) / (f.y / y) if gdp == f.gdp & gdp == f2.gdp 
by _state: gen delta = (f.y / y) / (y / l.y )	if gdp == f.gdp & gdp == f2.gdp
by _state: gen test  =             (    y )	if gdp == f.gdp & gdp == f2.gdp & month=="2014m1"

*populate missing delta and gamma
by _state:replace gamma = l2.gamma if strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0  
by _state:replace gamma = l.gamma  if strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
by _state:replace delta = l2.delta if strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0  
by _state:replace delta = l.delta  if strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
*define delta gamma
gen dg = delta * gamma
*define delta gamma squared
gen dgg = delta * gamma * gamma
*define gamma delta squared
gen ddg = delta * delta * gamma


gen constant = (3 * gdp - (y+f.y+f2.y)) / 3 if _n == 1
replace constant = (3 * gdp - (y+l.y+f.y)) / 3 if _n == 2
replace constant = (3 * gdp - (y+l.y+l2.y)) / 3 if _n == 3

gen yi = y + constant if _n < 4 
gen byte month1 =  strpos(month, "m11") == 0 & strpos(month, "m12") == 0 & strpos(month, "m1") != 0 | strpos(month, "m4") != 0 | strpos(month, "m7") != 0 | strpos(month, "m10") != 0
gen byte month2 =  strpos(month, "m2") != 0 | strpos(month, "m5") != 0 | strpos(month, "m8") != 0 | strpos(month, "m11") != 0
gen byte month3 =  strpos(month, "m3") != 0 | strpos(month, "m6") != 0 | strpos(month, "m9") != 0 | strpos(month, "m12") != 0
gen i = 1
egen j = count(y)
replace j = j /3

gen a = .
gen b = .
gen c = .
gen d = .

gen f = .
gen g = .
gen h = .
gen R = .
gen S = .
gen T = .
gen absT = .
gen U = .
gen X1 = .
gen yq = .
while i < j {

replace a = (ddg)/l.yi^2	if month1
replace b = delta/l.yi		if month1
replace c = 1				if month1
replace d = -(3*gdp)		if month1


replace f = [(3*c/a) - (b^2/a^2)]/3
replace g = [(2*b^3/a^3) - (9*b*c/a^2) + (27*d/a)] / 27
replace h = g^2/4 + f^3/27

replace R = -(g/2)+h^.5
replace S = R ^(1/3)
replace T = -(g/2)-h^.5
replace absT = abs(T)
replace U = absT ^ (1/3)
replace U = -U
replace X1 = (S+U) - (b/(3*a))
replace yi = X1									if month1 & yi == .
replace yi = delta *((l.yi*l.yi)/l2.yi)			if month2 & yi == .
replace yi = gamma * ((l.yi*l.yi)/l2.yi)		if month3 & yi == .

replace yq = round((yi + f.yi + f2.yi) / 3) if month1
replace i = i + 1
}
gen dy = d.y/l.y

replace yi = l.yi * dy + l.yi if yi == .

rename yi GDP_adj
rename yq GDPq_est

order timeq timem state gdp GDPq_est y GDP_adj 

twoway line GDPq GDP_est GDP_adj timem if timem >= tm(2011m1)



save saved_stata_files/oklahoma_adjusted, replace

