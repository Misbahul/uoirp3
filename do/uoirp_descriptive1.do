// uoirp_descriptive1.do
set more off

/*
	10DEC2010: File created based on template.do

	02DEC2010: File copied from L-SLIS files.

	09JUL09: File Created.
	Any introductory comments go here.
*/

/*
	Change the name here to reflect the new name of the do file.
	Stata will use this name in all the logs, etc.
*/
global dofilename "uoirp_descriptive1"

/*
	header.do, which is called here, will log all the results of
	the do file into the appropriate directory.
	
	If you want an output directory, keep this file as is.
	Otherwise, uncomment the local makeoutput = 0 line.
*/
local makeoutput = 1
// local makeoutput = 0
include "do/header"

// Sample Command to load the data file.
use "${workdatapath}new_variable_data"

label define imstat_en_label 3 "Other Visa", modify
label define imstat_en_label 4 "Foreign Unknown", modify

/*
	STEP 1: Initial "Proc Freqs"
	i.e. Frequencies and Proportions of all the individual variables
	that make sense.
*/
local cat_vars "imstat econ_region_origin apptype province credential_cd kind_of_program_cd"
local cat_vars "`cat_vars' mother_tongue main_subject1_cd ug_spec_level_cd er_province"
local cat_vars "`cat_vars' gender primary_org_cd cip_2digit prgm7 coop_ind"
local cat_vars "`cat_vars' used_tongue cont2 cont3 mat1320 mat1720 mat1330 mat1730 mat1300 mat1700"
local cat_vars "`cat_vars' eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501 math_highest"
local cat_vars "`cat_vars' english_highest french_highest philosophy_highest any_highest"
local cat_vars "`cat_vars' math_lowest english_lowest french_lowest philosophy_lowest any_lowest"
local cat_vars "`cat_vars' local1 local2 local3 admission_cat gpa_cat"

// local cat_vars "imstat"

local myrep "replace"
foreach i of varlist cohort `cat_vars' {
	display _newline as text "Processing variable " as result "`i'" as text "."
	uwtab `i', col save("`outputdir'${dofilename}_step1.xls") `myrep' sheet("`i'")
	uwtab `i' if missing(cgpa), col save("`outputdir'${dofilename}_step1.xls") `myrep' sheet("`i'_nogpa")
	local myrep "append"
} 

/*
	STEP 2: "Proc Freqs" by cohort
*/
local myrep "replace"
foreach i of varlist `cat_vars' {
	display _newline as text "Processing variable " as result "`i'" as text "."
	uwtab `i' cohort, col row save("`outputdir'${dofilename}_step2.xls") `myrep' sheet("`i'")
	uwtab `i' cohort if missing(cgpa), col row save("`outputdir'${dofilename}_step2.xls") `myrep' sheet("`i'_nogpa")
	local myrep "append"
}

log close
clear
