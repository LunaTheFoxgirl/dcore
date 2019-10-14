# D CORE #

This is a simple rewrite of coreutils in D, work in progress. Most of the behaviors, at this stage, will be more similar to the FreeBSD coreutils than GNU Coreutils, so as to adhere more closely to the minimum set of functionality defined by POSIX. Once that is implemented, we can look at making thingns diverge from both to be more usable or more ergonomic.

My personal challenge for myself is to implement this mostly from manpages of Linux and FreeBSD, including library manpages. Obviously it depends on some stdc library interfaces and options. Hopefully it'll be portable to other Unix-likes (I am developing in Linux).

# FAQ #

## WHY? ##

Fun.

# Tha list #
## Done ##

* yes
* tee
* tty
* echo
* uname

## WIP ##

* mkdir

## Todo ##

* Generic command boilerplate for --help, --verbose, --version on all commands.
* ls / vdir / dir
* cp
* mv
* rm
* rmdir
* ln
* chmod
* chown
* touch
* dd
* df
* du
* chroot
* cat
* head
* tail
* sort
* tr
* cut
* uniq
* wc
* basename
* dirname
* seq
* sleep
* true / false
* test
* md5sum / shasum / etc.
* base64 / base32
* paste
* join
* comm
* fmt
* fold
* expand
* pr
* split
* hostname
date
pwd
su
nice
who
id
groups
whoami
env
install
link
mkfifo
mknod
shred
sync
unlink
chgrp
expr
factor
hostid
logname
nohup
patchk
pinky
printenv
printf
stty
users
cksum
csplit
nl
od
ptx
sum
tac
tsort

... and anything else

# Maybe ? #

* i18n
* deesh the D language shell. It should have its own simple shell scripting language maybe based on D syntax (or like something) but with pipes and whatnot.
* a fully chrootable environment written in D.
* init? inetd? full userland?! kernel!!!???
