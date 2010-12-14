// master.do

do setup
do do/master_1_import_clean.do
do do/master_2_analysis.do
do finalcleanup

