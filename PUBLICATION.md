# Public source preview — 2026-10-29

Flutter CRPT code-checking UI/provider prototype. Complete source history reviewed; no real scanned
product-code corpus or credentials were identified.

Restored lib/src/data/crpt_api.dart, and added the existing locked http 1.4.0 package as an explicit
direct dependency in pubspec.yaml/pubspec.lock. No user app data or platform caches were copied.
The API adapter uploads a caller-supplied code to the public CRPT service when invoked.

Source/package contract reviewed. Flutter pub get --offline could not resolve the uncached
http_mock_adapter dependency; Flutter tests/build were NOT RUN. No live CRPT request was made.
Current service authorization/response compatibility remains unverified.
