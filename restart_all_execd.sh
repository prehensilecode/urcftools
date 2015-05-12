#!/bin/bash
. /etc/profile.d/modules.sh
module load shared
module load sge/univa
module load gcc

export PATH=/mnt/HA/sysadmin/bin:${PATH}

for ic in $( seq -w 21 ) 
do
    for n in 01 02 03 04
    do
        restart_execd.sh ic${ic}n${n}
        sleep 2
    done
done

for ac in 01 02 03 04 05 06 07 08 09
do
    for n in 01 02
    do
        restart_execd.sh ac${ac}n${n}
    done
done

for gn in $( seq -f "%02.0f" 8 )
do
    restart_execd.sh gpu${gn}
done

