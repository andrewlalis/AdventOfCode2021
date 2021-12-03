module day3.part1;

import std.file;
import std.stdio;
import std.bitmanip;

void writeBinary(uint n) {
    for (int i = 31; i >= 0; i--) {
        uint b = (n & (1 << i)) > 0 ? 1 : 0;
        writef("%d ", b);
    }
    writeln();
}

void binaryDiagnostic() {
    auto f = File("source/day3/input.txt", "r");
    int[ubyte] frequencies;
    int count = 0;
    foreach (line; f.byLine) {
        count++;
        ubyte idx = 0;
        foreach (c; line) {
            if (idx !in frequencies) frequencies[idx] = 0;
            if (c == '1') frequencies[idx]++;
            idx++;
        }
    }
    ulong bitCount = frequencies.length;
    uint gamma = 0;
    uint epsilon = 0;
    foreach (idx, freq; frequencies) {
        if (freq > count / 2) {
            gamma |= (1 << (bitCount - 1 - idx));
        } else {
            epsilon |= (1 << (bitCount - 1 - idx));
        }
    }
    writefln("Gamma: %d, Epsilon: %d, Power: %d", gamma, epsilon, gamma * epsilon);
}

bool is1Common(uint[] values, int idx, int bitCount, bool type) pure {
    int count = 0;
    foreach (v; values) {
        if ((v & (1 << (bitCount - 1 - idx))) > 0) count++;
    }
    if (type) {
        return count >= (values.length - count);
    } else {
        return count < (values.length - count);
    }
}

void filter(ref uint[] values, int idx, int bitCount, bool type) pure {
    bool common = is1Common(values, idx, bitCount, type);
    uint[] newValues = [];
    foreach (v; values) {
        bool b = (v & (1 << (bitCount - 1 - idx))) > 0;
        if (b == common) newValues ~= v;
    }
    values = newValues;
}

uint findValue(uint[] values, int bitCount, bool type) {
    int idx = 0;
    while (values.length > 1) {
        filter(values, idx++, bitCount, type);
    }
    return values[0];
}

void binaryDiagnostic2() {
    auto f = File("source/day3/input.txt", "r");
    uint[] values = [];
    int bitCount = 0;
    foreach (line; f.byLine) {
        bitCount = cast(int) line.length;
        int idx = 0;
        uint value = 0;
        foreach (c; line) {
            if (c == '1') value |= (1 << line.length - 1 - idx);
            idx++;
        }
        values ~= value;
    }
    uint o2 = findValue(values, bitCount, true);
    uint co2 = findValue(values, bitCount, false);
    writefln("Oxygen: %d, CO2: %d, LS Rating: %d", o2, co2, o2 * co2);
}
