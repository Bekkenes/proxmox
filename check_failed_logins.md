# Proxmox Failed Login Checker

This is a simple Bash script that searches through your Proxmox logs (or any authentication log file) for failed login attempts. The script uses color coding to highlight failed attempts and provides a human-readable summary.

## Features

- **Color-coded Output:**  
  - **Red:** Highlights each failed login attempt.
  - **Yellow:** Displays informational messages and summary counts.
  - **Green:** Indicates success messages.
- **Flexible Log File Location:**  
  By default, the script checks `/var/log/auth.log`. Proxmox VE 8 and newer only log to the systemd journal, so when that file is missing the script reads the journal for the last 7 days instead. Override with `LOG_FILE=/path ./check_failed_logins.sh` or `SINCE="1 day ago" ./check_failed_logins.sh`.
- **Human-Readable Format:**  
  The script prints each failed login entry in an easy-to-read format and provides a summary of the total number of failures.
- **Copy-Paste Friendly:**  
  Simply copy the code below directly into your repository and start using it.

## Prerequisites

- A Linux system (e.g., Proxmox)
- Bash shell
- Access to the log file (`/var/log/auth.log` by default; modify if necessary)
- Sudo privileges may be required to read the log file

## Usage

1. **Copy the Code:**  
   Create a new file named `check_failed_logins.sh` and copy the following code into it:
2. **Make the file executable:**
    Run `chmod +x check_failed_logins.sh`. 
3. **Run the Code:**
    Run `sudo ./check_failed_logins.sh`.
