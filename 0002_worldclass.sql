PRAGMA foreign_keys = ON;

ALTER TABLE projects ADD COLUMN project_type TEXT DEFAULT 'commercial';
ALTER TABLE projects ADD COLUMN commissioning_manager TEXT;
ALTER TABLE projects ADD COLUMN practical_completion TEXT;
ALTER TABLE equipment ADD COLUMN subsystem TEXT;
ALTER TABLE equipment ADD COLUMN manufacturer TEXT;
ALTER TABLE equipment ADD COLUMN model TEXT;
ALTER TABLE equipment ADD COLUMN serial_number TEXT;
ALTER TABLE equipment ADD COLUMN install_status TEXT DEFAULT 'not_started';
ALTER TABLE equipment ADD COLUMN qa_status TEXT DEFAULT 'not_started';
ALTER TABLE equipment ADD COLUMN cx_status TEXT DEFAULT 'not_started';
ALTER TABLE equipment ADD COLUMN turnover_status TEXT DEFAULT 'not_started';
ALTER TABLE defects ADD COLUMN category TEXT DEFAULT 'B';
ALTER TABLE defects ADD COLUMN source TEXT DEFAULT 'field';
ALTER TABLE defects ADD COLUMN rectification_note TEXT;
ALTER TABLE defects ADD COLUMN verified_by TEXT;
ALTER TABLE defects ADD COLUMN verified_at TEXT;

