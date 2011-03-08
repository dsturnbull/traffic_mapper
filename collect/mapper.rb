#!/usr/bin/env ruby
require 'rubygems'
require 'pcap'

def main
  pkts = {}

  STDIN.readlines.each do |line|
    file = line.strip

    begin
      Pcap::Capture.open_offline(file).dispatch do |pkt|
        if pkt.ip?
          src = pkt.src
          dst = pkt.dst

          k = [src, dst]
          pkts[k] ||= 0
          pkts[k] += pkt.size
        end
      end
    rescue
    end
  end

  pkts.each do |k, v|
    puts "#{k[0]}\t#{k[1]}\t#{v}"
  end
end

main

# vim: ts=2:sw=2:sts=2:et
