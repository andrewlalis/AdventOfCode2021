module day1.part2;

import std.stdio;
import util.fileutils;

void slidingSum() {
    int[] values = readInts("source/day1/input.txt");
    int previousSum = values[0] + values[1] + values[2];
    int increaseCount = 0;
    foreach (i; 1 .. (values.length - 2)) {
        int currentSum = values[i] + values[i + 1] + values[i + 2];
        bool increase = false;
        if (currentSum > previousSum) {
            increaseCount++;
            increase = true;
        }
        previousSum = currentSum;
    }
    writefln("%d", increaseCount);
}