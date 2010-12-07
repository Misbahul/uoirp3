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
  if row[0].to_s == 'QC' 
    label_number = row[1].to_i + 100
  end
  f2.puts("label define county_en_label " + label_number.to_s + " " + '"' + row[2].to_s.strip + '"' + ", add")
  f3.puts("label define county_fr_label " + label_number.to_s + " " + '"' + row[3].to_s.strip + '"' + ", add")
end

# f1.puts("")
f2.puts("")
f3.puts("")
# f1.close
f2.close
f3.close

f1 = File.open("/Users/sechilds/uoirp/data/user/labels/credential_cd_codes.do", "w")
f2 = File.open("/Users/sechilds/uoirp/data/user/labels/credential_cd_en_label.do", "w")
f3 = File.open("/Users/sechilds/uoirp/data/user/labels/credential_cd_fr_label.do", "w")
f4 = File.open("/Users/sechilds/uoirp/data/user/labels/credential_cd_en_abbrev.do", "w")
f5 = File.open("/Users/sechilds/uoirp/data/user/labels/credential_cd_fr_abbrev.do", "w")
mydata = FasterCSV.read('/Users/sechilds/uoirp/data/user/labels/credential_cd.txt',:headers => :first_row,:col_sep =>"\t") 
mydata.each_with_index do |row, index|
  f1.puts("label define credential_cd_codes " + (index+1).to_s + " " + '"' + row[0].to_s.strip + '"' + ", add")
  f2.puts("label define credential_cd_en_label " + (index+1).to_s + " " + '"' + row[2].to_s.strip + '"' + ", add")
  f3.puts("label define credential_cd_fr_label " + (index+1).to_s + " " + '"' + row[3].to_s.strip + '"' + ", add")
  f4.puts("label define credential_cd_en_abbrev " + (index+1).to_s + " " + '"' + row[1].to_s.strip + '"' + ", add")
  f5.puts("label define credential_cd_fr_abbrev " + (index+1).to_s + " " + '"' + row[5].to_s.strip + '"' + ", add")
end

f1.puts("")
f2.puts("")
f3.puts("")
f4.puts("")
f5.puts("")
f1.close
f2.close
f3.close
f4.close
f5.close

f1 = File.open("/Users/sechilds/uoirp/data/user/labels/imstat_codes.do", "w")
f2 = File.open("/Users/sechilds/uoirp/data/user/labels/imstat_en_label.do", "w")
f3 = File.open("/Users/sechilds/uoirp/data/user/labels/imstat_fr_label.do", "w")
mydata = FasterCSV.read('/Users/sechilds/uoirp/data/user/labels/imstat.txt',:headers => :first_row,:col_sep =>"\t") 
mydata.each_with_index do |row, index|
  f1.puts("label define imstat_codes " + (index+1).to_s + " " + '"' + row[0].to_s.strip + '"' + ", add")
  f2.puts("label define imstat_en_label " + (index+1).to_s + " " + '"' + row[1].to_s.strip + '"' + ", add")
  f3.puts("label define imstat_fr_label " + (index+1).to_s + " " + '"' + row[1].to_s.strip + '"' + ", add")
end

f1.puts("")
f2.puts("")
f3.puts("")
f1.close
f2.close
f3.close

f1 = File.open("/Users/sechilds/uoirp/data/user/labels/kind_of_program_cd_codes.do", "w")
f2 = File.open("/Users/sechilds/uoirp/data/user/labels/kind_of_program_cd_en_label.do", "w")
f3 = File.open("/Users/sechilds/uoirp/data/user/labels/kind_of_program_cd_fr_label.do", "w")
mydata = FasterCSV.read('/Users/sechilds/uoirp/data/user/labels/kind_of_program_cd.txt',:headers => :first_row,:col_sep =>"\t") 
mydata.each_with_index do |row, index|
  f1.puts("label define kind_of_program_cd_codes " + (index+1).to_s + " " + '"' + row[0].to_s.strip + '"' + ", add")
  f2.puts("label define kind_of_program_cd_en_label " + (index+1).to_s + " " + '"' + row[2].to_s.strip + '"' + ", add")
  f3.puts("label define kind_of_program_cd_fr_label " + (index+1).to_s + " " + '"' + row[1].to_s.strip + '"' + ", add")
end

f1.puts("")
f2.puts("")
f3.puts("")
f1.close
f2.close
f3.close

