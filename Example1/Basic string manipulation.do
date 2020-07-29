clear
clear matrix
clear mata
capture log close
set maxvar 15000
set more off
numlabel, add


* DHS Calendar Tutorial - Example 1
* Basic string manipulation


* download the model dataset for individual women's recode: "ZZIR62FL.DTA" 
* the model datasets are available at http://dhsprogram.com/data/download-model-datasets.cfm

* change to a working directory where the data are stored
* or add the full path to the 'use' command below
cd "E:\Self_GitKraken\DHS-Contraceptive-Calendar-Tutorial\ZZIR62DT"


* open the dataset, selecting just the variables we are going to use
use vcal_1 v000 v005 v007 v008 v017 v018 v019 using "ZZIR62FL.DTA", clear


* 1) display column 1 of the calendar for the first 6 respondents
list vcal_1 in 1/5


* 2) calculate the full length of calendar by displaying length of strings
gen vcal_len = strlen(vcal_1)
label variable vcal_len "length of calendar"
list vcal_len in 1/5



* 3) take a piece of a string from column 1
gen piece = substr(vcal_1,44,12) // start at position 44 for 12 characters
label variable piece "piece of calendar"
list piece in 1/5

* 4) find the position of a substring within a string
gen pos = strpos(vcal_1,"P") // look for first occurrence of "P"
label variable pos "position in calendar"
list pos in 1/5

* 5) reverse a string
gen rev_cal = reverse(vcal_1) // calendar from oldest to most recent month (L to R)
label variable rev_cal "reversed calendar"
list rev_cal in 1/5


* 6) trim a string of leading and trailing spaces
gen trim_cal = trim(vcal_1)
label variable trim_cal "trimmed calendar"
list trim_cal in 1/5

* replace var = subinstr(var,"$","",.) // can be used if any speial symbol us there


* 7) display the length of calendar actually used, from the trimmed version
gen vcal_used = strlen(trim_cal)
label variable vcal_used "length of calendar used"
* should be the same as v019
list vcal_used v019 in 1/5

cd "E:\Self_GitKraken\DHS-Contraceptive-Calendar-Tutorial\Example1"

save Example1.dta , replace 
