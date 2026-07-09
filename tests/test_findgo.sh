#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

run_case() {
  local case_dir query expected_dir output_file error_file status
  case_dir="$1"
  query="$2"
  expected_dir="$3"
  output_file="$case_dir/output.txt"
  error_file="$case_dir/error.txt"

  cd "$case_dir"
  set +e
  source "$repo_root/findgo" "$query" >"$output_file" 2>"$error_file"
  status=$?
  set -e

  if [[ "$status" -ne 0 ]]; then
    echo "expected success for query '$query' but got exit code $status" >&2
    cat "$output_file" >&2
    cat "$error_file" >&2
    exit 1
  fi

  if [[ "$(pwd)" != "$expected_dir" ]]; then
    echo "expected to change to $expected_dir, got $(pwd)" >&2
    cat "$output_file" >&2
    exit 1
  fi

  if ! grep -q 'Changed directory to:' "$output_file"; then
    echo 'expected success message in output' >&2
    cat "$output_file" >&2
    exit 1
  fi
}

# Baseline substring match regression.
mkdir -p "$tmpdir/case_regression/opencode/agents"
touch "$tmpdir/case_regression/opencode/agents/linux-admin.md"
run_case "$tmpdir/case_regression" admin "$tmpdir/case_regression/opencode/agents"

# Breadth-first behavior: shallower match must win over deeper match.
mkdir -p "$tmpdir/case_bfs/deep/path/target"
mkdir -p "$tmpdir/case_bfs/target"
run_case "$tmpdir/case_bfs" target "$tmpdir/case_bfs/target"

# Newest-first within a level: newer sibling directory should win.
mkdir -p "$tmpdir/case_newest/admin-old"
mkdir -p "$tmpdir/case_newest/admin-new"
touch -m -d '2021-01-01 00:00:00' "$tmpdir/case_newest/admin-old"
touch -m -d '2025-01-01 00:00:00' "$tmpdir/case_newest/admin-new"
run_case "$tmpdir/case_newest" admin "$tmpdir/case_newest/admin-new"
