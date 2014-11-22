#!/usr/bin/env ruby

filename = File.dirname(__FILE__) + "/../config/application.rb"
require "#{File.expand_path(filename)}"

page = ''
f = open('data/page.html')

while line = f.gets
  page << line
end

f.close


reg = /<a target="_blank" class="property_title" href="(.+\.html)" onclick="setPID\(\d+\);" title="[^<>]+">\s+<span itemprop="name">([^<>]+)<\/span>\s+<\/a>/
match = page.scan reg

hotels = {}

match.each do |item|
  url = item[0]
  name = item[1]
  hotels[name] = url
end

puts hotels.length
