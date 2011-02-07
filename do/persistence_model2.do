// persistence_model2.do

set more off
clear
set memory 1000m
set matsize 1000

local dofilename "persistence_model2"
include common/do/imm2_macros.do

adopath ++ "ado/"

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

adopath + "ado/"

capture drop _all

capture program drop access_mlogit
program define access_mlogit
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
		`quietly' mlogit `varlist' `if' [`weight'`exp'], baseoutcome(0) `options'
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

capture program drop access_model
program define access_model
	syntax using [if] [in], estdir(string) save(passthru) [replace append] ///
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
	
	include do/access_locals.do
	
	local estlist ""
	local cwidthlist "0 `cwidth_names'"
	local cwidthcount 1
	forvalues i = 1/`models' { 
		access_mlogit colluniv `m`i'' `regions' if `touse' & `consis_sample' `wt', ///
			save( "`estdir'`estname`i''.ster") /* cluster(schoolid) */ ///
			dummies( `dummies') estname( `estname`i'') ///
			regtitle( "`regname`i''")
		local estlist "`estlist' `estname`i''"
		local cwidthlist "`cwidthlist', `cwidthcount' `cwidth_reg'"
		local ++cwidthcount
		local cwidthlist "`cwidthlist', `cwidthcount' `cwidth_reg'"
		local ++cwidthcount
		local cwidthlist "`cwidthlist', `cwidthcount' `cwidth_blank'"
		local ++cwidthcount
	} 
	
	local mycblanks ""
	local blankcount = 0
	local blankincrement = 2
	
	local blanknumbers = `models' - 1
	
	forvalues i = 1/`blanknumbers' { 
		local blankcount = `blankcount' + `blankincrement'
		local mycblanks "`mycblanks' `blankcount'"
	} 
	
	
	
	xml_tab `estlist', `save' `replace' `append' below drop(NoPSE:) ///
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

// capture file close versionfile
// file open versionfile using "do/yap_versions_panel.txt", read text

// file read versionfile line

// local count = 0

// while r(eof)==0 { 
	// if substr( "`line'",1,1)=="#" { 
		// local comment = substr( "`line'",2,.)
		// display as text "Comment: " as result "`comment'"
	// } 
	// else { 
		// tokenize `"`macval(line)'"', parse(`"`delimiter'"') /* " */
		// if "`1'"!="" { 
			// ensuredir "estimates/`dofilename'/`3'/"
			// ensuredir "output/`dofilename'/`3'/"
			
			// local ++count
			
			// local datafile`count' "`1'"
			// local nick`count' "`3'"
			// local regionvars`count' "`5'"
			
		// } 
	// } 
	// file read versionfile line
// } 
// file close versionfile

local count = 1	// One version file.
local datafile1 "`loc_analysis'"
local nick1 "C4_access"

// set tracedepth 1
// set trace on

capture file close modelsfile
file open modelsfile using "do/access_reg1_modellist.txt", read text

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
	
	/*
		// Censor graduates.
		replace status1_p_y=. if status1_p_y==1
		
		generate all = 1
		
		quietly tabulate disab3cat, generate(disab3cat_)
		rename disab3cat_1 disab3cat_no
		rename disab3cat_2 disab3cat_some
		rename disab3cat_3 disab3cat_often
		
		local condition1 "if (level_p1==1 | level_p1==2)"
		local condition2 "if level_p1==3"
		
		local output1 "coll"
		local output2 "univ"
		
		local fullname1 "College"
		local fullname2 "University"

		local region1 "region_at_p1"
		local region2 "region_qc_p1"
		local region3 "region_on_p1"
		local region4 "region_pa_p1"
		local region5 "region_bc_p1"
		local region6 "all"

		local reg_output1 "at"
		local reg_output2 "qc"
		local reg_output3 "on"
		local reg_output4 "pa"
		local reg_output5 "bc"
		local reg_output6 "all"

		local reg_name1 "Atlantic"
		local reg_name2 "Quebec"
		local reg_name3 "Ontario"
		local reg_name4 "Praries"
		local reg_name5 "British Columbia"
		local reg_name6 "All"
		
		local reglist_regions1 ""
		local reglist_regions2 ""
		local reglist_regions3 ""
		local reglist_regions4 ""
		local reglist_regions5 ""
		local reglist_regions6 "region_at_p1 region_qc_p1 region_pa_p1 region_bc_p1"
		
		summarize faminc, detail
	*/
		
		replace hsgradn_c1 = hsgradn_c1 / 10
		replace wleread	= wleread / 100
		replace faminc = faminc / 10
	
	/*
		CREATE INTERACTION VARIABLES
		(This can be moved outside this file later.
	*/
	
	summarize hsgradn_c1, detail
	summarize wleread, detail
	summarize faminc, detail
	
	unab immagg : immgen_*
	unab immdisagg : immigrant_*

	local immagg_omit "immgen_3rd"
	local immdisagg_omit "immigrant_not"

	local immagg : list immagg - immagg_omit
	local immdisagg : list immdisagg - immdisagg_omit
	
	display "`immagg'"
	display "`immdisagg'"
	
	foreach cci of local allindex { 
		foreach aiv of local immagg { 
			clonevar `cci'_`aiv' = `cci'
			replace `cci'_`aiv' = 0 if `aiv'==0
		} 
		foreach div of local immdisagg { 
			if regexm("`div'","_([a-z0-9A-Z]+)$")	/* " */ {
				local divp = regexs(1)
			} 
			else {
				local divp "`div'"
			}
			clonevar `cci'_`divp' = `cci'
			replace `cci'_`divp' = 0 if `div'==0
		}
	} 
	
	d, fullnames
	
	forvalues m = 1/`mcount' { 
		local myreplace "replace"
		ensuredir "estimates/`dofilename'/`nick`i''/`modelnick`m''/"
		ensuredir "output/`dofilename'/`nick`i''/`modelnick`m''/"
		// forvalues j = 1/2 { 
			// ensuredir "estimates/`dofilename'/`nick`i''/`modelnick`m''/`output`j''/"
			// preserve
			// keep `condition`j''
			// d region_??_p1, fullnames
			// forvalues k = 6/6 { 
				// local region_intersection : list reglist_regions`k' & regionvars`i'
				// set tracedepth 1
				// set trace on
				local sysdate = c(current_date)
				local systime = c(current_time)
				local timestring "`sysdate' `systime'"
				access_model using "`modelfile`m''" /* if `region`k'' */, ///
					estdir( "estimates/`dofilename'/`nick`i''/`modelnick`m''/") ///
					title( "Regression Output: `modelname`m''") ///
					notes( Average marginal effects shown., Data file: `datafile`i'' (`nick`i''), Do file: `dofilename'.do; Model file: `modelfile`m''; Date ran: `timestring' ) sheet( "`modelnick`m''") ///
					save( "output/`dofilename'/`nick`i''/`modelnick`m''/`dofilename'_`nick`i''_`modelnick`m''.xls") `myreplace' ///
			// } 
			// restore
			local myreplace "append"
		// } 
	} 	
} 
		
	
log close
clear












