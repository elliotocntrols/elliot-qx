# Elliot Qx V4 - Flat GitHub Deploy

This package is deliberately flat. Upload every file in this folder directly to the root of the GitHub repository. No `src`, `public`, or `migrations` folders are required.

## Expected GitHub root

- index.js
- index.html
- app.js
- styles.css
- sw.js
- manifest.webmanifest
- qx.svg
- package.json
- wrangler.jsonc
- 0001_initial.sql
- 0002_worldclass.sql
- 0003_elite.sql
- 0004_market_leader.sql

The Worker entry point is `index.js`. The UI assets are embedded into that Worker at build time in this package, so Cloudflare does not require an `assets.directory` folder.

## Existing Cloudflare resources

Qx expects:

- D1 binding: `DB`, database name `elliot-qx-db`
- R2 binding: `FILES`, bucket name `elliot-qx-files`

After deployment succeeds, apply the four SQL files to the D1 database in order, then configure the `BOOTSTRAP_TOKEN` secret and create the first admin user.
