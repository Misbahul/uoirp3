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
local dofilename "uoirp_descriptive2"

/*
	header.do, which is called here, will log all the results of
	the do file into the appropriate directory.
	
	If you want an output directory, keep this file as is.
	Otherwise, uncomment the local makeoutput = 0 line.
*/
local makeoutput = 1
// local makeoutput = 0
include do/header.do

// Sample Command to load the data file.
use "`workdatapath'new_variable_data"


local cat_vars "imstat econ_region_origin apptype province credential_cd kind_of_program_cd"
local cat_vars "`cat_vars' mother_tongue main_subject1_cd ug_spec_level_cd er_province"
local cat_vars "`cat_vars' gender primary_org_cd cip_2digit prgm7 coop_ind"
local cat_vars "`cat_vars' used_tongue cont2 cont3 mat1320 mat1720 mat1330 mat1730 mat1300 mat1700"
local cat_vars "`cat_vars' eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501 math_highest"
local cat_vars "`cat_vars' eng_highest fre_highest phil_highest any_highest"
local cat_vars "`cat_vars' math_lowest eng_lowest fre_lowest phil_lowest any_lowest"
local cat_vars "`cat_vars' mat1320_y1 mat1720_y1 mat1330_y1 mat1730_y1 mat1300_y1 mat1700_y1"
local cat_vars "`cat_vars' eng1100_y1 eng1112_y1 fra1528_y1 fra1538_y1 fra1710_y1 phi1101_y1 phi1501_y1 math_highest_y1"
local cat_vars "`cat_vars' eng_highest_y1 fre_highest_y1 phil_highest_y1 any_highest_y1"
local cat_vars "`cat_vars' math_lowest_y1 eng_lowest_y1 fre_lowest_y1 phil_lowest_y1 any_lowest_y1"
local cat_vars "`cat_vars' mat1320_fall mat1720_fall mat1330_fall mat1730_fall mat1300_fall mat1700_fall"
local cat_vars "`cat_vars' eng1100_fall eng1112_fall fra1528_fall fra1538_fall fra1710_fall phi1101_fall phi1501_fall math_highest_fall"
local cat_vars "`cat_vars' eng_highest_fall fre_highest_fall phil_highest_fall any_highest_fall"
local cat_vars "`cat_vars' math_lowest_fall eng_lowest_fall fre_lowest_fall phil_lowest_fall any_lowest_fall"
local cat_vars "`cat_vars' mat1320_rel1 mat1720_rel1 mat1330_rel1 mat1730_rel1 mat1300_rel1 mat1700_rel1 eng1100_rel1 eng1112_rel1 fra1528_rel1 fra1710_rel1 phi1101_rel1 phi1501_rel1"
local cat_vars "`cat_vars' mat1320_rel2 mat1720_rel2 mat1330_rel2 mat1730_rel2 mat1300_rel2 mat1700_rel2 eng1100_rel2 eng1112_rel2 fra1528_rel2 fra1710_rel2 phi1101_rel2 phi1501_rel2"
local cat_vars "`cat_vars' mat1320_rel3 mat1720_rel3 mat1330_rel3 mat1730_rel3 mat1300_rel3 mat1700_rel3 eng1100_rel3 eng1112_rel3 fra1528_rel3 fra1710_rel3 phi1101_rel3 phi1501_rel3"
local cat_vars "`cat_vars' math_highest_rel1 math_lowest_rel1 eng_highest_rel1 eng_lowest_rel1 fre_highest_rel1 fre_lowest_rel1 phil_highest_rel1 phil_lowest_rel1 any_highest_rel1 any_lowest_rel1"
local cat_vars "`cat_vars' math_highest_rel2 math_lowest_rel2 eng_highest_rel2 eng_lowest_rel2 fre_highest_rel2 fre_lowest_rel2 phil_highest_rel2 phil_lowest_rel2 any_highest_rel2 any_lowest_rel2"
local cat_vars "`cat_vars' local1 local2 local3 admission_cat gpa_cat"
/*
	local cat_vars "`cat_vars' mat1320_session mat1720_session mat1330_session mat1730_session mat1300_session"
	local cat_vars "`cat_vars' mat1700_session eng1100_session eng1112_session fra1528_session fra1538_session"
	local cat_vars "`cat_vars' fra1710_session phi1101_session phi1501_session"
*/
local cat_vars "`cat_vars' mat1320_relsession mat1720_relsession mat1330_relsession mat1730_relsession mat1300_relsession"
local cat_vars "`cat_vars' mat1700_relsession eng1100_relsession eng1112_relsession fra1528_relsession fra1538_relsession"
local cat_vars "`cat_vars' fra1710_relsession phi1101_relsession phi1501_relsession"
local cat_vars "`cat_vars' session_1_awards_cat session_2_awards_cat"
local cat_vars "`cat_vars' gov_grant_s1_cat gov_loan_s1_cat"
local cat_vars "`cat_vars' gov_grant_s2_cat gov_loan_s2_cat"


// local cat_vars "imstat"

/*
	STEP 3: Grade outcomes
	I'm going to use the univeristy GPA scores over the categories included here.
*/


local myrep "replace"
foreach i of varlist cohort `cat_vars' {
	local short_i = substr("`i'",1,30)
	local var_lbl : variable label `i'
	local var_out "`var_lbl' (`i')"
	display _newline as text "Processing variable " as result "`var_out'" as text "."
	uwmean cgpa `i', save("`outputdir'`dofilename'_step3.xls") `myrep' sheet("`short_i'") format((SCLR0) (SCCR0 NCCR2)) title( "Mean GPA by `var_out'")
	local myrep "append"
} 


/*
	STEP 4: Grade outcomes by cohort
*/

local myrep "replace"
foreach i of varlist `cat_vars' {
	local short_i = substr("`i'",1,30)
	local var_lbl : variable label `i'
	local var_out "`var_lbl' (`i')"
	display _newline as text "Processing variable " as result "`var_out'" as text "."
	uwmean cgpa `i' cohort, save("`outputdir'`dofilename'_step4.xls") `myrep' sheet("`short_i'") format((SCLR0) (SCCR0 NCCR2))  title( "Mean GPA by Cohort by `var_out'")
	local myrep "append"
}


/*
	STEP 5: Retention outcomes.
	leave2 -- leave before second year
	leave3 -- leave before third year
	leave -- either leave2 or leave3 == 1
*/


foreach j of varlist leave2 leave3 leave {
	local myrep "replace"
	local short_j = substr("`j'",1,7)
	local outcome_lbl : variable label `j'
	local outcome_out "`outcome_lbl' (`j')"
	display _newline as text "Outcome variable " as result "`outcome_out'" as text "."
	foreach i of varlist cohort `cat_vars' {
		local short_i = substr("`i'",1,18) 
		local var_lbl : variable label `i'
		local var_out "`var_lbl' (`i')"
		display _newline as text "Processing variable " as result "`var_out'" as text "."
		uwtab `i' `j', row save("`outputdir'`dofilename'_step5_`short_j'.xls") `myrep' sheet("`short_i'") title( "`outcome_out' by `var_out'")
		local myrep "append"
	} 
}

include do/footer.do
