# Elliot Qx V4.3 - Validated Auth Build

This build fixes first-run bootstrap/login failures on Cloudflare Workers Free by replacing CPU-heavy PBKDF2 with a fast salted, server-peppered HMAC-SHA-256 credential verifier. The pepper is derived from the existing BOOTSTRAP_TOKEN secret, so no extra Cloudflare secret is required.

Existing D1 schema, DB binding `DB`, R2 binding `FILES`, and BOOTSTRAP_TOKEN remain unchanged. Upload the files in this package to the existing GitHub repository root.

Validation performed before release: JavaScript syntax check, database schema migration check, crypto round-trip check, bootstrap INSERT/audit SQL check, login/session SQL check.
