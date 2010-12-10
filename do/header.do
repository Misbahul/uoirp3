 // header.do

// do "${projectdirectory}setup.do"
cd "${projectdirectory}"
clear
set more off
set trace off
set tracedepth 1
capture log close
// local fileprefix "${logpath}${dofilename}_${locationname}_"
local mydofilename = subinstr( "${dofilename}", " ", "", .)
local fileprefix "${logpath}${locationname}/"
ensuredir "`fileprefix'"
// display "${fileprefix}"
if "${datestringp}"=="" {
	global datestringp "$S_DATE"
} 
// Convert the datestring to something a bit more useful.
tokenize $datestringp
// local day `1'
local month `2'
local year `3'
local day = string(`1',"%02.0f") // Add a leading zero to the day number
// display "${datestring}"
global datestring : subinstr global datestringp " " "", all
// display "${datestring}"
if "${timestringp}"=="" { 
	global timestringp "$S_TIME"
} 
global timestring : subinstr global timestringp ":" "_", all
local logfilename "`fileprefix'"
local filesuffix ".log"
local logfilename "`logfilename'${dofilename}`filesuffix'"
log using "`logfilename'", replace text

/*
	Setting up output directory
*/ 
if "`makeoutput'"=="1" { 
	local outputdir "${outputpath}`year'/"
	ensuredir "`outputdir'"
	local outputdir "`outputdir'`month'/"
	ensuredir "`outputdir'"
	local outputdir "`outputdir'`day'/"
	ensuredir "`outputdir'"
	local outputdir "`outputdir'${timestring}/"
	ensuredir "`outputdir'"
	local outputdir "`outputdir'`mydofilename'/"
	ensuredir "`outputdir'"
} 
local makeoutput = 0

clear mata
set memory 500m
set matsize 500
version 10.1
