# WSILabs fork of suyashkumar/dicom

This is a **minimal, tracking fork** of [`suyashkumar/dicom`](https://github.com/suyashkumar/dicom),
maintained for [`wsilabs/wsitools`](https://github.com/wsilabs/wsitools)'s DICOM-WSM writer.

## Why this fork exists

`suyashkumar/dicom` is the only Go library that writes DICOM, but its v1.1.0 UID
dictionary predates several now-standard JPEG-family transfer syntaxes, and it has
no API to register UIDs at runtime. `dicom.Write` therefore refuses to emit a
transfer syntax it doesn't know (`UID '…' not found in dictionary`), even though
the body encoding is identical Explicit VR LE for every encapsulated syntax.
Upstream is effectively frozen for merges (the equivalent fix, upstream PR #377,
sat unmerged), so wsitools consumes this fork via `go.mod replace`.

## What's changed vs upstream

1. **Transfer-syntax UID dictionary additions** (`pkg/uid/uid_definitions.go`,
   marked `WSILabs fork additions`):
   - High-Throughput JPEG 2000 — `…4.201`–`…4.205` (Sup 232; mirrors upstream PR #377).
   - JPEG XL — `…4.110`/`.111`/`.112` (Sup 235).
2. **Module path rebranded** to `github.com/WSILabs/dicom` (`scripts/wsilabs-rebrand.sh`)
   so the fork is consumable via a remote `go.mod replace`.

No other behavior is changed.

## Consuming it (wsitools)

```
// go.mod
replace github.com/suyashkumar/dicom => github.com/WSILabs/dicom v1.1.0-wsilabs.1
```

wsitools keeps importing `github.com/suyashkumar/dicom/...`; the replace remaps it.

## Staying current

`.github/workflows/wsilabs-sync-upstream.yml` runs weekly: if upstream advanced it
merges `upstream/main`, re-applies the rebrand, builds + tests, and opens a PR. It
also emits a notice if upstream has finally shipped the HTJ2K UIDs — at which point
this fork can be retired and the `replace` dropped.
