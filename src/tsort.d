/*
  tsort: Topologically sort input node pairs of a DAG.

  Written by: chaomodus
  2019-10-15T21:08:28
*/

import std.stdio;
import std.string;
import std.array;
import std.typecons;
import std.algorithm.mutation: remove;
import std.algorithm.searching: canFind, countUntil;
import std.format;

class TSortException: Exception {
      this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }
}

struct dag_node {
  string[] edges;
  string name;

  this(string name) {
    this.name = name;
  }

  void addEdge(string edge) {
    if (!this.edges.canFind(edge) && (this.name != edge)) {
      this.edges ~= edge;
    }
  }
}

dag_node[string] nodes;
string[] temp;
string[] perm;
string[] unmarked;

void visit(string nodename) {
  if (perm.canFind(nodename)) {
    return;
  }

  if (temp.canFind(nodename)) {
    throw new TSortException(format("detected cycle at %s", nodename));
  }

  auto idx = unmarked.countUntil(nodename);
  unmarked = unmarked.remove(idx);
  temp ~= nodename;

  foreach (child; nodes[nodename].edges) {
    visit(child);
  }

  idx = temp.countUntil(nodename);
  temp = temp.remove(idx);
  perm ~= nodename;
}

int main(string[] args) {
  auto input = stdin;
  string tokena;
  while (!input.eof) {
    string line = input.readln().strip();
    if (line.length) {
      auto tokens = line.split(' ');
      foreach (token; tokens) {
	token = token.strip();
	if (!token.length) {
	  continue;
	}
	if (!tokena) {
	  tokena = token;
	}
	else {
	  if (!(tokena in nodes)) {
	    nodes[tokena] = dag_node(tokena);
	  }
	  if (!(token in nodes)) {
	    nodes[token] = dag_node(token);
	  }
	  nodes[tokena].addEdge(token);

	  tokena = null;
	}
      }
    }
  }
  if (tokena) {
    writeln(args[0], ": odd number of tokens");
    return 1;
  }

  unmarked = nodes.keys[0..$];

  while(unmarked.length) {
    try {
      visit(unmarked[0]);
    } catch (TSortException e) {
      writeln(args[0], ": ", e.message);
    }
  }

  foreach (node; perm) {
    writeln(node);
  }
  return 0;
}
