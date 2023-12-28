#!/usr/bin/env python3
import sys
import os
import subprocess

if "BB_MAKEFIFO" in os.environ:
    fifoname = os.environ["BB_MAKEFIFO"]

    # look for -j n and if seen delete it
    seen = False
    Next = False
    NewArgv = []
    for i in sys.argv:
        if Next:
            Next = False
        else:
            if i == "-j":
                seen = True
                Next = True
            else:
                NewArgv.append(i)

    if seen:
        w = os.open(fifoname, os.O_WRONLY|os.O_NONBLOCK)
        os.environ["MAKEFLAGS"] = "-j --jobserver-auth=fifo:" + fifoname
else:
    NewArgv = []
    for i in sys.argv:
        NewArgv.append(i)

NewArgv[0] = NewArgv[0] + ".run"

# even if inheritable still nede to explicitly prevent from being closed

result = subprocess.run(NewArgv, shell=False, close_fds=False)
sys.exit(result.returncode)
