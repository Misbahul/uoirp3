*1.0 GHR Jan 19, 2011
capture program drop growl
program define growl
	version 10
	set more off
	syntax [anything]

	if "`c(os)'"=="MacOSX" {
		if "`anything'"=="" {
			local message "Stata needs attention"
		}
		else {
			local message "`anything'"
		}

		local appversion "Stata"
		if "`c(flavor)'"=="Small" {
			local appversion "smStata"
		}
		else {
			if `c(SE)'==1 {
				if `c(MP)'==1 {
					local appversion "StataMP"
				}
				else {
					local appversion "StataSE"
					if "`c(machine_type)'"=="Macintosh (Intel 64-bit)" {
						local appversion "Stata64SE"
					}
				
				}
			}
			else {
				local appversion "Stata"
			}
		}
		shell growlnotify -a `appversion' -m \ "`message'" \ `appversion' \
	}
end
