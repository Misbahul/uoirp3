// configure.do

/*
	This Stata do file will configure a new installation
	of the do files.
*/

capture program drop configure_paths
program configure_paths
	display _newline
	display as text "Welcome to the Stata do file configuration utility."
	display as text "We will setup a " as result "user_locals.do" as text "file for you."
	display _newline _newline

	/*
		If there is an existing user_locals.do file, back it up.
	*/
	capture confirm file do/user_locals.do
	if !_rc {
		copy do/user_locals.do do/user_locals_backup.do, replace
		rm do/user_locals.do
	}

	tempname myfile
	file open `myfile' using do/user_locals.do, write text replace

	file write `myfile' "// user_locals.do" _newline _newline

	display as text "*** Location Name ***"
	display as text "Please choose a name for this particularl installation of the do files."
	display _newline as text "Location name (home1):" _newline _request(locationname)
	if "${locationname}"=="" {
		global locationname "home1"
	}
	file write `myfile' `"local locationname "${locationname}""' _newline

	local currdir "`c(pwd)'"
	display _newline _newline
	display as text "*** Project Directory ***"
	display as text "Please enter the location where the project files are stored, or hit enter to put them in the current directory."
	display _newline as text "Project Directory (`currdir'`c(dirsep)'):" _newline _request(projectdirectory)
	if "${projectdirectory}"=="" {
		global projectdirectory "`currdir'`c(dirsep)'"
	}
	if substr( "${projectdirectory}",-1,1)!="/" & substr( "${projectdirectory}",-1,1)!="\" {
		global projectdirectory "${projectdirectory}`c(dirsep)'"
	}
	file write `myfile' `"local projectdirectory "${projectdirectory}""' _newline

	display _newline _newline
	display as text "*** Stata Utilities ***"
	display as text "Please enter the location of the Stata Utilities directory on your computer."
	global statautil ""
	while "${statautil}"=="" {
		display _newline as text "Stata Utilities Directory:" _newline _request(statautil)
	}
	file write `myfile' `"local statautil "${statautil}""' _newline

	display _newline _newline
	display as text "*** Data Path ***"
	display as text "All the data these do file use and generate will do into this directory."
	display as text "Logs and results will be generated here as well."
	display _newline as text "Data directory (${projectdirectory}`c(dirsep)'data`c(dirsep)'):" _newline _request(datapath)
	if "${datapath}"=="" {
		global datapath "${projectdirectory}`c(dirsep)'data`c(dirsep)'"
	}
	file write `myfile' `"local datapath "${datapath}""' _newline

	display _newline _newline
	display as text "*** Source Data Path ***"
	display as text "Original source data."
	display _newline as text "Source Data directory (${projectdirectory}`c(dirsep)'data`c(dirsep)'source`c(dirsep)'):" _newline _request(sourcedatapath)
	if "${sourcedatapath}"=="" {
		global sourcedatapath "${projectdirectory}`c(dirsep)'data`c(dirsep)'source`c(dirsep)'"
	}
	file write `myfile' `"local sourcedatapath "${sourcedatapath}""' _newline

	display _newline _newline
	display as text "*** Work Data Path ***"
	display as text "Working data files."
	display _newline as text "Work Data directory (${projectdirectory}`c(dirsep)'data`c(dirsep)'work`c(dirsep)'):" _newline _request(workdatapath)
	if "${workdatapath}"=="" {
		global workdatapath "${projectdirectory}`c(dirsep)'data`c(dirsep)'work`c(dirsep)'"
	}
	file write `myfile' `"local workdatapath "${workdatapath}""' _newline

	display _newline _newline
	display as text "*** User Data Path ***"
	display as text "Additional files created by the user."
	display _newline as text "User Data directory (${projectdirectory}`c(dirsep)'data`c(dirsep)'user`c(dirsep)'):" _newline _request(userdatapath)
	if "${userdatapath}"=="" {
		global userdatapath "${projectdirectory}`c(dirsep)'data`c(dirsep)'user`c(dirsep)'"
	}
	file write `myfile' `"local userdatapath "${userdatapath}""' _newline

	display _newline _newline
	display as text "*** Log Path ***"
	display as text "Directory for storing Stata logs."
	display _newline as text "Log paths (${projectdirectory}`c(dirsep)'data`c(dirsep)'log`c(dirsep)'):" _newline _request(logdatapath)
	if "${logdatapath}"=="" {
		global logdatapath "${projectdirectory}`c(dirsep)'data`c(dirsep)'log`c(dirsep)'"
	}
	file write `myfile' `"local logpath "${logdatapath}""' _newline

	display _newline _newline
	display as text "*** Manual Log Path ***"
	display as text "Directory for storing Stata manual logs."
	display _newline as text "Log paths (${projectdirectory}`c(dirsep)'data`c(dirsep)'log`c(dirsep)'manual`c(dirsep)'):" _newline _request(manuallogpath)
	if "${manuallogpath}"=="" {
		global manuallogpath "${projectdirectory}`c(dirsep)'data`c(dirsep)'log`c(dirsep)'manual`c(dirsep)'"
	}
	file write `myfile' `"local manuallogpath "${manuallogpath}""' _newline

	display _newline _newline
	display as text "*** Output Path ***"
	display as text "Generated output will be created here."
	display _newline as text "Output directory (${projectdirectory}`c(dirsep)'data`c(dirsep)'output`c(dirsep)'):" _newline _request(outputpath)
	if "${outputpath}"=="" {
		global outputpath "${projectdirectory}`c(dirsep)'data`c(dirsep)'output`c(dirsep)'"
	}
	file write `myfile' `"local outputpath "${outputpath}""' _newline
	file write `myfile' _newline _newline

	file close `myfile'
end

configure_paths
