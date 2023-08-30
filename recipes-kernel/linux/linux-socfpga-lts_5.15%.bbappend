SRC_URI += "file://socfpga_mitysom5cs.dtsi;subdir=git/arch/${ARCH}/boot/dts"
SRC_URI += "file://socfpga_mitysom5cse.dtsi;subdir=git/arch/${ARCH}/boot/dts"
SRC_URI += "file://socfpga_mitysom5cse_l23y8.dtsi;subdir=git/arch/${ARCH}/boot/dts"
SRC_URI += "file://socfpga_mitysom5cse_l23y8_empty.dts;subdir=git/arch/${ARCH}/boot/dts"
SRC_URI += "file://00-BootRequired.cfg"
//SRC_URI += "file://002_fix_transmit_queue.patch"
//SRC_URI += "file://003_fix_ptp_increment.patch"

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-socfpga-lts:"

PACKAGE_ARCH = "${MACHINE_ARCH}"

