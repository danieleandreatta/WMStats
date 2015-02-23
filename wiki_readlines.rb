#!/usr/bin/ruby

$t1 = Time.new()
$pages = []

File.open(ARGV[0], "r") do |fin|
    fin.binmode
    fin.readlines.each do |a|
        ws = a.split(" ")
        if ws[0] == "en" && ws[2].to_i > 500
            $pages << [ws[1], ws[2].to_i]        
        end
    end
end

$pages.sort! {|a, b| b[1] <=> a[1]}

$t2 = Time.new()
$t = $t2 - $t1

puts "Query took %.2f seconds" % $t
$pages[0..9].each {|x| puts "#{x[0]} (#{x[1]})"}
