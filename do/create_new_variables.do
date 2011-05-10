// create_new_variables.do

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
local dofilename "create_new_variables"

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
use "`workdatapath'labeled_retention_data"

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
insheet using "`userdatapath'ottawa_postal_codes.txt", tab nonames
rename v1 fsa3
sort fsa3
save "`workdatapath'ottawa_postal_codes.dta", replace
restore
sort fsa3
merge fsa3 using "`workdatapath'ottawa_postal_codes.dta", uniqusing _merge(_ottpostalcodes)
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
foreach i of varlist gpa_cat mat1320 mat1720 mat1330 mat1730 mat1300 mat1700 eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501 eng_hi eng_ho math_hi math_ho fre_hi fre_ho phil_hi phil_ho any_hi any_ho {
	recode `i' (1 2 3 = 1 "A") (4 5 = 2 "B") (6 7 = 3 "C") (8 9 = 4 "D") (10 = 5 "E") (11 = 6 "F"), generate(`i'_s)
	local var_lbl : variable label `i'
	label variable `i'_s "`var_lbl' (simplified)"
}

/*
	Relative grade variable
	
	I guess this means relative to their overall grade.
	i.e gpa_cat
*/

label define grade_rel1 1 "Higher than GPA" 2 "Same as GPA" 3 "Lower than GPA"
label define grade_rel2 1 "3+ levels higher" 2 "2 levels higher" 3 "1 level higher" 4 "Same level" 5 "1 level lower" 6 "2 levels lower" 7 "3+ levels lower"
label define grade_rel3 1 "2+ letters higher" 2 "1 letter higher" 3 "Same letter" 4 "1 letter lower" 5 "2 letters lower"
foreach i of varlist mat1320 mat1720 mat1330 mat1730 mat1300 mat1700 eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501 eng_hi eng_ho math_hi math_ho fre_hi fre_ho phil_hi phil_ho any_hi any_ho {
	local var_lbl : variable label `i'
	generate `i'_rel1 = .
	replace `i'_rel1 = 1 if `i' < gpa_cat & !missing(`i') & !missing(gpa_cat)
	replace `i'_rel1 = 2 if `i' == gpa_cat & !missing(`i') & !missing(gpa_cat)
	replace `i'_rel1 = 3 if `i' > gpa_cat & !missing(`i') & !missing(gpa_cat)
	label values `i'_rel1 grade_rel1
	label variable `i'_rel1 "`var_lbl' (relative)"
	
	generate `i'_rel2 = .
	replace `i'_rel2 = 1 if (`i' - gpa_cat) > 2 & !missing(`i') & !missing(gpa_cat)
	replace `i'_rel2 = 2 if (`i' - gpa_cat) == 2 & !missing(`i') & !missing(gpa_cat)
	replace `i'_rel2 = 3 if (`i' - gpa_cat) == 1 & !missing(`i') & !missing(gpa_cat)
	replace `i'_rel2 = 4 if (`i' - gpa_cat) == 0 & !missing(`i') & !missing(gpa_cat)
	replace `i'_rel2 = 5 if (gpa_cat - `i') == 1 & !missing(`i') & !missing(gpa_cat)
	replace `i'_rel2 = 6 if (gpa_cat - `i') == 2 & !missing(`i') & !missing(gpa_cat)
	replace `i'_rel2 = 7 if (gpa_cat - `i') > 2 & !missing(`i') & !missing(gpa_cat)
	label values `i'_rel2 grade_rel2
	label variable `i'_rel2 "`var_lbl' (relative)"
	
	generate `i'_rel3 = .
	replace `i'_rel3 = 1 if (`i'_s - gpa_cat_s) > 1 & !missing(`i'_s) & !missing(gpa_cat_s)
	replace `i'_rel3 = 2 if (`i'_s - gpa_cat_s) == 1 & !missing(`i'_s) & !missing(gpa_cat_s)
	replace `i'_rel3 = 3 if (`i'_s - gpa_cat_s) == 0 & !missing(`i'_s) & !missing(gpa_cat_s)
	replace `i'_rel3 = 4 if (gpa_cat_s - `i'_s) == 1 & !missing(`i'_s) & !missing(gpa_cat_s)
	replace `i'_rel3 = 5 if (gpa_cat_s - `i'_s) > 1 & !missing(`i'_s) & !missing(gpa_cat_s)
	label values `i'_rel3 grade_rel3
	label variable `i'_rel3 "`var_lbl' (relative)"
}




