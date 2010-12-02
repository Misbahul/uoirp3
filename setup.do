* setup.do

if "${ransetup}"=="" { 
	global datestringp "$S_DATE"
	global timestringp "$S_TIME"
	
	do "locationspecificglobals"
	global datestring "${datestringp}"
	global timestring "${timestringp}"
	
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

