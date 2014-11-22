#!/usr/bin/env ruby

filename = File.dirname(__FILE__) + "/../config/application.rb"
require "#{File.expand_path(filename)}"
require 'yaml'

requester = Util::HttpRequester.new

url = 'http://www.daodao.com/HACSearch'
geo_map = YAML.load(File.open('data/geo.yaml'))

geo = geo_map['北京市']
puts geo
field = {}
field['geo'] = geo

def retrieve_hotels(p)
  reg = /<a target="_blank" class="property_title" href="(.+\.html)" onclick="setPID\(\d+\);" title="[^<>]+">\s+<span itemprop="name">([^<>]+)<\/span>\s+<\/a>/
  match = p.scan reg

  hotels = {}

  match.each do |item|
    url = item[0]
    name = item[1]
    hotels[name] = url
  end

  return hotels
end

def get_next_page_url(p)
  next_page_url = /<a href="(.+\.html)" class="next sprite-arrow-right-green ml6 js_HACpager">[^<>]+<\/a>/
  match = p.scan next_page_url

  return match.length > 0 ? match[0][0] : nil
end

# crawl first page
page = requester.get(url, field)
hotels = retrieve_hotels page

next_page_url = get_next_page_url(page)
while next_page_url != nil
  url = "http://www.daodao.com#{next_page_url}"

  puts url
  begin
    page = requester.get(url, nil)
    h = retrieve_hotels(page)
    h.each do |k, v|
      hotels[k] = v
    end
    next_page_url = get_next_page_url(page)
  rescue
    puts "exception caught"
  end
  sleep 3
end


fo = open('beijing-hotels.yaml', 'w')
fo.write YAML.dump(hotels)
fo.close

