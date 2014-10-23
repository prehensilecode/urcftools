#!/bin/bash
### IPMI LAN settings based on hostname

export PATH=/mnt/HA/sysadmin/bin:/bin:/sbin:/usr/bin:/usr/sbin

ipmi_ip=$(host ${HOSTNAME}.ipmi.cluster | awk '{print $4}')

ipmitool lan set 1 ipsrc static
ipmitool lan set 1 ipaddr ${ipmi_ip}
ipmitool lan set 1 netmaskk 255.255.255.0
ipmitool lan set 1 defgw ipaddr 172.16.2.253
ipmitool lan set 1 bakgw ipaddr 172.16.2.1
