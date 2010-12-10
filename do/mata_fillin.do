// mata_fillin.do

mata:
string matrix fillin(string matrix A, real matrix B)
{
	string matrix C
	string matrix D
	real scalar i
	real scalar j
	
	C = strofreal(B)
	D = A
	
	for (i=1; i<=rows(A); i++) {
		for (j=1; j<=cols(A); j++) {
			if (A[i,j]=="") {
				D[i,j]=C[i,j]
			}
		}
	}
	return(D)
}
mata mosave fillin(), dir(ado/) replace
end

