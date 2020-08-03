#!/bin/bash

. /etc/profile.d/modules.sh

module load shared
module load proteus
module load sge/univa

usage() {
    echo "USAGE: $0 NODENAME [NODENAME NODENAME ... ]"
}

if [ $# -eq 0 ]
then
    usage
    exit 1
fi

declare -a inarr=($@)

if  [ ${#inarr[@]} -eq 1 ]
then
    if [ ${inarr[0]} = intel ]
    then
         for i in $( seq -w 1 22 )
         do
             crate_online.sh ic${i}
         done
    elif [ ${inarr[0]} = amd ]
    then
        for i in $( seq 1 6 ) 
        do
            crate_online.sh ac0${i}
        done
    elif [ ${inarr[0]} = gpu ]
    then
        for i in $( seq 1 8 )
        do
            crate_online.sh gpu0${i}
        done
    else
        usage
        exit 1
    fi
else
    for node in $inarr
    do
        for qc in $( qstat -f | grep -v ^- | grep -v ^queuename | grep @$node | awk '{print $1}' )
        do
            echo "FOO qc = $qc "
            qmod -e $qc
        done
    done
fi
