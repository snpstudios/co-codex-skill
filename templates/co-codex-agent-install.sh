#!/usr/bin/env bash
set -euo pipefail

REPO="${CO_CODEX_AGENT_REPO:-snpstudios/co-codex-skill}"
VERSION="${CO_CODEX_AGENT_VERSION:-latest}"
INSTALL_DIR="${CO_CODEX_AGENT_INSTALL_DIR:-$HOME/.codex/bin}"
TARGET_BINARY="$INSTALL_DIR/co-codex-agent"
TOKEN="${GITHUB_TOKEN:-${GH_TOKEN:-}}"

platform="$(uname -s | tr '[:upper:]' '[:lower:]')"
arch="$(uname -m)"

case "$platform" in
  darwin) platform="darwin" ;;
  linux) platform="linux" ;;
  *)
    echo "Unsupported platform: $platform" >&2
    exit 1
    ;;
esac

case "$arch" in
  arm64|aarch64) arch="arm64" ;;
  x86_64) arch="x64" ;;
  *)
    echo "Unsupported architecture: $arch" >&2
    exit 1
    ;;
esac

asset="co-codex-agent-${platform}-${arch}.tar.gz"
tmp_dir="$(mktemp -d)"
archive="$tmp_dir/$asset"

mkdir -p "$INSTALL_DIR"

if [ -x "$TARGET_BINARY" ]; then
  echo "$TARGET_BINARY"
  exit 0
fi

if [ -n "$TOKEN" ]; then
  if [ "$VERSION" = "latest" ]; then
    api_url="https://api.github.com/repos/${REPO}/releases/latest"
  else
    api_url="https://api.github.com/repos/${REPO}/releases/tags/${VERSION}"
  fi

  asset_api_url="$(python3 - "$api_url" "$asset" "$TOKEN" <<'PY'
import json, sys, urllib.request
api_url, asset_name, token = sys.argv[1:4]
req = urllib.request.Request(api_url)
req.add_header("Authorization", f"Bearer {token}")
req.add_header("Accept", "application/vnd.github+json")
req.add_header("X-GitHub-Api-Version", "2022-11-28")
with urllib.request.urlopen(req) as r:
    data = json.load(r)
for asset in data.get("assets", []):
    if asset.get("name") == asset_name:
        print(asset["url"])
        break
else:
    raise SystemExit(f"Missing asset: {asset_name}")
PY
)"

  echo "Downloading ${asset} via GitHub API" >&2
  curl -fL \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Accept: application/octet-stream" \
    "$asset_api_url" \
    -o "$archive"
else
  if [ "$VERSION" = "latest" ]; then
    url="https://github.com/${REPO}/releases/latest/download/${asset}"
  else
    url="https://github.com/${REPO}/releases/download/${VERSION}/${asset}"
  fi

  echo "Downloading ${url}" >&2
  curl -fL "$url" -o "$archive"
fi

tar -xzf "$archive" -C "$tmp_dir"

mv "$tmp_dir/co-codex-agent" "$TARGET_BINARY"
chmod +x "$TARGET_BINARY"
rm -rf "$tmp_dir"

echo "$TARGET_BINARY"
