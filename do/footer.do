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
	shell git commit -m "Ran footer.do manually. (Likely due to an error)."
}
else {
	shell git commit -m "Successfully ran `dofilename'.do at `timestring' on `datestring'."
}
shell git status