CREATE TABLE IF NOT EXISTS systems (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  code TEXT NOT NULL,
  name TEXT NOT NULL,
  discipline TEXT NOT NULL DEFAULT 'BMS',
  parent_system_id TEXT,
  location TEXT,
  status TEXT NOT NULL DEFAULT 'construction',
  target_date TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  UNIQUE(project_id, code),
  FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY(parent_system_id) REFERENCES systems(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS milestones (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  system_id TEXT,
  name TEXT NOT NULL,
  stage TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'not_started',
  planned_date TEXT,
  actual_date TEXT,
  gate_rule TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY(system_id) REFERENCES systems(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS bms_points (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  equipment_id TEXT,
  system_id TEXT,
  controller TEXT,
  point_name TEXT NOT NULL,
  point_type TEXT NOT NULL,
  io_address TEXT,
  cable_number TEXT,
  terminal TEXT,
  field_device TEXT,
  engineering_units TEXT,
  normal_state TEXT,
  field_status TEXT DEFAULT 'not_tested',
  controller_status TEXT DEFAULT 'not_tested',
  graphics_status TEXT DEFAULT 'not_tested',
  alarm_status TEXT DEFAULT 'not_tested',
  overall_status TEXT DEFAULT 'not_tested',
  tested_by TEXT,
  tested_at TEXT,
  comment TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY(equipment_id) REFERENCES equipment(id) ON DELETE SET NULL,
  FOREIGN KEY(system_id) REFERENCES systems(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS turnover_packages (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  system_id TEXT,
  name TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'draft',
  readiness_percent INTEGER NOT NULL DEFAULT 0,
  required_items INTEGER NOT NULL DEFAULT 0,
  complete_items INTEGER NOT NULL DEFAULT 0,
  approved_by TEXT,
  approved_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY(system_id) REFERENCES systems(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS turnover_items (
  id TEXT PRIMARY KEY,
  package_id TEXT NOT NULL,
  category TEXT NOT NULL,
  name TEXT NOT NULL,
  required INTEGER NOT NULL DEFAULT 1,
  status TEXT NOT NULL DEFAULT 'missing',
  file_id TEXT,
  note TEXT,
  updated_by TEXT,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(package_id) REFERENCES turnover_packages(id) ON DELETE CASCADE,
  FOREIGN KEY(file_id) REFERENCES files(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS daily_plans (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  work_date TEXT NOT NULL,
  title TEXT NOT NULL,
  owner TEXT,
  status TEXT NOT NULL DEFAULT 'planned',
  planned_count INTEGER DEFAULT 0,
  completed_count INTEGER DEFAULT 0,
  notes TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS witness_requests (
  id TEXT PRIMARY KEY,
  project_id TEXT NOT NULL,
  inspection_id TEXT,
  system_id TEXT,
  requested_for TEXT NOT NULL,
  witness_party TEXT,
  status TEXT NOT NULL DEFAULT 'requested',
  outcome TEXT,
  comment TEXT,
  created_by TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(project_id) REFERENCES projects(id) ON DELETE CASCADE,
  FOREIGN KEY(inspection_id) REFERENCES inspections(id) ON DELETE SET NULL,
  FOREIGN KEY(system_id) REFERENCES systems(id) ON DELETE SET NULL,
  FOREIGN KEY(created_by) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS comments (
  id TEXT PRIMARY KEY,
  entity_type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id TEXT NOT NULL,
  created_at TEXT NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE INDEX IF NOT EXISTS idx_systems_project ON systems(project_id);
CREATE INDEX IF NOT EXISTS idx_bms_points_project ON bms_points(project_id);
CREATE INDEX IF NOT EXISTS idx_bms_points_equipment ON bms_points(equipment_id);
CREATE INDEX IF NOT EXISTS idx_turnover_project ON turnover_packages(project_id);
CREATE INDEX IF NOT EXISTS idx_milestones_project ON milestones(project_id);
CREATE INDEX IF NOT EXISTS idx_witness_project ON witness_requests(project_id);

INSERT OR IGNORE INTO templates (id,name,discipline,stage,description,version,active,created_at) VALUES
('tpl-vsd','VSD Pre-Start & Functional Test','Electrical/BMS','functional','Electrical, communications, rotation, speed command, feedback and fault testing for variable speed drives.',1,1,datetime('now')),
('tpl-fcu','FCU Installation & BMS Functional Test','Mechanical/BMS','functional','Installation QA, valve control, fan operation, condensate, sensor and BMS functional testing for FCUs.',1,1,datetime('now')),
('tpl-pump','Pump Set Pre-Functional & Duty/Standby Test','Electrical/BMS','functional','Pump installation, rotation, differential pressure, duty/standby changeover, alarms and safeties.',1,1,datetime('now')),
('tpl-smoke','Smoke Control Interface Test','Electrical/BMS','integrated','Interface testing for fire mode, smoke dampers, fan proving, shutdowns, overrides and reset sequences.',1,1,datetime('now')),
('tpl-meter','Electrical Meter / Modbus Verification','Electrical/BMS','commissioning','Meter installation, CT ratio, phase, communications, scaling and BMS value verification.',1,1,datetime('now')),
('tpl-network','BMS Network & Controller Commissioning','BMS','commissioning','Controller, IP, BACnet/Modbus, trunk integrity, naming, time sync, backups and resilience checks.',1,1,datetime('now')),
('tpl-ups','BMS UPS / DC Supply Test','Electrical/BMS','functional','Normal supply, battery autonomy, failover, alarm and recovery testing for BMS UPS/DC systems.',1,1,datetime('now')),
('tpl-final','System Completion / Handover Gate','QA','handover','Final readiness gate covering defects, redlines, test records, O&M, training, witness and turnover acceptance.',1,1,datetime('now'));

INSERT OR IGNORE INTO template_items (id,template_id,sort_order,section,item_text,response_type,mandatory,hold_point) VALUES
('vsd-1','tpl-vsd',10,'Installation','VSD installed, labelled, accessible and ventilation clear','pass_fail_na',1,0),
('vsd-2','tpl-vsd',20,'Electrical','Supply, motor cabling, earth and isolator verified','pass_fail_na',1,0),
('vsd-3','tpl-vsd',30,'Rotation','Motor direction and minimum/maximum speed verified','pass_fail_na',1,1),
('vsd-4','tpl-vsd',40,'BMS','Start/stop, speed command, speed feedback and fault status proven','pass_fail_na',1,1),
('fcu-1','tpl-fcu',10,'Installation','FCU, filters, drain, valve and access complete','pass_fail_na',1,0),
('fcu-2','tpl-fcu',20,'Electrical','Supply, isolator and fan speed outputs proven','pass_fail_na',1,0),
('fcu-3','tpl-fcu',30,'BMS','Room sensor, valve command, fan control and alarms proven','pass_fail_na',1,1),
('pump-1','tpl-pump',10,'Mechanical','Pump, valves, strainers and pressure sensors complete','pass_fail_na',1,0),
('pump-2','tpl-pump',20,'Electrical','Motor protection, rotation and current verified','pass_fail_na',1,1),
('pump-3','tpl-pump',30,'Sequence','Duty/standby changeover, lead/lag and failure recovery proven','pass_fail_na',1,1),
('smoke-1','tpl-smoke',10,'Interface','Fire mode input received correctly','pass_fail_na',1,1),
('smoke-2','tpl-smoke',20,'Sequence','Fans/dampers drive to required smoke control states','pass_fail_na',1,1),
('smoke-3','tpl-smoke',30,'Reset','System restores safely after fire reset','pass_fail_na',1,1),
('meter-1','tpl-meter',10,'Meter','CT ratio, voltage references and phase mapping verified','pass_fail_na',1,0),
('meter-2','tpl-meter',20,'Comms','Modbus/BACnet communications stable and addressed correctly','pass_fail_na',1,0),
('meter-3','tpl-meter',30,'BMS','kW, kWh, V, A and PF values agree with local meter','pass_fail_na',1,1),
('network-1','tpl-network',10,'Controller','Controller naming, firmware, IP and time sync verified','pass_fail_na',1,0),
('network-2','tpl-network',20,'Network','BACnet/Modbus trunks healthy with no duplicate IDs','pass_fail_na',1,0),
('network-3','tpl-network',30,'Resilience','Backup/restore and controller restart recovery verified','pass_fail_na',1,1),
('ups-1','tpl-ups',10,'Normal','Normal supply and charger condition verified','pass_fail_na',1,0),
('ups-2','tpl-ups',20,'Failure','Mains failover to battery/DC supply proven','pass_fail_na',1,1),
('ups-3','tpl-ups',30,'Alarm','Low battery / charger fail / mains fail alarms proven','pass_fail_na',1,1),
('final-1','tpl-final',10,'Defects','All Category A defects closed and Category B items accepted','pass_fail_na',1,1),
('final-2','tpl-final',20,'Documents','As-builts, test records, certificates and O&M documentation complete','pass_fail_na',1,1),
('final-3','tpl-final',30,'Witness','Required witness tests completed and signed','pass_fail_na',1,1),
('final-4','tpl-final',40,'Operations','Training, backups, passwords and operating information handed over','pass_fail_na',1,1);
