* footer.do

capture noisily log close
capture noisily cmdlog close

clear

if "`c(os)'"=="Windows" {
	shell readygit.bat
}
shell git add data/output/
shell git add data/log/
shell git commit -m "Command Completed `datestring' `timestring'"
shell git status


