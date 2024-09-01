#!/command/with-contenv bashio
# shellcheck shell=bash

set -e

SWAP_SIZE=$(bashio::config 'swap_size')
SWAP_DEVICE="/dev/zram0"

remove_old_swap_file() {
    IS_SWAP="grep ${SWAP_DEVICE} /proc/swaps"
    if $IS_SWAP; then
        swapoff "${SWAP_DEVICE}"
        print_date "Old swap disconnected."
    fi
}

print_date() {
  timestamp=$(date +'%H:%M:%S %d/%m/%Y')
  echo "[$timestamp] $1"
}

print_date "Starting Swap add-on..."

remove_old_swap_file

zramctl -a zstd -s "${SWAP_SIZE}"M -t 4 "${SWAP_DEVICE}"
mkswap "${SWAP_DEVICE}"
swapon "${SWAP_DEVICE}" -p 1

print_date "New swap device: ${SWAP_DEVICE} created and enabled."
