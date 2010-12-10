// mata_mean_matrix.do

mata:
real matrix mean_matrix(string scalar varname1, string scalar varname2, string scalar varname3, real matrix A_row, real matrix A_col)
{
	real matrix A
	real matrix W
	real matrix X
	real matrix Y
	real matrix Z
	real scalar i
	real scalar j
	
	A = J(rows(A_row), cols(A_col),.)
	W = .
	X = .
	Y = .
	Z = .
	
	st_view(Z, ., (varname2))
	st_view(W, ., (varname3))
	
	for (i=1,i<=rows(A_row),i++) {
		for (j=1,j<=cols(A_col),j++) {
			void st_addvar("byte", name=st_tempname())
			st_view(Y, ., (name))
			Y = ((Z :== A_row[i,1]) :& (W :== A_col[1,j]))
			st_view(X, ., (varname1), name)
			A[i,j] = mean(X)
		}
	}
}
mata mosave mean_matrix(), dri(ado/) replace
end

