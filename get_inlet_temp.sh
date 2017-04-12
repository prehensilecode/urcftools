#!/bin/bash
IPMITOOL=/usr/bin/ipmitool
INLETTEMPLOG=/var/log/inlet_temp

export temp=""
if [[ $(echo ${HOSTNAME} | grep "^ac") ]]
then
    temp=$( ${IPMITOOL} -c sdr get "FCB Ambient1" | cut -f2 -d, ) 
elif [ ${HOSTNAME} = "proteusa01" ]
then
    temp=$( ${IPMITOOL} -c sdr get "Ambient Temp" | cut -f2 -d, )
else
    temp=$( ${IPMITOOL} -c sdr get "Inlet Temp" | cut -f2 -d, )
fi

if [[ $temp =~ ^[0-9]+$ ]]
then
    echo $temp > ${INLETTEMPLOG}
fi

exit 0
