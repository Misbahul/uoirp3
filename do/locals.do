// locals.do

include do/user_locals.do

/*
	Original data files -- these are the files that the data supplied
	by the university of Ottawa are stored in.
*/
local originaldatafile_31jan2011 "`sourcedatapath'Retention_Data_v2_31JAN2011.txt"
local originaldatafile_27apr2011 "`sourcedatapath'Retention_Data_v4_April_2011.txt"
local originaldatafile "`sourcedatapath'Retention_Data_v4_April_2011_nofrench_28APR2011.txt"

/*
	Birthdate format.
	
	This is used by Stata's date() function to parse the birthdates provided in
	the data.
*/
local bdate_format_31jan2011 "MD19Y"
local bdate_format "19YMD"
