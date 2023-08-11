# Simple initramfs image suitable for booting the MitySOM5CSE
#
# 
LICENSE = "BSD-3"

DESCRIPTION = "Small image capable of booting a device. The kernel includes \
the Minimal RAM-based Initial Root Filesystem (initramfs), which finds the \
first 'init' program more efficiently."

COMPATIBLE_MACHINE = "mitysom5cse"

INITRAMFS_SCRIPTS += "\
    initramfs-framework-base \
    initramfs-module-udev \
    initramfs-module-looproot \
    "

VIRTUAL-RUNTIME_dev_manager ?= "busybox-mdev"

PACKAGE_INSTALL = "\
    ${INITRAMFS_SCRIPTS} \
    initramfs-live-boot-tiny \
    packagegroup-core-boot \
    dropbear \
    ${VIRTUAL-RUNTIME_base-utils} \
    ${VIRTUAL-RUNTIME_dev_manager} \
    kernel-modules \
    base-passwd \
    ${ROOTFS_BOOTSTRAP_INSTALL}"

export IMAGE_BASENAME = "mitysom5cse-initramfs"
IMAGE_NAME_SUFFIX ?= ""
IMAGE_LINGUAS = ""
# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""
#PACKAGE_INSTALL = ""
PACKAGE_EXCLUDE = "\
    x11 \
    x11-base \
    weston \
    "
IMAGE_LINGUAS = ""
IMAGE_FSTYPES = "cpio.gz.u-boot"
IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

# Use the same restriction as initramfs-live-install
COMPATIBLE_HOST = "(i.86|x86_64|aarch64|arm).*-linux"
inherit core-image

# Use the same restriction as initramfs-live-install
COMPATIBLE_HOST = "(i.86|x86_64|aarch64|arm).*-linux"

ROOTFS_POSTPROCESS_COMMAND += " rootfs_tuning_filesystem;"

rootfs_tuning_filesystem() {
    # we dont want another copy of the bzImage boot file in here
    # plus the /boot directory will be hidden when we mount the real
    # EFI boot partition
    rm -f ${IMAGE_ROOTFS}/boot/*

    echo "MitySOM5CSE INITRAMFS" >> ${IMAGE_ROOTFS}/etc/issue
}