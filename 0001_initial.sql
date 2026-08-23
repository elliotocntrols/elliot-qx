PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  role TEXT NOT NULL CHECK(role IN ('admin','pm','engineer','site_manager','technician','electrician','client')),
  password_salt TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS sessions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  token_hash TEXT NOT NULL UNIQUE,
  expires_at TEXT NOT NULL,
  created_at TEXT NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS projects (
  id TEXT PRIMARY KEY,
  code TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  client TEXT,
  site_address TEXT,
  status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('planning','active','witnessing','handover','complete','archived')),
  completion_target TEXT,
  created_by TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(created_by) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS equipment (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  tag TEXT NOT NULL,
  name TEXT NOT NULL,
  system TEXT,
  building TEXT,
  level TEXT,
  area TEXT,
  equipment_type TEXT,
  status TEXT NOT NULL DEFAULT 'not_started' CHECK(status IN ('not_started','qa','commissioning','witness','blocked','complete')),
  qr_code TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  UNIQUE(project_id, tag),
  FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS templates (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  discipline TEXT NOT NULL,
  stage TEXT NOT NULL,
  description TEXT,
  version INTEGER NOT NULL DEFAULT 1,
  active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS template_items (
  id TEXT PRIMARY KEY,
  template_id TEXT NOT NULL,
  sort_order INTEGER NOT NULL,
  section TEXT NOT NULL,
  item_text TEXT NOT NULL,
  response_type TEXT NOT NULL DEFAULT 'pass_fail_na',
  mandatory INTEGER NOT NULL DEFAULT 1,
  hold_point INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY(template_id) REFERENCES templates(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS inspections (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  equipment_id TEXT,
  template_id TEXT NOT NULL,
  title TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'draft' CHECK(status IN ('draft','in_progress','submitted','witness_required','approved','rejected')),
  assigned_to TEXT,
  witness_name TEXT,
  signed_by TEXT,
  signed_at TEXT,
  created_by TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY(equipment_id) REFERENCES equipment(id) ON DELETE SET NULL,
  FOREIGN KEY(template_id) REFERENCES templates(id),
  FOREIGN KEY(assigned_to) REFERENCES users(id),
  FOREIGN KEY(created_by) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS inspection_results (
  id TEXT PRIMARY KEY,
  inspection_id TEXT NOT NULL,
  template_item_id TEXT NOT NULL,
  result TEXT CHECK(result IN ('pass','fail','na')),
  value_text TEXT,
  comment TEXT,
  completed_by TEXT,
  completed_at TEXT,
  FOREIGN KEY(inspection_id) REFERENCES inspections(id) ON DELETE CASCADE,
  FOREIGN KEY(template_item_id) REFERENCES template_items(id),
  FOREIGN KEY(completed_by) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS defects (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  equipment_id TEXT,
  inspection_id TEXT,
  title TEXT NOT NULL,
  description TEXT,
  discipline TEXT NOT NULL DEFAULT 'general',
  severity TEXT NOT NULL DEFAULT 'medium' CHECK(severity IN ('low','medium','high','critical')),
  status TEXT NOT NULL DEFAULT 'open' CHECK(status IN ('open','assigned','rectified','verified','closed')),
  assigned_to TEXT,
  due_date TEXT,
  raised_by TEXT NOT NULL,
  closed_by TEXT,
  closed_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY(equipment_id) REFERENCES equipment(id) ON DELETE SET NULL,
  FOREIGN KEY(inspection_id) REFERENCES inspections(id) ON DELETE SET NULL,
  FOREIGN KEY(assigned_to) REFERENCES users(id),
  FOREIGN KEY(raised_by) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS files (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  equipment_id TEXT,
  inspection_id TEXT,
  defect_id TEXT,
  object_key TEXT NOT NULL UNIQUE,
  file_name TEXT NOT NULL,
  content_type TEXT NOT NULL,
  size_bytes INTEGER NOT NULL,
  uploaded_by TEXT NOT NULL,
  created_at TEXT NOT NULL,
  FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY(uploaded_by) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS audit_log (
  id TEXT PRIMARY KEY,
  user_id TEXT,
  action TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id TEXT,
  details_json TEXT,
  created_at TEXT NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE INDEX IF NOT EXISTS idx_equipment_project ON equipment(project_id);
CREATE INDEX IF NOT EXISTS idx_inspections_project ON inspections(project_id);
CREATE INDEX IF NOT EXISTS idx_defects_project_status ON defects(project_id, status);
CREATE INDEX IF NOT EXISTS idx_sessions_hash ON sessions(token_hash);

INSERT OR IGNORE INTO templates (id,name,discipline,stage,description,version,active,created_at) VALUES
('tpl-bms-io','BMS Point-to-Point / I/O Checkout','BMS','commissioning','DI, DO, AI and AO point verification including field state, controller state and graphics verification.',1,1,datetime('now')),
('tpl-mssb','MSSB/MCC Pre-Energisation QA','Electrical','qa','Pre-energisation inspection for switchboards, MSSBs and MCCs.',1,1,datetime('now')),
('tpl-cable','Cable & Termination QA','Electrical','qa','Cable installation, identification, support, segregation and termination checks.',1,1,datetime('now')),
('tpl-ahu-pfc','AHU Pre-Functional Checklist','Mechanical/BMS','prefunctional','Pre-functional verification before AHU functional testing.',1,1,datetime('now')),
('tpl-ahu-fpt','AHU Functional Performance Test','BMS','functional','End-to-end functional performance testing against sequence of operation.',1,1,datetime('now'));

INSERT OR IGNORE INTO template_items (id,template_id,sort_order,section,item_text,response_type,mandatory,hold_point) VALUES
('bms-1','tpl-bms-io',10,'Field Device','Device installed, labelled and accessible','pass_fail_na',1,0),
('bms-2','tpl-bms-io',20,'Wiring','Cable number and terminal identification verified','pass_fail_na',1,0),
('bms-3','tpl-bms-io',30,'Point Test','Physical field state matches controller input/output','pass_fail_na',1,0),
('bms-4','tpl-bms-io',40,'Graphics','BMS graphic indication and command verified','pass_fail_na',1,0),
('bms-5','tpl-bms-io',50,'Alarm','Alarm, delay, priority and reset operation verified','pass_fail_na',1,1),
('mssb-1','tpl-mssb',10,'Board','Board construction and labelling match approved drawings','pass_fail_na',1,0),
('mssb-2','tpl-mssb',20,'Protection','Protective devices and settings verified','pass_fail_na',1,0),
('mssb-3','tpl-mssb',30,'Terminations','Torque and termination inspection complete','pass_fail_na',1,0),
('mssb-4','tpl-mssb',40,'Testing','IR, continuity and earth tests completed','pass_fail_na',1,1),
('cable-1','tpl-cable',10,'Route','Cable route, support and segregation comply with drawings/specification','pass_fail_na',1,0),
('cable-2','tpl-cable',20,'Identification','Cable labels are installed at both ends and required intermediate points','pass_fail_na',1,0),
('cable-3','tpl-cable',30,'Termination','Glands, ferrules, terminals and earth continuity verified','pass_fail_na',1,0),
('ahu-pfc-1','tpl-ahu-pfc',10,'Mechanical','Fan, filters, dampers, valves and sensors are installed and ready','pass_fail_na',1,0),
('ahu-pfc-2','tpl-ahu-pfc',20,'Electrical','MSSB supply, isolators and motor protection are proven','pass_fail_na',1,0),
('ahu-pfc-3','tpl-ahu-pfc',30,'BMS','All required I/O points are commissioned before FPT','pass_fail_na',1,1),
('ahu-fpt-1','tpl-ahu-fpt',10,'Start/Stop','Start, stop and enable sequence operates correctly','pass_fail_na',1,0),
('ahu-fpt-2','tpl-ahu-fpt',20,'Control','Temperature/pressure control loops respond to simulated load','pass_fail_na',1,0),
('ahu-fpt-3','tpl-ahu-fpt',30,'Safeties','All safeties, interlocks and fail-safe modes are proven','pass_fail_na',1,1),
('ahu-fpt-4','tpl-ahu-fpt',40,'Alarms','Alarms, delays, priorities and reset functions are proven','pass_fail_na',1,1);
