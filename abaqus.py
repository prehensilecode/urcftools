#!/usr/bin/env python
import sys, os

### PE startup script aka prologue to set up Abaqus MPI "hostfile"
### Based on documented env file format
###     http://www.simulia.com/support/v67/books/sgb67EF/default.htm?startat=ch04s01.html

machinefile = os.environ['PE_HOSTFILE']
abaqenvfile = "abaqus_v6.env"

machinelines = []
with open(machinefile, "ro") as mf:
    for l in mf:
        lsplit = l.split()
        machinelines.append( [lsplit[0], int(lsplit[1])] )

with open(abaqenvfile, "wo") as envfile:
    envfile.write("mp_mode=MPI\n")
    envfile.write("mp_rsh_command='/cm/shared/apps/sge/univa/mpi/rsh -n -l %U %H %C'\n")
    envfile.write("mp_host_list=%s\n" % (str(machinelines)))

