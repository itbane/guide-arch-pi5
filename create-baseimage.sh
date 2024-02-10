#!/usr/bin/bash
# Script based on https://kiljan.org/2023/11/24/arch-linux-arm-on-a-raspberry-pi-5-model-b/

# to ensure ppl don't just curl | bash, exit if not changed

exit 1

# replace device path to your needs!
export SDDEV=/dev/mmcblk0
export SDPARTBOOT=/dev/mmcblk0p1
export SDPARTROOT=/dev/mmcblk0p2
export SDMOUNT=/mnt/sd
export DOWNLOADDIR=/tmp/pi
export DISTURL="http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz"

mkdir -p $DOWNLOADDIR
(
  cd $DOWNLOADDIR && \
  curl -JLO $DISTURL
)

sfdisk --quiet --wipe always $SDDEV << EOF
,256M,0c,
,,,
EOF

mkfs.vfat -F 32 $SDPARTBOOT
mkfs.ext4 -E lazy_itable_init=0,lazy_journal_init=0 -F $SDPARTROOT

mkdir -p $SDMOUNT
mount $SDPARTROOT $SDMOUNT
mkdir -p ${SDMOUNT}/boot
mount $SDPARTBOOT ${SDMOUNT}/boot

bsdtar -xpf ${DOWNLOADDIR}/ArchLinuxARM-rpi-aarch64-latest.tar.gz -C $SDMOUNT
