module util.fileutils;

import std.file;
import std.string;
import std.algorithm;
import std.array;
import std.conv;

/** 
 * Reads a list of integers from a file, assuming one integer per line.
 * Params:
 *   filename = The name of the file to read, relative to the working dir.
 * Returns: A list of integers.
 */
int[] readInts(string filename, string sep = "\n") {
    return readText(filename)
        .strip()
        .split(sep)
        .map!(s => s.strip())
        .filter!(s => s.length > 0)
        .map!(s => s.to!int)
        .array;
}
