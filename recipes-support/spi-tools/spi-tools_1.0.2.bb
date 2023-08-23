SUMMARY = "SPI bus tools"
DESCRIPTION = "SPI bus tools"
LICENSE = "GPL-2.0"

SRC_URI = "git://github.com/cpb-/spi-tools.git;protocol=https;branch=master"
SRCREV = "${AUTOREV}"

# You must go through dependent modules extract licences and add them here.
LIC_FILES_CHKSUM = "file://LICENSE;md5=8c16666ae6c159876a0ba63099614381"
S = "${WORKDIR}/git"

inherit autotools