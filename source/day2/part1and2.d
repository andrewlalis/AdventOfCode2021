module day2.part1and2;

import std.file;
import std.stdio;
import std.string;
import std.conv;
import std.typecons;
import std.traits;

/** 
 * Parses a submarine instruction.
 * Params:
 *   op = The operation to parse.
 * Returns: A tuple containing the operation string and the value.
 */
Tuple!(string, int) parseOp(S)(S op) @safe pure if (isSomeString!S) {
    auto parts = op.split();
    return tuple(parts[0].to!string, parts[1].to!int);
}

void dive() {
    File f = File("source/day2/input.txt", "r");
    int depth = 0;
    int position = 0;
    foreach (line; f.byLine) {
        auto op = parseOp(line);
        if (op[0] == "up") depth -= op[1];
        if (op[0] == "down") depth += op[1];
        if (op[0] == "forward") position += op[1];
    }
    writefln("Final depth: %d, Final position: %d, Product: %d", depth, position, depth * position);
}

void dive2() {
    File f = File("source/day2/input.txt", "r");
    int aim = 0;
    int depth = 0;
    int position = 0;
    foreach (line; f.byLine) {
        auto op = parseOp(line);
        if (op[0] == "up") aim -= op[1];
        if (op[0] == "down") aim += op[1];
        if (op[0] == "forward") {
            position += op[1];
            depth += aim * op[1];
        }
    }
    writefln("Final depth: %d, Final position: %d, Product: %d", depth, position, depth * position);
}
