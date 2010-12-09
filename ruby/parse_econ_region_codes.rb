#!/usr/bin/ruby

require 'fileutils'
require 'rubygems'
require 'fastercsv'

f1 = File.open("/Users/sechilds/uottawa/data/user/econ_region_codes.do", "w")
mydata = FasterCSV.read('/Users/sechilds/uottawa/data/user/econ_region_codes.txt',:headers => false,:col_sep => "\t")
mydata.each do |row|
	f1.puts("label define econ_region_codes " + row[0].to_s.strip + ' "' + row[1].to_s.strip + '"' + ", add" )
end

f1.puts("")
f1.close
