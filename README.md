# Elliot Qx 4 — Market Leader Build

Elliot Qx 4 is the production-oriented QA, commissioning, systems-completion and handover platform built with **Elliot Controls as client #1**. The product benchmark is BlueRithm/CxAlloy-class field execution, but Qx differentiates through electrical/BMS depth, live completion intelligence and lower site administration.

## What is new in V4

- **Qx Intelligence readiness engine**: weighted live score and explicit blockers across QA/tests, Category A punch, BMS I/O, witness, turnover and asset completion.
- **Readiness snapshots**: creates a history for project trend reporting and management review.
- **Action engine**: assignable project/system/equipment actions with priority, due dates and source traceability.
- **Digital sign-off register**: project/entity-linked witness/acceptance records with signer/company/role/declaration fields.
- **Document/revision data model**: foundation for controlled drawings, test records, O&M and superseded revisions.
- **AI Project Builder foundation**: source text can generate a reviewable proposed equipment structure. It is deliberately human-in-the-loop; approved drawings/specifications remain authoritative.
- **Idempotent sync ledger**: device operation keys prevent duplicate replay as offline sync becomes more sophisticated.
- **Client-share data model**: secure expiring share-link foundation for client dashboards/handover views.
- Existing V3 features remain: systems, equipment, templates, QA/PFC/FPT, automatic punch from failures, BMS I/O import/testing, witness, turnover, R2 evidence, audit trail and PWA/offline queue.

## Architecture

Installable PWA -> Cloudflare Worker -> D1 + R2. Static assets and API deploy together. Secrets remain in Cloudflare, not source control.

## Deploy

1. `npm install`
2. `npx wrangler login`
3. `npx wrangler d1 create elliot-qx-db` and place the returned ID in `wrangler.jsonc`.
4. `npx wrangler r2 bucket create elliot-qx-files`
5. `npx wrangler secret put BOOTSTRAP_TOKEN`
6. `npm run db:remote`
7. `npm run types`
8. `npm run check`
9. `npm run deploy`

## Production priorities after pilot

Before broad commercial sale: Microsoft Entra SSO/MFA, true conflict-aware offline data replication, camera QR/barcode scanning, photo/PDF markup, PDF certificate/dossier generation, controlled document approvals, notifications/escalations, Simpro integration, Autodesk/Procore connectors, API/MCP surface, tenant isolation/billing, penetration testing, backup/restore drills and load testing at 100k+ forms/points.

## Safety / commissioning authority

Qx manages workflow and evidence. Approved project drawings, specifications, sequences, statutory requirements, manufacturer instructions, authorised test procedures and competent engineering judgement remain the authority for energisation, operation and acceptance.
