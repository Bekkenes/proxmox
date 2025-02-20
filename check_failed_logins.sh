#!/bin/bash
# Proxmox Failed Login Attempts Checker
# This script searches through /var/log/auth.log for any failed login attempts.
# It prints out each failed attempt in red and summarizes the total count.

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'  # No Color

LOG_FILE="/var/log/auth.log"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo -e "${RED}Error: Log file $LOG_FILE does not exist.${NC}"
    exit 1
fi

echo -e "${YELLOW}Scanning $LOG_FILE for failed login attempts...${NC}"

# Search for failed login attempts (e.g., "Failed password" or "authentication failure")
matches=$(grep -iE "failed|authentication failure" "$LOG_FILE")

if [ -z "$matches" ]; then
    echo -e "${GREEN}No failed login attempts found.${NC}"
else
    echo -e "${RED}Found failed login attempts:${NC}"
    # Print each matching line in red
    echo "$matches" | while read -r line; do
        echo -e "${RED}$line${NC}"
    done
    # Count and display the total number of failed attempts
    count=$(echo "$matches" | wc -l)
    echo -e "${YELLOW}Total failed attempts: $count${NC}"
fi
