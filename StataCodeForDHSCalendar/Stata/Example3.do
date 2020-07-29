* DHS Calendar Tutorial - Example 3
* whether woman used family planning at any point in first year after most recent birth

* variable ppfp (post-partum family planning) will be 
* 0 = No method used in first 12 months after birth
* 1 = Traditional method used in first 12 months after birth
* 2 = Modern method used in first 12 months after birth
* restricted to women whose most recent birth is at least 12 months before interview 
* back to five years before interview
* birth1_5=1 if the woman meets these criteria

* download the model dataset for individual women's recode: "ZZIR62FL.DTA" 
* the model datasets are available at http://dhsprogram.com/data/download-model-datasets.cfm

* change to a working directory where the data are stored
* or add the full path to the 'use' command below
cd "C:\Data\DHS_model"

* open the dataset to use, selecting just the variables we are going to use
use vcal_1 v000 v005 v007 using "ZZIR62FL.DTA", clear


* Step 3.1
* remove the leading blanks for the months after the interview
gen trim_cal=trim(vcal_1)

* search for the last birth in the calendar
gen lb=strpos(trim_cal,"B")
* eligible if most recent birth is between 13 months ago and 60 months ago
* equivalent to months 12-59 preceding the survey when month of interview is month 0
gen birth1_5=inrange(lb,13,60)

* split into strings separated by births ("B") for each postpartum period
split trim_cal, p("B") gen(pp)
* we only want pp1, following the most recent birth, drop all the others
foreach x of varlist pp* {
  if "`x'" != "pp1" {
    drop `x' 
  }
}


* Step 3.2
* reverse the string for the period after the birth
* so we are going forward in time from the birth
* limit to women whose most recent birth is at least 12 months before interview
gen postbirth=reverse(pp1) if birth1_5 == 1
* and then extract the first 12 months
replace postbirth=substr(postbirth,1,12)


* Step 3.3
* see if anything happened in this 12 month period other than non-use of contraception
gen used_month = indexnot(postbirth,"0")
* if no birth in the period 12-59 months preceding the survey (birth1_5 != 1) then
* reset used_month to 0 to facilitate later steps
replace used_month = 0 if birth1_5 != 1 
* get the method code for the method used following the pregnancy
gen method_used = substr(postbirth,used_month,1) if used_month > 0
* something was found, but it might be a pregnancy (or possibly a termination),
* if so don't count this. Births are always preceded by pregnancy,
* but a termination in month 1 would not have a P preceding it
replace used_month = 0 if used_month > 0 & inlist(method_used,"P","T")
replace method_used = "" if used_month == 0


* Step 3.4
* generate postpartum family planning variable, initially set to 0
gen ppfp=0 if birth1_5 == 1
* update ppfp if used a method
replace ppfp = 1 if used_month > 0
* search the 12 months after birth for one of the modern methods
* the list of codes below (in the 'strpos' function) are survey specific 
* and should be adapted for each survey
* in particular codes "E", "M", and "S" may have been traditional methods in older surveys,
* but are now standard codes for Emergency contraception, Other modern methods,
* and Standard days method
* also note that "L" (LAM) could be excluded because it is only valid within 6 months after birth
replace ppfp = 2 if used_month > 0 & strpos("1234567LNCFEMS",method_used) > 0

* label the ppfp variable
label variable ppfp "Used modern method within 12 months of birth"
label def used 0 "no method used" 1 "traditional method used" 2 "modern method used"
label val ppfp used


* Step 3.5
* weight the data and tabulate
gen wt=v005/1000000
tab ppfp [iw=wt] if birth1_5==1
