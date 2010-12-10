// mata_labelmatrix.do

mata:
void labelmatrix1(string scalar varname1, string scalar A_name, real matrix A_row)
{
	real matrix A
	string matrix rowlabels
	string matrix rowlabels_stripe
	
	A = st_matrix(A_name)
	rowlabels = st_vlmap(st_varvaluelabel(varname1), A_row)
	rowlabels_stripe = J(rows(A),1,"") , rowlabels
	st_matrixrowstripe(A_name,rowlabels_stripe)
}
mata mosave labelmatrix1(), dir(ado/) replace
end

mata:
void labelmatrix2(string scalar varname1, string scalar varname2, string scalar A_name, real matrix A_row, real matrix A_col)
{
	real matrix A
	string matrix rowlabels
	string matrix rowlabels_stripe
	string matrix collabels
	string matrix collabels_stripe
	
	A = st_matrix(A_name)
	rowlabels = st_vlmap(st_varvaluelabel(varname1), A_row)
	rowlabels_stripe = J(rows(A),1,"") , rowlabels
	st_matrixrowstripe(A_name,rowlabels_stripe)
	
	collabels = st_vlmap(st_varvaluelabel(varname2), A_col)
	collabels_stripe = J(cols(A),1,"") , collabels'
	st_matrixcolstripe(A_name,collabels_stripe)
}
mata mosave labelmatrix2(), dir(ado/) replace
end

