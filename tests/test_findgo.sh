#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mkdir -p "$tmpdir/opencode/agents"
touch "$tmpdir/opencode/agents/linux-admin.md"

cd "$tmpdir"
set +e
source "$repo_root/findgo" admin >"$tmpdir/output.txt" 2>"$tmpdir/error.txt"
status=$?
set -e

if [[ "$status" -ne 0 ]]; then
  echo "expected success but got exit code $status" >&2
  cat "$tmpdir/output.txt" >&2
  cat "$tmpdir/error.txt" >&2
  exit 1
fi

if [[ "$(pwd)" != "$tmpdir/opencode/agents" ]]; then
  echo "expected to change to $tmpdir/opencode/agents, got $(pwd)" >&2
  exit 1
fi

if ! grep -q 'Changed directory to:' "$tmpdir/output.txt"; then
  echo 'expected success message in output' >&2
  cat "$tmpdir/output.txt" >&2
  exit 1
fi
