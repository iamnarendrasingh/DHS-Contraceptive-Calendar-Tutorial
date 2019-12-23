* DHS Calendar Tutorial - Example 2
* Last pregnancy, duration of pregnancy and method used before pregnancy

* download the model dataset for individual women's recode: "ZZIR62FL.DTA" 
* the model datasets are available at http://dhsprogram.com/data/download-model-datasets.cfm

* change to a working directory where the data are stored
* or add the full path to the 'use' command below
cd "E:\Self_GitKraken\DHS-Contraceptive-Calendar-Tutorial\ZZIR62DT"


* open the dataset to use, selecting just the variables we are going to use
use vcal_1 v000 v005 v007 v008 v017 v018 v019 v208 b3_01 using "ZZIR62FL.DTA", clear

* Example 2A
* -----------------------
* get century month code (CMC) of date of last birth or pregnancy from calendar 
* using string functions


* Step 2.1
* length of full calendar string including leading blanks (80)
* actual length used according to v019 will be less
egen vcal_len = max(strlen(vcal_1))
* most calendars are 80 in length, but those without method use may be short, so use the max
label variable vcal_len "Length of calendar"

* Step 2.2
* position of last birth or terminated pregnancy in calendar
gen lb = strpos(vcal_1,"B")
gen lp = strpos(vcal_1,"T")
* update lp with position of last birth if there was no terminated pregnancy, 
* or if the last birth was more recent than last terminated pregnancy
replace lp = lb if lp == 0 | (lb > 0 & lb < lp)
* e.g. if calendar is as below ("_" used to replace blank for display here):
* ______________00000BPPPPPPPP000000555555500000TPP00000000000000BPPPPPPPP00000000
*                    ^
* lp would be 20
label variable lp "Position of last birth or terminated pregnancy in calendar"
label def lp 0 "No birth or terminated pregnancy in calendar"
label value lp lp
* get the type of birth or terminated pregnancy
* lp_type will be set to 1 if lp refers to a birth, 
* and 2 if lp refers to a terminated pregnancy using the position in "BT" for the resulting code
gen lp_type = strpos("BT",substr(vcal_1,lp,1)) if lp > 0 
