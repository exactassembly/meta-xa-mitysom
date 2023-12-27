DEPENDS:append = " xxd-native"
DEPENDS:append:mitysoma10s = " bitstreams-and-handoffs"

UBOOT_REPO = "git://git.criticallink.com/git/u-boot-socfpga.git"
SRCREV = "db48e7dfa5adfffd377ff0709cc2363f17aeec3b"


UBOOT_ENV="u-boot-initrd-env"
UBOOT_ENV_SUFFIX="scr"

FILESEXTRAPATHS:prepend := "${THISDIR}/files-mitysoma10s:"
SRC_URI += "file://u-boot-initrd-env.cmd"
SRC_URI += "file://002_use_default_env.cfg"

do_compile:prepend:mitysoma10s() {
    cp -r ${DEPLOY_DIR_IMAGE}/hps.xml ${S}/.
    ${S}/arch/arm/mach-socfpga/qts-filter-a10.sh ${S}/hps.xml ${S}/arch/arm/dts/socfpga_mitysom_a10s_handoff.h
}

do_compile:append:mitysoma10s() {
    cp ${B}/socfpga_mitysom_a10s_dsc_defconfig/u-boot-nodtb.bin ${S}/u-boot-nodtb.bin
    cp ${B}/socfpga_mitysom_a10s_dsc_defconfig/u-boot-dtb.bin ${S}/u-boot-dtb.bin
    cp ${DEPLOY_DIR_IMAGE}/mitysom_a10s.core.rbf ${S}/mitysom_a10s.core.rbf
    cp ${DEPLOY_DIR_IMAGE}/mitysom_a10s.periph.rbf ${S}/mitysom_a10s.periph.rbf
    mkimage -E -f ${S}/board/cl/mitysom-a10s-dsc/fit_spl_fpga.its ${B}/fit_spl_fpga.itb
}

do_deploy:append:mitysoma10s() {
    install -d ${DEPLOYDIR}
    install -m 744 ${B}/fit_spl_fpga.itb ${DEPLOYDIR}/
}