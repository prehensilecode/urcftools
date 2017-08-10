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
                qmod -e ${queue}@${crate}n${node}
            done
        elif [ $( echo $crate | grep "ic" ) ] ; then
            for node in 01 02 03 04 ; do
                qmod -e ${queue}@${crate}n${node}
            done
        elif [ $( echo $crate | grep "gpu" ) ] ; then
            for node in 01 02 03 04 05 06 07 08 ; do
                qmod -e gpu.q@${crate}${node}
            done
        elif [ $( echo $crate | grep "all$" ) ] ; then
            for chassis in 01 02 03 04 05 06 07 08 09 ; do
                for node in 01 02 ; do
                    qmod -e ${queue}@ac${chassis}n${node}
                done
            done
            for chassis in $( seq -w 22 ) ; do
                for node in 01 02 03 04 ; do
                    qmod -e ${queue}@ic${chassis}n${node}
                done
            done
            for node in 01 02 03 04 05 06 07 08 ; do
                qmod -e gpu.q@gpu${node}
            done
        fi
    done
done

