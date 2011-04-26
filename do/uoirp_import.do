// uoirp_import.do
set more off

/*
	02DEC2010: File created based on template.do

	02DEC2010: File copied from L-SLIS files.

	09JUL09: File Created.
	Any introductory comments go here.
*/

/*
	Change the name here to reflect the new name of the do file.
	Stata will use this name in all the logs, etc.
*/
local dofilename "uoirp_import"

/*
	header.do, which is called here, will log all the results of
	the do file into the appropriate directory.
	
	If you want an output directory, keep this file as is.
	Otherwise, uncomment the local makeoutput = 0 line.
*/
// local makeoutput = 1
local makeoutput = 0
include do/header.do

/*
	Import the data from the spreadsheet.
	tab = tab-delimited
	clear = clear data already in memory (should be redundant)
	case = preseve variable name case
	names = first row of the data is the variable names
*/

insheet using "`sourcedatapath'Retention_Data_v2_31JAN2011.txt", tab clear case names

save "`workdatapath'initial_retention_data.dta", replace

include do/footer.do
