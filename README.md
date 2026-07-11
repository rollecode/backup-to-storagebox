# 🚀 Backup to Storagebox

![Version](https://img.shields.io/badge/version-3.0.0-blue?style=for-the-badge) ![Hetzner](https://img.shields.io/badge/hetzner-%23d50c2d.svg?style=for-the-badge&logo=hetzner&logoColor=white) ![Better Stack](https://img.shields.io/badge/Better%20Stack-%235b63d3.svg?style=for-the-badge&logo=betterstack&logoColor=white) ![Rsync](https://img.shields.io/badge/rsync-%23FF6B35.svg?style=for-the-badge&logo=rsync&logoColor=white) ![Bash](https://img.shields.io/badge/bash-%23121011.svg?style=for-the-badge&color=%23222222&logo=gnu-bash&logoColor=white) 

A simple, fast backup script for Hetzner Storageboxes.

## ⚡ Quick start

```bash
# 1. Copy and configure the environment file
cp .env.example .env
# Edit .env with your Storagebox credentials

# 2. Run backups with simple command-line syntax
./backup-to-storagebox.sh / /backups/myserver/linux
./backup-to-storagebox.sh /home/user /backups/myserver/home
./backup-to-storagebox.sh /var/www /backups/myserver/www
```

### Required environment variables

- `STORAGEBOX_USER` - Your Storagebox username (e.g., u123456)
- `STORAGEBOX_HOST` - Your Storagebox hostname (e.g., u123456.your-storagebox.de)

### Optional environment variables

- `SSH_KEY_PATH` - SSH key path (default: ~/.ssh/id_rsa)
- `SSH_PORT` - SSH port (default: 23)
- `RSYNC_MAX_SIZE` - Max file size (default: 2G)
- `RSYNC_TIMEOUT` - Connection timeout (default: 300)
- `RSYNC_BANDWIDTH_LIMIT` - Bandwidth limit (e.g., 1000 for 1MB/s)
- `RSYNC_DELETE` - Mirror source deletions and purge already-synced excluded files, so the backup does not grow without bound (default: true). Set to 'false' for append-only. WARNING: with delete on, a file removed on the source is removed from the backup on the next run - preview with `DRY_RUN=true` first
- `RSYNC_MAX_DELETE` - Optional cap on deletions per run as a safety valve (default: none)
- `BETTER_STACK_HEARTBEAT` - Better Stack heartbeat URL for monitoring
- `DRY_RUN` - Set to 'true' for dry run (preview changes and deletions without touching the backup)

## 🔧 Features

- ✅ **Simple command-line interface** - No config files needed
- ✅ **Progress display** - See individual file transfers
- ✅ **File size limiting** - Skip large files automatically
- ✅ **Configurable excludes** - Control what to exclude via EXCLUDES environment variable
- ✅ **Incremental backups** - Only transfers changed files
- ✅ **Automatic crontab backup** - Backs up all crontabs when running as root
- ✅ **Better Stack monitoring** - Optional heartbeat notifications
- ✅ **Dry run support** - Test before running
- ✅ **Hetzner Storagebox optimized** - Works perfectly with Storagebox SSH/SFTP

### Test backup (dry run)
```bash
# Edit .env to set DRY_RUN=true
./backup-to-storagebox.sh /var/www /backups/myserver/www
```

## 🔑 SSH key setup

1. Generate SSH key if you don't have one:
```bash
ssh-keygen -t rsa -b 4096
```

2. Install key on Storagebox:
```bash
cat ~/.ssh/id_rsa.pub | ssh -p 23 u123456@u123456.your-storagebox.de install-ssh-key
```

## ⏰ Cronjob

### Daily backup at 2 AM
```bash
# Edit crontab
crontab -e

# Add this line for daily backup at 2:00 AM
0 2 * * * /path/to/backup-to-storagebox.sh / /backups/myserver/linux >> /var/log/backup.log 2>&1
```

## 📊 What you'll see

```
⚡ Backup to Storagebox v2.0.0
📁 Source: /home/user/
🎯 Dest: u123456@u123456.your-storagebox.de:backups/myserver/home
📏 Largest file allowed: 2G

🔌 Testing connection...
✅ Connected
📁 Creating destination...
✅ Destination ready

🚀 Starting backup...
sending incremental file list
./
Documents/
Documents/file1.txt
          1,234 100%    1.23MB/s    0:00:00 (xfr#1, to-chk=123/456)
...

🎉 Backup completed in 45s
```
