// label_institutional_data.do
set more off

/*
	02DEC2010: File copied from L-SLIS files.

	09JUL09: File Created.
	Any introductory comments go here.
*/

/*
	Change the name here to reflect the new name of the do file.
	Stata will use this name in all the logs, etc.
*/
global dofilename "label_institutional_data"

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
use "${workdatapath}initial_retention_data"

// APPTYPE
include do/apptype_codes.do
encode DIR_ENTRY_APPTYPE, generate(apptype) label(apptype_codes)
include do/apptype_en_label.do
label values apptype apptype_en_label

tabulate apptype, missing

// COUNTY
/*
	This one is made a bit difficult because we don't know
	the province. We have to figure it out from other information.
	
	We know the Postal Code, and if the first letter is "G" or "J",
	then the student is from Québec.
*/
generate fsa1 = substr(POSTAL_CD,1,1)
generate province = .
replace province = 10 if fsa1=="A"	// Newfoundland and Labrador
replace province = 12 if fsa1=="B"	// Nova Soctia
replace province = 11 if fsa1=="C"	// Prince Edward Island
replace province = 13 if fsa1=="E"	// New Brunswick
replace province = 24 if fsa1=="G"	// Eastern Québec
replace province = 24 if fsa1=="H"	// Metro Montréal
replace province = 24 if fsa1=="J"	// Western Québec
replace province = 35 if fsa1=="K"	// Eastern Ontario
replace province = 35 if fsa1=="L"	// Central Ontario
replace province = 35 if fsa1=="M"	// Metro Toronto
replace province = 35 if fsa1=="N"	// Southwestern Ontario
replace province = 35 if fsa1=="P"	// Nothern Ontario
replace province = 46 if fsa1=="R"	// Manitoba
replace province = 47 if fsa1=="S"	// Saskatchewan
replace province = 48 if fsa1=="T"	// Alberta
replace province = 59 if fsa1=="V"	// British Columbia
replace province = 60 if fsa1=="X"	// NWT & Nunavut
replace province = 61 if fsa1=="Y"	// Yukon

label define province 10 "Newfoundland and Labrador", add
label define province 11 "Prince Edward Island", add
label define province 12 "Nova Scotia", add
label define province 13 "New Brunswick", add
label define province 24 "Quebec", add
label define province 35 "Ontario", add
label define province 46 "Manitoba", add
label define province 47 "Saskatchewan", add
label define province 48 "Alberta", add
label define province 59 "British Columbia", add
label define province 60 "Northwest Territories", add
label define province 61 "Yukon", add
label define province 62 "Nunavut", add

label values province province

tabulate province
tab2 apptype province, missing

clonevar county = COUNTY
replace county = county + 100 if province==24

tab2 county province, missing

include do/county_en_label.do
label values county county_en_label

tabulate county, missing

tabulate province if missing(county)

tabulate county if province!=24 & province!=35, missing

tabulate province if !missing(county) & province!=24 & province!=35

// CREDENTIAL_CD
include do/credential_cd_codes.do
encode CREDENTIAL_CD, generate(credential_cd) label(credential_cd_codes)
encode J_CREDENTIAL_CD, generate(j_credential_cd) label(j_credential_cd)
include do/credential_cd_en_label.do
label values credential_cd credential_cd_en_label
label values j_credential_cd credential_cd_en_label

tabulate credential_cd, missing
tabulate j_credential_cd, missing

// IMSTAT
/*
	IMSTAT is already numeric.
*/
rename IMSTAT imstat
include do/imstat_en_label.do
label values imstat imstat_en_label

tabulate imstat, missing

// KIND_OF_PROGRAM_CD
include do/kind_of_program_cd_codes.do
encode KIND_OF_PROGRAM_CD, generate(kind_of_program_cd) label(kind_of_program_cd_codes)
include do/kind_of_program_cd_en_label.do
label values kind_of_program_cd kind_of_program_cd_en_label

tabulate kind_of_program_cd, missing

// MOTHER_TOUNGE
include do/mother_tongue_codes.do
encode MOTHER_TONGUE, generate(mother_tongue) label(mother_tongue_codes)
include do/mother_tongue_en_label.do
label values mother_tongue mother_tongue_en_label

tabulate mother_tongue, missing

// PRINC_TEACHING_LNG
include do/princ_teaching_lng_codes.do
encode PRINC_TEACHING_LNG, generate(princ_teaching_lng) label(princ_teaching_lng_codes)
include do/princ_teaching_lng_en_label.do
label values princ_teaching_lng princ_teaching_lng_en_label

