require u-boot-socfpga-cl.inc
LIC_FILES_CHKSUM = "file://Licenses/README;md5=30503fd321432fc713238f582193b78e"

UBOOT_VERSION = "v2019.10"

SRCREV = "964a62232a0216d196759a2a97ba4a4bea6fe982"

FILESEXTRAPATHS:prepend := "${THISDIR}/files-mitysom5cse:"
SRC_URI += "file://001_add_mitysom5cse_l23y8.patch"
SRC_URI += "file://initrd-squashfs-boot.txt"
SRC_URI += "file://003_use_default_env.cfg"

