// uoirp_descriptive_test.do
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
local dofilename "uoirp_descriptive_test"

/*
	header.do, which is called here, will log all the results of
	the do file into the appropriate directory.
	
	If you want an output directory, keep this file as is.
	Otherwise, uncomment the local makeoutput = 0 line.
*/
local makeoutput = 1
// local makeoutput = 0
include do\header.do

// Sample Command to load the data file.
use "`workdatapath'new_variable_data"

label define imstat_en_label 3 "Other Visa", modify
label define imstat_en_label 4 "Foreign Unknown", modify

/*
	STEP 1: Initial "Proc Freqs"
	i.e. Frequencies and Proportions of all the individual variables
	that make sense.
*/
local cat_vars "imstat econ_region_origin apptype province credential_cd kind_of_program_cd"
local cat_vars "`cat_vars' mother_tongue main_subject1_cd ug_spec_level_cd er_province"
local cat_vars "`cat_vars' primary_org_cd cip_2digit prgm7 coop_ind"
local cat_vars "`cat_vars' used_tongue cont2 cont3 mat1320 mat1720 mat1330 mat1730 mat1300 mat1700"
local cat_vars "`cat_vars' eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501 math_hi"
local cat_vars "`cat_vars' eng_hi fre_hi phil_hi any_hi"
local cat_vars "`cat_vars' math_lo eng_lo fre_lo phil_lo any_lo"
local cat_vars "`cat_vars' mat1320_rel1 mat1720_rel1 mat1330_rel1 mat1730_rel1 mat1300_rel1 mat1700_rel1 eng1100_rel1 eng1112_rel1 fra1528_rel1 fra1710_rel1 phi1101_rel1 phi1501_rel1"
local cat_vars "`cat_vars' mat1320_rel2 mat1720_rel2 mat1330_rel2 mat1730_rel2 mat1300_rel2 mat1700_rel2 eng1100_rel2 eng1112_rel2 fra1528_rel2 fra1710_rel2 phi1101_rel2 phi1501_rel2"
local cat_vars "`cat_vars' mat1320_rel3 mat1720_rel3 mat1330_rel3 mat1730_rel3 mat1300_rel3 mat1700_rel3 eng1100_rel3 eng1112_rel3 fra1528_rel3 fra1710_rel3 phi1101_rel3 phi1501_rel3"
local cat_vars "`cat_vars' math_hi_rel1 math_lo_rel1 eng_hi_rel1 eng_lo_rel1 fre_hi_rel1 fre_lo_rel1 phil_hi_rel1 phil_lo_rel1 any_hi_rel1 any_lo_rel1"
local cat_vars "`cat_vars' math_hi_rel2 math_lo_rel2 eng_hi_rel2 eng_lo_rel2 fre_hi_rel2 fre_lo_rel2 phil_hi_rel2 phil_lo_rel2 any_hi_rel2 any_lo_rel2"
local cat_vars "`cat_vars' math_hi_rel3 math_lo_rel3 eng_hi_rel3 eng_lo_rel3 fre_hi_rel3 fre_lo_rel3 phil_hi_rel3 phil_lo_rel3 any_hi_rel3 any_lo_rel3"
local cat_vars "`cat_vars' local1 local2 local3 admission_cat gpa_cat"

// local cat_vars "imstat"

/*
	STEP 2: "Proc Freqs" by cohort
*/
local myrep "replace"
foreach i of varlist `cat_vars' {
	display _newline as text "Processing variable " as result "`i'" as text "."
	uwtab `i' gender, col row save("`outputdir'`dofilename'_step2.xls") `myrep' sheet("`i'")
	uwtab `i' gender if missing(cgpa), col row save("`outputdir'`dofilename'_step2.xls") `myrep' sheet("`i'_nogpa")
	local myrep "append"
}

include do/footer.do
