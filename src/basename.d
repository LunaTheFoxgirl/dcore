/*
  basename: print the filename portion of a path name, optionally stripping a suffix

  Written by: chaomodus
  2019-10-13T19:11:00
*/

import std.path: baseName;
import std.stdio;
import std.getopt;
import std.string;

int main(string[] args) {
  bool multiple = false;
  string suffix;
  string[] paths;
  auto helpInformation = getopt(args,
				std.getopt.config.passThrough,
				"a|multiple", "Process each argument as a path name.", &multiple,
				"s|suffix", "Specify a suffix in -a mode.", &suffix,
				);

  if (helpInformation.helpWanted) {
    defaultGetoptPrinter("Print the basename portion of a pathname.",
      helpInformation.options);
    return 1;
  }

  if (multiple) {
    if (!(args.length >= 2)) {
      writeln(args[0], ": specify at least one path.");
      return 1;
    }
    paths = args[1..$];
  } else {
    if (args.length < 2) {
      writeln(args[0], ": specify a path name.");
      return 1;
    } else if (args.length > 3) {
      writeln(args[0], ": too many arguments. Specify a path name and optional suffix.");
      return 1;
    }
    paths ~= [args[1]];
    if (args.length == 3) {
      suffix = args[2];
    }
  }

  foreach (path; paths) {
    if (path.endsWith(suffix) && path != suffix) {
      path = path[1..$-suffix.length];
    }
    writeln(baseName(path));
  }
  return 0;
}