/*
	Regression dummy variables.
	(moved here from persistence_model.do on 07FEB2011.)
*/

tabulate cohort, generate(cohort_)
forvalues i = 1/13 {
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

recode admission_cat (7/11 = 7 "C or Below") (missing = 8 "Missing"), generate(admav)
label define admav 1 "A+" 2 "A" 3 "A-" 4 "B+" 5 "B" 6 "C+", add
tabulate admav, generate(admav_)
rename admav_1 admav_Aplus
rename admav_2 admav_A
rename admav_3 admav_Aminus
rename admav_4 admav_Bplus
rename admav_5 admav_B
rename admav_6 admav_Cplus
rename admav_7 admav_Cbelow
rename admav_8 admav_miss
label variable admav_Aplus "Admission Average A+"
label variable admav_A "Admission Average A"
label variable admav_Aminus "Admission Average A-"
label variable admav_Bplus "Admission Average B+"
label variable admav_B "Admission Average B"
label variable admav_Cplus "Admission Average C+"
label variable admav_Cbelow "Admission Average C or Below"
label variable admav_miss "Admission Average Missing"

foreach i of varlist gpa_cat mat1320 mat1720 mat1330 mat1730 mat1300 mat1700 eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501 eng_hi eng_ho math_hi math_ho fre_hi fre_ho phil_hi phil_ho any_hi any_ho {
	local var_lbl : variable label `i'
	recode `i' (8/11 = 8 " Below C") (missing = 9 "Missing"), generate(`i'_dum)
	label values `i'_dum admav
	tabulate `i'_dum, generate(`i'_dum_)
	rename `i'_dum_1 `i'_dum_Aplus
	rename `i'_dum_2 `i'_dum_A
	rename `i'_dum_3 `i'_dum_Aminus
	rename `i'_dum_4 `i'_dum_Bplus
	rename `i'_dum_5 `i'_dum_B
	rename `i'_dum_6 `i'_dum_Cplus
	rename `i'_dum_7 `i'_dum_C
	rename `i'_dum_8 `i'_dum_belowC
	rename `i'_dum_9 `i'_dum_miss
	label variable `i'_dum_Aplus "`var_lbl' A+"
	label variable `i'_dum_A "`var_lbl' A"
	label variable `i'_dum_Aminus "`var_lbl' A-"
	label variable `i'_dum_Bplus "`var_lbl' B+"
	label variable `i'_dum_B "`var_lbl' B"
	label variable `i'_dum_Cplus "`var_lbl' C+"
	label variable `i'_dum_C "`var_lbl' C"
	label variable `i'_dum_belowC "`var_lbl' Below C"
	label variable `i'_dum_miss "`var_lbl' Missing"
} 

