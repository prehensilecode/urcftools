#!/bin/bash

. /etc/profile.d/modules.sh

module load sge/univa

usage() {
    echo "USAGE: $0 NODENAME [NODENAME NODENAME ... ]"
}

if [ $# -eq 0 ] ; then
    usage
    exit 1
fi

for node in "$@" ; do
    qmod -d all.q@$node
done

