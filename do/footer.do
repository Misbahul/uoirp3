* footer.do

capture noisily log close
capture noisily cmdlog close

clear

if "`c(os)'"=="Windows" {
	shell readygit.bat
}
shell git add data/output/
shell git add data/log/
if "`dofilename'"=="" {
	shell git commit -m "Command Completed `datestring' `timestring'"
}
else {
	shell git commit -m "Successfully ran `dofilename'.do at `datestring' `timestring'"
}
shell git status


