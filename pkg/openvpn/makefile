# SLIM makefile for the 'openvpn' package.

PKG = openvpn
VER = 2.2.2
GET = wget
URL = http://swupdate.openvpn.org/community/releases
PRG = openvpn
TGZ = $(PKG)-$(VER).tar.gz
SRC = $(build)/$(PKG)-$(VER)
DST = $(rootfs)/usr/sbin

LICENSE  = GPL2
LICFILE  = $(SRC)/COPYING
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = networking

PREP_DEPEND = lzo.stage openssl.stage
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = OpenVPN allows to build a virtual private network (VPN) \
over a encrypted TLS connection.

ac_flags += \
	--disable-server \
	--disable-plugins \
	--disable-eurephia \
	--disable-debug \
	--enable-small \
	--disable-selinux

# paths of the busybox tools
ac_flags += \
	--with-ifconfig-path=/sbin/ifconfig \
	--with-iproute-path=/sbin/iproute \
	--with-route-path=/sbin/route \
	--with-netstat-path=/sbin/netstat

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" all $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) cd $(SRC) && cp $(PRG) $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/$(PRG)
	$(Q) $(start) -n 800 -f openvpn.init
	$(Q) if [ -d $(etc)/openvpn ]; then \
		cp -r $(etc)/openvpn $(rootfs)/etc; \
	     else \
		mkdir -p $(rootfs)/etc/openvpn; \
	     fi
	$(Q) cp client.conf $(rootfs)/etc/openvpn

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) true

include depend.mk
