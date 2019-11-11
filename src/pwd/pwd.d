module pwd;
import std.stdio;
import std.file;
import std.getopt;

bool physicalPath = false;
bool logicalPath = true;

void main(string[] args) {
    auto info = getopt(args, config.caseSensitive,
    "P|physical", "Display the current working directory's physical path (without symbolic links)", &physicalPath,
    "L|logical", "Display the current working directory's logical path (with symbolic links) [default]", &logicalPath);

    if (info.helpWanted) {
        defaultGetoptPrinter("Print Working Directory", info.options);
        return;
    }

    // Handle physical and logical path options
    if (logicalPath == true) physicalPath = false;
    if (physicalPath == true) logicalPath = false;

    string cwd = getcwd();
    
    if (physicalPath) {
        if (isSymlink(cwd)) {
            cwd = readLink(cwd);
        }
    }
    writeln(getcwd());
}