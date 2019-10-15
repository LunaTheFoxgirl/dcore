/*
  sync: call sync system call to flush buffers to disk

  Written by: chaomodus
  2019-10-14T21:42:17
*/

import core.sys.posix.unistd: sync;

int main() {
  sync();
  return 0;
}
