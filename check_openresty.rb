#!/bin/env ruby

require 'rest_client'

response = RestClient.get 'https://api.github.com/repos/openresty/ngx_openresty/tags'
latest = JSON.parse(response, { :symbolize_names => true })[0][:name]

puts latest
