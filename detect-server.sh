#!/bin/bash

# ============================================================
# Zyren Tech Server Detector
# Author: Zyren
# Powered by Zyren Tech
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
RESET='\033[0m'

clear 2>/dev/null

get_dmi() {
    for file in "$@"; do
        if [ -r "$file" ]; then
            cat "$file" 2>/dev/null
            return
        fi
    done
    echo "Unknown"
}

# Virtualization Detection
VIRT=$(systemd-detect-virt 2>/dev/null || echo "none")

# Hardware Information
SYS_VENDOR=$(get_dmi /sys/class/dmi/id/sys_vendor)
PRODUCT_NAME=$(get_dmi /sys/class/dmi/id/product_name)
PRODUCT_VERSION=$(get_dmi /sys/class/dmi/id/product_version)

# Cloud Provider Detection
DMI_INFO="${SYS_VENDOR} ${PRODUCT_NAME} ${PRODUCT_VERSION}"

if echo "$DMI_INFO" | grep -qi "Amazon\|EC2"; then
    PROVIDER="Amazon AWS"
elif echo "$DMI_INFO" | grep -qi "Google"; then
    PROVIDER="Google Cloud"
elif echo "$DMI_INFO" | grep -qi "Microsoft\|Virtual Machine"; then
    PROVIDER="Microsoft Azure / Hyper-V"
elif echo "$DMI_INFO" | grep -qi "Oracle"; then
    PROVIDER="Oracle Cloud"
elif echo "$DMI_INFO" | grep -qi "Alibaba"; then
    PROVIDER="Alibaba Cloud"
elif echo "$DMI_INFO" | grep -qi "DigitalOcean"; then
    PROVIDER="DigitalOcean"
elif echo "$DMI_INFO" | grep -qi "Hetzner"; then
    PROVIDER="Hetzner"
elif echo "$DMI_INFO" | grep -qi "VMware"; then
    PROVIDER="VMware"
elif echo "$DMI_INFO" | grep -qi "QEMU"; then
    PROVIDER="QEMU/KVM"
else
    PROVIDER="Unknown / Private Provider"
fi

# Server Type Detection
case "$VIRT" in
    docker|podman|lxc|lxc-libvirt|openvz|systemd-nspawn)
        SERVER_TYPE="Container"
        ;;
    kvm|qemu|vmware|xen|microsoft|oracle|bhyve|parallels)
        SERVER_TYPE="Virtual Server (VPS/VDS)"
        ;;
    none)
        SERVER_TYPE="Physical Server / Bare Metal"
        ;;
    *)
        SERVER_TYPE="Virtualized Server"
        ;;
esac

# Operating System
OS_NAME="Unknown"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME="$PRETTY_NAME"
fi

# CPU
CPU=$(grep -m1 "model name" /proc/cpuinfo 2>/dev/null | cut -d ':' -f2 | xargs)

if [ -z "$CPU" ]; then
    CPU=$(uname -p)
fi

CPU_CORES=$(nproc 2>/dev/null || echo "Unknown")
CPU_THREADS=$(grep -c processor /proc/cpuinfo 2>/dev/null)

# RAM
RAM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')
RAM_USED=$(free -h | awk '/Mem:/ {print $3}')
RAM_FREE=$(free -h | awk '/Mem:/ {print $4}')

# Disk
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_FREE=$(df -h / | awk 'NR==2 {print $4}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')

# IP
IP_ADDRESS=$(hostname -I 2>/dev/null | awk '{print $1}')
[ -z "$IP_ADDRESS" ] && IP_ADDRESS="Unavailable"

# Hostname
HOSTNAME=$(hostname)

# Kernel
KERNEL=$(uname -r)

# Architecture
ARCH=$(uname -m)

# Uptime
UPTIME=$(uptime -p 2>/dev/null)

# ============================================================
# OUTPUT
# ============================================================

echo -e "${CYAN}"
echo "============================================================"
echo "             ZYREN TECH SERVER DETECTOR"
echo "============================================================"
echo -e "${RESET}"

echo -e "${GREEN}[ SERVER CLASSIFICATION ]${RESET}"
echo -e "${WHITE}Server Type       :${RESET} $SERVER_TYPE"
echo -e "${WHITE}Virtualization    :${RESET} $VIRT"
echo -e "${WHITE}Provider          :${RESET} $PROVIDER"
echo -e "${WHITE}System Vendor     :${RESET} $SYS_VENDOR"
echo -e "${WHITE}Product Name      :${RESET} $PRODUCT_NAME"

echo ""

echo -e "${GREEN}[ SYSTEM INFORMATION ]${RESET}"
echo -e "${WHITE}Hostname          :${RESET} $HOSTNAME"
echo -e "${WHITE}Operating System  :${RESET} $OS_NAME"
echo -e "${WHITE}Kernel            :${RESET} $KERNEL"
echo -e "${WHITE}Architecture      :${RESET} $ARCH"
echo -e "${WHITE}IP Address        :${RESET} $IP_ADDRESS"
echo -e "${WHITE}Uptime            :${RESET} $UPTIME"

echo ""

echo -e "${GREEN}[ CPU INFORMATION ]${RESET}"
echo -e "${WHITE}Processor         :${RESET} $CPU"
echo -e "${WHITE}CPU Cores         :${RESET} $CPU_CORES"
echo -e "${WHITE}CPU Threads       :${RESET} $CPU_THREADS"

echo ""

echo -e "${GREEN}[ MEMORY INFORMATION ]${RESET}"
echo -e "${WHITE}Total RAM         :${RESET} $RAM_TOTAL"
echo -e "${WHITE}Used RAM          :${RESET} $RAM_USED"
echo -e "${WHITE}Free RAM          :${RESET} $RAM_FREE"

echo ""

echo -e "${GREEN}[ DISK INFORMATION ]${RESET}"
echo -e "${WHITE}Total Disk        :${RESET} $DISK_TOTAL"
echo -e "${WHITE}Used Disk         :${RESET} $DISK_USED"
echo -e "${WHITE}Free Disk         :${RESET} $DISK_FREE"
echo -e "${WHITE}Disk Usage        :${RESET} $DISK_USAGE"

echo ""

echo -e "${YELLOW}[ DETECTION NOTE ]${RESET}"
echo "VPS and VDS both use virtualization."
echo "Exact resource allocation cannot always be detected"
echo "from inside the operating system."

echo ""

echo -e "${CYAN}"
echo "============================================================"
echo "              Powered by Zyren Tech"
echo "                   Author: Zyren"
echo "============================================================"
echo -e "${RESET}"
