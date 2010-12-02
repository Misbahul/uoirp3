* finalcleanup.do

/*
	Clear the time and date strings.
*/
global datestring ""
global timestring ""
global ransetup ""

capture log close
capture cmdlog close
clear

