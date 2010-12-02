* setup.do

if "${ransetup}"=="" { 
	global datestringp "$S_DATE"
	global timestringp "$S_TIME"
	
	do "locationspecificglobals"
	global datestring "${datestringp}"
	global timestring "${timestringp}"
	global provinces `" "NL" "NS" "NB" "QC" "ON" "MB" "SK" "AB" "BC" "'
	global appendcode "CA"
	
	/*
		CODE NOT TO DISPLAY GRAPHS
		
		There are two global macro definitions below. They can be used
		to determine if graphs will be displayed or not.
	*/
	global nodraw "nodraw"
	// global nodraw ""
	
	/*
		Start with new ado files.
	*/
	capture program drop all
	
	/*
		We want to store the sampling data in a global variable so we can create the weights.
		The trick is dealing with those provinces that are split up into two groups. We will
		want to have a different weight for non-recipients in ON, NS, BC. [Non recipients are
		defined differently in ON than in the other two provinces. In Ontario, the non-recipients
		are those who did not recieve the foundation grant.
		
		The following numbers are for RECIPIENTS. Non-recipients will be handled below.
	*/
	// global senttosurvey	"624 316 300 1500 5000 499 373 1600 2101"
	// global totalpop		"624 356 824 3331 6122 517 807 3926 2361"
	
	// Be sure not to divide by zero -- non-recipients #'s
	// global nrsenttosurvey	"0 350 0 0 5000 0 0 0 540"
	// global nrtotalpop		"0 570 0 0 7563 0 0 0 630"
	
	// global wtname			"sampwt"
	
	cd "${projectdirectory}"
	
	/*
		25SEP08:
		adopath ++ adds a directory to the beginning of the adopath
		(which means that you access user written .ado files before
		others. So, if you accidentally give your .ado file the same
		name as an existing one, it will overwrite it. If this is
		the behaviour you want, I suggest a special directory for it.
		
		I am changing the command to a single + instead of a double,
		which will move this project ado directory to the end
		of the path.
		
		I'm also adding the statautil directory to the adopath. This
		directory will go AFTER the project ado directory in the 
		adopath, so it is possible to overwrite the Stata Utilities
		ado files with custom versions.
	*/
	
	adopath + "${projectdirectory}ado/"
	adopath + "${statautil}"
	discard
	capture program drop all
	
	/*
		Create the working data and output directories.
		If they do not already exist.
	*/
	ensuredir "${workdatapath}"
	ensuredir "${outputpath}"
	ensuredir "${logpath}"
	ensuredir "${manuallogpath}"
	
	global ransetup = 1
} 

