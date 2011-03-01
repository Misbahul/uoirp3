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
global dofilename "uoirp_descriptive3"

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

local outfile "`outputdir'${dofilename}.xls"

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

local grades "gpa_cat mat1320 mat1720 mat1330 mat1730 mat1300 mat1700 eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501 math_highest english_highest french_highest philosophy_highest any_highest math_lowest english_lowest french_lowest philosophy_lowest any_lowest"

foreach i of local grades {
	uwtab `i' primary_org_cd, col row save(`outfile') append sheet("Tab_4a_`i'") title("`i' by primary_org_cd")
	uwtab `i' prgm7, col row save(`outfile') append sheet("Tab_4b_`i'") title("`i' by prgm7")
	// uwtab `i' main_subject1_cd, col row save(`outfile') append sheet("Tab_4c_`i'") title("`i' by main_subject1_cd")
}

log close
clear
