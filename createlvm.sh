#!/bin/bash
# This script creates logical volumes
# It first uses the parted utility to make labels for each disk, generates a partition, and enables LVM
# Next it created physical volumes out of the partitions and adds the PVs to a Volume Group,
# which then is used to create various Logical Volumes from the VG
# The device names, and sizes can be tweaked, as well as the names of the Volume Groups and Logical Groups, in this instance I had two block storage devices
# /dev/vdg and /dev/vdh 
parted /dev/vdg mklabel msdos
parted /dev/vdh mklabel msdos
parted /dev/vdg mkpart primary 1 800M
parted /dev/vdh mkpart primary 1 800M
parted /dev/vdg set 1 lvm on
parted /dev/vdh set 1 lvm on
pvcreate /dev/vdg1
pvcreate /dev/vdh1
vgcreate vgscript /dev/vdg1 /dev/vdh1
lvcreate -L 500M -n lvscript1 vgscript
lvcreate -L 500M -n lvscript2 vgscript
lvcreate -L 500M -n lvscript3 vgscript

echo
echo "Successfully Generated Partitions, PVs, VGs, and LVs"
echo "==================================="
echo

echo "Below is the output for the Logical Volumes generated:"
/usr/sbin/pvs
echo
echo "Below is the output for the Volume Group generated:"
/usr/sbin/vgs
echo
echo "Below is the output for the Logical Volumes generated:"
/usr/sbin/lvs