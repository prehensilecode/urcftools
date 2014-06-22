#!/bin/bash
### Set the Mellanox InfiniBand interface MaxReadRequest parameter 
### to a vendor-recommended setting.
PATH=/bin:/usr/bin:/sbin:/usr/sbin

pci_setting="68.W"

mlnx_pci_id=$(lspci | grep -i mellanox | cut -f1 -d\ )
max_read_req=$(setpci -s $mlnx_pci_id $pci_setting)
new_max_read_req=$(echo $max_read_req | sed -e 's/^2/5/')
setpci -s $mlnx_pci_id $pci_setting=$new_max_read_req

