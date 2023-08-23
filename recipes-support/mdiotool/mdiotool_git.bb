SUMMARY = "MDIO utility"
DESCRIPTION = "Ethernet PHY MDIO register access utility"
LICENSE = "GPL-2.0"

SRC_URI = "git://github.com/PieVo/mdio-tool.git;protocol=https;branch=master"
SRC_URI[sha256sum] = "a90df3515b7015d46379043132cb06ca0b0059820d110d2673636b4cb8818ced"
SRCREV = "${AUTOREV}"

# You must go through dependent modules extract licences and add them here.
LIC_FILES_CHKSUM = "file://LICENSE;md5=e8c1458438ead3c34974bc0be3a03ed6"
S = "${WORKDIR}/git"

inherit cmake