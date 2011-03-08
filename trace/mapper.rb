#!/usr/bin/env ruby

def main
  pipes = {}

  data = []
  STDIN.readlines.each_with_index do |line, i|
    src, dst, amt = line.split("\t")
    amt = amt.to_i
    data << [src, dst, amt]
  end

  split = 20
  div = (data.length / split.to_f).ceil
  segments = data.each_slice(div).to_a

  threads = (0 .. split).map do |i|
    Thread.new do
      segment = segments[i]
      if segment
        segment.each do |src, dst, amt|
          r = `traceroute -m 25 -n -w 1 -q 1 #{dst}`
          path = r.split("\n").map { |trace|
            if trace =~ /[0-9]+ +([0-9]+\..*?) /
              $1
            end
          }.compact

          path.each_with_index do |dst, i|
            k = [path[i - 1], dst]
            pipes[k] ||= 0
            pipes[k] += amt
          end
        end
      end
    end
  end

  threads.map(&:join)

  pipes.each do |k, v|
    puts "#{k[0]}\t#{k[1]}\t#{v}"
  end
end

main

# vim: ts=2:sw=2:sts=2:et
