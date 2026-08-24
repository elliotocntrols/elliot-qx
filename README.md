# Elliot Qx V8.4 - Definitive Light Workspace

This package fixes the deployment architecture issue that caused the app to stay dark: the Cloudflare Worker was serving embedded V6/V8.1 static CSS/JS instead of the uploaded standalone files. V8.4 re-embeds the current app, CSS, service worker, manifest and HTML directly inside index.js.

- Navy left navigation retained
- Main workspace forced white/light grey
- White cards, tables, forms and modals
- Orange Elliot action accent
- Template Library modal closes via X, Escape or backdrop click
- Existing DB/R2/auth preserved

Deploy by replacing the repository root files. Do not change Cloudflare bindings or D1/R2.