tabulate princ_teaching_lng, missing

// SUBJECT_CD
include do/subject_cd_codes.do
include do/subject_cd_en_label.do
foreach i of varlist MAIN_SUBJECT1_CD MAIN_SUBJECT2_CD J_MAIN_SUBJECT1_CD /* J_MAIN_SUBJECT2_CD */ {
	local lower_i = lower("`i'")
	encode `i', generate(`lower_i') label(subject_cd_codes)
	label values `lower_i' subject_cd_en_label
	tabulate `lower_i', missing
	display _n
}

// UG_SPEC_LEVEL_CD
include do/ug_spec_level_cd_codes.do
encode UG_SPEC_LEVEL_CD, generate(ug_spec_level_cd) label(ug_spec_level_cd_codes)
include do/ug_spec_level_cd_en_label.do
label values ug_spec_level_cd ug_spec_level_cd_en_label

tabulate ug_spec_level_cd, missing

// ECON_REGION_ORIGIN
include do/econ_region_codes.do
label values ECON_REGION_ORIGIN econ_region_codes

tabulate ECON_REGION_ORIGIN

recode ECON_REGION_ORIGIN 	(1010/1040	= 10) ///
							(1110 		= 11) ///
							(1210/1250	= 12) ///
							(1310/1350	= 13) ///
							(2410/2490	= 24) ///
							(3510/3595	= 35) ///
							(4610/4680	= 46) ///
							(4710/4760	= 47) ///
							(4810/4880	= 48) ///
							(5910/5980	= 59) ///
							(6010		= 60) ///
							(6110		= 61) ///
							(6210		= 62) ///
							, generate(er_province)
							
label values er_province province
tab2 province er_province

// SESSION_CD
label define SESSION_CD 19979 "September 1997", add
label define SESSION_CD 19989 "September 1997", add
label define SESSION_CD 19999 "September 1997", add
label define SESSION_CD 20009 "September 1997", add
label define SESSION_CD 20019 "September 1997", add
label define SESSION_CD 20029 "September 1997", add
label define SESSION_CD 20039 "September 1997", add
label define SESSION_CD 20049 "September 1997", add
label define SESSION_CD 20059 "September 1997", add
label define SESSION_CD 20069 "September 1997", add
label define SESSION_CD 20079 "September 1997", add
label define SESSION_CD 20089 "September 1997", add

label values SESSION_CD SESSION_CD

recode SESSION_CD	(19979 =	1 "September 1997") ///
					(19989 =	2 "September 1998") ///
					(19999 =	3 "September 1999") ///
					(20009 =	4 "September 2000") ///
					(20019 = 	5 "September 2001") ///
					(20029 =	6 "September 2002") ///
					(20039 =	7 "September 2003") ///
					(20049 =	8 "September 2004") ///
					(20059 =	9 "September 2005") ///
					(20069 =	10 "September 2006") ///
					(20079 =	11 "September 2007") ///
					(20089 =	12 "September 2008") ///
					, generate(session_cd)

recode COHORT		(1997 =	1 "1997") ///
					(1998 =	2 "1998") ///
					(1999 =	3 "1999") ///
					(2000 =	4 "2000") ///
					(2001 = 5 "2001") ///
					(2002 =	6 "2002") ///
					(2003 =	7 "2003") ///
					(2004 =	8 "2004") ///
					(2005 =	9 "2005") ///
					(2006 =	10 "2006") ///
					(2007 =	11 "2007") ///
					(2008 =	12 "2008") ///
					, generate(cohort)
					
compare session_cd cohort
tab2 session_cd cohort

generate int entry_month = ym(COHORT, 9)
format %tm entry_month

generate long entry_day = mdy(9, 1, COHORT)
format %td entry_day


// GENDER

label define gender_codes 0 "F" 1 "H"
encode GENDER, generate(gender) label(gender_codes)
label define gender_en_label 0 "Female" 1 "Male"
label values gender gender_en_label

// BIRTH_DT

genderate long birth_dt = date(BIRTH_DT, "MD19Y")
format birth_dt %td

generate long age_days = entry_day - birth_dt
generate float age_float = age_days / 365.25
generate int age = floor(age_float)

tab age
tabulate cohort, summarize(age)

save "${workdatapath}labeled_retention_data", replace

log close
clear
