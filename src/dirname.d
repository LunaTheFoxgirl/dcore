/*
  basename: print directory part of the specified path

  Written by: chaomodus
  2019-10-15T21:02:10
*/

import std.path: dirName;
import std.stdio;

int main(string[] args) {
  if (args.length < 2) {
    writeln(args[0], ": specify at least one path");
    return 1;
  }
  foreach (path; args[1..$]) {
    writeln(dirName(path));
  }
  return 0;
}
