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
            /bin/unmount ${BOOTDIR}
            /bin/sleep 1
            /bin/mount ${bootparam_loopimgdev} ${BOOTDIR}
        fi
    else
        debug "Boot partition already mounted"
    fi

    UPGRADEDIR="${BOOTDIR}/upgrade"
    /bin/mkdir -p ${UPGRADEDIR}
    FAILEDDIR="${BOOTDIR}/failed"
    /bin/mkdir -p ${FAILEDDIR}
    BACKUPDIR="${BOOTDIR}/backup"
    /bin/mkdir -p ${BACKUPDIR}

    UPGRADESTAMP="${BOOTDIR}/UPGRADE-IN-PROGRESS"
    ROLLBACKSTAMP="${BOOTDIR}/ROLLBACK"
    OLDIMGFILE="${bootparam_loopimgfile}.old"

    BOOTIMGFILE="${BOOTDIR}/${bootparam_loopimgfile}"
    UPGRADEIMGFILE="${UPGRADEDIR}/${bootparam_loopimgfile}"
    BACKUPIMGFILE="${BACKUPDIR}/${bootparam_loopimgfile}"

    if [ -f ${UPGRADEIMGFILE} ]; then
        debug "Found upgrade img: ${UPGRADEIMGFILE} ... attempting upgrade"
        
        if [ ! -f ${ROLLBACKSTAMP} ]; then
        
            /bin/touch $UPGRADESTAMP

            if [ -f ${BACKUPIMGFILE} ]; then
                debug "Found existing backup img: ${BACKUPIMGFILE} ... marking as old"
                /bin/mv $BACKUPIMGFILE ${BACKUPDIR}/${OLDIMGFILE}
            fi

            if [ -f ${BOOTIMGFILE} ]; then
                debug "Found existing boot img: ${BOOTIMGFILE} ... moving to backup"
                /bin/mv $BOOTIMGFILE $BACKUPDIR
            fi

            debug "Moving upgrade img to boot img location"
            /bin/mv $UPGRADEIMGFILE $BOOTDIR

        else

            msg "SquashFS: CONFLICT: Rollback stamp ${ROLLBACKSTAMP} and Upgrade img ${UPGRADEIMGFILE} both exist... ignoring both and booting normally"
            /bin/echo "Both ${ROLLBACKSTAMP} and ${UPGRADEIMGFILE} existed and were ignored, please remove one..." > ${FAILEDDIR}/failed

        fi
    
    else
        # if there's not an upgrade file, and there is a ROLLBACKSTAMP, try to rollback
        if [ -f ${ROLLBACKSTAMP} ]; then
            debug "Found Rollback stamp ${ROLLBACKSTAMP} ... attempting to rollback img"

            if [ -f ${BACKUPIMGFILE} ]; then
                debug "Found backup img ${BACKUPIMGFILE} ... rolling back to backup img"
                /bin/mv $BACKUPIMGFILE $BOOTDIR

                if [ -f ${BACKUPDIR}/${OLDIMGFILE} ]; then
                    debug "Found old backup img ${BACKUPDIR}/${OLDIMGFILE} ... setting old img as backup"
                    /bin/mv ${BACKUPDIR}/${OLDIMGFILE} $BACKUPIMGFILE
                fi

                debug "Successfully rolled back img ... deleting rollback stamp ${ROLLBACKSTAMP}"
                /bin/rm $ROLLBACKSTAMP

            else
                msg "SquashFS: MISSING FILE: found rollback stamp @ ${ROLLBACKSTAMP} but found no backup img in ${BACKUPDIR} ... booting as normal -- check /boot/fatal"
                /bin/echo "Found rollback stamp ${ROLLBACKSTAMP} but not backup img ${BACKUPIMGFILE}" > ${FAILEDDIR}/failed
            fi
        fi 

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
    /bin/mkdir -p ${PERSISTDIR}
    if [ -b "${bootparam_looppersistdev}" ]; then
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

    debug "Moving ro and rw root file system into overlay"
    /bin/mkdir -p $ROOTFS_DIR/$SQUASHDIR $ROOTFS_DIR/$PERSISTDIR 
    /bin/mount --move $SQUASHDIR ${ROOTFS_DIR}/$SQUASHDIR
    /bin/mount --move $PERSISTDIR ${ROOTFS_DIR}/$PERSISTDIR

    # move /boot into the overlayfs so that the user has access
    /bin/mount --move $BOOTDIR ${ROOTFS_DIR}/$BOOTDIR


    debug "OverlayFS complete"
}