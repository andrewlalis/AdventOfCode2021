module day1.part1;

import std.stdio;
import util.fileutils;

void sonarSweep() {
    int increaseCount = 0;
    auto values = readInts("source/day1/input.txt");
    int previousValue = values[0];
    foreach(value; values[1..$]) {
        if (value > previousValue) {
            increaseCount++;
        }
        previousValue = value;
    }
    writefln("%d", increaseCount);
}