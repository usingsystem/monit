#!/usr/bin/env python

"""
status and metric rollup task.
"""
from settings import *

import sys, time, getopt, pycassa, cassandra, MySQLdb 

def rollup(type, hour):
  now = int(time.time())
  conn = pycassa.connect(CASSANDRA['servers'])
  rollup_time = calc_time(now, hour)
  src, dest = ROLLUP[(type, hour)]
  src_cf = pycassa.ColumnFamily(conn, 'Monit', src, super=True)
  dest_cf = pycassa.ColumnFamily(conn, 'Monit', dest, super=True)
  if type == 'metric':
    rollup_metric(src_cf, dest_cf, rollup_time)
  else: #status
    rollup_status(src_cf, dest_cf, rollup_time)

def rollup_status(src_cf, dest_cf, rollup_time):
  for tab in ["services", "hosts", "apps", "devices", "sites"]:
    conn, cursor = mysql_cursor(tab)
    while (True): 
      row = cursor.fetchone () 
      if row == None: 
        break 
      rollup_status_row(row['uuid'], src_cf, dest_cf, rollup_time)
    cursor.close()
    conn.close()

def rollup_status_row(uuid, src_cf, dest_cf, rollup_time):
  rollup_at, rollup_start, rollup_end = rollup_time
  try: 
    data = src_cf.get(uuid, column_start = rollup_start, column_finish = rollup_end)
    status = {'ok' : 0, 'warning': 0, 'critical': 0, 'unknown': 0, 'pending': 0}
    for item in data.itervalues():
      for k in ('ok', 'warning', 'critical', 'unknown', 'pending'):
        if k in item: 
          status[k] += int(item[k])
    for k, v in status.items():
      status[k] = str(v) 
    print status
    dest_cf.insert(uuid, {rollup_at: status})
  except cassandra.ttypes.NotFoundException,e:
    pass

def rollup_metric(src_cf, dest_cf, rollup_time):
  conn, cursor = mysql_cursor("services")
  while (True): 
    row = cursor.fetchone () 
    if row == None: 
      break 
    rollup_metric_row(row['uuid'], src_cf, dest_cf, rollup_time)
  cursor.close()
  conn.close()

def rollup_metric_row(uuid, src_cf, dest_cf, rollup_time):
  rollup_at, rollup_start, rollup_end = rollup_time
  try: 
    sup_columns = src_cf.get(uuid, column_start = rollup_start, column_finish = rollup_end)
    total = {}
    aggreate = {}
    for sup_column in sup_columns.itervalues():
      for name, val in sup_column.items():
        if val == '':
          total[name] = total.get(name, 0)
        else:
          total[name] = total.get(name, 0) + 1
          aggreate[name] = aggreate.get(name, 0) + float(val)
    for name, num in total.items():
      if num == 0:
        aggreate[name] = ''
      else:
        aggreate[name] = str(aggreate[name] / num) 
    print aggreate
    dest_cf.insert(uuid, {rollup_at: aggreate})
  except cassandra.ttypes.NotFoundException,e:
    pass

def calc_time(now, hour):
    rollup_at = now - now % (hour * 3600)
    rollup_start = str(rollup_at - (hour * 3600))
    rollup_end = str(rollup_at + 30)
    return (str(rollup_at), rollup_start, rollup_end)

def mysql_cursor(tab):
  try: 
    conn = MySQLdb.connect(host = DATABASE['host'], user = DATABASE['user'], 
	passwd = DATABASE['password'], db = DATABASE['name']) 
    cursor = conn.cursor(MySQLdb.cursors.DictCursor) 
    cursor.execute ("select uuid from " + tab) 
    return (conn, cursor)
  except MySQLdb.Error, e: 
    print "Connected MySQL Error %d: %s" % (e.args[0], e.args[1]) 
    sys.exit (1) 

def usage():
  print "Usage: rollup --status|metric --hour=1|12|24"
  
if __name__ == "__main__":
  try:
    opts, args = getopt.getopt(sys.argv[1:], "h", ["help", "status", "metric", "hour="])
  except getopt.GetoptError, err:
    # print help information and exit:
    print usage()
    sys.exit(2)
  for o, a in opts:
    if o in ("-h", "--help"):
      usage(),
      sys.exit(0)
    elif o in ("--status"):
      type = 'status' 
    elif o in ("--metric"):
      type = 'metric' 
    elif "--hour" in o:
      hour = a 
    else:
      print usage()
      sys.exit(1)
  if type not in ('metric', 'status'):
    usage()
    sys.exit(2)
  if hour not in ('1', '12', '24'):
    print "uknown rollup hour, only support 1,12,24"
    usage()
    sys.exit(2)
  rollup(type, int(hour))

def rollup(type, hour):
  now = int(time.time())
  last_hour = now - now % 3600
  rollup_start = str(last_hour - 3600)
  rollup_end = str(last_hour + 60)
  cassa = pycassa.connect(CASSANDRA['servers'])
  status_cf = pycassa.ColumnFamily(cassa, 'Monit', 'Status', super=True)
  rollup_cf = pycassa.ColumnFamily(cassa, 'Monit', 'StatusRollup1', super=True)
  try: 
    mysql = MySQLdb.connect(host = DATABASE['host'], user = DATABASE['user'], 
	passwd = DATABASE['password'], db = DATABASE['name']) 
  except MySQLdb.Error, e: 
    print "Connected MySQL Error %d: %s" % (e.args[0], e.args[1]) 
    sys.exit (1) 
  try: 
    cursor = mysql.cursor(MySQLdb.cursors.DictCursor) 
    cursor.execute ("select uuid from services") 
    while (1): 
      row = cursor.fetchone () 
      if row == None: 
        break 
      rollup(status_cf, rollup_cf, row['uuid'], str(last_hour), rollup_start, rollup_end)
  except MySQLdb.Error, e:
    print "MySQL Error %d: %s" % (e.args[0], e.args[1]) 
    sys.exit (1) 
  cursor.close()
  mysql.close()
  sys.exit(0)
