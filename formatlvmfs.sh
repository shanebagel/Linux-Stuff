#!/bin/bash
# This script formats Logical Volumes with file systems, then generates a directory for each file system
# Next, all file systems are mounted, and content is then echoed to the /etc/fstab file for file system mount persistence
# Lastly the script provides disk availablity, including file system type, in a human-readable format
echo "Formatting file systems"
echo "======================="
mkfs.xfs /dev/vgscript/lvscript1
mkfs.ext4 /dev/vgscript/lvscript2
mkfs.vfat /dev/vgscript/lvscript3
echo
echo "Formatting completed, generating mount points"
echo "============================================="
sudo mkdir /mnt/xfs /mnt/ext4 /mnt/vfat
echo "Mounts generated, updating /etc/fstab with relevant content"
echo "============================================================="
echo "/dev/vgscript/lvscript1 /mnt/xfs xfs defaults 0 0" >> /etc/fstab
echo "/dev/vgscript/lvscript2 /mnt/ext4 ext4 defaults 0 0" >> /etc/fstab
echo "/dev/vgscript/lvscript3 /mnt/vfat vfat defaults 0 0" >> /etc/fstab
echo "/etc/fstab file updated, executing mounts"
mount -a
echo
echo "Mounts executed!"
echo
echo "Disk Overview:"
echo "=============:"
df -hT