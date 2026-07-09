#!/bin/bash

LOGFILE="/var/log/patching_$(date +%F_%H-%M-%S).log"

echo "==========================================" | tee -a $LOGFILE
echo "STARTING PRODUCTION PATCHING" | tee -a $LOGFILE
echo "==========================================" | tee -a $LOGFILE

# Check root user
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script as root" | tee -a $LOGFILE
    exit 1
fi

# Host information
echo "Hostname: $(hostname)" | tee -a $LOGFILE
echo "Date: $(date)" | tee -a $LOGFILE

echo "==========================================" | tee -a $LOGFILE

# Check disk space
echo "Checking disk space..." | tee -a $LOGFILE
df -h | tee -a $LOGFILE

echo "==========================================" | tee -a $LOGFILE

# Check failed services
echo "Checking failed services..." | tee -a $LOGFILE
systemctl --failed | tee -a $LOGFILE

echo "==========================================" | tee -a $LOGFILE

# Save current kernel
OLD_KERNEL=$(uname -r)

echo "Current Kernel: $OLD_KERNEL" | tee -a $LOGFILE

echo "==========================================" | tee -a $LOGFILE

# Check available security updates
echo "Available Security Updates:" | tee -a $LOGFILE
yum updateinfo list security all | tee -a $LOGFILE

echo "==========================================" | tee -a $LOGFILE

# Apply only security patches
echo "Applying security patches..." | tee -a $LOGFILE
yum update --security -y >> $LOGFILE 2>&1

if [ $? -eq 0 ]; then
    echo "Security patching completed successfully" | tee -a $LOGFILE
else
    echo "ERROR: Security patching failed" | tee -a $LOGFILE
    exit 1
fi

echo "==========================================" | tee -a $LOGFILE

# Check kernel update
NEW_KERNEL=$(rpm -q --last kernel | head -1 | awk '{print $1}' | sed 's/kernel-//')

echo "Old Kernel: $OLD_KERNEL" | tee -a $LOGFILE
echo "Latest Kernel: $NEW_KERNEL" | tee -a $LOGFILE

if [ "$OLD_KERNEL" != "$NEW_KERNEL" ]; then
    echo "Kernel update detected." | tee -a $LOGFILE
    echo "Server reboot required." | tee -a $LOGFILE
else
    echo "No reboot required." | tee -a $LOGFILE
fi

echo "==========================================" | tee -a $LOGFILE
echo "PATCHING COMPLETED" | tee -a $LOGFILE
echo "Log file: $LOGFILE" | tee -a $LOGFILE
echo "=========================================="
