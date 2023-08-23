SUMMARY = "System/configuration tools"
DESCRIPTION = "Packages which provide OS/system level debugging utilities"
PR = "r1"

inherit packagegroup

PACKAGE_ARCH = ""

RDEPENDS:${PN} = "\
    i2c-tools \
    mdiotool \
    libgpiod-tools \
"
