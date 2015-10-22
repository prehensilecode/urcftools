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

for crate in "$@" ; do
    for queue in $( qconf -sql ) ; do
        if [ $( echo $crate | grep "ac" ) ] ; then
            for node in 01 02 ; do
                qmod -e $queue@${crate}n${node}
            done
        elif [ $( echo $crate | grep "ic" ) ] ; then
            for node in 01 02 03 04 ; do
                qmod -e $queue@${crate}n${node}
            done
        elif [ $( echo $crate | grep "gpu" ) ] ; then
            for node in 01 02 03 04 05 06 07 08 ; do
                qmod -e $queue@${crate}${node}
            done
        fi
    done
done

