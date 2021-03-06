# SLIM makefile for the 'glibc' package.

PKG = glibc
VER = NA
GET = NA
URL = NA
PRG =
TGZ =
SRC = $(shell ./findlibc.sh)
DST = $(rootfs)/lib

LICENSE  = LGPL
LICFILE  = COPYING.LIB
UPSTREAM =
BINARIES =
PROVIDES = libstdc++ \
ld-linux \
libBrokenLocale \
libanl \
libc \
libcrypt \
libdl \
libgcc_s \
libm \
libnsl \
libnss_compat \
libnss_dns \
libnss_files \
libnss_hesiod \
libnss_nis \
libnss_nisplus \
libpthread \
libresolv \
librt \
libthread_db \
libutil
CATEGORY = libraries

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND =

DESCRIPTION = This package provides the standard C library.

fetch:
unpack:
prep:
build:

# The normal 'comply' script will not work for us.  So, we just copy
# the glibc sources ourselves.

SOURCES_DIR = $(shell ./findsources.sh)

stage:
ifneq ($(SOURCES_DIR),)
	$(Q) echo Found libc sources:
	$(Q) mkdir -p $(redist)/src
	$(Q) cp $(SOURCES_DIR)/* $(redist)/src
	$(Q) for f in $(SOURCES_DIR)/* ; do \
		echo "\t" $$f ; \
	done
endif

ifeq ($(CROSS_COMPILE)gcc,$(HOSTCC))
SRC     = /lib
CXX_SRC = /usr/lib
GCC_SRC = /lib
else
SRC     = $(shell ./findlibc.sh)
CXX_SRC = $(shell ./findstdcxx.sh)
GCC_SRC = $(shell ./findlibgcc.sh)
endif

DST = $(rootfs)/lib
STAGE = $(stage)/lib

install:
	$(Q) mkdir -p $(STAGE)
	$(Q) cp -f $(SRC)/*-*.so $(STAGE)
	$(Q) cp -fd $(SRC)/*.so.[*0-9] $(STAGE)
	$(Q) mkdir -p $(DST)
	$(Q) echo Found libc in $(SRC)
	$(Q) cp -f $(SRC)/*-*.so $(DST)
	$(Q) cp -fd $(SRC)/*.so.[*0-9] $(DST)
	$(Q) for f in $(DST)/*-*.so ; do \
		echo -e "\t" $$f ; \
		./strip-wrapper.sh $$f ; \
	done
	$(Q) cp -fd $(CXX_SRC)/libstdc++.so* $(STAGE)
	$(Q) cp -fd $(CXX_SRC)/libstdc++.so* $(DST)
	$(Q) ./strip-wrapper.sh $(DST)/libstdc++.so*
	$(Q) cp -fd $(GCC_SRC)/libgcc_s.so* $(STAGE)
	$(Q) cp -fd $(GCC_SRC)/libgcc_s.so* $(DST)
	$(Q) ./strip-wrapper.sh $(DST)/libgcc_s.so* || true

clean:
	$(Q) true

distclean: clean
	$(Q) true

include depend.mk
