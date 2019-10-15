/*
   hostid: Print the 32 bit host id in hex.

   Written by: chaomodus
   2019-10-13T19:45:01
 */

import std.stdio;
import std.format;

extern (C) ulong gethostid();

void main() {
  writeln(format("%08x", gethostid()));
}
