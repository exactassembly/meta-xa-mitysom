LICENSE = "BSD-3"
LIC_FILES_CHKSUM = ""
PR="r0"

inherit deploy

SRC_URI = "\
  file://75-overlayfs.sh \
"

DEPENDS += " \
  initramfs-framework-base \
"

RDEPENDS:${PN} = "\
  initramfs-framework-base \
  "

S="${WORKDIR}"

do_install() {
    install -d ${D}/init.d
    install -m 0555 ${S}/75-overlayfs.sh ${D}/init.d/75-overlayfs
}

do_patch[noexec] = "1"
do_configure[noexec] = "1"
do_compile[noexec] = "1"

FILES:${PN}="\
  /init.d \
  /init.d/75-overlayfs \
"