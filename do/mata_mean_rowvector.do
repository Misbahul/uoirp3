// mata_mean_rowvector.do

mata:
real matrix mean_rowvector(string scalar varname1, string scalar varname2, real matrix A_row)
{
	real matrix A
	real matrix X
	real matrix Y
	real matrix Z
	real scalar i
	real scalar j
	
	A = J(rows(A_row), 1,.)
	W = .
	X = .
	Y = .
	Z = .
	
	st_view(Z, ., (varname2))
	
	for (i=1; i<=rows(A_row); i++) {
		(void) st_addvar("byte", name=st_tempname())
		st_view(Y, ., (name))
		Y[.,.] = (Z :== A_row[i,1])
		st_view(X, ., (varname1), name)
		A[i,1] = mean(X)
	}
	return(A)
}
mata mosave mean_rowvector(), dir(ado/) replace
end