f1 = File.open("/Users/sechilds/uoirp/data/user/labels/mother_tongue_codes.do", "w")
f2 = File.open("/Users/sechilds/uoirp/data/user/labels/mother_tongue_en_label.do", "w")
f3 = File.open("/Users/sechilds/uoirp/data/user/labels/mother_tongue_fr_label.do", "w")
mydata = FasterCSV.read('/Users/sechilds/uoirp/data/user/labels/mother_tongue.txt',:headers => :first_row,:col_sep =>"\t") 
mydata.each_with_index do |row, index|
  f1.puts("label define mother_tongue_codes " + (index+1).to_s + " " + '"' + row[0].to_s.strip + '"' + ", add")
  f2.puts("label define mother_tongue_en_label " + (index+1).to_s + " " + '"' + row[1].to_s.strip + '"' + ", add")
  f3.puts("label define mother_tongue_fr_label " + (index+1).to_s + " " + '"' + row[2].to_s.strip + '"' + ", add")
end

f1.puts("")
f2.puts("")
f3.puts("")
f1.close
f2.close
f3.close

f1 = File.open("/Users/sechilds/uoirp/data/user/labels/princ_teaching_lng_codes.do", "w")
f2 = File.open("/Users/sechilds/uoirp/data/user/labels/princ_teaching_lng_en_label.do", "w")
f3 = File.open("/Users/sechilds/uoirp/data/user/labels/princ_teaching_lng_fr_label.do", "w")
mydata = FasterCSV.read('/Users/sechilds/uoirp/data/user/labels/princ_teaching_lng.txt',:headers => :first_row,:col_sep =>"\t") 
mydata.each_with_index do |row, index|
  f1.puts("label define princ_teaching_lng_codes " + (index+1).to_s + " " + '"' + row[0].to_s.strip + '"' + ", add")
  f2.puts("label define princ_teaching_lng_en_label " + (index+1).to_s + " " + '"' + row[1].to_s.strip + '"' + ", add")
  f3.puts("label define princ_teaching_lng_fr_label " + (index+1).to_s + " " + '"' + row[1].to_s.strip + '"' + ", add")
end

f1.puts("")
f2.puts("")
f3.puts("")
f1.close
f2.close
f3.close


f1 = File.open("/Users/sechilds/uoirp/data/user/labels/subject_cd_codes.do", "w")
f2 = File.open("/Users/sechilds/uoirp/data/user/labels/subject_cd_en_label.do", "w")
f3 = File.open("/Users/sechilds/uoirp/data/user/labels/subject_cd_fr_label.do", "w")
mydata = FasterCSV.read('/Users/sechilds/uoirp/data/user/labels/subject_cd.txt',:headers => :first_row,:col_sep =>"\t") 
mydata.each_with_index do |row, index|
  f1.puts("label define subject_cd_codes " + (index+1).to_s + " " + '"' + row[0].to_s.strip + '"' + ", add")
  f2.puts("label define subject_cd_en_label " + (index+1).to_s + " " + '"' + row[2].to_s.strip + '"' + ", add")
  f3.puts("label define subject_cd_fr_label " + (index+1).to_s + " " + '"' + row[1].to_s.strip + '"' + ", add")
end

f1.puts("")
f2.puts("")
f3.puts("")
f1.close
f2.close
f3.close

f1 = File.open("/Users/sechilds/uoirp/data/user/labels/ug_spec_level_cd_codes.do", "w")
f2 = File.open("/Users/sechilds/uoirp/data/user/labels/ug_spec_level_cd_en_label.do", "w")
f3 = File.open("/Users/sechilds/uoirp/data/user/labels/ug_spec_level_cd_fr_label.do", "w")
mydata = FasterCSV.read('/Users/sechilds/uoirp/data/user/labels/ug_spec_level_cd.txt',:headers => :first_row,:col_sep =>"\t") 
mydata.each_with_index do |row, index|
  f1.puts("label define ug_spec_level_cd_codes " + (index+1).to_s + " " + '"' + row[0].to_s.strip + '"' + ", add")
  f2.puts("label define ug_spec_level_cd_en_label " + (index+1).to_s + " " + '"' + row[2].to_s.strip + '"' + ", add")
  f3.puts("label define ug_spec_level_cd_fr_label " + (index+1).to_s + " " + '"' + row[1].to_s.strip + '"' + ", add")
end

f1.puts("")
f2.puts("")
f3.puts("")
f1.close
f2.close
f3.close

