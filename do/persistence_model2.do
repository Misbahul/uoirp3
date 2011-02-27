// persistence_model2.do

set more off
clear
set memory 1000m
set matsize 1000

global dofilename "persistence_model2"
// include common/do/imm2_macros.do
local makeoutput = 1
include do/header

// adopath ++ "ado/"

/*
	If you need to regenerate all the matrix
	data files from this do file, you can use
	the macro below.
	
	It will replace all the existing data files,\
	so the subsequent runs of this program will
	take longer.
*/
local regenerate ""
// local regenerate "regenerate"

// adopath + "ado/"

capture drop _all

capture program drop persistence_logit
program define persistence_logit
	version 10
	syntax varlist [if] [pweight], save(string) [regtitle(string)] dummies(string) estname(string) [quietly] [*]
	
	local save_noext = regexr( "`save'", ".ster$", "")
	local save_main = "`save_noext'.ster"
	
	capture confirm file `"`save_main'"' /* " */	// Does the estimates file exist?
	if _rc { // if the file does not exist
		if "`quietly'"=="" { 
			display _newline as text  "----------------------------Regression----------------------------"
			display as result "`regtitle'" as text "."
			display as text "------------------------------------------------------------------" _newline
		} 
		`quietly' logit `varlist' `if' [`weight'`exp'], `options'
		if "`quietly'"=="" { 
			display _newline as text  "-------------------------Marginal Effects-------------------------"
			display as result "`regtitle'" as text "."
			display as text "------------------------------------------------------------------" _newline
		} 
		`quietly' margeff, dummies(`dummies') replace
		estimates title: "`regtitle'"
		estimates store `estname'
		estimates save `"`save_main'"'	/* " */
		// estwrite `estname' using `"`save'"'	/* " */, alt 
	} 
	else {
		display _newline as text "Estimates file " as result "`save_main'" as text " already exists."
		estimates use "`save_main'"
		estimates title: "`regtitle'"
		estimates store `estname'
		display as text "File loaded."
	} 
end

capture program drop persistence_model
program define persistence_model
	syntax varname using [if] [in], estdir(string) save(passthru) [replace append] ///
		title(passthru) notes(passthru) sheet(passthru)
	marksample touse
	tempvar consis_sample
	
	quietly generate `consis_sample' = 1
	
	local delimiter=`"`=char(9)'"'		/* " */
	
	local allvars ""
	local keepvars ""
	local rownames ""
	local colformats ""
	local rowblank ""
	local last_var "COL_NAMES"
	local models 0
	local consistent ""
	
	capture file close myfile
	file open myfile `using', read text
	
	file read myfile line
	while substr( "`line'", 1, 1) != "@" { 
		if substr( "`line'", 1, 1) == "#" { 
			local comment = substr( "`line'", 2, .)
			display as text "Comment: " as result "`comment'"
		} 
		else {
			if "`line'"=="consistent" { 
				local consistent "consistent"
			} 
			else { 
				if "`line'"!="" { 
					local ++models
					tokenize `"`macval(line)'"', parse(`"`delimiter'"')	/* " */
					local estname`models' "`1'"
					local regname`models' "`3'"
				} 
			}
		} 
		file read myfile line
	} 
	
	local dummies ""
	forvalues i = 1/`models' { 
		local m`i' ""
	} 
	
	file read myfile line
	while r(eof) == 0 { 
		if substr( "`line'", 1, 1) == "#" { 
			local comment = substr( "`line'", 2, .)
			display as text "Comment: " as result "`comment'"
		} 
		else {
			if substr( "`line'",1,1)==">" {
				// Heading
				local line = substr("`line'",2,.)
				if `"`rowblank'"' == "" { /* " */
					local comma ""
				} 
				else { 
					local comma ","
				} 
				local rowblank `"`rowblank' `comma' `last_var' "`line'" SCLB0"'
			}
			else {
				if substr( "`line'",1,1)=="\" { 
					local dummies = rtrim( "`dummies'")
					if "`dummies'" != "" & substr( "`dummies'", -1, 1) != "\" { 
						local dummies "`dummies' \ "
					} 
				} 
				else { 
					if "`line'"!="" { 
						tokenize `"`macval(line)'"', parse(`"`delimiter'"')	/* " */
						// local variable "`variable' `1'"
						local last_var "`1'"
						local allvars "`allvars' `1'"
						label variable `1' `"`3'"'	/* " */
						quietly replace `consis_sample' = 0 if missing( `1') & "`consistent'"=="consistent"
						if "`5'"=="1" { 
							local keepvars "`keepvars' `1'"
							local rownames `"`rownames' "`3'""'	/* " */
							local colformats "`colformats' NCCR3 NCCR3"
						}
						if "`7'"=="1" { 
							local dummies "`dummies' `1'"
						} 
						forvalues i = 1/`models' { 
							local tabpos = `i'-1
							local tabpos = `tabpos'*2
							local tabpos = `tabpos' + 9
							if "``tabpos''" == "1" { 
								local m`i' "`m`i'' `1'"
							} 
						} 
					} 
				} 
			} 
		} 
		file read myfile line
	}
	file close myfile
	
	include do/persistence_locals.do
	
	local estlist ""
	local cwidthlist "0 `cwidth_names'"
	local cwidthcount 1
	forvalues i = 1/`models' { 
		persistence_logit `varlist' `m`i'' `regions' if `touse' & `consis_sample' `wt', ///
			save( "`estdir'`estname`i''.ster") ///
			dummies( `dummies') estname( `estname`i'') ///
			regtitle( "`regname`i''")
		local estlist "`estlist' `estname`i''"
		local cwidthlist "`cwidthlist', `cwidthcount' `cwidth_reg'"
		local ++cwidthcount
		// local cwidthlist "`cwidthlist', `cwidthcount' `cwidth_reg'"
		// local ++cwidthcount
		// local cwidthlist "`cwidthlist', `cwidthcount' `cwidth_blank'"
		// local ++cwidthcount
	} 
	
	local mycblanks ""
	// local blankcount = 0
	// local blankincrement = 2
	
	// local blanknumbers = `models' - 1
	
	// forvalues i = 1/`blanknumbers' { 
		// local blankcount = `blankcount' + `blankincrement'
		// local mycblanks "`mycblanks' `blankcount'"
	// } 
	
	
	
	xml_tab `estlist', `save' `replace' `append' below ///
		`title' `notes' lines(COL_NAMES 3 LAST_ROW 4) ///
		rblanks( `rowblank')  ///
		keep( `keepvars') ///
		`sheet' cblanks( `mycblanks') font( "Arial" 8) stats(N) ///
		cwidth( `cwidthlist') ///
		format((SCLR0) (SCCB0 `colformats' NCCR0))
end

	
capture log close
log using "log/`dofilename'.log", replace text
	
ensuredir "estimates/"
ensuredir "estimates/`dofilename'/"
// ensuredir "estimates/`dofilename'/test_model/"

ensuredir "output/"
ensuredir "output/`dofilename'/"


local delimiter=`"`=char(9)'"'		/* " */

local count = 1	// One version file.
local datafile1 "${workdatapath}new_variable_data"
local nick1 "main"

// set tracedepth 3
// set trace on

capture file close modelsfile
file open modelsfile using "do/persistence_model2_modellist.txt", read text

file read modelsfile line

local mcount = 0

while r(eof)==0 { 
	if substr( "`line'",1,1)=="#" { 
		local comment = substr( "`line'",2,.)
		display as text "Comment: " as result "`comment'"
	} 
	else { 
		tokenize `"`macval(line)'"', parse(`"`delimiter'"') /* " */
		if "`1'"!="" { 
			// ensuredir "estimates/`dofilename'/`3'/"
			// ensuredir "output/`dofilename'/`3'/"
			
			local ++mcount
			
			local modelfile`mcount' "`1'"
			local modelnick`mcount' "`3'"
			local modelname`mcount' "`5'"
		} 
	} 
	file read modelsfile line
} 
file close modelsfile

forvalues i = 1/`count' { 
	use "`datafile`i''", clear
	
	ensuredir "estimates/`dofilename'/`nick`i''/"
	ensuredir "output/`dofilename'/`nick`i''/"
	
	forvalues m = 1/`mcount' { 
		ensuredir "estimates/`dofilename'/`nick`i''/`modelnick`m''/"
		ensuredir "output/`dofilename'/`nick`i''/`modelnick`m''/"
		foreach n of varlist leave2 leave3 leave /* cont2 cont3 uoreturn */ {
			local myreplace "replace"
			ensuredir "estimates/`dofilename'/`nick`i''/`modelnick`m''/`n'/"
			ensuredir "output/`dofilename'/`nick`i''/`modelnick`m''/`n'/"
			local sysdate = c(current_date)
			local systime = c(current_time)
			local timestring "`sysdate' `systime'"
			persistence_model `n' using "`modelfile`m''", ///
				estdir( "estimates/`dofilename'/`nick`i''/`modelnick`m''/`n'/") ///
				title( "Regression Output: `modelname`m'' (`n')") ///
				notes( Dependant Variable: `n'; Average marginal effects shown., Data file: `datafile`i'' (`nick`i''), Do file: `dofilename'.do; Model file: `modelfile`m''; Date ran: `timestring' ) ///
				sheet( "`modelnick`m''_`n'") ///
				save( "output/`dofilename'/`nick`i''/`modelnick`m''/`n'/${dofilename}_`nick`i''_`modelnick`m''_`n'.xls") `myreplace'
			local myreplace "append" 
		} 
	} 	
} 
		
	
log close
clear












