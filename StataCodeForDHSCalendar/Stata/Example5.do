* DHS Calendar Tutorial - Example 5
* Percent distribution of discontinuations of contraceptive methods in the five years
* preceding the survey by main reason stated for discontinuation, according to specific method

* download the model dataset for individual women's recode: "ZZIR62FL.DTA" 
* the model datasets are available at http://dhsprogram.com/data/download-model-datasets.cfm

* change to a working directory where the data are stored
* or add the full path to the 'use' command below
cd "C:\Data\DHS_model"

* open the dataset to use, selecting just the variables we are going to use
use caseid vcal_1 vcal_2 v000 v005 v007 v018 v021 v023 using "ZZIR62FL.DTA", clear


* Step 5.1
* loop through calendar creating separate variables for each month
* total length of calendar to loop over including leading blanks (80)
local vcal_len = strlen(vcal_1[1])
forvalues i = 1/`vcal_len' {
  gen str1 method`i' = substr(vcal_1,`i',1)
  gen str1 reason`i' = substr(vcal_2,`i',1)
}


* Step 5.2
* drop calendar string variables as we don't need them further
drop vcal_1 vcal_2

* reshape the data file into a file where the month is the unit of analysis
reshape long method reason, i(caseid) j(i)


* Step 5.3
* keep only the cases of discontinuations (reason is not blank)
* in the five years preceding the survey
* checks for both a single blank and the null string in reason
* string can be null if position i is beyond the last non-blank in the original string
keep if reason != " " & reason != "" & inrange(i,v018,v018+59)


* Step 5.4
* list of codes of methods
local methodlist = "123456789WNALCFEMS"
* convert the contraceptive methods to numeric codes, using the position in the string
gen method_num = strpos("`methodlist'",method)
* convert the missing code to 99
replace method_num = 99 if method == "?"
* now check if there are any codes that were not converted, and change these to -1
replace method_num = -1 if method_num == 0 & method != " "

* list of codes of reasons for discontinuation. ~ represents other survey specific codes
local reasonlist = "123456789CFAD~~~~"
* convert the reasons for discontinuation to numeric codes, using the position in the string
gen reason_num = strpos("`reasonlist'",reason)
* now convert the special codes for other, don't know and missing to 96, 98, 99 respectively
gen special = strpos("W~K?",reason)
replace reason_num = special+95 if special > 0
drop special
* now check if there are any codes that were not converted, and change these to -1
replace reason_num = -1 if reason_num == 0 & reason != " "


* Step 5.5
* label the method variables and codes
label variable method "Contraceptive method (alpha)"
label variable method_num  "Contraceptive method"
label def method_codes ///
  0 "No method used" ///
  1 "Pill" ///
  2 "IUD" ///
  3 "Injectable" ///
  4 "Diaphragm" ///
  5 "Condom" ///
  6 "Female sterilization" ///
  7 "Male sterilization" ///
  8 "Periodic abstinence/Rhythm" ///
  9 "Withdrawal" ///
 10 "Other traditional methods" ///
 11 "Norplant" ///
 12 "Abstinence" ///
 13 "Lactational amenorrhea method" ///
 14 "Female condom" ///
 15 "Foam and Jelly" ///
 16 "Emergency contraception" ///
 17 "Other modern method" ///
 18 "Standard days method" ///
 99 "Missing" ///
 -1 "***Unknown code not recoded***" 
label val method_num method_codes

* label the reason variables and codes
label variable reason "Discontinuation code (alpha)"
label variable reason_num  "Discontinuation code"
label def reason_codes ///
  0 "No discontinuation" ///
  1 "Became pregnant while using" ///
  2 "Wanted to become pregnant" ///
  3 "Husband disapproved" ///
  4 "Side effects" ///
  5 "Health concerns" ///
  6 "Access/availability" ///
  7 "Wanted more effective method" ///
  8 "Inconvenient to use" ///
  9 "Infrequent sex/husband away" ///
 10 "Cost" ///
 11 "Fatalistic" ///
 12 "Difficult to get pregnant/menopause" ///
 13 "Marital dissolution" ///
 96 "Other" ///
 98 "Don't know" ///
 99 "Missing" ///
 -1 "***Unknown code not recoded***" 
label val reason_num reason_codes


* Step 5.6
* Compute weight variable
gen wt=v005/1000000

* crosstab reason and method, either using a simple tab:
tab reason_num method_num [iweight=wt], col

* or better, using svy tab:
svyset v021 [pweight=wt], strata(v023)
svy: tab reason_num method_num, col per
