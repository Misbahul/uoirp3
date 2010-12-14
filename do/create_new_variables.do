// create_new_variables.do
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
global dofilename "create_new_variables"

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
use "${workdatapath}labeled_retention_data"

/*
	The big task of this file is to resolve the local vs. non-local
	problem. We have multiple ways to do this:
	
	1) Economic Region
	2) Postal Code
	3) School Board
	4) County Code
*/

label define loclbl 0 "Non-Local" 1 "Local"

// Economic Region
generate local1 = .
replace local1 = 1 if econ_region_origin == 3510 // Ottawa
replace local1 = 1 if econ_region_origin == 2460 // Outaouais
replace local1 = 0 if econ_region_origin != 3510 & econ_region_origin != 2460 & econ_region_origin < 99998

label variable local1 "Local Student (by Economic Region)"
label values local1 loclbl

// Postal Code
generate fsa3 = substr(POSTAL_CD,1,3)
preserve
clear
insheet using "${userdatapath}ottawa_postal_codes.txt", tab nonames
rename v1 fsa3
sort fsa3
save "${workdatapath}ottawa_postal_codes.dta", replace
restore
sort fsa3
merge fsa3 using "${workdatapath}ottawa_postal_codes.dta", uniqusing _merge(_ottpostalcodes)
tab _ottpostalcodes
drop if _ottpostalcodes==2 // Codes not in the data
recode _ottpostalcodes (1 = 0) (3 = 1)
rename _ottpostalcodes local2

label variable local2 "Local Student (by Postal Code)"
label values local2 loclbl

// School Board -- pending

// County
generate local4 = .
replace local4 = 1 if county == 6 // Ottawa-Carleton Regional Municipality
replace local4 = 1 if county == 181 // Communaute-Urbaine-de-L'Outaouais
replace local4 = 0 if county != 6 & county != 181 & !missing(county)

label variable local4 "Local Student (by County Code)"
label values local4 loclbl

forvalues i = 1/4 {
	local locvarname : variable label local`i'
	display "`locvarname'"
	tab local`i', missing
	local start = `i' + 1
	if `start' < 5 {
		forvalues j = `start'/4 {
			local locjname : variable label local`j'
			display "`locvarname' by `locjname'"
			tab local`i' local`j'
		}
	}
}

// High School Admission Average
generate admission_cat = .
replace admission_cat = 1	if	admission_avg >=	90	&	admission_avg	<=	100		// A+
replace admission_cat = 2	if	admission_avg >=	85	&	admission_avg	<	90		// A
replace admission_cat = 3	if	admission_avg >=	80	&	admission_avg	<	85		// A-
replace admission_cat = 4	if	admission_avg >=	75	&	admission_avg	<	80		// B+
replace admission_cat = 5	if	admission_avg >=	70	&	admission_avg	<	75		// B
replace admission_cat = 6	if	admission_avg >=	65	&	admission_avg	<	70		// C+
replace admission_cat = 7	if	admission_avg >=	60	&	admission_avg	<	65		// C
replace admission_cat = 8	if	admission_avg >=	55	&	admission_avg	<	60		// D+
replace admission_cat = 9	if	admission_avg >=	50	&	admission_avg	<	55		// D
replace admission_cat = 10	if	admission_avg >=	40	&	admission_avg	<	49		// E
replace admission_cat = 11	if	admission_avg >=	0	&	admission-avg	<	40		// F

label variable admission_cat "Admission Average (Categorical Letter Grade)"
label values admission_cat grade_codes

// uOttawa GPA
generate gpa_cat = .
replace gpa_cat = 1		if	cgpa >=		10	&	cgpa	<=	10	// A+
replace gpa_cat = 2		if	cgpa >=		9	&	cgpa	<	10	// A
replace gpa_cat = 3		if	cgpa >=		8	&	cgpa	<	9	// A
replace gpa_cat = 4		if	cgpa >=		7	&	cgpa	<	8	// B+
replace gpa_cat = 5		if	cgpa >=		6	&	cgpa	<	7	// B
replace gpa_cat = 6		if	cgpa >=		5	&	cgpa	<	6	// C+
replace gpa_cat = 7		if	cgpa >=		4	&	cgpa	<	5	// C
replace gpa_cat = 8		if	cgpa >=		3	&	cgpa	<	4	// D+
replace gpa_cat = 9		if	cgpa >=		2	&	cgpa	<	3	// D
replace gpa_cat = 10	if	cgpa >=		1	&	cgpa	<	2	// E
replace gpa_cat = 11	if	cgpa >=		0	&	cgpa	<	1	// F

label variable gpa_cat "University GPA (Categorical Letter Grade)"
label values gpa_cat grade_codes

save "${workdatapath}new_variable_data.dta"

log close
clear
