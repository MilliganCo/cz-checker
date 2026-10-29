# Source preview verification — 2026-10-29

Complete source history and available GitHub surfaces reviewed; no identified credential or
real scanned-code corpus disclosure blocker. The expired original Actions log is unavailable,
not counted as a passed log scan. All own change-run logs were checked with no secret findings.

## Fixed

- Restored the missing CRPT adapter and explicit http dependency/locked direct-package metadata.
- Aligned CI with Flutter 3.32.8 / Dart 3.8-compatible lock constraints, read-only permissions and
  checkout credentials disabled after checkout.
- Corrected scanner test imports and replaced an obsolete counter-template test with real app smoke.
- Guarded controller/context use after awaited scans when the page has been disposed.
- Tested pending/completed state and corrected raw-status/theme-cycle assertions to their contracts.

## Passed

GitHub run 40912103674 at code commit 32173b8880af4e2e245a3520741c364a1c693165:
strict static analyzer **No issues found**, **11 tests passed**. The HTTP client is mocked; tests
cover status colors, pending state, theme behavior, scanner shell and scan completion after unmount.
This file is a documentation-only update to that tested implementation.

No live CRPT request, real barcode/camera use, user database or mobile installation was performed.
Real service availability/authorization and camera/platform behavior remain unverified.
The adapter sends caller-provided product codes to the configured public CRPT service when used.
