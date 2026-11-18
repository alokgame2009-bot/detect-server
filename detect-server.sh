#!/bin/bash

# ============================================================
# Zyren Tech Server Detector
# Author: Zyren
# Powered by Zyren Tech
# ============================================================

clear

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
RESET='\033[0m'

echo -e "${CYAN}"
echo "============================================================"
echo "             ZYREN TECH SERVER DETECTOR"
echo "============================================================"
echo -e "${RESET}"

# OS Information
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME="$PRETTY_NAME"
else
    OS_NAME="Unknown Linux"
fi

# Hostname
HOSTNAME=$(hostname)

# Kernel
KERNEL=$(uname -r)

# Architecture
ARCH=$(uname -m)

# CPU
CPU=$(grep -m1 "model name" /proc/cpuinfo | cut -d ':' -f2 | xargs)

# CPU Cores
CORES=$(nproc)

# RAM
RAM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')
RAM_USED=$(free -h | awk '/Mem:/ {print $3}')
RAM_FREE=$(free -h | awk '/Mem:/ {print $4}')

# Disk
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_FREE=$(df -h / | awk 'NR==2 {print $4}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')

# Uptime
UPTIME=$(uptime -p)

# Virtualization
VIRT=$(systemd-detect-virt 2>/dev/null || echo "Unknown")

# IP Address
IP_ADDRESS=$(hostname -I 2>/dev/null | awk '{print $1}')
[ -z "$IP_ADDRESS" ] && IP_ADDRESS="Unavailable"

# Server Information
echo -e "${GREEN}[ SERVER INFORMATION ]${RESET}"
echo -e "${WHITE}Hostname       :${RESET} $HOSTNAME"
echo -e "${WHITE}Operating System:${RESET} $OS_NAME"
echo -e "${WHITE}Kernel         :${RESET} $KERNEL"
echo -e "${WHITE}Architecture   :${RESET} $ARCH"
echo -e "${WHITE}Virtualization :${RESET} $VIRT"
echo -e "${WHITE}IP Address     :${RESET} $IP_ADDRESS"
echo -e "${WHITE}Uptime         :${RESET} $UPTIME"

echo ""

# CPU Information
echo -e "${GREEN}[ CPU INFORMATION ]${RESET}"
echo -e "${WHITE}Processor      :${RESET} $CPU"
echo -e "${WHITE}CPU Cores      :${RESET} $CORES"

echo ""

# RAM Information
echo -e "${GREEN}[ MEMORY INFORMATION ]${RESET}"
echo -e "${WHITE}Total RAM      :${RESET} $RAM_TOTAL"
echo -e "${WHITE}Used RAM       :${RESET} $RAM_USED"
echo -e "${WHITE}Free RAM       :${RESET} $RAM_FREE"

echo ""

# Disk Information
echo -e "${GREEN}[ DISK INFORMATION ]${RESET}"
echo -e "${WHITE}Total Disk     :${RESET} $DISK_TOTAL"
echo -e "${WHITE}Used Disk      :${RESET} $DISK_USED"
echo -e "${WHITE}Free Disk      :${RESET} $DISK_FREE"
echo -e "${WHITE}Disk Usage     :${RESET} $DISK_USAGE"

echo ""

echo -e "${CYAN}"
echo "============================================================"
echo "              Powered by Zyren Tech"
echo "                   Author: Zyren"
echo "============================================================"
echo -e "${RESET}"
