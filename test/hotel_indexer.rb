#!/usr/bin/env ruby


page = ''
f = open('data/hotel_page.html')
while line = f.gets
  page << line
end
f.close

reg = /all_single_meta_reqs = JSON.decode\('([^;]+)'\);/
match = page.scan reg
tmp = match[0][ 0]

all_single_meta_reqs = []
tmp = tmp[1, tmp.length - 2]
bindex = 0
while eindex = tmp.index('{"hotel_id', bindex + 1)
  item = tmp[bindex, eindex - bindex - 1]
  all_single_meta_reqs << item
  bindex = eindex
end

if bindex < tmp.length
  all_single_meta_reqs << tmp[bindex, tmp.length - bindex]
end

all_single_meta_reqs.each do |single_meta_reqs|
  puts single_meta_reqs
end

