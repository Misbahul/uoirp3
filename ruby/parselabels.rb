#!/usr/bin/ruby

require 'fileutils'
require 'rubygems'
require 'fastercsv'

# f1 = File.open("/Users/sechilds/uoirp/data/user/labels/apptype_codes.do", "w")
# counter = 1
FasterCSV.foreach('/Users/sechilds/uoirp/data/user/labels/apptype.txt',:headers => :first_row,:col_sep =>"\t") do |row|
  # puts("label apptype_codes " + counter.to_s + " " + row[0].to_s + ", add")
  # counter += counter
  puts row
end

# f1.close

