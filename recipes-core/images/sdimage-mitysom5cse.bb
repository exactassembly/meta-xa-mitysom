SUMMARY = "MitySOM5CSE bootable SDCard image"

IMAGE_INSTALL = " "
PACKAGE_INSTALL = " "

IMAGE_FEATURES = " "

IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image

SOCFPGA_MITYSOM5_ROOTFS_IMAGE ?= "application-rootfs"
SOCFPGA_MITYSOM5_INITRAMFS_IMAGE ?= "initramfs-mitysom5cse"
SOCFPGA_MITYSOM5_BITSTREAM ?= "5cse_l2_3y8.rbf"

DEPENDS+=" \
    ${PREFERRED_PROVIDER_virtual/bootloader} \
    ${SOCFPGA_MITYSOM5_INITRAMFS_IMAGE} \
    ${SOCFPGA_MITYSOM5_ROOTFS_IMAGE} \
    "

IMAGE_ROOTFS_SIZE = "262144"
export IMAGE_BASENAME = "sdimage-mitysom5cse"
IMAGE_FSTYPES = "wic"
WKS_FILE = "sdimage-mitysom5cse.wks"

IMAGE_BOOT_FILES += " \
	${SOCFPGA_MITYSOM5_INITRAMFS_IMAGE}.cpio.gz.u-boot \
    ${SOCFPGA_MITYSOM5_ROOTFS_IMAGE}-mitysom5cse.squashfs \
    ${SOCFPGA_MITYSOM5_BITSTREAM} \
    "

