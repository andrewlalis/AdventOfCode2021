module day10.part1;

import std.file;
import std.stdio;
import std.string;
import std.algorithm;
import std.container;
import std.array;

char getClosingChar(char c) {
    if (c == '(') return ')';
    if (c == '[') return ']';
    if (c == '{') return '}';
    if (c == '<') return '>';
    return 0;
}

char isOpeningChar(char c) {
    return c == '(' || c == '[' || c == '{' || c == '<';
}

char findFirstIllegalCharacter(string s) {
    SList!char stack;
    foreach (c; s) {
        if (isOpeningChar(c)) {
            stack.insertFront(c);
        } else {
            char opening = stack.front();
            if (getClosingChar(opening) != c) {
                return c;
            } else {
                stack.removeFront();
            }
        }
    }
    return 0;
}

bool isCorrupted(string s) {
    return s.findFirstIllegalCharacter != 0;
}

string completeString(string s) {
    SList!char stack;
    foreach (c; s) {
        if (isOpeningChar(c)) {
            stack.insertFront(c);
        } else {
            char opening = stack.front();
            if (getClosingChar(opening) != c) {
                throw new Exception("Corrupt string!");
            } else {
                stack.removeFront();
            }
        }
    }
    auto a = appender!string;
    while (!stack.empty()) {
        a ~= stack.front.getClosingChar;
        stack.removeFront();
    }
    return a[];
}

ulong getSuffixScore(string s) {
    ulong score = 0;
    foreach (c; s) {
        score *= 5;
        if (c == ')') score += 1;
        if (c == ']') score += 2;
        if (c == '}') score += 3;
        if (c == '>') score += 4;
    }
    return score;
}

void syntaxChecker() {
    int[char] scores;
    scores[')'] = 3;
    scores[']'] = 57;
    scores['}'] = 1197;
    scores['>'] = 25_137;
    readText("source/day10/input.txt").strip.split("\n")
        .map!(strip)
        .filter!(s => !s.isCorrupted)
        .map!(completeString)
        .map!(getSuffixScore)
        .array.sort[$/2 .. $/2 + 1].writeln;
}