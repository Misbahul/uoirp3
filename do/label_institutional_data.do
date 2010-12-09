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

tabulate province
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
include do/credential_cd_en_label.do
label values credential_cd credential_cd_en_label

tabulate credential_cd, missing

// IMSTAT
include do/imstat_codes.do
encode IMSTAT, generate(imstat) label(imstat_codes)
include do/imstat_en_label.do
label values imstat imstat_en_label

tabulate imstat, missing

log close
clear
