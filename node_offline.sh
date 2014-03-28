#!/bin/bash

. /etc/profile.d/modules.sh

module load shared
module load proteus
module load sge/univa

usage() {
    echo "USAGE: $0 NODENAME [NODENAME NODENAME ... ]"
}

if [ $# -eq 0 ] ; then
    usage
    exit 1
fi

for queue in $( qconf -sql ) ; do
    for node in "$@" ; do
        qmod -d $queue@$node
    done
done

