// uwtab2.ado

capture program drop uwtab2
program uwtab2
	syntax varlist(min=2) [if] [in], [missing] [append replace] [sheet(string)] [*]
	marksample touse, novarlist
	tempname A A_row A_col B D E
	
	if "`sheet'"=="" {
		local sheet "Sheet1"
	}
	
	
	tokenize `varlist'
	
	quietly count if !missing(`1') & `touse'
	if r(N)==0 {
		exit
	}
	
	local matcol "matcol(`A_col')"
	quietly count if !missing(`2') & `touse'
	if r(N)==0 {
		exit
	}

	local row_var "`1'"
	macro shift	// The varlist is now all the column variables
	local rest `*'

	foreach i of local rest { 	
		quietly tabulate `row_var' if `touse', subpop(`i') `missing' matcell(`A') matrow(`A_row')
		mata: labelmatrix1("`row_var'", "`A'", st_matrix("`A_row'"))
		matrix colnames `A' = `i'
		matrix list `A'
		matrix `D' = nullmat( `D') , `A'
		
		mata: col_proportion("`A'", "`B'")
		mata: labelmatrix1("`row_var'", "`B'", st_matrix("`A_row'"))
		matrix colnames `B' = `i'
		matrix list `B'
		matrix `E' = nullmat( `E') , `B'
	}
	
	xml_tab `D', sheet("`sheet'_freq") format((SCLR0) (SCCR0 NCCR0)) `options' `append' `replace'
	xml_tab `E', sheet("`sheet'_col") format((SCLR0) (SCCR0 NCCR1)) `options' append

	capture matrix drop `A'
	capture matrix drop `B'
	capture matrix drop `A_row'
	capture matrix drop `D'
	capture matrix drop `E'
end
