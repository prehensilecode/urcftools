#!/bin/bash

. /etc/profile.d/modules.sh

module load shared
module load proteus
module load sge/univa

usage() {
    echo "USAGE: $0 CRATENAME [CRATENAME CRATENAME ... ]"
}

if [ $# -eq 0 ] ; then
    usage
    exit 1
fi

for crate in "$@"
do
    for qc in $( qstat -f | grep -v ^- | grep -v ^queuename | grep @$crate | awk '{print $1}' )
    do
        qmod -e $qc
    done
done

