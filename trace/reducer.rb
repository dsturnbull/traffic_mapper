#!/usr/bin/env ruby

def main
  ips = {}
  STDIN.readlines.each do |line|
    src, dst, amt = line.split("\t")
    amt = amt.to_i

    unless local_ip(src) || local_ip(dst)
      k = [src, dst]
      ips[k] ||= 0
      ips[k] += amt
    end
  end

  ips.each do |k, v|
    puts "#{k[0]}\t#{k[1]}\t#{v}"
  end
end

def local_ip(ip)
  case ip
  when /^10\./
    true
  when /^192\.168/
    true
  when /^172.[123][0-9]\./
    true
  when /^224/
    true
  when /^255\.255\.255\.255/
    true
  else
    false
  end
end

main

# vim: ts=2:sw=2:sts=2:et
