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
printf '#!/bin/bash\nexit "$FAKE_RSYNC_CODE"\n' > "$TMP/bin/rsync"
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

exit $FAIL
