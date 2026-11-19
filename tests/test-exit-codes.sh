#!/bin/bash
# Checks which heartbeat URL each rsync exit code sends. Run: bash tests/test-exit-codes.sh
cd "$(dirname "$0")/.." || exit 1
FAIL=0
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"; mv -f "$TMP.env" .env 2>/dev/null' EXIT

[ -f .env ] && cp .env "$TMP.env"
printf 'STORAGEBOX_USER=u\nSTORAGEBOX_HOST=h\nSSH_KEY_PATH=%s/key\nBETTER_STACK_HEARTBEAT=https://hb.example/x\nRSYNC_DELETE=false\n' "$TMP" > .env
touch "$TMP/key"
mkdir "$TMP/bin" "$TMP/src"
for c in sftp crontab; do printf '#!/bin/bash\nexit 0\n' > "$TMP/bin/$c"; done
printf '#!/bin/bash\necho "$*" >> "${RSYNC_LOG:-/dev/null}"\nexit "${FAKE_RSYNC_CODE:-0}"\n' > "$TMP/bin/rsync"
printf '#!/bin/bash\necho "${@: -1}" >> "$CURL_LOG"\n' > "$TMP/bin/curl"
chmod +x "$TMP/bin"/*

check() {
  local CODE="$1" WANT="$2"
  : > "$TMP/curl.log"
  FAKE_RSYNC_CODE=$CODE CURL_LOG="$TMP/curl.log" PATH="$TMP/bin:$PATH" bash backup-to-storagebox.sh "$TMP/src" /backups/t >/dev/null 2>&1
  local GOT
  GOT=$(cat "$TMP/curl.log")
  if [ "$GOT" == "$WANT" ]; then echo "ok   rsync $CODE -> $WANT"; else echo "FAIL rsync $CODE: sent [$GOT], want [$WANT]"; FAIL=1; fi
}

check 0 "https://hb.example/x"
check 23 "https://hb.example/x"
check 24 "https://hb.example/x"
check 12 "https://hb.example/x/12"

# Uptime Kuma push URL
sed -i 's|^BETTER_STACK_HEARTBEAT=.*|BETTER_STACK_HEARTBEAT=https://kuma.example/api/push/t?status=up|' .env
check 0 "https://kuma.example/api/push/t?status=up"
check 12 "https://kuma.example/api/push/t?status=down&msg=exit+code+12"

# A backup of / already holds /var/spool/cron, and its read-only root refuses a crontabs/ dir
: > "$TMP/rsync.log"
RSYNC_LOG="$TMP/rsync.log" PATH="$TMP/bin:$PATH" bash backup-to-storagebox.sh / /backups/t >/dev/null 2>&1
if grep -q "crontabs/" "$TMP/rsync.log"; then echo "FAIL source / still uploads crontabs separately"; FAIL=1; else echo "ok   source / skips the separate crontab upload"; fi

exit $FAIL