foreach i of varlist mat1320 mat1720 mat1330 mat1730 mat1300 mat1700 eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501 eng_hi eng_ho math_hi math_ho fre_hi fre_ho phil_hi phil_ho any_hi any_ho {
	local var_lbl : variable label `i'
	tabulate `i'_rel1, generate(`i'_rel1_)
	rename `i'_rel1_1 `i'_rel1_higher
	rename `i'_rel1_2 `i'_rel1_same
	rename `i'_rel1_3 `i'_rel1_lower
	label variable `i'_rel1_higher "`var_lbl' Higher than GPA"
	label variable `i'_rel1_same "`var_lbl' Same as GPA"
	label variable `i'_rel1_lower "`var_lbl' Lower than GPA"
	
	tabulate `i'_rel2, generate(`i'_rel2_)
	rename `i'_rel2_1 `i'_rel2_3higher
	rename `i'_rel2_2 `i'_rel2_2higher
	rename `i'_rel2_3 `i'_rel2_1higher
	rename `i'_rel2_4 `i'_rel2_same
	rename `i'_rel2_5 `i'_rel2_1lower
	rename `i'_rel2_6 `i'_rel2_2lower
	rename `i'_rel2_7 `i'_rel2_3lower
	label variable `i'_rel2_3higher "`var_lbl 3 Levels Higher than GPA"
	label variable `i'_rel2_2higher "`var_lbl 2 Levels Higher than GPA"
	label variable `i'_rel2_1higher "`var_lbl 1 Level Higher than GPA"
	label variable `i'_rel2_same "`var_lbl' Same as GPA"
	label variable `i'_rel2_1lower "`var_lbl' 1 Level Lower than GPA"
	label variable `i'_rel2_2lower "`var_lbl' 2 Levels Lower than GPA"
	label variable `i'_rel2_3lower "`var_lbl' 3 Levels Lower than GPA"
	
	tabulate `i'_rel3, generate(`i'_rel3_)
	rename `i'_rel3_1 `i'_rel3_2higher
	rename `i'_rel3_2 `i'_rel3_1higher
	rename `i'_rel3_3 `i'_rel3_same
	rename `i'_rel3_4 `i'_rel3_1lower
	rename `i'_rel3_5 `i'_rel3_2lower
	label variable `i'_rel3_2higher "`var_lbl 2 Levels Higher than GPA"
	label variable `i'_rel3_1higher "`var_lbl 1 Level Higher than GPA"
	label variable `i'_rel3_same "`var_lbl' Same as GPA"
	label variable `i'_rel3_1lower "`var_lbl' 1 Level Lower than GPA"
	label variable `i'_rel3_2lower "`var_lbl' 2 Levels Lower than GPA"
}

foreach i of varlist mat1320 mat1720 mat1330 mat1730 mat1300 mat1700 eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501 { 
	local var_lbl : variable label `i'
	recode `i' (1/max = 1) (missing = 0), generate(`i'x)
	label variable `i'x "Took `var_lbl'"
	label define `i'x 0 "Did not take `var_lbl'" 1 "Took `var_label'"
	label values `i'x `i'x
}
	
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
replace uoreturn = . if missing(cont3)
label variable uoreturn "Returned to University of Ottawa"

recode cont2 (1 = 0 "Continue") (0 = 1 "Leave"), generate(leave2)
recode cont3 (1 = 0 "Continue") (0 = 1 "Leave"), generate(leave3)
label variable leave2 "Left in Year 2"
label variable leave3 "left in Year 3"
clonevar leave = leave2
label variable leave "Left uOttawa"
replace leave = 1 if leave3==1
replace leave = . if missing(leave3)

// Faculty
tabulate primary_org_cd, generate(faculty_)
rename faculty_1 faculty_admin
label variable faculty_admin "Admin"
rename faculty_2 faculty_arts
label variable faculty_arts "Arts"
rename faculty_3 faculty_genie
label variable faculty_genie "Engineering"
rename faculty_4 faculty_scien
label variable faculty_scien "Science"
rename faculty_5 faculty_ssan
label variable faculty_ssan "Health Sciences"
rename faculty_6 faculty_ssoc
label variable faculty_ssoc "Social Sciences"

