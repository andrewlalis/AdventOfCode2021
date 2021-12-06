module day6.part1;

import std.file;
import std.stdio;
import std.math;
import std.string;
import std.algorithm;
import std.conv;
import std.array;
import std.parallelism;

ulong computeGrowth(ulong initial, ulong t) {
    return (t <= initial) ? 1 : computeGrowth(6, t - initial - 1) + computeGrowth(8, t - initial - 1);
}

void lanternFish() {
    auto f = File("source/day6/input.txt", "r");
    ulong t = 256;
    ulong[] fish = f.readln().strip().split(",").map!(s => s.to!ulong).array;
    ulong total = 0;
    // WARNING!!! Only use this on a PC with >= 24 threads.
    writefln("Using %d threads.", taskPool.size());
    foreach (idx, i; taskPool.parallel(fish, 1)) {
        total += computeGrowth(i, t);
        writefln("Computed growth for fish %d", idx);
    }
    writefln("%d", total);
}