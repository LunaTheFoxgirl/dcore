/*
  unlink: call unlink function on specified file.

  Written by: chaomodus
  2019-10-14T21:16:21
*/

import std.stdio;
import std.string;
import core.stdc.stdio: perror;

extern (C) int unlink(const char *path);

int main(string[] args) {
  if (args.length != 2) {
    writeln("Incorrect number of arguments: specify one filename.");
    return 1;
  }

  int result = unlink(toStringz(args[1]));
  if (result != 0) {
    perror(toStringz(format("%s - %s", args[0], args[1])));
    return 1;
  }

  return 0;
}
