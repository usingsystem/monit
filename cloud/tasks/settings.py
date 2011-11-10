#settings
DATABASE = {
  'host': 'localhost',  
  'port': '3306', 
  'user': 'root',     
  'password': 'public',  
  'name': 'monit',     
}

CASSANDRA = {
  'servers': ['localhost:9160']
}

ROLLUP = { 
  ("metric", 1):  ("Metric", "MetricRollup1"), 
  ("metric", 12): ("MetricRollup1", "MetricRollup12"), 
  ("metric", 24): ("MetricRollup1", "MetricRollup24"),
  ("status", 1):  ("Status", "StatusRollup1"), 
  ("status", 12): ("StatusRollup1", "StatusRollup12"), 
  ("status", 24): ("StatusRollup1", "StatusRollup24"),
}

CLEANUP = { 
  ('metric', 0):  ('Metric', 5), #5 days before
  ('metric', 1):  ('MetricRollup1', 30), #30 days before
  ('metric', 12): ('MetricRollup12', 360), #360 days before
  ('metric', 24): ('MetricRollup24', 720), #720 days before
  ('status', 0):  ('Status', 5),
  ('status', 1):  ('StatusRollup1', 30),
  ('status', 12): ('StatusRollup12', 360),
  ('status', 24): ('StatusRollup24', 720),
}

