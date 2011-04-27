// master_mata.do

/*
	File created 26APR2011. This master file will re-run
	all the mata programs to re-generate the .mo files
	in the ado directory.
	
	This is useful when these programs have been recompiled
	for a different version of mata.
*/

do do/mata_fillin.do
do do/mata_labelmatrix.do
do do/mata_matrix_proportions.do
do do/mata_mean_matrix.do
do do/mata_mean_rowvector.do
