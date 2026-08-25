# Elliot Qx V8.6 - Schedule Import & Auto-Commissioning Builder

Built on the working V8.4 light workspace/authentication baseline.

## New in V8.6

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

## V8.6 Demo & Team Rollout

- New **Demo Centre** in the Command navigation.
- One-click `QX-DEMO` project seed (idempotent; it will not create duplicates).
- Demo project includes two systems, AHU + MSSB assets, sample BMS I/O states, a Category A defect, witness request, turnover package and an in-progress QA/commissioning sheet.
- Built-in downloads for sample BMS points and MSSB schedule CSVs.
- In-app 30-minute runbook and 4-week team implementation plan.
- Additional package files: `DEMO_RUNBOOK.md`, `TEAM_IMPLEMENTATION_GUIDE.md`, `QX_DEMO_BMS_POINTS.csv`, `QX_DEMO_MSSB_SCHEDULE.csv`.

No D1 migration or Cloudflare binding change is required.
