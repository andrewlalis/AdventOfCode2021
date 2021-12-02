module day2.part1;

import std.file;
import std.stdio;
import std.string;
import std.conv;
import std.typecons;

Tuple!(string, int) parseOp(char[] op) {
    auto parts = op.split();
    int x = parts[1].to!int;
    string d = parts[0].to!string;
    return tuple(d, x);
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
