module day4.part1and2;

import std.file;
import std.stdio;
import std.traits;
import std.algorithm;
import std.conv;
import std.array;
import std.string;
import std.format;
import std.range;

struct BingoBoard {
    uint[][] board = new uint[5][5];
    bool[][] marks = new bool[5][5];

    this(string s) {
        auto rows = s.strip().split("\n");
        foreach (i, row; rows) {
            auto br = board[i];
            formattedRead(row.strip(), "%d %d %d %d %d", br[0], br[1], br[2], br[3], br[4]);
        }
    }

    void mark(uint value) {
        foreach (r, row; board) {
            foreach (c, col; row) {
                if (col == value) marks[r][c] = true;
            }
        }
    }

    uint sumUnmarked() {
        uint sum = 0;
        foreach (r, row; board) {
            foreach (c, col; row) {
                if (!marks[r][c]) sum += col;
            }
        }
        return sum;
    }

    bool isWinner() {
        foreach (r; 0..5) {
            bool rowMarked = true;
            foreach (c; 0..5) {
                if (!marks[r][c]) {
                    rowMarked = false;
                    break;
                }
            }
            if (rowMarked) return true;
        }
        foreach (c; 0..5) {
            bool colMarked = true;
            foreach (r; 0..5) {
                if (!marks[r][c]) {
                    colMarked = false;
                    break;
                }
            }
            if (colMarked) return true;
        }
        return false;
    }

    public string toString() const {
        string s = "";
        foreach (r, row; board) {
            foreach (c, col; row) {
                s ~= format("%02d", col) ~ (marks[r][c] ? "*" : "-");
                if (c < 4) s ~= " ";
            }
            s ~= "\n";
        }
        return s;
    }
}

uint[] readSeparatedInts(S)(S str, string separator) if (isSomeString!S) {
    return str.strip().split(separator).map!(s => to!uint(s)).array;
}

void bingo() {
    auto f = File("source/day4/input.txt", "r");
    uint[] chosenValues = readSeparatedInts(f.readln().strip(), ",");
    string boardsText;
    string line;
    while ((line = f.readln()) !is null) {
        boardsText ~= line;
    }
    BingoBoard[] boards = boardsText.split("\n\n")
        .map!(t => BingoBoard(t))
        .array;
    uint[] winIndexes = [];
    foreach (v; chosenValues) {
        foreach (idx, b; boards) {
            b.mark(v);
            if (b.isWinner() && !winIndexes.canFind(idx)) {
                winIndexes ~= cast(uint) idx;
            }
        }
        if (boards.length == winIndexes.length) {
            auto winningBoard = boards[winIndexes[winIndexes.length - 1]];
            writefln("%d", winningBoard.sumUnmarked() * v);
            return;
        }
    }
}