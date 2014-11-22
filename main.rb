#!/usr/bin/env ruby

require 'yaml'

hotels = YAML.load(File.open('data/beijing-hotels.yaml'))
hotels.each do |k, v|
  puts k
end
