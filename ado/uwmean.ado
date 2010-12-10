// uwmean.ado

capture program drop uwmean
program uwmean
	syntax varlist(min=2 max=3) [if] [in], [append replace] [sheet(string)] [format(passthru)] [*]
	marksample touse, novarlist
	tempname A A_row A_col B
	
	if "`sheet'"=="" {
		local sheet "Sheet1"
	}
	
	tokenize `varlist'
	
	local matcol "matcol(`A_col')"
	if "`3'"=="" {
		local matcol ""
	}
	
	quietly tabulate `varlist' if `touse', matcell(`A') matrow(`A_row') `matcol'
	if "`2'"=="" {
		mata: labelmatrix1("`2'", "`A'", st_matrix("`A_row'"))
		mata: st_matrix("`B'", mean_rowvector("`1'", "`2'", st_matrix("`A_row'")))
		mata: labelmatrix1("`2'", "`B'", st_matrix("`A_row'"))
	}
	else {
		mata: labelmatrix2("`2'", "`3'", "`A'", st_matrix("`A_row'"), st_matrix("`A_col'"))
		mata: st_matrix("`B'", mean_matrix("`1'", "`2'", "`3'", st_matrix("`A_row'"), st_matrix("`A_col'")))
		mata: labelmatrix2("`2'", "`3'", "`B'", st_matrix("`A_row'"), st_matrix("`A_col'"))
	}
	// matrix list `A'
	xml_tab `A', sheet("`sheet'_freq") format((SCLR0) (SCCR0 NCCR0)) `options' `append' `replace'
	xml_tab `B', sheet("`sheet'_mean") `format' `options' append
	
	capture matrix drop `A'
	capture matrix drop `B'
	capture matrix drop `A_row'
	capture matrix drop `A_col'
end
