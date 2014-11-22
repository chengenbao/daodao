#!/usr/bin/env ruby


filename = File.dirname(__FILE__) + "/../config/application.rb"
require "#{File.expand_path(filename)}"
require 'yaml'
require 'json'
require 'uri'

requester = Util::HttpRequester.new
hotels_map = YAML.load(File.open('data/beijing-hotels.yaml'))
map = {}
hotels_map.each do |k, v|
  s = k.unpack('H*')[0]
  map[s] = v
end

name = ARGV[0].unpack('H*')[0]
url = map[name]
url = "http://www.daodao.com#{url}"

#page = requester.get url, nil

#// read page data
page = ''
f = open('data/hotel_page.html')
while line = f.gets
  page << line
end

reg = /all_single_meta_reqs = JSON.decode\('([^;]+)'\);/
match = page.scan reg
all_single_meta_reqs = match[0][ 0]

all_single_meta_reqs = JSON.parse(all_single_meta_reqs)

all_single_meta_reqs.each do |single_mata_req|
  data = single_mata_req.to_json
  field = {}
  field['single_hotel_meta_req'] = data

  url = 'http://www.daodao.com/DaoDaoCheckRatesAjax?action=getSingleHotelMeta'
  page = requester.get url, field
  puts page
  puts
end
