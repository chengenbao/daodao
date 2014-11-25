#!/usr/bin/env ruby


filename = File.dirname(__FILE__) + "/../lib/daodao/utils/http_requester"
require "#{File.expand_path(filename)}"
require 'yaml'
require 'json'
require 'uri'

requester = Util::HttpRequester.new

url = "http://www.daodao.com/Hotel_Review-g294212-d3198755-Reviews-The_HuLu_Hotel-Beijing.html"

page = requester.get url, nil

reg = /all_single_meta_reqs = JSON.decode\('([^;]+)'\);/
match = page.scan reg
tmp = match[0][ 0]

all_single_meta_reqs = []
tmp = tmp[1, tmp.length - 2]
bindex = 0
while eindex = tmp.index('{"hotel_id', bindex + 1)
  item = tmp[bindex, eindex - bindex - 1]
  puts item
  all_single_meta_reqs << item
  bindex = eindex
end

if bindex < tmp.length
  all_single_meta_reqs << tmp[bindex, tmp.length - bindex]
end
all_single_meta_reqs.each do |single_mata_req|
  field = {}
  field['single_hotel_meta_req'] = single_mata_req

  url = 'http://www.daodao.com/DaoDaoCheckRatesAjax?action=getSingleHotelMeta'
  page = requester.get url, field
  puts page
  puts
end
