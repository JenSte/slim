# SLIM makefile for the 'rpi_boot' package.

PKG = rpi_boot
VER = master
GET = git
URL = git://github.com/raspberrypi/firmware.git
PRG = rpi_boot
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/bin

LICENSE  = Proprietary
LICFILE  =
UPSTREAM =
BINARIES =
PROVIDES =
CATEGORY = main

PREP_DEPEND =
BUILD_DEPEND = linux.install
INSTALL_DEPEND = basefiles.install

DESCRIPTION = This package assembles the boot files for the Raspberry Pi.

# The GPU binary to use (defines the memory split between CPU and GPU).
START=arm240_start.elf

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) true

build:
	$(Q) true

stage:
	$(Q) true

install:
	$(Q) mkdir -p $(imgdir)/boot
	$(Q) cp $(SRC)/boot/bootcode.bin $(imgdir)/boot
	$(Q) cp $(SRC)/boot/loader.bin   $(imgdir)/boot
	$(Q) cp $(SRC)/boot/$(START)     $(imgdir)/boot/start.elf
	$(Q) cp $(imgdir)/rpi-zImage     $(imgdir)/boot/kernel.img
	$(Q) cp cmdline.txt              $(imgdir)/boot
	$(Q) cp config.txt               $(imgdir)/boot
	# create the mountpoint for the boot partition
	$(Q) mkdir -p $(rootfs)/boot


clean:
	$(Q) rm -rf $(imgdir)/boot

distclean: clean
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
