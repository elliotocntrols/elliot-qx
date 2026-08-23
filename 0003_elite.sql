PRAGMA foreign_keys = ON;

ALTER TABLE projects ADD COLUMN health_status TEXT DEFAULT 'green';
ALTER TABLE projects ADD COLUMN commissioning_phase TEXT DEFAULT 'construction';
ALTER TABLE projects ADD COLUMN percent_complete INTEGER DEFAULT 0;
ALTER TABLE equipment ADD COLUMN criticality TEXT DEFAULT 'normal';
ALTER TABLE equipment ADD COLUMN install_verified_at TEXT;
ALTER TABLE equipment ADD COLUMN commissioned_at TEXT;
ALTER TABLE equipment ADD COLUMN latitude REAL;
ALTER TABLE equipment ADD COLUMN longitude REAL;
ALTER TABLE inspections ADD COLUMN signed_status TEXT DEFAULT 'unsigned';
ALTER TABLE inspections ADD COLUMN witness_status TEXT DEFAULT 'not_required';

CREATE TABLE IF NOT EXISTS signatures (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  signer_name TEXT NOT NULL,
  signer_role TEXT,
  signer_company TEXT,
  declaration TEXT,
  file_id TEXT,
  signed_by_user_id TEXT,
  signed_at TEXT NOT NULL,
  created_at TEXT NOT NULL,
  FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY(file_id) REFERENCES files(id) ON DELETE SET NULL,
  FOREIGN KEY(signed_by_user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS readiness_snapshots (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  system_id TEXT,
  readiness_percent INTEGER NOT NULL,
  blocker_count INTEGER NOT NULL DEFAULT 0,
  blockers_json TEXT NOT NULL,
  created_at TEXT NOT NULL,
  FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY(system_id) REFERENCES systems(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS project_documents (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  document_type TEXT NOT NULL,
  title TEXT NOT NULL,
  revision TEXT,
  status TEXT NOT NULL DEFAULT 'current',
  file_id TEXT,
  source TEXT DEFAULT 'upload',
  notes TEXT,
  created_by TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY(file_id) REFERENCES files(id) ON DELETE SET NULL,
  FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS notifications (
  id TEXT PRIMARY KEY,
  user_id TEXT,
  project_id TEXT,
  kind TEXT NOT NULL,
  title TEXT NOT NULL,
  body TEXT,
  entity_type TEXT,
  entity_id TEXT,
  read_at TEXT,
  created_at TEXT NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS import_jobs (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  import_type TEXT NOT NULL,
  file_name TEXT,
  row_count INTEGER NOT NULL DEFAULT 0,
  success_count INTEGER NOT NULL DEFAULT 0,
  error_count INTEGER NOT NULL DEFAULT 0,
  errors_json TEXT,
  created_by TEXT NOT NULL,
  created_at TEXT NOT NULL,
  FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY(created_by) REFERENCES users(id)
);

CREATE INDEX IF NOT EXISTS idx_signatures_entity ON signatures(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_documents_project ON project_documents(project_id, document_type);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id, read_at, created_at);
CREATE INDEX IF NOT EXISTS idx_readiness_project ON readiness_snapshots(project_id, created_at);
