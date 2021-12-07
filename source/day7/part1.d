module day7.part1;

import std.stdio;
import std.math;
import std.algorithm;
import util.fileutils;

int getFuelCost(int[] crabs, int pos) {
    return crabs.map!((crab) {
        int distance = abs(pos - crab);
        return (distance * (distance + 1)) / 2;
    }).sum();
}

void crabFuel() {
    int[] crabs = readInts("source/day7/input.txt", ",");
    int minCost = 1_000_000_000;
    foreach (pos; crabs.minElement .. crabs.maxElement) {
        int c = getFuelCost(crabs, pos);
        if (c < minCost) minCost = c;
    }
    writefln("%d", minCost);
}