SRC_URI += "file://socfpga_mitysom5cs.dtsi;subdir=git/arch/${ARCH}/boot/dts"
SRC_URI += "file://socfpga_mitysom5cse.dtsi;subdir=git/arch/${ARCH}/boot/dts"
SRC_URI += "file://socfpga_mitysom5cse_l23y8.dtsi;subdir=git/arch/${ARCH}/boot/dts"
SRC_URI += "file://socfpga_mitysom5cse_l23y8_empty.dts;subdir=git/arch/${ARCH}/boot/dts"
SRC_URI += "file://00-BootRequired.cfg"
SRC_URI += "file://01-MicrelPHY_ClDevKit.cfg"

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-socfpga-lts-6.1:"

KERNEL_DEVICETREE += "\
			socfpga_mitysom5cse_l23y8_empty.dtb \
			"

PACKAGE_ARCH = "${MACHINE_ARCH}"