recode age (15/17 = 1 "Below 18") (18 = 2 "18") (19 = 3 "19") (20/22 = 4 "20-22") (23/26 = 5 "23-26") (27/max = 6 "27 and above"), generate(agecat)
label variable agecat "Entry Age (categorical)"
tabulate agecat, generate(agecat_)
rename agecat_1 agecat_17
label variable agecat_17 "Entry Age Below 18"
rename agecat_2 agecat_18
label variable agecat_18 "Entry Age 18"
rename agecat_3 agecat_19
label variable agecat_19 "Entry Age 19"
rename agecat_4 agecat_22
label variable agecat_22 "Entry Age 20-22"
rename agecat_5 agecat_26
label variable agecat_26 "Entry Age 23-26"
rename agecat_6 agecat_27
label variable agecat_27 "Entry Age 27 and above"

label define relsession 1 "Fall Y1" 2 "Winter Y1" 3 "Spring Y1" 4 "Fall Y2" 5 "Winter Y2" 6 "Spring Y2" 7 "Y3 and later"
foreach i of varlist mat1320 mat1720 mat1330 mat1730 mat1300 mat1700 eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501 {
	generate `i'_relsession = `i'_session - session_date
	recode `i'_relsession (0 = 1) (1/4 = 2) (5/8 = 3) (9/12 = 4) (13/16 = 5) (17/20 = 6) (21/max = 7) (missing = .), generate(`i'_relsession2)
	drop `i'_relsession
	rename `i'_relsession2 `i'_relsession
	label values `i'_relsession relsession
	label variable `i'_relsession "`i' session (terms relative to cohort)"
} 

foreach i of varlist mat1320 mat1720 mat1330 mat1730 mat1300 mat1700 eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501 {
	clonevar `i'_fall = `i'
	clonevar `i'_y1 = `i'
	replace `i'_fall = .x if `i'_relsession > 1
	replace `i'_y1 = .x if `i'_relsession > 3
}

