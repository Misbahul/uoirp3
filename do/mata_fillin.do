// mata_fillin.do

mata:
string matrix fillin(string matrix A, real matrix B)
{
	string matrix C
	real scalar i
	real scalar j
	
	C = strofreal(B)
	
	for (i=1; i<=rows(A); i++) {
		for (j=1; i<=cols(A); j++) {
			if A[i,j]=="" {
				A[i,j]=C[i,j]
			}
		}
	}
	return C
}
mata mosave fillin(), dir(ado/) replace
end

