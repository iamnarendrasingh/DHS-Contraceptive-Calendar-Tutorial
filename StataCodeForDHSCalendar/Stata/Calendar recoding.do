* DHS Calendar Tutorial - Calendar recoding
* Recode contraceptive method and reason for discontinuation string variables to numeric variables

* 4 parameters can be passed to call this do file:
* 1: input  method string  variable name (single character)
* 2: output method numeric variable name
* 3: input  reason for discontinuation string  variable name (single character)
* 4: output reason for discontinuation numeric variable name
* can leave empty or use dot (.) for paramters

* Ensure that data fixes are applied first if needed.

capture program drop add2list
program define add2list
* parameters: listname position code
  local len = length(`1')
if `2' == 1 {
  scalar `1' = "`3'" + substr(`1',`2',`len'-1)
}
else if `2' == `len' {
  scalar `1' = substr(`1',1,`len'-1) + "`3'"
}
else {
  scalar `1' = substr(`1',1,`2'-1) + "`3'" + substr(`1',`2'+1,`len'-`2')
}
  scalar list `1'
end

* define standard method codes - using a string of 99 characters, filled out with "~" and a "?" in the 99th position
*                    ....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8....+....9....+....0
scalar methodlist = "123456789WNALCF~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~BTP~~~~~~~~~~~~~~~?"

* Other modern methods
if substr(v000,3,1) == "6" | (substr(v000,3,1) == "7" & v000 != "CO7") | ///
   v000 == "TL6" | v000 == "LS6" {
  add2list methodlist 17 "M"	// 17: Other modern methods
}
* Emergency contraception and standard days method
if substr(v000,3,1) == "7" {
  add2list methodlist 16 "E"  // 16: Emergency contraception
  add2list methodlist 18 "S"  // 18: Standard days method
}

if v000 == "AM4" & v007 == 2000            add2list methodlist 23 "D"  // AMIR42   23: Douche
if v000 == "AM6" & v007 == 2010            add2list methodlist 18 "G"  // AMIR61   18: Standard days method - Fertility wheel
if v000 == "BD3" & inlist(v007,99,00)      add2list methodlist 13 "á"  // BDIR41   13: Lactational amenorrhea (á)
if v000 == "BO5" & v007 == 2008            add2list methodlist 18 "K"  // BOIR51   18: Standard days method
if v000 == "CO7" & inrange(v007,2015,2016) add2list methodlist  3 "I"  // COIR71    3: 3 monthly injectable
if v000 == "CO7" & inrange(v007,2015,2016) add2list methodlist 32 "3"  // COIR71   32: Monthly injectable
if v000 == "CO7" & inrange(v007,2015,2016) add2list methodlist 31 "M"  // COIR71   31: Contraceptive patch
if v000 == "CO7" & inrange(v007,2015,2016) add2list methodlist 34 "R"  // COIR71   34: Vaginal ring
if v000 == "DR3" & v007 ==   96            add2list methodlist 13 "M"  // DRIR32   13: LAM
if v000 == "DR3" & v007 ==   99            add2list methodlist 13 "á"  // DRIR41   13: LAM
if v000 == "EG2" & inrange(v007,92,93)     add2list methodlist 24 "G"  // EGIR21   24: Prolonged breastfeeding
if v000 == "EG3" & inrange(v007,95,96)     add2list methodlist 24 "G"  // EGIR33   24: Prolonged breastfeeding
if v000 == "EG4" & v007 == 2000            add2list methodlist 19 "D"  // EGIR42   19: Diaphragm/Foam/Jelly - could be any of these
if v000 == "EG4" & v007 == 2000            add2list methodlist 24 "G"  // EGIR42   24: Prolonged breastfeeding
if v000 == "EG4" & v007 == 2003            add2list methodlist 19 "D"  // EGIR4A   19: Diaphragm/Foam/Jelly - could be any of these
if v000 == "EG4" & v007 == 2003            add2list methodlist 24 "G"  // EGIR4A   24: Prolonged breastfeeding
if v000 == "EG4" & v007 == 2005            add2list methodlist 19 "K"  // EGIR51   19: Diaphragm/Foam/Jelly - could be any of these
if v000 == "EG4" & v007 == 2005            add2list methodlist 24 "R"  // EGIR51   24: Prolonged breastfeeding
if v000 == "EG5" & v007 == 2008            add2list methodlist 19 "K"  // EGIR5A   19: Diaphragm/Foam/Jelly - could be any of these
if v000 == "EG5" & v007 == 2008            add2list methodlist 24 "R"  // EGIR5A   24: Prolonged breastfeeding
if v000 == "EG6" & v007 == 2014            add2list methodlist 32 "G"  // EGIR61   32: Injections (monthly)
if v000 == "EG6" & v007 == 2014            add2list methodlist 24 "H"  // EGIR61   24: Prolonged breastfeeding
if v000 == "ET4" & v007 == 1992 /*2000*/   add2list methodlist 18 "S"  // ETIR51   18: Standard days method    - 1992 in local calendar, 2000 western
if v000 == "ET6" & v007 == 2003 /*2010*/   add2list methodlist 18 "O"  // ETIR61   18: Standard days method    - 2003 in local calendar, 2010 western
if v000 == "GU6" & inrange(v007,2014,2015) add2list methodlist 16 "O"  // GUIR71   16: Emergency contraception
if v000 == "GU6" & inrange(v007,2014,2015) add2list methodlist 18 "Q"  // GUIR71   18: Standard days method - Fixed days collar
if v000 == "HN5" & inrange(v007,2005,2006) add2list methodlist 18 "K"  // HNIR52   18: Standard days method - Fixed days collar
if v000 == "ID2" & v007 ==   91            add2list methodlist 26 "J"  // IDIR21   26: Herbs
if v000 == "ID2" & v007 ==   91            add2list methodlist 27 "U"  // IDIR21   27: Massage
if v000 == "ID2" & v007 ==   91            add2list methodlist 28 "I"  // IDIR21   28: Intravag
if v000 == "ID3" & v007 ==   94            add2list methodlist 26 "J"  // IDIR31   26: Herbs
if v000 == "ID3" & v007 ==   94            add2list methodlist 27 "U"  // IDIR31   27: Massage
if v000 == "ID3" & v007 ==   97            add2list methodlist 26 "J"  // IDIR3A   26: Herbs
if v000 == "ID3" & v007 ==   97            add2list methodlist 27 "U"  // IDIR3A   27: Massage
if v000 == "ID5" & v007 == 2007            add2list methodlist 26 "X"  // IDIR51   26: Herbs
if v000 == "ID5" & v007 == 2007            add2list methodlist 27 "Y"  // IDIR51   27: Massage
if v000 == "ID5" & v007 == 2007            add2list methodlist 16 "G"  // IDIR51   16: Emergency contraception
if v000 == "JO5" & v007 == 2007            add2list methodlist 25 "S"  // JOIR51   25: Suppository
if v000 == "KH5" & v007 == 2010            add2list methodlist 17 "X"  // KHIR61   17: Other modern methods
if v000 == "KH6" & v007 == 2014            add2list methodlist 33 "D"  // KHIR72   33: Monthly (Chinese) Pill
if v000 == "KK3" & v007 ==   99            add2list methodlist 13 "á"  // KKIR42   13: LAM
if v000 == "KK3" & v007 ==   99            add2list methodlist 14 "à"  // KKIR42   14: Female condom
if v000 == "LB6" & v007 == 2013            add2list methodlist 18 "S"  // LBIR6A   18: Standard days method/cycle bead
if v000 == "MD5" & inrange(v007,2008,2009) add2list methodlist 18 "K"  // MDIR51   18: Standard days method
if v000 == "ML6" & inrange(v007,2012,2013) add2list methodlist 18 "R"  // MLIR6H   18: Standard days method - Cycle collar
if v000 == "NG6" & v007 == 2013            add2list methodlist 18 "K"  // NGIR6A   18: Standard days method
if v000 == "NM6" & v007 == 2013            add2list methodlist 31 "K"  // NMIR60   31: Contraceptive patch 
if v000 == "PE5" & inrange(v007,2003,2008) add2list methodlist 16 "E"  // PEIR51   16: Emergency contraception
if v000 == "PE5" & inrange(v007,2003,2008) add2list methodlist 18 "M"  // PEIR51   18: Standard days method - Cycle collar
if v000 == "PE6" & v007 == 2009            add2list methodlist 16 "E"  // PEIR5I   16: Emergency contraception
if v000 == "PE6" & v007 == 2009            add2list methodlist 18 "M"  // PEIR5I   18: Standard days method - Cycle collar
if v000 == "PE6" & v007 == 2010            add2list methodlist 16 "E"  // PEIR61   16: Emergency contraception
if v000 == "PE6" & v007 == 2011            add2list methodlist 16 "E"  // PEIR6A   16: Emergency contraception
if v000 == "PE6" & v007 == 2012            add2list methodlist 16 "E"  // PEIR6I   16: Emergency contraception
if v000 == "PH3" & v007 ==   98            add2list methodlist 13 "à"  // PHIR3B   13: LAM
if v000 == "PH3" & v007 ==   98            add2list methodlist 24 "á"  // PHIR3B   24: Prolonged breastfeeding
if v000 == "PH3" & v007 ==   98            add2list methodlist 29 "â"  // PHIR3B   29: Modern methods of periodic abstinence
if v000 == "PH4" & v007 == 2003            add2list methodlist 16 "M"  // PHIR41   16: Emergency contraception
if v000 == "PH4" & v007 == 2003            add2list methodlist 20 "D"  // PHIR41   20: Mucus, billings, ovulation
if v000 == "PH4" & v007 == 2003            add2list methodlist 21 "E"  // PHIR41   21: Basal body temperature
if v000 == "PH4" & v007 == 2003            add2list methodlist 22 "G"  // PHIR41   22: Symptothermal
if v000 == "PH4" & v007 == 2003            add2list methodlist 18 "H"  // PHIR41   18: Standard days method
if v000 == "PK6" & inrange(v007,2012,2013) add2list methodlist 18 "S"  // PKIR61   18: Standard days method
if v000 == "RW6" & inrange(v007,2010,2011) add2list methodlist 18 "D"  // RWIR61   18: Standard days method
if v000 == "RW6" & inrange(v007,2014,2015) add2list methodlist 18 "S"  // RWIR70   18: Standard days method
if v000 == "SN6" & inrange(v007,2012,2013) add2list methodlist 18 "a"  // SNIR6D   18: Standard days method - Cycle collar
if v000 == "SN6" & v007 == 2015            add2list methodlist 18 "a"  // SNIR7H   18: Standard days method - Cycle collar
if v000 == "TR2" & v007 ==   93            add2list methodlist 23 "Y"  // TRIR31   23: Douche
if v000 == "TR5" & v007 == 2008            add2list methodlist 16 "G"  // TRIR52   16: Emergency contraception
if v000 == "TR6" & v007 == 2013            add2list methodlist 34 "V"  // TRIR61   34: Vaginal ring
if v000 == "TR6" & v007 == 2013            add2list methodlist 19 "4"  // TRIR61   19: Diaphragm/foam/jelly 
if v000 == "TR6" & v007 == 2013            add2list methodlist  4 "~"  // TRIR61    4: - not used here
if v000 == "ZM6" & inrange(v007,2013,2014) add2list methodlist 18 "S"  // ZMIR61   18: Standard days method
* Other pregnancy codes                                                                              
if v000 == "BD3" & inlist(v007,99,00)      add2list methodlist 84 "H"  // BDIR41   84: Hysterectomy !!!
if v000 == "BD4" & v007 == 2004            add2list methodlist 84 "H"  // BDIR4J   84: Hysterectomy !!!
if v000 == "VNT" & v007 ==   97            add2list methodlist 91 "à"  // VNIR31   ??: !!!


capture label drop method
label def method ///
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
 10 "Other traditional method" ///
 11 "Norplant" ///
 12 "Abstinence" ///
 13 "Lactational amenorrhea method" ///
 14 "Female condom" ///
 15 "Foam and Jelly" ///
 16 "Emergency contraception" ///
 17 "Other modern method" ///
 18 "Standard days method" ///
 19 "Diaphgram/Foam/Jelly" ///
 20 "Mucus, billings, ovulation" ///
 21 "Basal body temperature" ///
 22 "Symptothermal" ///
 23 "Douche" ///
 24 "Prolonged breastfeeding" ///
 25 "Suppository" ///
 26 "Herbs" ///
 27 "Massage" ///
 28 "Intravag" ///
 29 "Modern methods of periodic abstinence" ///
 31 "Contraceptive patch" ///
 32 "Injections (monthly)" ///
 33 "Monthly (Chinese) Pill" ///
 34 "Vaginal ring" ///
 81 "Birth" ///
 82 "Termination" ///
 83 "Pregnancy" ///
 84 "Hysterectomy" ///
 91 "Not currently married or living together" ///
 99 "Missing" ///
 -1 "***Unknown code not recoded***" 
 

* define standard reason codes - using a string of 99 characters, filled out with "~" and a "?" in the 99th position
*                    ....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8....+....9....+....0
scalar reasonlist = "123456789CFAD~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~W~K?"

if v000 == "BR2" & inrange(v007,  91,  92) add2list reasonlist 17 "à"     //BRIR21   17: Break  
if v000 == "BR3" & v007 ==   96            add2list reasonlist 16 "H"     //BRIR31   16: Hysterectomy  
if v000 == "BR3" & v007 ==   96            add2list reasonlist 17 "B"     //BRIR31   17: Break  
if v000 == "EG2" & inrange(v007,  92,  93) add2list reasonlist 18 "E"     //EGIR21   18: E = IUD expelled  
if v000 == "EG2" & inrange(v007,  92,  93) add2list reasonlist 19 "X"     //EGIR21   19: X = IUD expired  
if v000 == "EG2" & inrange(v007,  92,  93) add2list reasonlist 20 "M"     //EGIR21   20: M = Medical advice  
if v000 == "EG2" & inrange(v007,  92,  93) add2list reasonlist 21 "S"     //EGIR21   21: S = Switch to another brand or method  
if v000 == "EG2" & inrange(v007,  92,  93) add2list reasonlist 22 "B"     //EGIR21   22: B = Death of spouse  
if v000 == "EG4" & v007 == 2003            add2list reasonlist 98 "~"     //EGIR4A   Don't know not used and K used for something else below  
if v000 == "EG4" & v007 == 2003            add2list reasonlist 18 "N"     //EGIR4A   18: IUD expelled  
if v000 == "EG4" & v007 == 2003            add2list reasonlist 23 "P"     //EGIR4A   23: Husband ill  
if v000 == "EG4" & v007 == 2003            add2list reasonlist 24 "Q"     //EGIR4A   24: Can't get pregnant  
if v000 == "EG4" & v007 == 2003            add2list reasonlist 29 "J"     //EGIR4A   29: J = Changed method  
if v000 == "EG4" & v007 == 2003            add2list reasonlist 30 "K"     //EGIR4A   30: K = Husband wants her pregnant  
if v000 == "EG4" & v007 == 2003            add2list reasonlist 31 "L"     //EGIR4A   31: L = Afraid of forgetting method  
if v000 == "EG4" & v007 == 2003            add2list reasonlist 32 "M"     //EGIR4A   32: M = Afraid of using method  
if v000 == "EG4" & v007 == 2003            add2list reasonlist 33 "R"     //EGIR4A   33: R = Thinks she is pregnant  
if v000 == "EG4" & v007 == 2005            add2list reasonlist 18 "P"     //EGIR51   18: IUD expelled  
if v000 == "EG4" & v007 == 2005            add2list reasonlist 34 "O"     //EGIR51   34: Doctor's opinion  
if v000 == "EG5" & v007 == 2008            add2list reasonlist 34 "O"     //EGIR5A   34: Doctor's opinion  
if v000 == "ET4" & v007 == 1997 /*2005*/   add2list reasonlist 35 "M"     //ETIR51   35: Method not available   - 1997 local year, 2005 western 
if v000 == "IA5" & inrange(v007,2005,2006) add2list reasonlist 36 "L"     //IAIR52   36: Lack of sexual satisfaction  
if v000 == "IA5" & inrange(v007,2005,2006) add2list reasonlist 37 "M"     //IAIR52   37: Created menstrual problem  
if v000 == "IA5" & inrange(v007,2005,2006) add2list reasonlist 38 "N"     //IAIR52   38: Did not like method  
if v000 == "IA5" & inrange(v007,2005,2006) add2list reasonlist 39 "P"     //IAIR52   39: Lack of privacy  
if v000 == "IA5" & inrange(v007,2005,2006) add2list reasonlist 40 "G"     //IAIR52   40: Gained weight  
if v000 == "ID2" & v007 ==   91            add2list reasonlist 18 "X"     //IDIR21   18: X = IUD expelled  
if v000 == "ID2" & v007 ==   91            add2list reasonlist 20 "M"     //IDIR21   20: M = Medical advice  
if v000 == "ID2" & v007 ==   91            add2list reasonlist 24 "I"     //IDIR21   24: I = Can't get pregnant  
if v000 == "ID3" & v007 ==   94            add2list reasonlist 18 "N"     //IDIR31   18: IUD expelled  
if v000 == "ID3" & v007 ==   97            add2list reasonlist 18 "N"     //IDIR3A   18: IUD expelled  
if v000 == "ID4" & inrange(v007,2002,2003) add2list reasonlist 18 "I"     //IDIR42   18: IUD expelled  
if v000 == "ID5" & v007 == 2007            add2list reasonlist 18 "I"     //IDIR51   18: IUD expelled  
if v000 == "ID6" & v007 == 2012            add2list reasonlist 18 "N"     //IDIR63   18: IUD expelled  
if v000 == "JO3" & v007 ==   97            add2list reasonlist 17 "R"     //JOIR31   17: Rest  
if v000 == "JO3" & v007 ==   97            add2list reasonlist 27 "P"     //JOIR31   27: Period returned  
if v000 == "JO5" & v007 == 2007            add2list reasonlist 23 "T"     //JOIR51   23: Husband travelling/ill 
if v000 == "JO5" & v007 == 2007            add2list reasonlist 25 "R"     //JOIR51   25: Ramadan  
if v000 == "JO5" & v007 == 2007            add2list reasonlist 26 "B"     //JOIR51   26: End of breastfeeding  
if v000 == "JO5" & v007 == 2009            add2list reasonlist 25 "R"     //JOIR61   25: Ramadan  
if v000 == "JO6" & v007 == 2012            add2list reasonlist 25 "R"     //JOIR6C   25: Ramadan  
if v000 == "JO6" & v007 == 2012            add2list reasonlist 41 "E"     //JOIR6C   41: The absence of one condition of breastfeeding ???  
if v000 == "JO6" & v007 == 2012            add2list reasonlist 17 "G"     //JOIR6C   17: Rest  
if v000 == "JO6" & v007 == 2012            add2list reasonlist 42 "H"     //JOIR6C   42: Expiration/lack of method  B14
if v000 == "JO6" & v007 == 2012            add2list reasonlist 43 "I"     //JOIR6C   43: Erectile dysfunction in husband  
if v000 == "NC3" & inrange(v007,  97,  98) add2list reasonlist 23 "B"     //NCIR31   23: Husband absent  
if v000 == "NP6" & inrange(v007,2067,2068) add2list reasonlist 23 "H"     //NPIR60   23: Husband away   - 2067-2068 local year, 2011 western
if v000 == "UA5" & v007 == 2007            add2list reasonlist 19 "E"     //UAIR51   19: IUD expired  


capture label drop reason
label def reason ///
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
 16 "Hysterectomy" ///
 17 "Break" ///
 18 "IUD expelled" ///
 19 "IUD expired" ///
 20 "Medical advice" ///
 21 "Switch to another brand or method" ///
 22 "Death of spouse" ///
 23 "Husband absent, ill" ///
 24 "Can't get pregnant" ///
 25 "Ramadan" ///
 26 "End of breastfeeding" ///
 27 "Period returned" ///
 29 "Changed method" ///
 30 "Husband wants her pregnant" ///
 31 "Afraid of forgetting method" ///
 32 "Afraid of using method" ///
 33 "Thinks she is pregnant" ///
 34 "Doctor's opinion" ///
 35 "Method not available" ///
 36 "Lack of sexual satisfaction" ///
 37 "Created menstrual problem" ///
 38 "Did not like method" ///
 39 "Lack of privacy" ///
 40 "Gained weight" ///
 41 "The absence of one condition of breastfeeding" ///
 42 "Expiration/lack of method" ///
 43 "Erectile dysfunction in husband" ///
 96 "Other" ///
 98 "Don't know" ///
 99 "Missing" ///
 -1 "***Unknown code not recoded***" 


* Now the actual recoding
* Method and pregnancy codes
if "`1'" != "" & "`1'" != "." { // input method variable given
  if "`2'" == "" | "`2'" == "." { // no result variable given
    di in red "Method variable `1' given, but no result variable given"
  }
  else
  {
	gen `2' = strpos(methodlist,`1') if `1' != "" & `1' != " "
	replace `2' = -1 if `2' == 0 & `1' != "0"
	label values `2' method
  }
}

* Discontinuation codes
if "`3'" != "" & "`3'" != "." { // input reason variable given
  if "`4'" == "" | "`4'" == "." { // no result variable given
    di in red "Reason for discontinuation variable `3' given, but no result variable given"
  }
  else
  {
	gen `4' = strpos(reasonlist,`3') if `3' != "" & `3' != " "
	replace `4' = -1 if `4' == 0 & `3' != "0"
	label values `4' reason
  }
}
