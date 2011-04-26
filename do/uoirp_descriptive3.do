// uoirp_descriptive3.do
set more off

/*
	01MAR2011: File created based on template.do
	

	02DEC2010: File copied from L-SLIS files.

	09JUL09: File Created.
	Any introductory comments go here.
*/

/*
	Change the name here to reflect the new name of the do file.
	Stata will use this name in all the logs, etc.
*/
local dofilename "uoirp_descriptive3"

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

local outfile "`outputdir'`dofilename'.xls"

// Credential and main subject.
uwtab main_subject1_cd credential_cd, col row save(`outfile') replace sheet("Tab_1a") title("main_subject1_cd by credential_cd")
uwtab main_subject2_cd credential_cd, col row save(`outfile') append sheet("Tab_1b") title("main_subject2_cd by credential_cd")
uwtab j_main_subject1_cd credential_cd, col row save(`outfile') append sheet("Tab_1c") title("j_main_subject1_cd by credential_cd")
uwtab main_subject1_cd ug_spec_level_cd, col row save(`outfile') append sheet("Tab_2a") title("main_subject1_cd by ug_spec_level_cd")
uwtab main_subject2_cd ug_spec_level_cd, col row save(`outfile') append sheet("Tab_2b") title("main_subject2_cd by ug_spec_level_cd")
uwtab j_main_subject1_cd ug_spec_level_cd, col row save(`outfile') append sheet("Tab_2c") title("main_subject1_cd by ug_spec_level_cd")
uwtab prgm7 primary_org_cd, col row save(`outfile') append sheet("Tab_3a") title("prgm7 by primary_org_cd")
uwtab main_subject1_cd if prgm7==3 & primary_org_cd==1, col save(`outfile') append sheet("Tab_3b") title("Subject for Arts & ADMIN")
uwtab main_subject1_cd if prgm7==5 & primary_org_cd==2, col save(`outfile') append sheet("Tab_3c") title("Subject for Sciences & ARTS")
uwtab main_subject1_cd if prgm7==6 & primary_org_cd==2, col save(`outfile') append sheet("Tab_3d") title("Subject for Architecture and Engineering & ARTS")
uwtab main_subject1_cd if prgm7==7 & primary_org_cd==2, col save(`outfile') append sheet("Tab_3e") title("Subject for Health and Fitness & ARTS")
uwtab main_subject1_cd if prgm7==5 & primary_org_cd==3, col save(`outfile') append sheet("Tab_3f") title("Subject for Sciences & GENIE")
uwtab main_subject1_cd if prgm7==6 & primary_org_cd==4, col save(`outfile') append sheet("Tab_3g") title("Subject for Architecture and Engineering & SCIEN")
uwtab main_subject1_cd if prgm7==7 & primary_org_cd==4, col save(`outfile') append sheet("Tab_3h") title("Subject for Health and Fitness & SCIEN")
uwtab main_subject1_cd if prgm7==3 & primary_org_cd==5, col save(`outfile') append sheet("Tab_3i") title("Subject for Arts & SSAN")

local grades "gpa_cat mat1320 mat1720 mat1330 mat1730 mat1300 mat1700 eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501 math_highest english_highest french_highest philosophy_highest any_highest math_lowest english_lowest french_lowest philosophy_lowest any_lowest mat1320_rel1 mat1720_rel1 mat1330_rel1 mat1730_rel1 mat1300_rel1 mat1700_rel1 eng1100_rel1 eng1112_rel1 fra1528_rel1 fra1710_rel1 phi1101_rel1 phi1501_rel1 mat1320_rel2 mat1720_rel2 mat1330_rel2 mat1730_rel2 mat1300_rel2 mat1700_rel2 eng1100_rel2 eng1112_rel2 fra1528_rel2 fra1710_rel2 phi1101_rel2 phi1501_rel2 mat1320_rel3 mat1720_rel3 mat1330_rel3 mat1730_rel3 mat1300_rel3 mat1700_rel3 eng1100_rel3 eng1112_rel3 fra1528_rel3 fra1710_rel3 phi1101_rel3 phi1501_rel3 math_highest_rel1 math_lowest_rel1 english_highest_rel1 english_lowest_rel1 french_highest_rel1 french_lowest_rel1 philosophy_highest_rel1 philosophy_lowest_rel1 any_highest_rel1 any_lowest_rel1 math_highest_rel2 math_lowest_rel2 english_highest_rel2 english_lowest_rel2 french_highest_rel2 french_lowest_rel2 philosophy_highest_rel2 philosophy_lowest_rel2 any_highest_rel2 any_lowest_rel2 math_highest_rel3 math_lowest_rel3 english_highest_rel3 english_lowest_rel3 french_highest_rel3 french_lowest_rel3 philosophy_highest_rel3 philosophy_lowest_rel3 any_highest_rel3 any_lowest_rel3"

local outfile1 "`outputdir'`dofilename'_grades_by_faculty.xls"
local outfile2 "`outputdir'`dofilename'_grades_by_program.xls"

local myrep "replace"
foreach i of local grades {
	local sheet_name = substr("`i'",1,20)
	uwtab `i' primary_org_cd, col row save(`outfile1') `myrep' sheet("`sheet_name'") title("`i' by primary_org_cd")
	uwtab `i' prgm7, col row save(`outfile2') `myrep' sheet("`sheet_name'") title("`i' by prgm7")
	// uwtab `i' main_subject1_cd, col row save(`outfile') append sheet("Tab_4c_`i'") title("`i' by main_subject1_cd")
	local myrep "append"
}

// GPA distributions by continuier and leaver

local outfile3 "`outputdir'`dofilename'_gpa_by_leave.xls"
local grades2 "gpa_cat"

local myrep "replace"
foreach i of varlist cont2 cont3 uoreturn leave2 leave3 leave {
	foreach j of local grades2 {
		local sheet_name = substr("`j'_`i'",1,28)
		uwtab `j' `i', col row save(`outfile3') `myrep' sheet("`sheet_name'") title("`j' by leaving (`i')")
		local myrep "append"
	}
}

include do/footer.do
