#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.new('../input', 'r').read

lines = input.split("\n").map { |line| line.split(' -> ').map { |coord| coord.split(',').map { |val| Integer(val) } } }

max_x = lines.map { |line| line.map { |point| point[0] }.max }.max

max_y = lines.map { |line| line.map { |point| point[1] }.max }.max

grid = Array.new(max_y + 1).map { |_| Array.new(max_x + 1, 0) }

horizontal_lines = lines.select { |line| line[0][1] == line[1][1] && line[0][0] != line[1][0] }

vertical_lines = lines.select { |line| line[0][1] != line[1][1] && line[0][0] == line[1][0] }

points = lines.select { |line| line[0][1] == line[1][1] && line[0][0] == line[1][0] }

horizontal_lines.each do |line|
  [*[line[0][0], line[1][0]].min..[line[0][0], line[1][0]].max].each do |i|
    grid[line[0][1]][i] += 1
  end
end

vertical_lines.each do |line|
  [*[line[0][1], line[1][1]].min..[line[0][1], line[1][1]].max].each do |i|
    grid[i][line[0][0]] += 1
  end
end

points.each do |point|
  grid[point[0][0]][point[0][1]] += 1
end

puts grid.map { |row| row.select { |val| val >= 2 }.length }.sum
