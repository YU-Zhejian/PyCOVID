#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sqlite3

conn = sqlite3.connect("data.db")
cursor = conn.cursor()
cursor.execute("PRAGMA synchronous = OFF")
sqlfh = open("data.db.sql", "r")
cursor.execute("BEGIN TRANSACTION")
with os.popen("wc -l  data.db.sql") as all_lenh:
	all_len = int(all_lenh.read().split(" ")[0])+1
# On WIndows it should be "TYPE data.db.sql | FIND /v \"\" /c"
try:
	i = 0
	while True:
		line = sqlfh.readline()
		if line:
			i+=1
			cursor.execute(line)
			print("\033[1APumping " + str(i)+ "/" + str(all_len)+", "+str(i/all_len*100)+"%")
		else:
			break
finally:
	sqlfh.close()
print("Comitting...")
cursor.execute("COMMIT")
conn.close()
