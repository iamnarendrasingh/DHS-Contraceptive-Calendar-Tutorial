local C="C:\DATA\DHS_Stata"
* Change directory to the data directory
cd `C'

* log the output
log using "vcal_misalign.log", replace

* get a list of files currently on C:
local flist: dir "`C'" files "??ir??fl.dta"

* Loop through each sub DHS recode file in the directory
foreach file of local flist {
	use `file', clear
	display "`file'"
	capture gen str1 x=" "
	capture replace x=substr(vcal_1,1,1)
	tab x
}
log close
