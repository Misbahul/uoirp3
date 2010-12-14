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
replace local1 = 1 if econ_region_origin = 3510 // Ottawa
replace local1 = 1 if econ_region_origin = 2460 // Outaouais
replace local1 = 0 if econ_region_orgin != 3510 & econ_region_origin != 2460 & econ_region_origin < 99998

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
drop _ottpostalcodes==2 // Codes not in the data
recode _ottpostalcodes (1 = 0) (3 = 1)
rename _ottpostalcodes local2

label variable local2 "Local Student (by Postal Code)"
label values local2 loclbl

// School Board -- pending

// County





log close
clear
