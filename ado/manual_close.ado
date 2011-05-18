capture program drop manual_close
program manual_close
	syntax [, NAMe(passthru)]
	
	log close `name'
	cmdlog close
end
