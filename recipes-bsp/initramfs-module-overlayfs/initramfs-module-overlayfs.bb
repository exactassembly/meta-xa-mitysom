LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://75-overlayfs.sh;beginline=1;endline=4;md5=d13e1d7613e8081e0d5b9de5fd475cfc"
PR="r0"

inherit deploy allarch

SRC_URI = "\
  file://75-overlayfs.sh \
"

DEPENDS += " \
  initramfs-framework \
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