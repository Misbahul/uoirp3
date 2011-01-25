* finalcleanup.do

/*
	Clear the time and date strings.
*/

global ransetup ""

capture noisily log close
capture noisily cmdlog close



clear

if "`c(os)'"=="Windows" {
	shell readygit.bat
}
shell git commit -a -m "Command Completed ${datestring} ${timestring}"
shell git status

global datestring ""
global timestring ""