foreach i in _fall _y1 {
	// Highest in each category
	egen math_hi`i' = rowmin(mat1320`i' mat1720`i' mat1330`i' mat1730`i' mat1300`i' mat1700`i')
	label values math_hi`i' grade_codes
	tabulate math_hi`i', missing

	egen eng_hi`i' = rowmin(eng1100`i' eng1112`i')
	label values eng_hi`i' grade_codes
	tabulate eng_hi`i', missing

	egen fre_hi`i' = rowmin(fra1528`i' fra1538`i' fra1710`i')
	label values fre_hi`i' grade_codes
	tabulate fre_hi`i', missing

	egen phil_hi`i' = rowmin(phi1101`i' phi1501`i')
	label values phil_hi`i' grade_codes
	tabulate phil_hi`i', missing

	egen enfr_hi`i' = rowmax(eng1100`i' eng1112`i' fra1528`i' fra1538`i' fra1710`i')
	label values enfr_hi`i' grade_codes
	tabulate enfr_hi`i', missing

	egen any_hi`i' = rowmin(mat1320`i' mat1720`i' mat1330`i' mat1730`i' mat1300`i' mat1700`i' eng1100`i' eng1112`i' fra1528`i' fra1538`i' fra1710`i' phi1101`i' phi1501`i')
	label values any_hi`i' grade_codes
	tabulate any_hi`i', missing

	// Lowest in each category
	egen math_ho`i' = rowmax(mat1320`i' mat1720`i' mat1330`i' mat1730`i' mat1300`i' mat1700`i')
	label values math_ho`i' grade_codes
	tabulate math_hi`i', missing

	egen eng_ho`i' = rowmax(eng1100`i' eng1112`i')
	label values eng_ho`i' grade_codes
	tabulate eng_ho`i', missing

	egen fre_ho`i' = rowmax(fra1528`i' fra1538`i' fra1710`i')
	label values fre_ho`i' grade_codes
	tabulate fre_ho`i', missing

	egen phil_ho`i' = rowmax(phi1101`i' phi1501`i')
	label values phil_ho`i' grade_codes
	tabulate phil_ho`i', missing

	egen enfr_ho`i' = rowmin(eng1100`i' eng1112`i' fra1528`i' fra1538`i' fra1710`i')
	label values enfr_ho`i' grade_codes
	tabulate enfr_ho`i', missing

	egen any_ho`i' = rowmax(mat1320`i' mat1720`i' mat1330`i' mat1730`i' mat1300`i' mat1700`i' eng1100`i' eng1112`i' fra1528`i' fra1538`i' fra1710`i' phi1101`i' phi1501`i')
	label values any_ho`i' grade_codes
	tabulate any_ho`i', missing
	
	foreach j of varlist mat1320`i' mat1720`i' mat1330`i' mat1730`i' mat1300`i' mat1700`i' eng1100`i' eng1112`i' fra1528`i' fra1538`i' fra1710`i' phi1101`i' phi1501`i' eng_hi`i' eng_ho`i' math_hi`i' math_ho`i' fre_hi`i' fre_ho`i' phil_hi`i' phil_ho`i' any_hi`i' any_ho`i' {
		local var_lbl : variable label `j'
		recode `j' (8/11 = 8 " Below C") (missing = 9 "Missing"), generate(`j'_dum)
		label values `j'_dum admav
		tabulate `j'_dum, generate(`j'_dum_)
		rename `j'_dum_1 `j'_dum_Aplus
		rename `j'_dum_2 `j'_dum_A
		rename `j'_dum_3 `j'_dum_Aminus
		rename `j'_dum_4 `j'_dum_Bplus
		rename `j'_dum_5 `j'_dum_B
		rename `j'_dum_6 `j'_dum_Cplus
		rename `j'_dum_7 `j'_dum_C
		rename `j'_dum_8 `j'_dum_belowC
		rename `j'_dum_9 `j'_dum_miss
		label variable `j'_dum_Aplus "`var_lbl' A+"
		label variable `j'_dum_A "`var_lbl' A"
		label variable `j'_dum_Aminus "`var_lbl' A-"
		label variable `j'_dum_Bplus "`var_lbl' B+"
		label variable `j'_dum_B "`var_lbl' B"
		label variable `j'_dum_Cplus "`var_lbl' C+"
		label variable `j'_dum_C "`var_lbl' C"
		label variable `j'_dum_belowC "`var_lbl' Below C"
		label variable `j'_dum_miss "`var_lbl' Missing"
	}
	
}

foreach i of varlist session_*_awards gov_grant_s* gov_loan_s* {
	local varlbl : variable label `i'
	recode `i' (1/999.99 = 1 "Below 1 000") (1000/1999.99 = 2 "1 000-2 000") (2000/3999.99 = 3 "2 000-4 000") (4000/5999.99 = 4 "4 000-6 000") (6000/9999.99 = 5 "6 000-10 000") (10000/max = 6 "10 000 and up") (missing = 0 "No Award"), generate(`i'_cat)
	tabulate `i'_cat, generate(`i'_cat_)
	rename `i'_cat_1 `i'_cat_noaward
	rename `i'_cat_2 `i'_cat_1000
	rename `i'_cat_3 `i'_cat_2000
	rename `i'_cat_4 `i'_cat_4000
	rename `i'_cat_5 `i'_cat_6000
	rename `i'_cat_6 `i'_cat_10000
	capture rename `i'_cat_7 `i'_cat_max
	label variable `i'_cat_noaward "varlbl' No Award"
	label variable `i'_cat_1000 "`varlbl' Below 1 000"
	label variable `i'_cat_2000 "`varlbl' 1 000 to 2 000"
	label variable `i'_cat_4000 "`varlbl' 2 000 to 4 000"
	label variable `i'_cat_6000 "`varlbl' 4 000 to 6 000"
	label variable `i'_cat_10000 "`varlbl' 6 000 to 10 000"
	capture label variable `i'_cat_max "`varlbl' 10 000 and up"
}
set trace off

save "`workdatapath'new_variable_data.dta", replace

include do/footer.do

