/*
   false / true / return: Exit with true, false or specified value.

   Written by: chaomodus
   2019-10-13T14:00:06
 */

import std.conv;
import std.algorithm;

int main(string[] args) {
  int retval = 0;
  if (args[0].endsWith("false")) {
    retval = 1;
  }
  if (args.length >= 2) {
    retval = parse!int(args[1]);
  }
  return retval;
}
