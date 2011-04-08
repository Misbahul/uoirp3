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
generate local3 = .
replace local3 = 1 if county == 6 // Ottawa-Carleton Regional Municipality
replace local3 = 1 if county == 181 // Communaute-Urbaine-de-L'Outaouais
replace local3 = 0 if county != 6 & county != 181 & !missing(county)

label variable local3 "Local Student (by County Code)"
label values local3 loclbl

forvalues i = 1/3 {
	local locvarname : variable label local`i'
	display "`locvarname'"
	tab local`i', missing
	local start = `i' + 1
	if `start' < 4 {
		forvalues j = `start'/3 {
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
replace admission_cat = 11	if	admission_avg >=	0	&	admission_avg	<	40		// F

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

/*
	Simplified Grade variables -- just letter grades
*/
foreach i of varlist gpa_cat mat1320 mat1720 mat1330 mat1730 mat1300 mat1700 eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501 english_highest english_lowest math_highest math_lowest french_highest french_lowest philosophy_highest philosophy_lowest any_highest any_lowest {
	recode `i' (1 2 3 = 1 "A") (4 5 = 2 "B") (6 7 = 3 "C") (8 9 = 4 "D") (10 = 5 "E") (11 = 6 "F"), generate(`i'_s)
	local var_lbl : variable label `i'
	label variable `i'_s "`var_lbl (simplified)"
}

/*
	Relative grade variable
	
	I guess this means relative to their overall grade.
	i.e gpa_cat
*/

label define grade_rel1 1 "Higher than GPA" 2 "Same as GPA" 3 "Lower than GPA"
label define grade_rel2 1 "3+ levels higher" 2 "2 levels higher" 3 "1 level higher" 4 "Same level" 5 "1 level lower" 6 "2 levels lower" 7 "3+ levels lower"
label define grade_rel3 1 "2+ letters higher" 2 "1 letter higher" 3 "Same letter" 4 "1 letter lower" 5 "2 letters lower"
foreach i of varlist mat1320 mat1720 mat1330 mat1730 mat1300 mat1700 eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501 english_highest english_lowest math_highest math_lowest french_highest french_lowest philosophy_highest philosophy_lowest any_highest any_lowest {
	local var_lbl : variable label `i'
	generate `i'_rel1 = .
	replace `i'_rel1 = 1 if `i' < gpa_cat & !missing(`i') & !missing(gpa_cat)
	replace `i'_rel1 = 2 if `i' == gpa_cat & !missing(`i') & !missing(gpa_cat)
	replace `i'_rel1 = 3 if `i' > gpa_cat & !missing(`i') & !missing(gpa_cat)
	label values `i'_rel1 grade_rel1
	label variable `i'_rel1 "`var_lbl (relative)"
	
	generate `i'_rel2 = .
	replace `i'_rel2 = 1 if (`i' - gpa_cat) > 2 & !missing(`i') & !missing(gpa_cat)
	replace `i'_rel2 = 2 if (`i' - gpa_cat) == 2 & !missing(`i') & !missing(gpa_cat)
	replace `i'_rel2 = 3 if (`i' - gpa_cat) == 1 & !missing(`i') & !missing(gpa_cat)
	replace `i'_rel2 = 4 if (`i' - gpa_cat) == 0 & !missing(`i') & !missing(gpa_cat)
	replace `i'_rel2 = 5 if (gpa_cat - `i') == 1 & !missing(`i') & !missing(gpa_cat)
	replace `i'_rel2 = 6 if (gpa_cat - `i') == 2 & !missing(`i') & !missing(gpa_cat)
	replace `i'_rel2 =76 if (gpa_cat - `i') > 2 & !missing(`i') & !missing(gpa_cat)
	label values `i'_rel2 grade_rel2
	label variable `i'_rel2 "`var_lbl (relative)"
	
	generate `i'_rel3 = .
	replace `i'_rel3 = 1 if (`i'_s - gpa_cat_s) > 1 & !missing(`i'_s) & !missing(gpa_cat_s)
	replace `i'_rel3 = 2 if (`i'_s - gpa_cat_s) == 1 & !missing(`i'_s) & !missing(gpa_cat_s)
	replace `i'_rel3 = 3 if (`i'_s - gpa_cat_s) == 0 & !missing(`i'_s) & !missing(gpa_cat_s)
	replace `i'_rel3 = 4 if (gpa_cat_s - `i'_s) == 1 & !missing(`i'_s) & !missing(gpa_cat_s)
	replace `i'_rel3 = 5 if (gpa_cat_s - `i'_s) > 1 & !missing(`i'_s) & !missing(gpa_cat_s)
	label values `i'_rel3 grade_rel3
	label variable `i'_rel3 "`var_lbl (relative)"
}




/*
	Regression dummy variables.
	(moved here from persistence_model.do on 07FEB2011.)
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

tabulate prgm7, generate(prgm_) missing
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

recode cont2 (1 = 0 "Continue") (0 = 1 "Leave"), generate(leave2)
recode cont3 (1 = 0 "Continue") (0 = 1 "Leave"), generate(leave3)
label variable leave2 "Left in Year 2"
label variable leave3 "left in Year 3"
clonevar leave = leave2
label variable leave "Left uOttawa"
replace leave = 1 if leave3==1

// Faculty
tabulate primary_org_cd, generate(faculty_)
rename faculty_1 faculty_admin
label faculty_admin "Admin"
rename faculty_2 faculty_arts
label faculty_arts "Arts"
rename faculty_3 faculty_genie
label faculty_genie "Engineering"
rename faculty_4 faculty_scien
label faculty_scien "Science"
rename faculty_5 faculty_ssan
label faculty_ssan "Health Sciences"
rename faculty_6 faculty_ssoc
label faculty_ssoc "Social Sciences"


save "${workdatapath}new_variable_data.dta", replace

log close
clear
