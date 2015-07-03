#!/bin/bash +x
set -e

# Set environment with defaults
SWAPSIZE=${SWAPSIZE:-1024m}
SWAPFILE="${SWAPFILE:-/swapfile}"

# Create and enable the swapfile
/usr/bin/fallocate -l ${SWAPSIZE} "${SWAPFILE}"
/usr/bin/chmod 600 "${SWAPFILE}"
/usr/bin/chattr +C "${SWAPFILE}"
/usr/sbin/mkswap "${SWAPFILE}"
/usr/sbin/losetup -f "${SWAPFILE}"
/usr/sbin/sysctl vm.swappiness=10
/usr/sbin/sysctl vm.vfs_cache_pressure=50
/usr/sbin/swapon $(/usr/sbin/losetup -j ${SWAPFILE} | /bin/cut -d : -f 1)