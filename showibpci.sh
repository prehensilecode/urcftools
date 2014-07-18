#!/bin/bash
### Display the Mellanox InfiniBand interface MaxReadRequest parameter 
PATH=/bin:/usr/bin:/sbin:/usr/sbin

# Mellanox vendor ID is 15b3
vendor_id=15b3
pci_setting=68.W

mlnx_pci_id=$( lspci -d ${vendor_id}: | cut -f1 -d\  )
setpci -s $mlnx_pci_id $pci_setting

