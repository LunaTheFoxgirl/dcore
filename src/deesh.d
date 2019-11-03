/*
  deesh: Simple programmable command interpreter.

  Written by: chaomodus
  2019-10-21T22:33:59


  Bugs:
   WIP

   DONE:
     command arg arg "arg many words"

   TODO:
   suspend / resume / jobs
   history
   prompt

   programming constructs:
      functions/blocks/closures
      tokenize string
      blocks / subshells
      conditionals
        if / elif / else
      looping
        loop until condition
	loop over contents of an array/string/tokens
      IO redirection
        output to or input from files
	output to command
	selecting which handles to redirect
      variables
        assign variable to value
	assign variable to outputs of command
	fill variable in place of string etc.
*/

import std.array;
import std.path;
import std.process;
import std.stdio;
import std.string;
import std.format;
import std.regex;
import core.sys.posix.unistd: access, X_OK;

auto whitespace_regex = ctRegex!(`^[\t\n\r ]+$`, ['s']);
auto tokendelim_regex = ctRegex!(`^[\t\n\r;=()$%"' ]$`, ['s']);

enum DTT {
	  EOF,
	  EOS,
	  STRING,
	  VAR_DOL,
	  VAR_PERC,
	  WORD,
	  FUNC,
	  ASSIGN,
	  ARGLIST_START,
	  ARGLIST_END,
}

class DeeshError: Exception {
  this(string msg, string file = __FILE__, size_t line = __LINE__){
    super(msg, file, line);
  }
}

class DeeshLexError: DeeshError {
  this(string msg, string file = __FILE__, size_t line = __LINE__){
    super(msg, file, line);
  }
};

class PeekyBuffer {
  uint pos;
  string buffer;

  this(string inbuffer) {
    this.buffer = " " ~ inbuffer;
    this.pos = 1;
  }

  string next() {
    if (!this.eob) {
      pos += 1;
      return this.buffer[this.pos-1..this.pos];
    }
    return "";
  }

  string checkNext(uint peek=1) {
    return this.buffer[this.pos..this.pos+peek];
  }

  bool eob () {
    return (pos >= this.buffer.length);
  }
}

class DeeshToken {
  DTT tokenType;
  uint position;
  string value;
  string extra;
  DeeshToken[] subtokens;

  this(DTT tokenType, uint position, string value, string extra="", DeeshToken[] subtokens=[]) {
    this.tokenType = tokenType;
    this.position = position;
    this.value = value;
    this.extra = extra;
    this.subtokens = subtokens;
  }

  override string toString() {
    return format("<DeeshToken: %s pos %d lit: [%s]>", this.tokenType, this.position, this.value);
  }
}

class DeeshLex {
  DeeshToken[] tokens;
  bool closed;
  uint line, pos;
  PeekyBuffer buffer;

  void addToken(DTT tokenType, uint position, string value="", string extra="", DeeshToken[] subtokens=[]) {
    this.tokens ~= new DeeshToken(tokenType, position, value, extra, subtokens);
  }

  void processString(string startChar) {
    string wordb;
    uint startpos = this.buffer.pos;
    while (!this.buffer.eob && this.buffer.checkNext != startChar) {
      if (this.buffer.checkNext == "\\") {
	this.buffer.next;
      }
      wordb ~= this.buffer.next;
    }
    this.buffer.next;
    this.addToken(DTT.STRING, startpos, wordb);
  }

  void processWord(DTT tokenType, string extra="") {
    string wordb;
    uint startpos = this.buffer.pos;
    while (!this.buffer.eob && !match(this.buffer.checkNext, tokendelim_regex)) {
      wordb ~= this.buffer.next;
    }
    this.addToken(tokenType, startpos, wordb, extra);
  }

  void processComment() {
    while (!this.buffer.eob && !(this.buffer.checkNext == "\n")) {
      this.buffer.next;
    }
  }

  bool parseString(string inl, string delim="") {
    this.buffer = new PeekyBuffer(inl);
    string ch;
    bool foundDelim = false;
    while (!this.buffer.eob && !foundDelim) {
      ch = this.buffer.checkNext;
      switch (ch) {
      case " ":
	this.buffer.next;
	continue;
      case "\n":
      case "\t":
      case ";":
	this.buffer.next;
	if (this.tokens.length && this.tokens[$-1].tokenType != DTT.EOS)
	  this.addToken(DTT.EOS, this.buffer.pos);
	continue;
      case "=":
	this.buffer.next;
	this.addToken(DTT.ASSIGN, this.buffer.pos);
	break;
      case "%":
	this.buffer.next;
	this.addToken(DTT.VAR_PERC, this.buffer.pos);
	break;
      case "$":
	this.buffer.next;
	this.addToken(DTT.VAR_DOL, this.buffer.pos);
	break;

      case "(":
	this.buffer.next;
	this.addToken(DTT.ARGLIST_START, this.buffer.pos);
	break;
      case ")":
	this.buffer.next;
	this.addToken(DTT.ARGLIST_END, this.buffer.pos);
	break;
      case "\"":
      case "\'":
	this.processString(this.buffer.next);
	break;
      case "#":
	this.buffer.next;
	this.processComment;
	break;
      default:
	if (ch == delim) {
	  foundDelim = true;
	  this.buffer.next;
	} else {
	  this.processWord(DTT.WORD);
	}
	break;
      }
    }
    return true;
  }

}

int main(string[] args) {
  File input = stdin;
  string commandline;
  DeeshLex lexer = new DeeshLex();
  while (!input.eof) {
    // read input
    commandline = input.readln();
    // parse
    lexer.parseString(commandline);
    DeeshToken token;
    while (lexer.tokens.length) {
      token = lexer.tokens[0];
      lexer.tokens.popFront();
      writeln(token);
    }
    // execute things if necessary
    // goto read
  }
  return 0;
}
