/*
  yes: Repeatedly print specified string.

   Written by: chaomodus
   2019-10-13T19:11:00
 */

import std.stdio;
import std.array;

string output = "y";

void main(string[] args) {
  if (args.length > 1) {
    output = args[1..$].join(' ');
  }
  while (true) {
    writeln(output);
  }
}
