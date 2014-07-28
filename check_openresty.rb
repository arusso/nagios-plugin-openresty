#!/bin/env ruby

#require 'rubygems'
require 'net/http'
require 'net/https'
require 'json'
require 'openssl'

def get_latest()
  uri = URI.parse('https://api.github.com/repos/openresty/ngx_openresty/tags')
  http = Net::HTTP.new(uri.host,uri.port)
  if uri.scheme == 'https'
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  request = Net::HTTP::Get.new(uri.request_uri)
  request.add_field('User-Agent','openresty-check-1.0')
  response = http.request(request)

  latest = JSON.parse(response.body, { :symbolize_names => true })[0][:name]
  latest.gsub!('v','')
  latest
end

def get_current(uri)
  uri = URI.parse(uri)
  http = Net::HTTP.new(uri.host,uri.port)
  if uri.scheme == 'https'
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  request = Net::HTTP::Head.new(uri.request_uri)
  request.add_field('User-Agent', 'openresty-check-1.0')
  response = http.request(request)
  version = response['Server']
  version.gsub(/(ngx_|)openresty\//,'')
end

# We're not installing gems or anything, just using their version class to do a
# proper comparison of version strings
current = Gem::Version.new(get_current(ARGV[0]))
latest = Gem::Version.new(get_latest)

if current > latest
  # version is newer than it should be, report an unknown error
  puts "UNKNOWN: installed version greater than latest version (#{current} > #{latest})"
  exit 3
elsif current == latest
  # we're on the latest
  puts "OK: current version matches latest (#{current} == #{latest})"
  exit 0
elsif current < latest
  # we're on an old version
  puts "CRITICAL: current version is out-of-date (#{current} < #{latest})"
  exit 2
else
  puts "UNKNOWN: An unexplained error occurred!"
  exit 3
end
