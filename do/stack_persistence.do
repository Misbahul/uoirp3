// stack_persistence.do
set more off

/*
  22JUL2011: File created based on stack_persistence.do
    from the L-SLIS project.

	17MAY2010: File created based on template.do
	I want to create a stacked persistence model.

	09JUL09: File Created.
	Any introductory comments go here.
*/

/*
	Change the name here to reflect the new name of the do file.
	Stata will use this name in all the logs, etc.
*/
local dofilename "stack_persistence"

/*
	header.do, which is called here, will log all the results of
	the do file into the appropriate directory.
	
	If you want an output directory, keep this file as is.
	Otherwise, uncomment the local makeoutput = 0 line.
*/
local makeoutput = 1
// local makeoutput = 0
include "do/header"

/*
	Add persistence variables and create a new data file.
	(Also, create a persistence data directory.)
*/
/*
  local persisdir "${workdatapath}persistence/"
  ensuredir "`persisdir'"

  capture confirm new file "`persisdir'main.dta"
  if !_rc {
    persistence_variables using "`workdatapath'labeled_retention_data", save("`persisdir'main.dta")
  }
*/

// Sample Command to load the data file.
use "`workdatapath'new_variable_data.dta", clear

/*
	Relabel some variables.
*/
label variable fsa3 "First Three Leters of Postal Code"
label variable text_province "???"
label variable enfr_hi "Highest English/French Grade"
label variable enfr_lo "Lowest English/French Grade"

/*
	Drop inconsistent observations (in Year 3, but
	not in Y2).
*/
drop if cont3==1 & cont2==0

rename session_1_awards awards2
rename session_2_awards awards3
rename gov_grant_s1 gov_grant2
rename gov_grant_s2 gov_grant3
rename gov_loan_s1 gov_loan2
rename gov_loan_s2 gov_loan3
reshape long cont awards gov_grant gov_loan, i(person_id) j(year)
rename cont continuer 
label variable continuer "Continuing or Left University"
label variable year "Years in University"

/*
  drop if year==2 & cont2==0
  drop if year==3 & cont3==0
*/


tabulate year, generate(lyear_)

forvalues i = 1/2 {
	label variable lyear_`i' "Transition Year `i'"
	tabulate lyear_`i', missing
}

save "`workdatapath'stacked.dta", replace

log close
clear

