// template.do
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
global dofilename "template"

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
// use "${workdatapath}analysis/l${appendcode}_002"

/*
	Your code goes here.
*/
display _newline as text "Hello World!"

log close
clear
