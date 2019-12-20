* DHS Calendar Tutorial - Example 2
* Last pregnancy, duration of pregnancy and method used before pregnancy

* download the model dataset for individual women's recode: "ZZIR62FL.DTA" 
* the model datasets are available at http://dhsprogram.com/data/download-model-datasets.cfm

* change to a working directory where the data are stored
* or add the full path to the 'use' command below
cd "E:\Self_GitKraken\DHS-Contraceptive-Calendar-Tutorial\ZZIR62DT"


* open the dataset to use, selecting just the variables we are going to use
use vcal_1 v000 v005 v007 v008 v017 v018 v019 v208 b3_01 using "ZZIR62FL.DTA", clear

