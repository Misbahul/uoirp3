// uoirp_descriptive4.do
set more off

/*
	10MAY2011: File created based on uoirp_descriptive3.do

	01MAR2011: File created based on template.do
	

	02DEC2010: File copied from L-SLIS files.

	09JUL09: File Created.
	Any introductory comments go here.
*/

/*
	Change the name here to reflect the new name of the do file.
	Stata will use this name in all the logs, etc.
*/
local dofilename "uoirp_descriptive4"

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

// The big table of disciplines and required courses.

/*
	Actually, to pull this off I think I'm going to need another table making program.
*/

uwtab2 main_subject1_cd mat1320x mat1720x mat1330x mat1730x mat1300x mat1700x eng1100x eng1112x fra1528x fra1538x fra1710x phi1101x phi1501x no_key_course key_math key_eng key_fra key_phil key_math_eng key_math_fra key_math_phil key_eng_fra key_eng_phil key_fra_phil key_math_eng_fra key_math_eng_phil key_eng_fra_phil key_all, save( "`outputdir'`dofilename'_keycourses.xls") replace sheet( "key_courses") title( "Key Course Information, All Observations")

quietly levelsof cohort, local(cohortlist)

local myreplace "replace"
foreach i of local cohortlist {
	local cohort_name : label (cohort) `i'
	uwtab2 main_subject1_cd no_key_course if cohort==`i', save( "`outputdir'`dofilename'_missing_by_cohort.xls") `myreplace' sheet( "missing_`cohort_name'") title( "Missing Key Course for `cohort_name' Cohort")
	uwtab2 main_subject1_cd mat1320x mat1720x mat1330x mat1730x mat1300x mat1700x eng1100x eng1112x fra1528x fra1538x fra1710x phi1101x phi1501x no_key_course key_math key_eng key_fra key_phil key_math_eng key_math_fra key_math_phil key_eng_fra key_eng_phil key_fra_phil key_math_eng_fra key_math_eng_phil key_eng_fra_phil key_all if cohort==`i', save( "`outputdir'`dofilename'_full_by_cohort.xls") `myreplace' sheet( "bycohort_`cohort_name'") title( "Key Course Info for `cohort_name' Cohort")
	local myreplace "append"
} 

include do/footer.do


