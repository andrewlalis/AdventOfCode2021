module day9.part1;

import std.file;
import std.stdio;
import std.algorithm;
import std.string;
import std.conv;
import std.array;

struct Point {
    int col;
    int row;
}

Point[] getNeighbors(int[][] heightmap, int row, int col) {
    Point[] points = [];
    if (row > 0) points ~= Point(col, row - 1);
    if (col > 0) points ~= Point(col - 1, row);
    if (row + 1 < heightmap.length) points ~= Point(col, row + 1);
    if (col + 1 < heightmap[0].length) points ~= Point(col + 1, row);
    return points;
}

Point[] findLowPoints(int[][] heightmap) {
    Point[] points = [];
    foreach (r, row; heightmap) {
        foreach (c, height; row) {
            int minHeight = 10_000;
            foreach (neighbor; heightmap.getNeighbors(cast (int) r, cast(int) c)) {
                minHeight = min(minHeight, heightmap[neighbor.row][neighbor.col]);
            }
            if (height < minHeight) points ~= Point(cast(int) c, cast(int) r);
        }
    }
    return points;
}

Point[] exploreBasin(int[][] heightmap, Point location, ref Point[] visited) {
    int height = heightmap[location.row][location.col];
    visited ~= location;
    if (height >= 9) return [];
    Point[] basin = [location];
    foreach (neighbor; heightmap.getNeighbors(location.row, location.col)) {
        if (!canFind(visited, neighbor)) {
            basin ~= exploreBasin(heightmap, neighbor, visited);
        }
    }
    return basin;
}

Point[][] findBasins(int[][] heightmap) {
    Point[][] basins = [];
    Point[] visited = [];
    foreach (r, row; heightmap) {
        foreach (c, height; row) {
            Point p = Point(cast(int) c, cast(int) r);
            if (!canFind(visited, p) && height < 9) {
                basins ~= exploreBasin(heightmap, p, visited);
            }
        }
    }
    return basins;
}

void lavaTubes() {
    int[][] heightmap = readText("source/day9/input.txt").strip.split("\n")
        .map!(s => s.strip.map!(c => (c.to!int) - '0').array)
        .array;
    Point[][] basins = heightmap.findBasins;
    ulong basinSizeProduct = 1;
    basins.sort!((a, b) => a.length > b.length);
    foreach (i; 0..3) {
        basinSizeProduct *= basins[i].length;
    }
    writeln(basinSizeProduct);
}