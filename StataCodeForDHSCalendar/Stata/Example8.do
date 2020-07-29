* DHS Calendar Tutorial - Example 8
* Reason for discontinuation in the last five years by method.

* change to a working directory where the data are stored
* or add the full path to the 'use' command below
cd "C:\Data\DHS_model"

* open the events file dataset created by the 'create events file.do'
use "eventsfile.DTA", clear

* weight variable
gen wt = v005/1000000

* recode the methods to group methods together
recode ev902                    ///
	(1=1 "Pill")                ///
	(2=2 "IUD")                 ///
	(3=3 "Injection")           ///
	(11=4 "Implants")           ///
	(5=5 "Male condom")         ///
	(13=6 "LAM")                ///
	(nonmissing = 10 "Other")   ///
	(missing=.), g(method)
* Other includes: Female Sterilization, Male sterilization, Other Traditional, Female Condom, 
*                 Emergency contraception, Other Modern, Standard Days Method,
*                 Periodic Abstinence and Withdrawal
label var method "Contraceptive method"

* tabulate all discontinuations that occurred within the last five years
tab ev903 method [iw=wt] if ev903 != 0 & v008-ev901 < 60, col
