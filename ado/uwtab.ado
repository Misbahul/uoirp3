// uwtab.ado

capture program drop uwtab
program uwtab
	syntax varlist(min=1 max=2) [if] [in], [col row] [missing] [append replace] [sheet(string)] [*]
	marksample touse, novarlist
	tempname A A_row A_col B C
	
	if "`sheet'"=="" {
		local sheet "Sheet1"
	}
	
	tokenize `varlist'
	
	local matcol "matcol(`A_col')"
	if "`2'"=="" {
		local matcol ""
	}
	
	quietly tabulate `varlist' if `touse', `missing' matcell(`A') matrow(`A_row') `matcol'
	if "`2'"=="" {
		mata: labelmatrix1("`1'", "`A'", st_matrix("`A_row'"))
	}
	else {
		mata: labelmatrix2("`1'", "`2'", "`A'", st_matrix("`A_row'"), st_matrix("`A_col'"))
	}
	// matrix list `A'
	xml_tab `A', sheet("`sheet'_freq") format((SCLR0) (SCCR0 NCCR0)) `options' `append' `replace'
	
	if "`col'"=="col" {
		mata: col_proportion("`A'", "`B'")
		if "`2'"=="" {
			mata: labelmatrix1("`1'", "`B'", st_matrix("`A_row'"))
		}
		else {
			mata: labelmatrix2("`1'", "`2'", "`B'", st_matrix("`A_row'"), st_matrix("`A_col'"))
		}
		// matrix list `B'
		xml_tab `B', sheet("`sheet'_col") format((SCLR0) (SCCR0 NCCR1)) `options' append
	}
	
	if "`row'"=="row" {
		mata: row_proportion("`A'", "`C'")
		if "`2'"=="" {
			mata: labelmatrix1("`1'", "`C'", st_matrix("`A_row'"))
		}
		else {
			mata: labelmatrix2("`1'", "`2'", "`C'", st_matrix("`A_row'"), st_matrix("`A_col'"))
		}
		// matrix list `C'
		xml_tab `C', sheet("`sheet'_row") format((SCLR0) (SCCR0 NCCR1)) `options' append
	}
	
	capture matrix drop `A'
	capture matrix drop `B'
	capture matrix drop `C'
	capture matrix drop `A_row'
	capture matrix drop `A_col'
end
