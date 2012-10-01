# SLIM makefile for the 'rpisdcard.mk' package.
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

IMAGE = $(imgdir)/$(BOARD)-sdcard.img

all:
	$(Q) $(rpisd) $(IMAGE) $(imgdir)/boot $(imgdir)/rootfs

# use a udev rule like this to make your SD card writable as a
# user of the 'developer' group:
#
# $ cat /etc/udev/rules.d/50-sdcard.rules
# KERNEL=="sd?", SUBSYSTEM=="block", SUBSYSTEMS=="usb", ATTRS{serial}=="<serial no. of your card reader>", GROUP="developer", SYMLINK+="sdcard"

SDCARD := /dev/sdcard

install:
	if [ ! -b $(SDCARD) ]; then \
		echo "error: $(SDCARD) not present"; \
	else \
		echo "copying image to $(SDCARD)"; \
		dd if=rpi/rpi-sdcard.img of=/dev/sdcard bs=4096; \
	fi
