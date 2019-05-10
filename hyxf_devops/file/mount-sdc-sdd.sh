#!/bin/bash

mkdir /data -pv
mkdir /databackup -pv
\n|yes|mkfs.ext4 -N 80000000 -j /dev/sdc
#\n|yes|mkfs.ext4 -j /dev/sdd
cat >> /etc/fstab << "EOF"
/dev/sdc        /data         ext4    defaults        0 0
#/dev/sdd        /databackup         ext4    defaults        0 0
EOF
mount -a
