#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
CONFIG_PATH="${CO_CODEX_CONFIG:-$CODEX_HOME/co-codex.config.json}"
INSTALLER="$CODEX_HOME/bin/co-codex-agent-install"
AGENT="$CODEX_HOME/bin/co-codex-agent"
WAIT_SECONDS="${CO_CODEX_WAIT_SECONDS:-25}"
POLL_INTERVAL="${CO_CODEX_POLL_INTERVAL:-1}"

if [ ! -f "$CONFIG_PATH" ]; then
  echo "Missing config: $CONFIG_PATH" >&2
  exit 1
fi

read_config() {
  python3 - "$CONFIG_PATH" "$1" <<'PY'
import json, pathlib, sys
config_path = pathlib.Path(sys.argv[1])
key = sys.argv[2]
data = json.loads(config_path.read_text(encoding="utf-8"))
value = data.get(key, "")
if isinstance(value, bool):
    print("true" if value else "false")
elif value is None:
    print("")
else:
    print(value)
PY
}

RELAY_AGENT_KEY="${RELAY_AGENT_KEY:-$(read_config relayAgentKey)}"
RELAY_URL="${RELAY_URL:-$(read_config relayUrl)}"
DEFAULT_PRO_PATH="${DEFAULT_PRO_PATH:-$(read_config default_pro_path)}"
PORT="${PORT:-$(read_config port)}"
BRIDGE_TOKEN="${BRIDGE_TOKEN:-$(read_config bridgeToken)}"
ALLOW_REMOTE_INJECT="${ALLOW_REMOTE_INJECT:-$(read_config allowRemoteInject)}"
RELAY_DEVICE_NAME="${RELAY_DEVICE_NAME:-$(read_config deviceName)}"

PORT="${PORT:-4317}"
RELAY_URL="${RELAY_URL:-https://worker.aipage.asia}"

if [ -z "$RELAY_AGENT_KEY" ]; then
  echo "Missing relayAgentKey in $CONFIG_PATH" >&2
  exit 1
fi

if [ ! -x "$INSTALLER" ]; then
  echo "Missing installer: $INSTALLER" >&2
  exit 1
fi

if [ ! -x "$AGENT" ]; then
  "$INSTALLER" >/dev/null
fi

read_mobile_url() {
  python3 - "$1" <<'PY'
import json, sys
payload = json.loads(sys.argv[1])
print((((payload or {}).get("relay") or {}).get("mobileUrl")) or "")
PY
}

read_meta() {
  if [ -n "$BRIDGE_TOKEN" ]; then
    curl -sf --max-time 2 -H "Authorization: Bearer $BRIDGE_TOKEN" "http://127.0.0.1:${PORT}/api/meta"
    return
  fi

  curl -sf --max-time 2 "http://127.0.0.1:${PORT}/api/meta"
}

if meta="$(read_meta 2>/dev/null || true)" && [ -n "$meta" ]; then
  mobile_url="$(read_mobile_url "$meta")"
  if [ -n "$mobile_url" ]; then
    echo "$mobile_url"
    exit 0
  fi
fi

stale_pid="$(lsof -tiTCP:${PORT} -sTCP:LISTEN || true)"
if [ -n "$stale_pid" ]; then
  kill "$stale_pid" || true
  sleep 1
fi

(
  export HOME CODEX_HOME CONFIG_PATH PORT BRIDGE_TOKEN RELAY_URL RELAY_AGENT_KEY RELAY_DEVICE_NAME ALLOW_REMOTE_INJECT DEFAULT_PRO_PATH
  cd "$CODEX_HOME/bin"
  nohup "$AGENT" serve </dev/null >/dev/null 2>&1 &
) >/dev/null 2>&1

deadline=$((SECONDS + WAIT_SECONDS))
while [ "$SECONDS" -lt "$deadline" ]; do
  if meta="$(read_meta 2>/dev/null || true)" && [ -n "$meta" ]; then
    mobile_url="$(read_mobile_url "$meta")"
    if [ -n "$mobile_url" ]; then
      echo "$mobile_url"
      exit 0
    fi
  fi
  sleep "$POLL_INTERVAL"
done

echo "Timed out waiting for the co-codex mobile URL." >&2
exit 1
