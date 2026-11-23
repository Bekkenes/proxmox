#!/bin/bash
# Proxmox Failed Login Attempts Checker
# Searches the auth log for failed SSH, PAM and Proxmox web UI logins, prints each
# one in red and summarises the total count.
#
# Proxmox VE 8+ (Debian 12) logs to the systemd journal only and has no
# /var/log/auth.log unless rsyslog is installed, so the journal is used when
# that file is missing. Override with: LOG_FILE=/path/to/log ./check_failed_logins.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

LOG_FILE="${LOG_FILE:-/var/log/auth.log}"
SINCE="${SINCE:-7 days ago}"

# Only real login failures: sshd, PAM and the Proxmox web UI (pvedaemon/pveproxy).
# A plain "failed" would also match every "Failed to start ..." from systemd.
PATTERN='Failed password|Failed publickey|Invalid user|authentication failure|pam_unix\(.*\): auth.*failure|maximum authentication attempts'

if [ -f "$LOG_FILE" ]; then
    source_desc="$LOG_FILE"
    matches=$(grep -E "$PATTERN" "$LOG_FILE")
elif command -v journalctl >/dev/null 2>&1; then
    source_desc="systemd journal (since $SINCE)"
    matches=$(journalctl --no-pager -q --since "$SINCE" \
        _COMM=sshd + _COMM=sshd-session + _COMM=pvedaemon + _COMM=pveproxy + _COMM=login + _COMM=su \
        2>/dev/null | grep -E "$PATTERN")
else
    echo -e "${RED}Error: $LOG_FILE does not exist and journalctl is not available.${NC}"
    exit 1
fi

echo -e "${YELLOW}Scanning $source_desc for failed login attempts...${NC}"

if [ -z "$matches" ]; then
    echo -e "${GREEN}No failed login attempts found.${NC}"
else
    echo -e "${RED}Found failed login attempts:${NC}"
    while IFS= read -r line; do
        echo -e "${RED}${line}${NC}"
    done <<< "$matches"
    count=$(wc -l <<< "$matches")
    echo -e "${YELLOW}Total failed attempts: $count${NC}"
fi
