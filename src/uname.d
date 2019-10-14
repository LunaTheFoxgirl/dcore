/*
   uname: Print information about the operating system.

   Written by: chaomodus
   2019-10-13T19:11:00
 */

import std.stdio;
import std.string;
import std.algorithm: canFind;
import core.stdc.errno;
import core.sys.posix.sys.utsname;
import core.stdc.stdio: perror;

int main(string[] args) {
  utsname info;
  int result = core.sys.posix.sys.utsname.uname(&info);

  if (result == 0) {
    if (args.length == 1) {
      args = ["", "-s"];
    } else if (args.canFind("-a")) {
      args = ["", "-s", "-n", "-r", "-v", "-m"];
    }

    foreach (idx, arg; args[1..$]) {
      switch (arg) {
      default:
	stdout.write("unknown argument: ", arg);
	return 1;
      case "-o":
      case "-s":
	stdout.write(info.sysname);
	break;
      case "-n":
	stdout.write(info.nodename);
	break;
      case "-r":
	stdout.write(info.release);
	break;
      case "-v":
	stdout.write(info.version_);
	break;
      case "-m":
	stdout.write(info.machine);
	break;
      }
      if (idx != args.length - 2) {
	stdout.write(" ");
      }
    }
  } else {
    perror(null);
    return 1;
  }
  stdout.write("\n");
  return 0;
}
