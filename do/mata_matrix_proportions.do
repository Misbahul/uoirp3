// mata_matrix_proportions.do

capture mata mata drop col_proportion()
mata:
void col_proportion(string scalar freq_matrix, string scalar prop_matrix)
{
	A = st_matrix(freq_matrix)
	B = A :/ colsum(A)
	B = B*100
	st_matrix(prop_matrix, B)
}
mata mosave col_proportion(), dir(ado/) replace
end

capture mata mata drop row_proportion()
mata:
void row_proportion(string scalar freq_matrix, string scalar prop_matrix)
{
	A = st_matrix(freq_matrix)
	B = A :/ rowsum(A)
	B = B*100
	st_matrix(prop_matrix, B)
}
mata mosave row_proportion(), dir(ado/) replace
end



