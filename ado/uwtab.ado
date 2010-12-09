// uwtab.ado

capture program drop uwtab
program uwtab
	syntax varlist(min=1 max=2) [if] [in], [col row] [missing]
	marksample touse, novarlist
	tempname A A_row A_col B C
	
	tokenize varlist
	
	local matcol "matcol(`A_col')"
	if "`2'"=="" {
		local matcol ""
	}
	
	quietly tabulate `varlist' if `touse', `missing' matcell(`A') matrow(`A_row') `matcol'
	matrix list `A'
	
	if "`col'"=="col" {
		mata: col_proportion("`A'", "`B'")
		matrix list `B'
	}
	
	if "`row'"=="row" {
		mata: row_proportion("`A'", "`C'")
		matrix list `C'
	}
	
	capture matrix drop `A'
	capture matrix drop `B'
	capture matrix drop `C'
	capture matrix drop `A_row'
	capture matrix drop `A_col'
end
