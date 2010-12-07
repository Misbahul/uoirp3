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

# f1 = File.open("/Users/sechilds/uoirp/data/user/labels/county_codes.do", "w")
f2 = File.open("/Users/sechilds/uoirp/data/user/labels/county_en_label.do", "w")
f3 = File.open("/Users/sechilds/uoirp/data/user/labels/county_fr_label.do", "w")
mydata = FasterCSV.read('/Users/sechilds/uoirp/data/user/labels/county.txt',:headers => :first_row,:col_sep =>"\t") 
mydata.each do |row|
  # f1.puts("label define apptype_codes " + (index+1).to_s + " " + '"' + row[0].to_s.strip + '"' + ", add")
  label_number = row[1]
  if row[0]=="QC" { label_number = label_number + 100 }
  f2.puts("label define county_en_label " + row[1].to_s + " " + '"' + row[2].to_s.strip + '"' + ", add")
  f3.puts("label define county_fr_label " + row[1].to_s + " " + '"' + row[3].to_s.strip + '"' + ", add")
end

# f1.puts("")
f2.puts("")
f3.puts("")
# f1.close
f2.close
f3.close


