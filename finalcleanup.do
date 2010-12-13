* finalcleanup.do

/*
	Clear the time and date strings.
*/

global ransetup ""

capture log close
capture cmdlog close



clear

shell git commit -a -m "Command Completed ${datestring} ${timestring}"

global datestring ""
global timestring ""

