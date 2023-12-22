DEPENDS:append = " xxd-native"

UBOOT_REPO = "git://git.criticallink.com/git/u-boot-socfpga.git"
SRCREV = "db48e7dfa5adfffd377ff0709cc2363f17aeec3b"


UBOOT_ENV="u-boot-initrd-env"
UBOOT_ENV_SUFFIX="scr"

FILESEXTRAPATHS:prepend := "${THISDIR}/files-mitysoma10s:"
SRC_URI += "file://u-boot-initrd-env.cmd"
SRC_URI += "file://002_use_default_env.cfg"