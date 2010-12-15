// persistence_model.do
set more off

/*
	14DEC2010: File created based on template.do

	02DEC2010: File copied from L-SLIS files.

	09JUL09: File Created.
	Any introductory comments go here.
*/

/*
	Change the name here to reflect the new name of the do file.
	Stata will use this name in all the logs, etc.
*/
global dofilename "persistence_model"

/*
	header.do, which is called here, will log all the results of
	the do file into the appropriate directory.
	
	If you want an output directory, keep this file as is.
	Otherwise, uncomment the local makeoutput = 0 line.
*/
// local makeoutput = 1
local makeoutput = 0
include "do/header"

// Sample Command to load the data file.
use "${workdatapath}new_variable_data"

/*
	This file should start to get at the models.
	I'm not going to do anything fancy, just rely
	on Stata regression output.
*/

/*
	STEP 1: Create dummy variables.
*/

tabulate cohort, generate(cohort_)
forvalues i = 1/12 {
	local y = `i' + 1996
	rename cohort_`i' cohort_`y'
	label variable cohort_`y' "`y' Cohort"
}
describe cohort_*, fullnames

tabulate province, generate(prov_) missing
rename prov_1 prov_nl
rename prov_2 prov_pei
rename prov_3 prov_ns
rename prov_4 prov_nb
rename prov_5 prov_qc
rename prov_6 prov_on
rename prov_7 prov_mb
rename prov_8 prov_sk
rename prov_9 prov_ab
rename prov_10 prov_bc
rename prov_11 prov_nwt
rename prov_12 prov_yk
rename prov_13 prov_oth

clonevar male = gender

recode mother_tongue (19 = 1 "English") (51 = 2 "French") (nonmissing = 3 "Other"), generate(ml2)
label variable ml2 "Mother Tongue (3 categories)"
tabulate ml2, generate(ml2_)
rename ml2_1 ml2_en
rename ml2_2 ml2_fr
rename ml2_3 ml2_oth

tabulate princ_teaching_lng, generate(tl_)
rename tl_1 tl_en
rename tl_2 tl_fr
rename tl_3 tl_imm

clonevar used_fr = used_tongue

recode admission_cat (8/11 = 8 " Below C") (missing = 9 "Missing"), generate(admav)
label define admav 1 "A+" 2 "A" 3 "A-" 4 "B+" 5 "B" 6 "C+" 7 "C", add
tabulate admav, generate(admav_)
rename admav_1 admav_Aplus
rename admav_2 admav_A
rename admav_3 admav_Aminus
rename admav_4 admav_Bplus
rename admav_5 admav_B
rename admav_6 admav_Cplus
rename admav_7 admav_C
rename admav_8 admav_belowC
rename admav_9 admav_miss

tabulate prgm7, genrate(prgm_) missing
rename prgm_1 prgm_ed
rename prgm_2 prgm_vparts
rename prgm_3 prgm_arts
rename prgm_4 prgm_biz
rename prgm_5 prgm_sci
rename prgm_6 prgm_areng
rename prgm_7 prgm_health
rename prgm_8 prgm_oth

clonevar uoreturn = cont2
replace uoreturn = 1 if cont3==1
label variable uoreturn "Returned to University of Ottawa"

/*
	STEP 2: Models
*/
local basic_controls ""
forvalues i = 1998/2008 {
	local basic_controls "`basic_controls' cohort_`i'"
}
local basic_controls "`basic_controls' prov_nl prov_pei prov_ns prov_nb prov_qc prov_mb prov_sk prov_ab prov_bc prov_nwt prov_yk prov_oth male"
local lang1 "ml2_fr ml2_oth"
local lang2 "tl_fr tl_imm"
local lang3 "used_fr"
local admav_omit "admav_Aminus"
unab admav : admav_*
local admav : list admav - admav_omit
local prgm_omit "prgm_arts"
unab prgm : prgm_*
local prgm : list prgm - prgm_omit

foreach i of varlist cont2 cont3 uoreturn {
	regress `i' `basic_controls'
	forvalues j = 1/3 {
		regress `i' `basic_controls' `lang`j''
	}
	forvalues j = 1/3 {
		regress `i' `basic_controls' `lang1' local`j'
	}
	regress `i' `basic_controls' `lang1' local1
	regress `i' `basic_controls' `lang1' local1 `admav'
	regress `i' `basic_controls' `lang1' local1 `prgm'
	regress `i' `basic_controls' `lang1' local1 `admav' `prgm'	 
}

log close
clear
