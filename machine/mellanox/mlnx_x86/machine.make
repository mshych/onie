# Mellanox X86 Series
# MSX1400: CPU Module: Intel Core i7-3612QE

ONIE_ARCH ?= x86_64
SWITCH_ASIC_VENDOR = mlnx

VENDOR_REV ?= 0

# Translate hardware revision to ONIE hardware revision
ifeq ($(VENDOR_REV),0)
  MACHINE_REV = 0
else
  $(warning Unknown VENDOR_REV '$(VENDOR_REV)' for MACHINE '$(MACHINE)')
  $(error Unknown VENDOR_REV)
endif

# Vendor ID -- IANA Private Enterprise Number:
# http://www.iana.org/assignments/enterprise-numbers
# Mellanox IANA number
VENDOR_ID = 33049

I2CTOOLS_ENABLE = yes

export EXTRA_CMDLINE_LINUX := acpi_enforce_resources=lax acpi=noirq $(EXTRA_CMDLINE_LINUX)

#
#-------------------------------------------------------------------------------
#
# Local Variables:
# mode: makefile-gmake
# End:

LINUX_VERSION		= 4.9

LINUX_MINOR_VERSION	= 0

LINUX_TARBALL_URLS	+= file://$(MAKE_CT_PREFETCH_FOLDER)

LINUX_TARBALL		= linux-4.9.0.tar.xz

LINUX_CONFIG		= conf/kernel/4.9.0/linux.x86_64.config

# Specify uClibc version
UCLIBC_VERSION = 0.9.32.1

MELLANOX_PXE_UPDATER_STAMP   = $(STAMPDIR)/mellanox-pxe-updater-stamp
MELLANOX_NETBOOT_PXE_UPDATER = $(IMAGEDIR)/mellanox_net_boot_label.sh

mellanox-net-boot-label: $(MELLANOX_PXE_UPDATER_STAMP)

$(MELLANOX_PXE_UPDATER_STAMP): $(MELLANOX_NETBOOT_PXE_UPDATER)
	touch $@

$(MELLANOX_NETBOOT_PXE_UPDATER): $(MACHINEDIR)/net_boot_label.template
	mkdir -p $(@D)
	cat $< | sed -e "s/@VERSION@/$(MACHINE_PREFIX)/g" > $@
	chmod +x $@
