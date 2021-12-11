module day11.part1;

import std.file;
import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import std.array;

struct Point { size_t r; size_t c; }

Point[] getAdjacentPoints(ubyte[][] map, Point p) {
    size_t size = map.length;
    Point[] points = [];
    if (p.r > 0 && p.c > 0) points ~= Point(p.r - 1, p.c - 1);
    if (p.r > 0) points ~= Point(p.r - 1, p.c);
    if (p.c > 0) points ~= Point(p.r, p.c - 1);
    if (p.r > 0 && p.c + 1 < size) points ~= Point(p.r - 1, p.c + 1);
    if (p.c + 1 < size) points ~= Point(p.r, p.c + 1);
    if (p.r + 1 < size) points ~= Point(p.r + 1, p.c);
    if (p.r + 1 < size && p.c > 0) points ~= Point(p.r + 1, p.c - 1);
    if (p.r + 1 < size && p.c + 1 < size) points ~= Point(p.r + 1, p.c + 1);
    return points;
}

uint flash(ref ubyte[][] map, size_t row, size_t col, ref bool[][] flashed) {
    Point[] neighbors = getAdjacentPoints(map, Point(row, col));
    uint flashes = 1;
    flashed[row][col] = true;
    foreach (n; neighbors) {
        if (!flashed[n.r][n.c]) {
            map[n.r][n.c]++;
            if (map[n.r][n.c] > 9) {
                flashes += flash(map, n.r, n.c, flashed);
            }
        }
    }
    return flashes;
}

uint doStepPart1(ref ubyte[][] map) {
    bool[][] flashed;
    flashed.length = map.length;
    foreach (r, row; map) {
        flashed[r].length = map.length;
        foreach (c, e; row) {
            map[r][c]++;
        }
    }
    uint flashes = 0;
    foreach (r, row; map) {
        foreach (c, e; row) {
            if (e > 9 && !flashed[r][c]) {
                flashes += flash(map, r, c, flashed);
            }
        }
    }
    bool allFlashed = true;
    foreach (r, row; map) {
        foreach (c, e; row) {
            if (flashed[r][c]) {
                map[r][c] = 0;
            } else {
                allFlashed = false;
            }
        }
    }
    return flashes;
}

uint doStepPart2(ref ubyte[][] map) {
    bool[][] flashed;
    flashed.length = map.length;
    foreach (r, row; map) {
        flashed[r].length = map.length;
        foreach (c, e; row) {
            map[r][c]++;
        }
    }
    uint flashes = 0;
    foreach (r, row; map) {
        foreach (c, e; row) {
            if (e > 9 && !flashed[r][c]) {
                flashes += flash(map, r, c, flashed);
            }
        }
    }
    foreach (r, row; map) {
        foreach (c, e; row) {
            if (flashed[r][c]) {
                map[r][c] = 0;
            }
        }
    }
    return flashes == (map.length * map.length);
}

void dumboOctopus() {
    ubyte[][] map = readText("source/day11/input.txt").strip.split("\n")
        .map!(s => s.strip.map!(c => cast(ubyte)(c.to!ubyte - '0')).array)
        .array;
    ulong i = 0;
    while (true) {
        if (doStepPart2(map)) {
            writefln("All flashed at: %d", i + 1);
            break;
        }
        i++;
    }
}