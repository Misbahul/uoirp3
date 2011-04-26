 // header.do

include do/locals.do

cd "`projectdirectory'"
adopath + "`projectdirectory'ado/"
adopath + "`statautil'"
ensuredir "`workdatapath'"
ensuredir "`outputpath'"
ensuredir "`logpath'"
ensuredir "`manuallogpath'"
clear
set more off
set trace off
set tracedepth 1
capture log close
local mydofilename = subinstr( "`dofilename'", " ", "", .)
local fileprefix "`logpath'`locationname'/"
ensuredir "`fileprefix'"
local datestringp "$S_DATE" 
// Convert the datestring to something a bit more useful.
tokenize `datestringp'
local month `2'
local year `3'
local day = string(`1',"%02.0f") // Add a leading zero to the day number
local datestring : subinstr local datestringp " " "", all
local timestringp "$S_TIME"
local timestring : subinstr local timestringp ":" "_", all
local logfilename "`fileprefix'"
local filesuffix ".log"
local logfilename "`logfilename'`dofilename'`filesuffix'"
log using "`logfilename'", replace text

shell git describe --tags

/*
	Setting up output directory
*/ 
if "`makeoutput'"=="1" { 
	local outputdir "`outputpath'`year'/"
	ensuredir "`outputdir'"
	local outputdir "`outputdir'`month'/"
	ensuredir "`outputdir'"
	local outputdir "`outputdir'`day'/"
	ensuredir "`outputdir'"
	local outputdir "`outputdir'`timestring'/"
	ensuredir "`outputdir'"
	local outputdir "`outputdir'`mydofilename'/"
	ensuredir "`outputdir'"
} 
local makeoutput = 0

clear matrix
clear mata
set memory 750m
set matsize 1000
version 10.1
