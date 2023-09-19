# Common configuration for atomic MitySOM5 images
#   - Depends on having an initramfs image for boot
#   - 
#   - 
#
# Copyright (C) 2023 Exact Assembly, LLC

LICENSE = "BSD-3"

IMAGE_INSTALL = "\
    ${CORE_IMAGE_BASE_INSTALL} \
    kernel-modules \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    "

do_rootfs[depends] += "initramfs-mitysom5cse:do_image_complete"

IMAGE_LINGUAS = " "

# qemu seems to be needed by image assembly scripts associatd with udev (must 
# be doing runtime things during the build that execute with ARM binaries)
DEPENDS="qemuwrapper-cross"

ROOTFS_POSTPROCESS_COMMAND_mitysom5cse += " rootfs_tuning_boot;"

rootfs_tuning_boot() {
    # make it clear this is the squahfs
    echo "SMEG Module SquashFS" >> ${IMAGE_ROOTFS}/etc/issue
    # we dont want another copy of the bzImage boot file in here
    # plus the /boot directory will be hidden when we mount the real
    # EFI boot partition
    rm -rf ${IMAGE_ROOTFS}/boot/*

    # remove unnecessary things like NFS mounting
    rm ${IMAGE_ROOTFS}/etc/rc5.d/S15mountnfs.sh
}

IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE:append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "" ,d)}"
export IMAGE_BASENAME = "application-rootfs"
PROVIDES = "application-rootfs"

IMAGE_FSTYPES = "squashfs"

inherit core-image
