* DHS Calendar Tutorial - data fixes

* drop duplicate cases - two cases in DRIR21FL
if v000 == "DR2" {
	sort caseid
	drop if caseid == caseid[_n-1]
}


* Fix for EGIR51FL - code Z means switched source (but continued method - not considered a discontinuation)
if v000 == "EG4" & v007 == 2005 {
	gen tempvcal_1 = vcal_1
	gen tempvcal_2 = vcal_2
	tempvar rsn
	gen `rsn' = " "
	forvalues i = 1/80 {
*		Find reason for discontinuation if there is a Z
		replace `rsn' = " "
		replace `rsn' = substr(tempvcal_2,`i',1) if substr(tempvcal_1,`i',1) == "Z"
*		Create updated versions of vcal_1 and vcal_2, replacing reason with " " 
		replace tempvcal_2 = subinstr(tempvcal_2, `rsn', " ", 1) if substr(tempvcal_1,`i',1) == "Z"
*		and then replacing Z with the method in the next month
		replace tempvcal_1 = subinstr(tempvcal_1, "Z", substr(tempvcal_1,`i'-1,1), 1)
	}
	drop `rsn'
	replace vcal_1 = tempvcal_1
	replace vcal_2 = tempvcal_2
	drop tempvcal_1
	drop tempvcal_2
}


* Fix for HNIR51FL - two cases with code M should have code B for a birth
if v000 == "HN5" & inrange(v007,2005,2006) {
  replace vcal_1 = subinstr(vcal_1,"M","B",.)
}


* Fix for PEIR5IFL - codes are incorrectly used
if v000 == "PE6" & v007 == 2009 {
	gen tempvcal_1 = vcal_1
	* changes must be in this order to avoid double correcting
	replace tempvcal_1 = subinstr(tempvcal_1, "F", "C", .)
	replace tempvcal_1 = subinstr(tempvcal_1, "L", "F", .)
	replace tempvcal_1 = subinstr(tempvcal_1, "8", "L", .)
	replace tempvcal_1 = subinstr(tempvcal_1, "9", "8", .)
	replace tempvcal_1 = subinstr(tempvcal_1, "E", "9", .)
	replace tempvcal_1 = subinstr(tempvcal_1, "M", "E", .)
	replace tempvcal_1 = subinstr(tempvcal_1, "*", "M", .)
	replace vcal_1 = tempvcal_1
	drop tempvcal_1
}


* Fix for dates in PEIR6IFL - v017, v018 and v019 are all off by 12 months
if v000 == "PE6" & v007 == 2012 {
  * has asterisk instead of blank after after month of interview
  replace vcal_1 = subinstr(vcal_1,"*"," ",.)
  
  capture confirm variable v017
  if _rc == 0 {
	replace v017 = 1285
  }
  capture confirm variable v018
  if _rc == 0 & v018 <= 6 {
    replace v018 = v018 + 12
  }
  capture confirm variable v019
  if _rc == 0 & v019 > 72 {
    replace v019 = v019 - 12
  }
}


