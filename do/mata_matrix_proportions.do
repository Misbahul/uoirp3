// mata_matrix_proportions.do

mata:
void col_proportion(string scalar freq_matrix, string scalar prop_matrix)
{
	A = st_matrix(freq_matrix)
	B = A :/ colsum(A)
	st_matrix(prop_matrix, B)
}
mata mosave col_proportion(), dir(ado/) replace
end

mata:
void row_proportion(string scalar freq_matrix, string scalar prop_matrix)
{
	A = st_matrix(freq_matrix)
	B = A :/ rowsum(A)
	st_matrix(prop_matrix, B)
}
mata mosave row_proportion(), dir(ado/) replace
end



