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

for node in "$@" ; do
    ssh $node 'service sgeexecd softstop && service sgeexecd start'
done

