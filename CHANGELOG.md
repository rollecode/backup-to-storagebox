### 2.9.0: 2026-07-11

* Add `RSYNC_DELETE` mode (`--delete --delete-excluded`) to mirror source deletions and purge already-synced excluded files, preventing unbounded backup growth
* Add `RSYNC_MAX_DELETE` safety cap for deletions per run
* Implement `DRY_RUN` (was documented but had no effect) so changes and deletions can be previewed before enabling delete mode
* Harden default excludes with lost+found, swapfile, swap.img and editor swap files

### 2.8.1: 2025-09-16

* Fix color variables being referenced before definition

### 2.8.0: 2025-09-02

* Simplify excludes to single EXCLUDES comma-separated environment variable

### 2.7.7: 2025-06-21

* Fixes to Better Stack heartbeat logic

### 2.7.6: 2025-06-14

* Fix critical issue where .excludes are not being properly considered

### 2.7.5: 2025-06-14

* Add lock file handling to prevent multiple instances
* Finally fix crontab backup issues
* Add verbose logging to terminal

### 2.7.4: 2025-06-14

* Revise crontab backup and move it to the end of the script

### 2.7.3: 2025-06-14

* Fix regression with script exiting too early after root crontab backup

### 2.7.2: 2025-06-14

* Backup current user's crontab if not root
* Fix: Backup all user crontabs if root

### 2.7.1: 2025-06-14

* Improve formatting of the backup summary

### 2.7.0: 2025-06-14

* Fix ongoing issues with the heartbeat
* Make sure the backup summary is always shown
* Better version control
* Add badges to README.md

### 2.6.1: 2025-06-14

* Make Better Stack heartbeat more bulletproof

### 2.6.0: 2025-06-14

* Fix user crontab backup hanging issue with timeout protection
* Add background process execution for user crontab backup to prevent script blocking
* Add debug output showing which user is being processed during crontab backup
* Ensure script always continues to main backup even if crontab backup fails
* Fix crontab backup to save individual .txt files for each user
* Add guaranteed script continuation with force-kill protection for hanging processes

### 2.5.0: 2025-06-14

* Add Better Stack heartbeat monitoring support via BETTER_STACK_HEARTBEAT environment variable
* Restore automatic crontab backup functionality when running as root

### 2.4.0: 2025-06-14

* Fix SSH key authentication using Hetzner's official install-ssh-key service
* Replace manual SSH key installation with proper Hetzner-compatible method
* Add interactive prompt for SSH key installation instead of automatic attempts
* Improve SSH key authentication testing and error handling
* Ensure proper RFC4716 and OpenSSH key format handling for port 23
* Follow official Hetzner Storage Box documentation for SSH key management
* Enhance user experience with better feedback during authentication setup

### 2.3.0: 2025-06-13

* Simplify backup completion logic - never show "failure" if connection is working
* All backups are considered successful since SSH connection is pre-tested
* Remove complex exit code handling - just show success with optional note about skipped files
* Improve user experience by eliminating false failure messages

### 2.2.0: 2025-06-13

* Fix rsync exit code handling - now properly recognizes partial success
* Exit code 23 (some files/attrs not transferred) is now treated as successful with warning
* Exit code 24 (some files vanished during transfer) is now treated as successful with warning
* Backup completion messages now show actual duration in all cases
* Improve backup success reporting to avoid false failure messages

### 2.1.0: 2025-06-13

* Add .env file configuration for credentials and settings
* Remove hardcoded defaults from script - all configuration now in .env
* Add RSYNC_BANDWIDTH_LIMIT option for bandwidth limiting
* Add RSYNC_TIMEOUT option for connection timeout configuration
* Improve configuration management organization
* Fix proper separation of configuration from code

### 2.0.0: 2025-06-13

* Major rewrite: simplify to use command-line arguments instead of config files
* Breaking change: now uses `./script.sh <source> <dest>` syntax
* Add environment variables for configuration (STORAGEBOX_USER, STORAGEBOX_HOST, etc.)
* Remove complex configuration files (.env, .directories, .excludes)
* Enhance interface to be much cleaner and easier to use
* Fix relative path handling for Hetzner Storageboxes
* Example: `./backup-to-storagebox.sh / /backups/myserver/linux`

### 1.3.0: 2025-06-13

* Add RSYNC_MAX_SIZE option to limit file size (e.g., 2G to skip files over 2GB)
* Add progress display with --progress and --stats for real-time transfer monitoring
* Add SHOW_PROGRESS option to control progress display (default: true)
* Make individual file transfer progress visible during backup
* Add configuration summary display showing all active options
* Restore proper backup directory structure (/backups/myserver/linux)
* Remove problematic --mkpath option for better compatibility
* Fix SFTP connection syntax errors

### 1.2.1: 2025-06-13

* Critical fix: fix remote directory structure creation for nested paths
* Critical fix: resolve "No such file or directory" errors during backup
* Enhance remote directory creation to build complete path hierarchy
* Improve SSH key path detection for sudo/root usage scenarios
* Add better rsync exit code handling (partial success for permission issues)
* Add user context warnings for system directory access
* Fix destination path construction to match created directory structure
* Restore configuration example files (env.example, directories.example, excludes.example)

### 1.1.0: 2025-06-13

* Add colorful output with emojis for better user experience
* Add automatic SSH key installation using Hetzner's install-ssh-key service
* Improve SFTP connection testing (proper support for Storageboxes)
* Remove retry functionality to simplify the script
* Enhance error messages with color coding and better formatting
* Add visual progress indicators and section separators

### 1.0.0: 2025-06-13

* Initial release of improved backup script
* Add configuration via .env file for credentials
* Add .directories file for custom backup locations
* Add .excludes file for custom exclusion patterns
* Implement direct Hetzner Storagebox connectivity via SSH/SFTP
* Remove complex logging functionality for simplicity
* Make script idempotent and dependency-free
* Change to update-only mode (newer files only)
* Add automatic crontab backup functionality
* Improve documentation with README and examples 
