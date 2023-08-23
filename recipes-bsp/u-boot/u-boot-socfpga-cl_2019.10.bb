require u-boot-socfpga-cl.inc
LIC_FILES_CHKSUM = "file://Licenses/README;md5=30503fd321432fc713238f582193b78e"

UBOOT_VERSION = "v2019.10"

SRCREV = "964a62232a0216d196759a2a97ba4a4bea6fe982"

FILESEXTRAPATHS:prepend := "${THISDIR}/files-mitysom5cse:"
#SRC_URI += "file://socfpga_mitysom5csx.dts;subdir=git/arch/${ARCH}/dts"
#SRC_URI += "file://socfpga_mitysom5cse.dtsi;subdir=git/arch/${ARCH}/dts"
#SRC_URI += "file://socfpga_mitysom5cs.dtsi;subdir=git/arch/${ARCH}/dts"
SRC_URI += "file://socfpga_mitysom5cs-l2-3y8_defconfig;subdir=git/configs"
SRC_URI += "file://002_sdram_plls_l23y8.patch"
SRC_URI += "file://002_add_dts.patch"
SRC_URI += "file://initrd-squashfs-boot.txt"
SRC_URI += "file://003_use_default_env.cfg"
SRC_URI += "file://004_enable_rgmii.cfg"

#ENV_BASE_NAME = "initrd-squashfs-boot"
#ENV_SIZE = "65535"
#require u-boot-socfpga-cl-env.inc

