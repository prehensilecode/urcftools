#!/bin/bash
IPMITOOL=/usr/bin/ipmitool
INLETTEMPLOG=/var/log/inlet_temp

export temp=""
if [[ $(echo ${HOSTNAME} | grep "^ac") ]]
then
    temp=$( ${IPMITOOL} -c sdr get "FCB Ambient1" 2> /dev/null | cut -f2 -d, ) 
elif [ ${HOSTNAME} = "proteusa01" ]
then
    temp=$( ${IPMITOOL} -c sdr get "Ambient Temp" 2> /dev/null | cut -f2 -d, )
else
    temp=$( ${IPMITOOL} -c sdr get "Inlet Temp" 2> /dev/null | cut -f2 -d, )
fi

if [[ $temp =~ ^[0-9]+$ ]]
then
    echo $temp > ${INLETTEMPLOG}
else
    echo 20 > ${INLETTEMPLOG}
fi

exit 0

