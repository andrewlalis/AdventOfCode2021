module day5.part1;

import std.file;
import std.stdio;
import std.format;
import std.math;

bool between(int a, int b, int x) {
    if (a < b) {
        return x >= a && x <= b;
    }
    return x >= b && x <= a;
}

void updateMin(ref int m, int[] values...) {
    foreach (v; values) {
        if (v < m) m = v;
    }
}

void updateMax(ref int m, int[] values...) {
    foreach (v; values) {
        if (v > m) m = v;
    }
}

struct Point {
    int x;
    int y;
}

struct LineSegment {
    Point p1;
    Point p2;

    float slope() {
        return (p2.y - p1.y) / cast(float) (p2.x - p1.x);
    }

    bool isOrthogonal() {
        return isVertical || isHorizontal;
    }

    bool isVertical() {
        return p1.x == p2.x;
    }

    bool isHorizontal() {
        return p1.y == p2.y;
    }

    bool isDiagonal() {
        return abs(p2.x - p1.x) == abs(p2.y - p1.y);
    }

    bool occupiesPoint(Point p) {
        if (isVertical()) {
            return p.x == p1.x && between(p1.y, p2.y, p.y);
        } else if (isHorizontal()) {
            return p.y == p1.y && between(p1.x, p2.x, p.x);
        } else if (isDiagonal()) {
            return between(p1.x, p2.x, p.x) && between(p1.y, p2.y, p.y) && abs(p.x - p1.x) == abs(p.y - p1.y);
        }
        return false;
    }
}

void draw(Point minCorner, Point maxCorner, LineSegment[] segments) {
    for (int y = minCorner.y; y <= maxCorner.y; y++) {
        for (int x = minCorner.x; x <= maxCorner.x; x++) {
            Point p = Point(x, y);
            int overlaps = 0;
            foreach (ls; segments) {
                if (ls.occupiesPoint(p)) overlaps++;
            }
            if (overlaps > 0) {
                writef("%d", overlaps);
            } else {
                write(".");
            }
        }
        writeln();
    }
}

void hydrothermalVents() {
    auto f = File("source/day5/input.txt", "r");
    LineSegment[] segments = [];
    Point minCorner = Point(1_000_000, 1_000_000);
    Point maxCorner = Point(0, 0);
    foreach (line; f.byLine) {
        LineSegment ls;
        formattedRead!"%d,%d -> %d,%d"(line, ls.p1.x, ls.p1.y, ls.p2.x, ls.p2.y);
        if (ls.isOrthogonal() || ls.isDiagonal()) {
            updateMin(minCorner.x, ls.p1.x, ls.p2.x);
            updateMin(minCorner.y, ls.p1.y, ls.p2.y);
            updateMax(maxCorner.x, ls.p1.x, ls.p2.x);
            updateMax(maxCorner.y, ls.p1.y, ls.p2.y);
            segments ~= ls;
        }
    }
    writefln("Checking %d segments between %s and %s", segments.length, minCorner, maxCorner);
    // draw(minCorner, maxCorner, segments);
    int intersects = 0;
    for (int x = minCorner.x; x <= maxCorner.x; x++) {
        for (int y = minCorner.y; y <= maxCorner.y; y++) {
            Point p = Point(x, y);
            int overlaps = 0;
            foreach (ls; segments) {
                if (ls.occupiesPoint(p)) {
                    overlaps++;
                }
            }
            if (overlaps > 1) intersects++;
        }
    }
    writefln("%d", intersects);
}