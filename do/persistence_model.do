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
	STEP 1: Create local macros.
*/

local basic_controls ""
forvalues i = 1998/2008 {
	local basic_controls "`basic_controls' cohort_`i'"
}
local bc_dum "`basic_controls' \"
local basic_controls "`basic_controls' prov_nl prov_pei prov_ns prov_nb prov_qc prov_mb prov_sk prov_ab prov_bc prov_nwt prov_yk prov_oth male"
local bc_dum "`bc_dum' prov_nl prov_pei prov_ns prov_nb prov_qc prov_mb prov_sk prov_ab prov_bc prov_nwt prov_yk prov_oth"
local lang1 "ml2_fr ml2_oth"
local lang2 "tl_fr tl_imm"
local lang3 "used_fr"
local admav_omit "admav_Aminus"
unab admav : admav_*
local admav : list admav - admav_omit
local prgm_omit "prgm_arts"
unab prgm : prgm_*
local prgm : list prgm - prgm_omit

/*
	STEP 2: Models
*/

foreach i of varlist cont2 cont3 uoreturn cgpa {
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

foreach i of varlist cont2 cont3 uoreturn {
	logit `i' `basic_controls'
	margeff, dummies(`bc_dum') replace
	forvalues j = 1/3 {
		logit `i' `basic_controls' `lang`j''
		margeff, dummies(`bc_dum' \ `lang`j'') replace
	}
	forvalues j = 1/3 {
		logit `i' `basic_controls' `lang1' local`j'
		margeff, dummies(`bc_dum' \ `lang1') replace
	}
	logit `i' `basic_controls' `lang1' local1
	margeff, dummies(`bc_dum' \ `lang1') replace
	logit `i' `basic_controls' `lang1' local1 `admav'
	margeff, dummies(`bc_dum' \ `lang1' \ `admav')
	logit `i' `basic_controls' `lang1' local1 `prgm'
	margeff, dummies(`bc_dum' \ `lang1' \ `prgm')
	logit `i' `basic_controls' `lang1' local1 `admav' `prgm'
	margeff, dummies(`bc_dum' \ `lang1' \ `admav' \ `prgm')
}

log close
clear
