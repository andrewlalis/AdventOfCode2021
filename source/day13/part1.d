module day13.part1;

import std.file;
import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.array;

struct Point {
    int x;
    int y;
}

enum LineType {
    HORIZONTAL,
    VERTICAL
}

struct Line {
    LineType type;
    int value;
}

Point[] foldOver(ref Point[] points, Line line) {
    Point[] newPoints = [];
    void add(ref Point[] pts, Point p) {
        if (!canFind(pts, p)) pts ~= p;
    }
    foreach (i, point; points) {
        if (line.type == LineType.HORIZONTAL) {
            if (point.y < line.value) {
                add(newPoints, point);
            } else {
                int reflectedY = line.value - (point.y - line.value);
                if (reflectedY < line.value && reflectedY >= 0) {
                    add(newPoints, Point(point.x, reflectedY));
                }
            }
        } else if (line.type == LineType.VERTICAL) {
            if (point.x < line.value) {
                add(newPoints, point);
            } else {
                int reflectedX = line.value - (point.x - line.value);
                if (reflectedX < line.value && reflectedX >= 0) {
                    add(newPoints, Point(reflectedX, point.y));
                }
            }
        }
    }
    return newPoints;
}

void print(Point[] points) {
    int maxX = points.map!(p => p.x).maxElement;
    int maxY = points.map!(p => p.y).maxElement;
    foreach (y; 0..maxY + 1) {
        foreach (x; 0..maxX + 1) {
            bool pointExists = points.any!(p => p.x == x && p.y == y);
            writef("%c", pointExists ? '#' : '.');
        }
        writeln;
    }
}

void transparentOrigami() {
    string[] textBlocks = readText("source/day13/input.txt").strip.split("\r\n\r\n");
    writeln(textBlocks);
    Point[] points = textBlocks[0].split("\n")
        .filter!(line => line.strip.length > 0)
        .map!((line) {
            string[] parts = line.strip.split(",");
            return Point(parts[0].to!int, parts[1].to!int);
        }).array;
    Line[] lines = textBlocks[1].split("\n")
        .map!((line) {
            string[] parts = line.strip.split("=");
            LineType type = parts[0][$ - 1] == 'x' ? LineType.VERTICAL : LineType.HORIZONTAL;
            int value = parts[1].to!int;
            return Line(type, value);
        }).array;
    
    points.writeln;
    lines.writeln;

    foreach (i, line; lines) {
        points = foldOver(points, line);
        writefln("After fold %d, %d dots are visible.", i + 1, points.length);
    }
    print(points);
}