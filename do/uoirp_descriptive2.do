// uoirp_descriptive2.do
set more off

/*
	10DEC2010: File created based on uoirp_descriptive1

	10DEC2010: File created based on template.do

	02DEC2010: File copied from L-SLIS files.

	09JUL09: File Created.
	Any introductory comments go here.
*/

/*
	Change the name here to reflect the new name of the do file.
	Stata will use this name in all the logs, etc.
*/
global dofilename "uoirp_descriptive2"

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


local cat_vars "imstat econ_region_origin apptype province credential_cd kind_of_program_cd"
local cat_vars "`cat_vars' mother_tongue main_subject1_cd ug_spec_level_cd er_province"
local cat_vars "`cat_vars' gender primary_org_cd cip_2digit prgm7 coop_ind"
local cat_vars "`cat_vars' used_tongue cont2 cont3 mat1320 mat1720 mat1330 mat1730 mat1300 mat1700"
local cat_vars "`cat_vars' eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501 math_highest"
local cat_vars "`cat_vars' english_highest french_highest philosophy_highest any_highest"
local cat_vars "`cat_vars' local1 local2 local3 admission_cat gpa_cat"

// local cat_vars "imstat"

/*
	STEP 3: Grade outcomes
	I'm going to use the univeristy GPA scores over the categories included here.
*/

local myrep "replace"
foreach i of varlist cohort `cat_vars' {
	local short_i = substr("`i'",1,30)
	display _newline as text "Processing variable " as result "`i'" as text "."
	uwmean cgpa `i', save("`outputdir'${dofilename}_step3.xls") `myrep' sheet("`short_i'") format((SCLR0) (SCCR0 NCCR2))
	local myrep "append"
} 

/*
	STEP 4: Grade outcomes by cohort
*/
local myrep "replace"
foreach i of varlist `cat_vars' {
	local short_i = substr("`i'",1,30)
	display _newline as text "Processing variable " as result "`i'" as text "."
	uwmean cgpa `i' cohort, save("`outputdir'${dofilename}_step4.xls") `myrep' sheet("`short_i'") format((SCLR0) (SCCR0 NCCR2))
	local myrep "append"
}

/*
	STEP 5: Retention outcomes.
	cont2 -- continue until second year
	cont3 -- continue until third year
		(there are students for whom cont2==0 and cont3==1)
	uoreturn -- either cont2 or cont3 == 1.
*/
clonevar uoreturn = cont2
replace uoreturn = 1 if cont3==1
label variable uoreturn "Returned to University of Ottawa"

local myrep "replace"
foreach j of varlist cont2 cont3 uoreturn {
	local short_j = substr("`j'",1,5)
	display _newline as text "Outcome variable " as result "`j'" as text "."
	foreach i of varlist cohort `cat_vars' {
		local short_i = substr("`i'",1,18) 
		display _newline as text "Processing variable " as result "`i'" as text "."
		uwtab `i' `j', row save("`outputdir'${dofilename}_step5.xls") `myrep' sheet("`short_i'_`short_j'")
		local myrep "append"
	} 
}

log close
clear
