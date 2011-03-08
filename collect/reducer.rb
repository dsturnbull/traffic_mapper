#!/usr/bin/env ruby

def main
  pipes = {}

  STDIN.readlines.each do |line|
    src, dst, amt = line.strip.split("\t")
    k = [src, dst]

    unless local_ip(dst)
      pipes[k] ||= 0
      pipes[k] += amt.to_i
    end
  end

  pipes.each do |k, v|
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
