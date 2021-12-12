module day12.part1;

import std.file;
import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import std.array;

bool isLarge(string name) {
    return name.toUpper() == name;
}

void registerPath(ref string[][string] paths, string[] caves) {
    if (caves[0] !in paths) {
        paths[caves[0]] = [caves[1]];
    } else {
        paths[caves[0]] ~= caves[1];
    }
    if (caves[1] !in paths) {
        paths[caves[1]] = [caves[0]];
    } else {
        paths[caves[1]] ~= caves[0];
    }
}

uint[string] getVisitCounts(string[] history) {
    uint[string] visitCounts;
    foreach (p; history) {
        if (p !in visitCounts) {
            visitCounts[p] = 1;
        } else {
            visitCounts[p]++;
        }
    }
    return visitCounts;
}

bool canVisit(string cave, string[] history) {
    if (cave.isLarge) return true;
    uint[string] visitCounts = getVisitCounts(history);
    bool visitedSmallCaveTwice = false;
    foreach (p, c; visitCounts) {
        if (!p.isLarge && c > 1) {
            visitedSmallCaveTwice = true;
            break;
        }
    }
    uint availablePathVisitCount = visitCounts.require(cave, 0);
    return visitedSmallCaveTwice ? availablePathVisitCount < 1 : availablePathVisitCount < 2;
}

string[][] findPaths(ref string[][string] paths, string cave, string[] history) {
    if (cave == "end") return [history ~ cave];
    string[][] nextPaths = [];
    foreach (availablePath; paths[cave]) {
        if (availablePath == "start") continue;
        if (canVisit(availablePath, history ~ cave)) nextPaths ~= findPaths(paths, availablePath, history ~ cave);
    }
    return nextPaths;
}

void passagePathing() {
    string[] pathDescriptors = readText("source/day12/input.txt").strip.split("\n")
        .map!(s => s.strip).array;
    string[][string] paths;
    foreach (desc; pathDescriptors) {
        registerPath(paths, desc.split("-"));
    }
    findPaths(paths, "start", [])
        .map!(p => p.joiner!(string[], string)(",").to!string)
        .array.length.writeln;
}