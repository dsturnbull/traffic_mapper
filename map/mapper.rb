#!/usr/bin/env ruby
require 'rubygems'
require 'geoip'

def g
  @g ||= GeoIP.new(File.dirname(__FILE__) + '/GeoLiteCity.dat')
end

def main
  STDIN.readlines.each do |line|
    src, dst, amt = line.strip.split("\t")
    src_loc = get_loc(src)
    dst_loc = get_loc(dst)

    if src_loc && dst_loc
      print "#{src}\t#{src_loc[0]}\t#{src_loc[1]}\t"
      print "#{dst}\t#{dst_loc[0]}\t#{dst_loc[1]}\t"
      print "#{amt}\n"
    end
  end
end

def get_loc(ip)
  _, _, _, _, _, _, _, _, _, lat, long, _, _, _ = g.city(ip)
  if lat && long
    [lat, long]
  end
end

main

# vim: ts=2:sw=2:sts=2:et
