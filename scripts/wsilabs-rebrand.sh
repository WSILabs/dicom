#!/usr/bin/env bash
# Rebrands this fork's module path from github.com/suyashkumar/dicom to
# github.com/WSILabs/dicom so it can be consumed via a remote `go.mod replace`
# (Go validates that the replacement's declared module path matches the
# directive's right-hand side). Idempotent — safe to re-run after every upstream
# merge so newly-added upstream files adopt the fork's module path.
#
# Only the module/import path string is rewritten; the WSILabs fork additions in
# pkg/uid/uid_definitions.go (HTJ2K / JPEG XL transfer-syntax UIDs) are content,
# not affected by this rename.
set -euo pipefail
cd "$(dirname "$0")/.."

# Rewrite import paths in Go sources.
files=$(grep -rl 'github.com/suyashkumar/dicom' --include='*.go' . || true)
if [ -n "$files" ]; then
  printf '%s\n' "$files" | while IFS= read -r f; do
    sed -i.bak 's#github.com/suyashkumar/dicom#github.com/WSILabs/dicom#g' "$f"
    rm -f "$f.bak"
  done
fi

# Rewrite the module declaration.
sed -i.bak 's#^module github.com/suyashkumar/dicom#module github.com/WSILabs/dicom#' go.mod
rm -f go.mod.bak

echo "rebrand: module path now github.com/WSILabs/dicom"
