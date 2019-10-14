/*
   echo: Print arguments to stdout.

   Written by: chaomodus
   2019-10-13T19:11:00
 */

import std.stdio;
bool noend = false;

int main(string[] arg) {
  string[] words = arg[1..$];
  if (words.length > 0) {
    if (words[0] == "-n") {
       noend = true;
       words = words[1..$];
    }
  }
  foreach (i, s; words) {
    stdout.write(s);
    if (i+1 != words.length) {
      stdout.write(" ");
    }
  }
  if (!noend) {
    stdout.write("\n");
  }
  return 0;
}
