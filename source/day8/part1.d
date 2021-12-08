module day8.part1;

import std.file;
import std.stdio;
import std.string;
import std.algorithm;
import std.typecons;
import std.array;
import std.conv;

struct Entry {
    string[] signalPatterns;
    string[] outputValues;
}

Entry[] readEntries(string filename) {
    return readText(filename).strip.split("\n")
        .map!((line) {
            auto parts = line.split("|");
            return Entry(parts[0].strip.split(), parts[1].strip.split());
        }).array;
}

ulong count1478(Entry[] entries) {
    return entries.map!((entry) {
        writeln(entry);
        return entry.outputValues.filter!(v => v.length == 2 || v.length == 4 || v.length == 3 || v.length == 7).count;
    }).sum();
}

int decodeEntry(Entry entry) {
    int[string] knownSignals;
    string[int] knownSignalsInverse;

    void registerKnownSignal(string signal, int digit) {
        knownSignals[signal] = digit;
        knownSignalsInverse[digit] = signal;
    }

    // First we register all of the basic signals that will be used to identify others.
    foreach (signal; entry.signalPatterns) {
        if (signal.length == 2) {
            registerKnownSignal(signal, 1);
        }
        if (signal.length == 3) {
            registerKnownSignal(signal, 7);
        }
        if (signal.length == 4) {
            registerKnownSignal(signal, 4);
        }
        if (signal.length == 7) {
            registerKnownSignal(signal, 8);
        }
    }

    bool matchesCount(string signal, int knownSignal, int requiredMatches = -1) {
        int c = 0;
        if (requiredMatches == -1) requiredMatches = cast(int) knownSignalsInverse[knownSignal].length;
        foreach (segment; signal) {
            if (knownSignalsInverse[knownSignal].canFind(segment)) c++;
        }
        return c == requiredMatches;
    }

    // Register all other signals using the ones we registered in the first pass.
    foreach (signal; entry.signalPatterns) {
        if (signal.length == 6) {
            if (0 !in knownSignalsInverse && matchesCount(signal, 1) && matchesCount(signal, 7) && matchesCount(signal, 4, 3)) {
                registerKnownSignal(signal, 0);
            }
            if (6 !in knownSignalsInverse && matchesCount(signal, 1, 1) && matchesCount(signal, 4, 3) && matchesCount(signal, 7, 2)) {
                registerKnownSignal(signal, 6);
            }
            if (9 !in knownSignalsInverse && matchesCount(signal, 1) && matchesCount(signal, 4) && matchesCount(signal, 7)) {
                registerKnownSignal(signal, 9);
            }
        }
        if (signal.length == 5) {
            if (2 !in knownSignalsInverse && matchesCount(signal, 1, 1) && matchesCount(signal, 4, 2) && matchesCount(signal, 7, 2)) {
                registerKnownSignal(signal, 2);
            }
            if (3 !in knownSignalsInverse && matchesCount(signal, 1) && matchesCount(signal, 7) && matchesCount(signal, 4, 3)) {
                registerKnownSignal(signal, 3);
            }
            if (5 !in knownSignalsInverse && matchesCount(signal, 1, 1) && matchesCount(signal, 4, 3) && matchesCount(signal, 7, 2)) {
                registerKnownSignal(signal, 5);
            }
        }
    }

    bool areStringsPermutations(string a, string b) {
        if (a.length != b.length) return false;
        foreach (c; a) {
            if (!b.canFind(c)) return false;
        }
        return true;
    }

    int[] resultDigits = [];
    foreach (outputValue; entry.outputValues) {
        foreach (knownSignal, digit; knownSignals) {
            if (areStringsPermutations(outputValue, knownSignal)) {
                resultDigits ~= digit;
                break;
            }
        }
    }

    return resultDigits.map!(digit => digit.to!string).joiner().to!int;
}

void sevenSegmentSearch() {
    "source/day8/input.txt".readEntries.map!(decodeEntry).sum.writeln;
}