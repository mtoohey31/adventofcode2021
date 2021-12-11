const std = @import("std");
const fs = std.fs;
const print = std.debug.print;

pub fn main() !void {
    var inputFile = try std.fs.cwd().openFile("../input", .{});
    defer inputFile.close();

    var buf_reader = std.io.bufferedReader(inputFile.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    var grid: [10][10]u8 = undefined;

    var i: u8 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var j: u8 = 0;
        while (j < 10) {
            grid[i][j] = line[j] - 48;
            j += 1;
        }
        i += 1;
    }

    var numFlashes: u32 = 0;

    i = 0;
    while (i < 100) {
        increment(&grid);
        numFlashes += checkFlashes(&grid);

        i += 1;
    }

    // printGrid(&grid);
    print("{d}\n", .{numFlashes});
}

fn printGrid(grid: *[10][10]u8) void {
    for (grid) |row| {
        for (row) |int| {
            print("{d}", .{int});
        }
        print("\n", .{});
    }
}

fn increment(grid: *[10][10]u8) void {
    var i: u8 = 0;
    while (i < 10) {
        var j: u8 = 0;
        while (j < 10) {
            grid[i][j] += 1;

            j += 1;
        }

        i += 1;
    }
}

fn checkFlashes(grid: *[10][10]u8) u32 {
    var numFlashes: u32 = 0;

    var i: u8 = 0;
    while (i < 10) {
        var j: u8 = 0;
        while (j < 10) {
            if (grid[i][j] > 9) {
                numFlashes += flash(grid, i, j);
            }

            j += 1;
        }

        i += 1;
    }

    return numFlashes;
}

fn flash(grid: *[10][10]u8, i: u8, j: u8) u32 {
    var numFlashes: u32 = 1;

    var rangeYStart = max(1, i) - 1;
    var rangeXStart = max(1, j) - 1;
    var rangeYEnd = min(10, i + 2);
    var rangeXEnd = min(10, j + 2);

    grid[i][j] = 0;

    var k: u8 = rangeYStart;
    while (k < rangeYEnd) {
        var l: u8 = rangeXStart;
        while (l < rangeXEnd) {
            if (grid[k][l] != 0) {
                grid[k][l] += 1;
            }

            if (grid[k][l] > 9) {
                numFlashes += flash(grid, k, l);
            }

            l += 1;
        }

        k += 1;
    }

    return numFlashes;
}

fn max(a: u8, b: u8) u8 {
    return if (a > b) a else b;
}

fn min(a: u8, b: u8) u8 {
    return if (a < b) a else b;
}
