// uoirp_descriptive3.do
set more off

/*
	01MAR2011: File created based on template.do
	

	02DEC2010: File copied from L-SLIS files.

	09JUL09: File Created.
	Any introductory comments go here.
*/

/*
	Change the name here to reflect the new name of the do file.
	Stata will use this name in all the logs, etc.
*/
global dofilename "uoirp_descriptive3"

/*
	header.do, which is called here, will log all the results of
	the do file into the appropriate directory.
	
	If you want an output directory, keep this file as is.
	Otherwise, uncomment the local makeoutput = 0 line.
*/
local makeoutput = 1
// local makeoutput = 0
include "do/header"

// Sample Command to load the data file.
use "${workdatapath}new_variable_data"

local outfile "`outputdir'${dofilename}.xls"

// Credential and main subject.
uwtab main_subject1_cd credential_cd, col row save(`outfile') replace sheet("Tab_1a")
uwtab main_subject2_cd credential_cd, col row save(`outfile') append sheet("Tab_1b")
uwtab j_main_subject1_cd credential_cd, col row save(`outfile') append sheet("Tab_1c")
uwtab main_subject1_cd ug_spec_level_cd, col row save(`outfile') append sheet("Tab_2a")
uwtab main_subject2_cd ug_spec_level_cd, col row save(`outfile') append sheet("Tab_2b")
uwtab j_main_subject1_cd credential_cd, col row save(`outfile') append sheet("Tab_2c")

log close
clear
