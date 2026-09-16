#!/bin/bash

echo "===== SERVER HEALTH CHECK ====="
echo "Hostname: $(hostname)"
echo "Date: $(date)"
echo

echo "===== UPTIME ====="
uptime
echo

echo "===== MEMORY ====="
free -h
echo

echo "===== DISK USAGE ====="
df -h /
df -h /srv/data
echo

echo "===== NETWORK ====="
ip -brief address show ens3
echo

echo "===== SSH SERVICE ====="

if systemctl is-active --quiet ssh; then
    echo "SSH service: OK"
else
    echo "SSH service: FAILED"
fi
