CREATE TABLE IF NOT EXISTS readiness_rules (id TEXT PRIMARY KEY, project_id TEXT, code TEXT NOT NULL, name TEXT NOT NULL, scope TEXT NOT NULL DEFAULT 'project', weight INTEGER NOT NULL DEFAULT 10, blocking INTEGER NOT NULL DEFAULT 1, active INTEGER NOT NULL DEFAULT 1, created_at TEXT NOT NULL, UNIQUE(project_id,code));
CREATE TABLE IF NOT EXISTS readiness_snapshots (id TEXT PRIMARY KEY, project_id TEXT NOT NULL, system_id TEXT, score INTEGER NOT NULL DEFAULT 0, blocker_count INTEGER NOT NULL DEFAULT 0, blockers_json TEXT, metrics_json TEXT, created_at TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS idx_readiness_project ON readiness_snapshots(project_id,created_at);
CREATE TABLE IF NOT EXISTS signoffs (id TEXT PRIMARY KEY, project_id TEXT NOT NULL, entity_type TEXT NOT NULL, entity_id TEXT NOT NULL, signoff_type TEXT NOT NULL, signer_name TEXT NOT NULL, signer_company TEXT, signer_role TEXT, signature_data TEXT, declaration TEXT, signed_at TEXT NOT NULL, created_by TEXT, created_at TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS idx_signoffs_entity ON signoffs(entity_type,entity_id);
CREATE TABLE IF NOT EXISTS document_register (id TEXT PRIMARY KEY, project_id TEXT NOT NULL, document_no TEXT, title TEXT NOT NULL, doc_type TEXT NOT NULL, revision TEXT, status TEXT NOT NULL DEFAULT 'current', object_file_id TEXT, equipment_id TEXT, system_id TEXT, supersedes_id TEXT, uploaded_by TEXT, created_at TEXT NOT NULL, updated_at TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS idx_documents_project ON document_register(project_id,doc_type,status);
CREATE TABLE IF NOT EXISTS action_items (id TEXT PRIMARY KEY, project_id TEXT NOT NULL, system_id TEXT, equipment_id TEXT, title TEXT NOT NULL, description TEXT, priority TEXT NOT NULL DEFAULT 'normal', status TEXT NOT NULL DEFAULT 'open', assigned_to TEXT, due_at TEXT, source TEXT NOT NULL DEFAULT 'manual', source_id TEXT, created_by TEXT, created_at TEXT NOT NULL, updated_at TEXT NOT NULL);
CREATE INDEX IF NOT EXISTS idx_actions_project ON action_items(project_id,status,due_at);
CREATE TABLE IF NOT EXISTS ai_jobs (id TEXT PRIMARY KEY, project_id TEXT NOT NULL, job_type TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'draft', source_text TEXT, source_file_id TEXT, proposal_json TEXT, approved_json TEXT, created_by TEXT, reviewed_by TEXT, created_at TEXT NOT NULL, updated_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS client_share_links (id TEXT PRIMARY KEY, project_id TEXT NOT NULL, token_hash TEXT NOT NULL UNIQUE, label TEXT, expires_at TEXT, revoked_at TEXT, created_by TEXT, created_at TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS sync_operations (id TEXT PRIMARY KEY, user_id TEXT NOT NULL, device_id TEXT, operation_key TEXT NOT NULL UNIQUE, entity_type TEXT NOT NULL, entity_id TEXT, operation TEXT NOT NULL, payload_json TEXT, status TEXT NOT NULL DEFAULT 'applied', created_at TEXT NOT NULL);

INSERT OR IGNORE INTO readiness_rules(id,project_id,code,name,scope,weight,blocking,active,created_at) VALUES
('rr_global_cat_a',NULL,'NO_CAT_A','No open Category A defects','project',20,1,1,datetime('now')),
('rr_global_tests',NULL,'TESTS_COMPLETE','Mandatory QA / commissioning tests complete','project',20,1,1,datetime('now')),
('rr_global_bms',NULL,'BMS_PROVEN','BMS I/O proven with no failed points','project',20,1,1,datetime('now')),
('rr_global_witness',NULL,'WITNESS_CLEAR','Required witness points completed','project',15,1,1,datetime('now')),
('rr_global_turnover',NULL,'TURNOVER_READY','Turnover packages at 100%','project',15,1,1,datetime('now')),
('rr_global_assets',NULL,'ASSETS_COMPLETE','Equipment completion at target','project',10,0,1,datetime('now'));
