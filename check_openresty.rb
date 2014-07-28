#!/bin/env ruby

#require 'rubygems'
require 'net/http'
require 'net/https'
require 'json'

uri = URI.parse('https://api.github.com/repos/openresty/ngx_openresty/tags')
http = Net::HTTP.new(uri.host,uri.port)
http.use_ssl = true
request = Net::HTTP::Get.new(uri.request_uri)
request.add_field('User-Agent','openresty-check-1.0')
response = http.request(request)

latest = JSON.parse(response.body, { :symbolize_names => true })[0][:name]

puts latest
