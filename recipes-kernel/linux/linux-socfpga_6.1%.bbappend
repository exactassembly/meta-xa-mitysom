SRC_URI += "file://mitysom_a10s_devkit.dts;subdir=git/arch/${ARCH}/boot/dts"
SRC_URI += "file://mitysom_a10s.dtsi;subdir=git/arch/${ARCH}/boot/dts"
SRC_URI += "file://socfpga_arria10.dtsi;subdir=git/arch/${ARCH}/boot/dts"
SRC_URI += "file://01-A10S.cfg"
SRC_URI += "file://00-BootRequired.cfg"



FILESEXTRAPATHS:prepend := "${THISDIR}/linux-socfpga:"

PACKAGE_ARCH = "${MACHINE_ARCH}"
