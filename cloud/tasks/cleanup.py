#!/usr/bin/env python

"""
status and metric cleanup task.
TODO: shoud use cassandra 0.6 'deletion' to cleanup.
"""

from settings import *

import sys, time, getopt, pycassa, cassandra, MySQLdb 

def cleanup(type, hour):
  cf_name, days = CLEANUP[(type, hour)]
  expired_at = int(time.time()) - days * 24 * 3600
  cassa = pycassa.connect(CASSANDRA['servers'])
  cf = pycassa.ColumnFamily(cassa, 'Monit', cf_name, super=True)
  mysql, cursor = mysql_cursor()
  while (True): 
    row = cursor.fetchone () 
    if row == None: 
      break 
    cleanup_row(row['uuid'], cf, expired_at)
  cursor.close()
  mysql.close()

def cleanup_row(uuid, cf, expired_time):
  try: 
    expired_data = cf.get(uuid, column_finish = str(expired_time), column_count = 200)
    for col in expired_data.iterkeys():
      cf.remove(uuid, column=col)
      print "clean up (%s, %s)" % (uuid, col) 
  except cassandra.ttypes.NotFoundException,e:
    pass

def mysql_cursor():
  try: 
    conn = MySQLdb.connect(host = DATABASE['host'], user = DATABASE['user'], 
	passwd = DATABASE['password'], db = DATABASE['name']) 
    cursor = conn.cursor(MySQLdb.cursors.DictCursor) 
    cursor.execute ("select uuid from services") 
    return (conn, cursor)
  except MySQLdb.Error, e: 
    print "Connected MySQL Error %d: %s" % (e.args[0], e.args[1]) 
    sys.exit (1) 

def usage():
  print "Usage: cleanup --status|metric --hour=0|1|12|24"
  
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
  if hour not in ('0', '1', '12', '24'):
    print "uknown clean hour, only support 0, 1, 12, 24"
    usage()
    sys.exit(2)
  cleanup(type, int(hour))

