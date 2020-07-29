* DHS Calendar Tutorial - Example 4
* Stillbirths and perinatal mortality

* download the model dataset for individual women's recode: "ZZIR62FL.DTA" 
* the model datasets are available at http://dhsprogram.com/data/download-model-datasets.cfm

* change to a working directory where the data are stored
* or add the full path to the 'use' command below
cd "C:\Data\DHS_model\"

* open the dataset to use, selecting just the variables we are going to use
use vcal_1 v000 v005 v007 v008 v018 v021 v023 v024 b3* b6* using "ZZIR62FL.DTA", clear


* Step 4.1
* Stillbirths
gen stillbirths = 0
label variable stillbirths "Stillbirths"
* Births in calendar
gen births = 0
label variable births "Births in calendar (excludes twins)"
* Births in birth history including twins in the five years preceding the survey
gen births2 = 0
label variable births2 "Births in birth history (including twins)"
* Early neonatal deaths in the five years preceding the survey
gen earlyneo = 0
label variable earlyneo "Early neonatal deaths"


* Step 4.2
* Set the start and end positions to use for the five year windows
gen beg = v018
gen end = v018+59

* Loop through calendar summing births, non-live pregnancies and stillbirths
* total length of calendar to loop over including leading blanks (80)
local vcal_len = strlen(vcal_1[1])
forvalues i = 1/`vcal_len' {
  * count the births, but restricting to just the 60 months preceding survey
  replace births = births+1 if inrange(`i',beg,end) & substr(vcal_1,`i',1) == "B"
  * count the stillbirths, also restricting to just the 60 months preceding survey
  replace stillbirths = stillbirths+1 if inrange(`i',beg,end) & ///
    substr(vcal_1,`i',7) == "TPPPPPP" 
} 


* Step 4.3
* reuse beg and end for CMCs range for the birth history
replace end = v008
replace beg = v008-59

* rename b3 and b6 variables to facilitate use in the for loop
rename b3_0* b3_*
rename b6_0* b6_*

* Loop through birth history summing births and early neonatal deaths
* in the five years preceding the survey
forvalues i = 1/20 {
* restrict to 60 months preceding survey
  replace births2 = births2+1 if inrange(b3_`i',beg,end)
  replace earlyneo = earlyneo+1 if inrange(b3_`i',beg,end) & inrange(b6_`i',100,106)
} 


* Step 4.4
* total pregnancies of 7+ months in last 5 years (all live births (including twins),
* plus the stillbirths)
gen totpreg7m = births2+stillbirths
label variable totpreg7m "Number of pregnancies of 7+ months duration"

* total perinatal mortality = early neonatal deaths plus stillbirths
gen perinatal = earlyneo+stillbirths
label variable perinatal "Perinatal mortality"


* Step 4.5
* create weight variable
gen wt = v005/1000000

* set up svyset parameters for complex samples
svyset v021 [pweight=wt], strata(v023)

* number of stillbirths
* weight the number of women by the number of stillbirths for the correct count
replace wt = stillbirths*v005/1000000
svy: tab v024, cell count
* early neonatal deaths
* weight the number of women by the number of early neonatal deaths
replace wt = earlyneo*v005/1000000
svy: tab v024, cell count
* number of pregnancies of 7+ months
* weight the number of women by the total number of pregnancies of 7+ months
replace wt = totpreg7m*v005/1000000
svy: tab v024, cell count

* reset the weight variable
replace wt = v005/1000000
* perinatal mortality ratio
svy: ratio perinatal/totpreg7m
svy: ratio perinatal/totpreg7m, over(v024)
