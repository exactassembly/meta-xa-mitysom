#/bin/sh
# Copyright (C) 2023 ExactAssembly LLC
# Author: ted@xassembly.com
# Licensed on BSD-3

overlayfs_enabled() {
        return 0
}

overlayfs_run() {
    MEDIADIR="/media"
    BOOTDIR="/boot"
    /bin/mkdir -p ${MEDIADIR}
    SQUASHDIR="${MEDIADIR}/squashfs"
    /bin/mkdir -p ${SQUASHDIR}

    debug "Using ${bootparam_loopimgdev} for image objects"
    if [ -z ${bootparam_loopimgfile} ]; then 
        bootparam_loopimgfile="rootfs-mitysom5cse.squashfs"
    fi
    debug "Using ${bootparam_loopimgfile} for squashfs image"

    MOUNTEDBOOT=`grep -o -e "/boot" /proc/mounts`
    if [ -z "$MOUNTEDBOOT" ]; then

        debug "Mounting boot partition '${bootparam_loopimgdev}' @ ${BOOTDIR}"
        /bin/mount ${bootparam_loopimgdev} ${BOOTDIR}
        if [ ! -f ${BOOTDIR}/${bootparam_loopimgfile} ]; then
            # retry if mount doesnt work
            debug "Re-try Mounting boot partition '${bootparam_loopimgdev}' @ ${BOOTDIR}"
            /bin/sleep 1
            /bin/mount ${bootparam_loopimgdev} ${BOOTDIR}
        fi
    else
        debug "Boot partition already mounted"
    fi

    if [ ! -f ${BOOTDIR}/${bootparam_loopimgfile} ]; then
        debug "Failed to find ${BOOTDIR}/${bootparam_loopimgfile}"
            /bin/sh
        fatal "Failed to find ${BOOTDIR}/${bootparam_loopimgfile}"
    fi
    debug "Mounting squashfs @ ${SQUASHDIR}"
    /bin/mount -o ro,loop -t squashfs ${BOOTDIR}/${bootparam_loopimgfile} ${SQUASHDIR}
    if [ ! -f ${SQUASHDIR}/etc/issue ]; then
        fatal "Failed to find /etc/issue in ${SQUASHDIR}"
    fi

    # mount the persistent data device, either from SDCard partition
    # or create a tempfs to allow read/write for the root partition
    PERSISTDIR="${MEDIADIR}/persist"
    /bin/mkdir -p ${SQUASHDIR}
    if [ -f "${bootparam_looppersistdev}" ]; then
        debug "Using ${bootparam_looppersistdev} @ ${PERSISTDIR}"
        /bin/mount -n ${bootparam_looppersistdev} ${PERSISTDIR}
    else
        debug "!!Using tempfs for emphemerial data"
        /bin/mount -n -t tmpfs    tmpfs    ${PERSISTDIR}
    fi

    # make sure there are directories for the retained and work
    # directories needed by OverlayFS
    UPPERDIR="${PERSISTDIR}/upper"
    /bin/mkdir -p ${UPPERDIR}
    WORKDIR="${PERSISTDIR}/work"
    /bin/mkdir -p ${WORKDIR}
    debug "Mounting OverlayFS @ ${ROOTFS_DIR} lower=${SQUASHDIR} upper=${UPPERDIR} work=${WORKDIR}"
    /bin/mount -t overlay overlay \
        -o rw,lowerdir=${SQUASHDIR},upperdir=${UPPERDIR},workdir=${WORKDIR} \
        $ROOTFS_DIR
    if [ ! -f ${ROOTFS_DIR}/etc/issue ]; then
        fatal "Found /etc/issue in ${ROOTFS_DIR}"
    fi
    debug "OverlayFS complete"
}