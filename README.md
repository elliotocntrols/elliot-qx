# Elliot Qx V8.5 - Schedule Import & Auto-Commissioning Builder

Built on the working V8.4 light workspace/authentication baseline.

## New in V8.5

- New **Schedule Importer** in the Project navigation.
- Import **PDF, XLSX, XLS or CSV**.
- Auto-detect or manually select **BMS points list** vs **MSSB / switchboard schedule**.
- Preview normalized rows before anything is written to Qx.
- BMS points import:
  - creates detailed BMS I/O point records,
  - groups points by controller,
  - creates a controller commissioning sheet for each controller,
  - creates point-specific checks for field device, controller, graphics and alarm/sequence verification.
- MSSB schedule import:
  - creates/links an MSSB asset passport for each board,
  - groups circuits by board,
  - creates board QA / commissioning sheets,
  - generates individual circuit verification checks plus incoming supply, earthing, protection, controls/BMS, electrical tests, functional test and closeout hold points.
- The imported source file is stored in the existing private R2 evidence store after successful generation.
- Existing D1, R2, authentication and Cloudflare bindings are unchanged.

## Deploy

Upload the files in this package to the root of the existing GitHub repository and replace the current files. Wait for the Cloudflare deployment green tick and hard refresh once.

No database migration is required.

## Notes

Excel and PDF parsing libraries are loaded on demand in the browser when Schedule Importer is used. CSV import is fully local. PDF extraction works best with text-based schedule PDFs; scanned image-only PDFs are not OCR'd in this release.
