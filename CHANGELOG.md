# Changelog

## 2026-11-23

### Fixed
- `check_failed_logins.sh` failed on Proxmox VE 8+ (Debian 12), which has no `/var/log/auth.log` by default. It now reads the systemd journal (last 7 days, `SINCE` to change) when the file is missing.
- The pattern `failed` also counted every systemd "Failed to start ..." line. It now matches only real login failures from sshd, PAM and the Proxmox web UI.
