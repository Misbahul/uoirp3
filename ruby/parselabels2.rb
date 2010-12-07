#!/usr/bin/ruby

require 'fileutils'
require 'rubygems'
require 'fastercsv'

f1 = File.open("/Users/sechilds/uoirp/data/user/labels/apptype_codes.do", "w")
f2 = File.open("/Users/sechilds/uoirp/data/user/labels/apptype_en_label.do", "w")
f3 = File.open("/Users/sechilds/uoirp/data/user/labels/apptype_fr_label.do", "w")
mydata = FasterCSV.read('/Users/sechilds/uoirp/data/user/labels/apptype.txt',:headers => :first_row,:col_sep =>"\t") 
mydata.each_with_index do |row, index|
  f1.puts("label define apptype_codes " + (index+1).to_s + " " + '"' + row[0].to_s.strip + '"' + ", add")
  f2.puts("label define apptype_en_label " + (index+1).to_s + " " + '"' + row[1].to_s.strip + '"' + ", add")
  f3.puts("label define apptype_fr_label " + (index+1).to_s + " " + '"' + row[2].to_s.strip + '"' + ", add")
end

f1.puts("")
f2.puts("")
f3.puts("")
f1.close
f2.close
f3.close


