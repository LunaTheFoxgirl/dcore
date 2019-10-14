/*
   tty: Print the name of the tty running under.

   Written by: chaomodus
   2019-10-13T19:11:00
 */

import std.stdio;
import std.string;
import std.getopt;

bool silent = false;

extern (C) char *ttyname(int fd);

int main(string[] args) {
  auto helpInformation = getopt(args,
				std.getopt.config.passThrough,
				"s|silent", "Do not print any output.", &silent,
				);

  if (helpInformation.helpWanted) {
    defaultGetoptPrinter("Print the name of the current tty.",
      helpInformation.options);
    return 1;
  }

  char* tty = ttyname(stdout.fileno);

  if (!tty) {
    return 2;
  }
  if (!silent) {
    writeln(fromStringz(tty));
  }
  return 0;
}
