// mata_labelmatrix.do

capture mata mata drop labelmatrix1()
mata:
void labelmatrix1(string scalar varname1, string scalar A_name, real matrix A_row)
{
	real matrix A
	string matrix rowlabels
	string matrix rowlabels_filled
	string matrix rowlabels_stripe
	string matrix rowlabels_stripe_clean
	string matrix rowlabels_stripe_trim
	
	A = st_matrix(A_name)
	rowlabels = st_vlmap(st_varvaluelabel(varname1), A_row)
	rowlabels_filled = fillin(rowlabels, A_row)
	rowlabels_stripe = J(rows(A),1,"") , rowlabels_filled
	rowlabels_stripe_clean = subinstr(rowlabels_stripe, ".", "")
	rowlabels_stripe_clean = subinstr(rowlabels_stripe_clean, ":", "")
	rowlabels_stripe_clean = subinstr(rowlabels_stripe_clean, "-", "_")
	rowlabels_stripe_clean = subinstr(rowlabels_stripe_clean, " ", "_")
	rowlabels_stripe_trim = substr(rowlabels_stripe_clean, J(rows(A),2,1), J(rows(A),2,30))
	st_matrixrowstripe(A_name,rowlabels_stripe_trim)
}
mata mosave labelmatrix1(), dir(ado/) replace
end

capture mata mata drop labelmatrix2()
mata:
void labelmatrix2(string scalar varname1, string scalar varname2, string scalar A_name, real matrix A_row, real matrix A_col)
{
	real matrix A
	string matrix rowlabels
	string matrix rowlabels_filled
	string matrix rowlabels_stripe
	string matrix rowlabels_stripe_clean
	string matrix rowlabels_stripe_trim
	string matrix collabels
	string matrix collabels_filled
	string matrix collabels_stripe
	string matrix collabels_stripe_clean
	string matrix collabels_stripe_trim
	
	A = st_matrix(A_name)
	rowlabels = st_vlmap(st_varvaluelabel(varname1), A_row)
	rowlabels_filled = fillin(rowlabels, A_row)
	rowlabels_stripe = J(rows(A),1,"") , rowlabels_filled
	rowlabels_stripe_clean = subinstr(rowlabels_stripe, ".", "")
	rowlabels_stripe_clean = subinstr(rowlabels_stripe_clean, ":", "")
	rowlabels_stripe_clean = subinstr(rowlabels_stripe_clean, "-", "_")
	rowlabels_stripe_trim = substr(rowlabels_stripe_clean, J(rows(A),2,1), J(rows(A),2,30))
	st_matrixrowstripe(A_name,rowlabels_stripe_trim)
	
	collabels = st_vlmap(st_varvaluelabel(varname2), A_col)
	collabels_filled = fillin(collabels, A_col)
	collabels_stripe = J(cols(A),1,"") , collabels_filled
	collabels_stripe_clean = subinstr(collabels_stripe, ".", "")
	collabels_stripe_clean = subinstr(collabels_stripe_clean, ":", "")
	collabels_stripe_clean = subinstr(collabels_stripe_clean, "-", "_")
	collabels_stripe_trim = substr(collabels_stripe_clean, J(cols(A),2,1), J(cols(A),2,30))
	st_matrixcolstripe(A_name,collabels_stripe_trim)
}
mata mosave labelmatrix2(), dir(ado/) replace
end

