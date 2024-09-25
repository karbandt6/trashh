#!/bin/sh

mkdir -p /backup
BckP_fl="/backup/openwrt-full-backup-$(date +%d-%m-%Y).tar.gz"
echo "Memulai backup penuh dari filesystem overlay dan ROM ke $BckP_fl"
tar -czf $BckP_fl -C /overlay . -C /rom .
sync
echo "Backup penuh selesai dan disimpan di $BckP_fl"
