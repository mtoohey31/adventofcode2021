#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.new('../input', 'r').read

lines = input.split("\n").map { |line| line.split(' -> ').map { |coord| coord.split(',').map { |val| Integer(val) } } }

max_x = lines.map { |line| line.map { |point| point[0] }.max }.max

max_y = lines.map { |line| line.map { |point| point[1] }.max }.max

grid = Array.new(max_y + 1).map { |_| Array.new(max_x + 1, 0) }

lines.each do |line|
  distance = [(line[0][0] - line[1][0]).abs, (line[0][1] - line[1][1]).abs].max

  x_step = if line[0][0] < line[1][0]
             1
           elsif line[0][0] > line[1][0]
             -1
           else
             0
           end
  y_step = if line[0][1] < line[1][1]
             1
           elsif line[0][1] > line[1][1]
             -1
           else
             0
           end
  [*0..distance].each do |i|
    grid[line[0][1] + (i * y_step)][line[0][0] + (i * x_step)] += 1
  end
end

puts grid.map { |row| row.select { |val| val >= 2 }.length }.sum
