#!/bin/bash
#
# Create a bootable SD card image for the Raspberry Pi.
#
# Copyright (C) 2012 Jens Steinhauser <jens.steinhauser@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

# size in MB of the complete image
IMGSIZE=120

# size in MB of the FAT32 boot partition
BOOTSIZE=64

usage ()
{
	printf "\n"
	printf "usage: `basename $0` IMAGE BOOTDIR ROOTDIR\n"
	printf "\n"
	printf "  IMAGE    The filename of the image to create.\n"
	printf "  BOOTDIR  A directory containing the boot files.\n"
	printf "  ROOTDIR  A directory containing the root file system.\n"
	printf "\n"
	exit 1
}

hint_genfatfs ()
{
	printf "error: 'genfatfs' not found\n"
	printf "This tool is part of https://code.google.com/p/raspberrypi-openwrt/\n"
	printf "You don't have to build the whole project, just apply the included\n"
	printf "patches for the tool and then compile it using:\n"
	printf "echo -e 'CPPFLAGS := -Ifatfs/src\\\\ngenfatfs: genfatfs.o diskio.o"
	printf "fatfs/src/ff.o fatfs/src/option/ccsbcs.o' | make -f /dev/fd/0\n"
	exit 1
}

hint_genext2fs ()
{
	printf "error: 'genext2fs' not found\n"
	printf "Get it here: http://genext2fs.sourceforge.net/\n"
	exit 1
}

#
# check arguments
#
if [ $# -eq 0 ]; then
	printf "This tool creates a bootable SD card image for the Raspberry Pi.\n"
	usage
fi
if [ $# -ne 3 ]; then
	printf "error: wrong number of arguments\n"
	usage
fi

IMAGE=$1
BOOTDIR=$2
ROOTDIR=$3

if [ ! -d $BOOTDIR ]; then
	printf "error: '$BOOTDIR' is not a directory\n"
	usage
fi
if [ ! -d $ROOTDIR ]; then
	printf "error: '$ROOTDIR' is not a directory\n"
	usage
fi

#
# check for used tools
#
hash genfatfs  2>/dev/null || hint_genfatfs
hash genext2fs 2>/dev/null || hint_genext2fs

#
# create and partition image
#
dd if=/dev/zero of=$IMAGE bs=1 count=1 seek=$((IMGSIZE * 1024 * 1024 - 1)) 2>/dev/null

fdisk $IMAGE >/dev/null 2>&1 << EOF
o
n
p
1

+${BOOTSIZE}M
t
c
n
p
2


w
EOF

#
# create the file system images
#
BOOTSTART=$(parted -s $IMAGE unit B print | awk '$1 ~/1/ { gsub(/B/, "", $2); print $2 }')
BOOTSIZE=$( parted -s $IMAGE unit B print | awk '$1 ~/1/ { gsub(/B/, "", $4); print $4 }')
ROOTSTART=$(parted -s $IMAGE unit B print | awk '$1 ~/2/ { gsub(/B/, "", $2); print $2 }')
ROOTSIZE=$( parted -s $IMAGE unit B print | awk '$1 ~/2/ { gsub(/B/, "", $4); print $4 }')

BOOTSEC=$((BOOTSIZE / 1024))
ROOTSEC=$((ROOTSIZE / 1024))

#echo "boot starts at $BOOTSTART, size: $BOOTSIZE ($BOOTSEC sectors)"
#echo "root starts at $ROOTSTART, size: $ROOTSIZE ($ROOTSEC sectors)"

BOOTIMAGE=`mktemp`
ROOTIMAGE=`mktemp`
trap "rm $BOOTIMAGE" EXIT
trap "rm $ROOTIMAGE" EXIT

genfatfs     --root $BOOTDIR --size-in-blocks $BOOTSEC $BOOTIMAGE
genext2fs -U --root $ROOTDIR --size-in-blocks $ROOTSEC $ROOTIMAGE

#
# adjust the partition labels
#
hash mlabel  2>/dev/null
if [ $? -eq 0 ]; then
	MTOOLS_SKIP_CHECK=1 mlabel -i $BOOTIMAGE ::"rpiboot"
else
	printf "'mlabel' not found, not changing the partition label of the boot partition\n"
fi

hash e2label  2>/dev/null
if [ $? -eq 0 ]; then
	e2label $ROOTIMAGE "rpiroot"
else
	printf "'e2label' not found, not changing the partition label of the root partition\n"
fi

#
# copy the file systems into the image
#
dd if=$BOOTIMAGE of=$IMAGE bs=512 seek=$((BOOTSTART / 512)) 2>/dev/null
dd if=$ROOTIMAGE of=$IMAGE bs=512 seek=$((ROOTSTART / 512)) 2>/dev/null

printf "`basename $0`: $IMAGE is ready\n"
