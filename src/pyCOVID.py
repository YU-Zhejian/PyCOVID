#!/usr/bin/env python 
# -*- coding: utf-8 -*-
import datetime
import sqlite3
import sys
import traceback

import PyQt5
import pandas
from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QMainWindow, QFileDialog, QDialog, QApplication, QMessageBox, QTableWidgetItem, QHeaderView

from AboutDialogue import *
from MainWindow import *


class MyMainForm(QMainWindow):
	def __init__(self):
		super().__init__()
		self.ui = Ui_MainWindow()
		self.ui.setupUi(self)
		self.ui.actionConnect.triggered.connect(self.actionConnect_click)
		self.ui.actionExport.triggered.connect(self.actionExport_click)
		self.ui.actionQuit.triggered.connect(self.actionQuit_click)
		self.ui.actionAbout.triggered.connect(self.actionAbout_click)
		self.ui.submitSQL.clicked.connect(self.submitSQL_click)
		self.ui.clear.clicked.connect(self.clear_click)
		self.ui.submitVALUE.clicked.connect(self.submitVALUE_click)
		self.ui.statusBar.showMessage("Database not connected")
		self.ui.tableWidget.horizontalHeader().resizeSections(QHeaderView.ResizeToContents)
		self.ui.dateEnd.setDate(datetime.date.today())
		self.show()
		self.myconnection = None
		self.df = pandas.DataFrame()
		self.headers = []

	def actionConnect_click(self):
		if self.myconnection == None:
			self.ui.statusBar.showMessage("Opening SQLite database from \'data.db\'...")
			self.ui.progressBar.setMaximum(3)
			self.ui.contySelect.addItem('*')
			try:
				self.myconnection = sqlite3.connect("data.db")
				self.ui.progressBar.setValue(1)
				mycursor = self.myconnection.cursor()
				self.ui.progressBar.setValue(2)
				for i in mycursor.execute("SELECT DISTINCT Country FROM Country_CRD;").fetchall():
					self.ui.contySelect.addItem(i[0])
				self.ui.progressBar.setValue(3)
			except Exception as e:
				QMessageBox.critical(self, e.__str__(), traceback.format_exc())
				sys.exit(1)
			self.ui.actionConnect.setText("Close")
			self.ui.statusBar.showMessage("Opened SQLite database from \'data.db\'")
		else:
			self.ui.statusBar.showMessage("Closing SQLite database from \'data.db\'...")
			self.myconnection.close()
			self.ui.statusBar.showMessage("Closed SQLite database from \'data.db\'...")
			self.myconnection = None
			self.ui.tableWidget.clear()
			self.ui.SQLBox.clear()
			self.ui.contySelect.clear()
			self.ui.actionConnect.setText("Connect")

	def actionQuit_click(self):
		if self.myconnection != None:
			self.ui.statusBar.showMessage("Closing SQLite database from \'data.db\'...")
			self.myconnection.close()
			self.ui.statusBar.showMessage("Closed SQLite database from \'data.db\'...")
		sys.exit(0)

	def actionExport_click(self):
		open_fn = QFileDialog.getSaveFileName(parent=self, caption="Save as",
											  filter="Comma Separate Value (*.csv);;Tab Separate Values (*.tsv);;Microsoft Excel 2007-2019 (*.xlsx);;JavaScript Object Notation (*.json)")[
			0]
		if open_fn == "":
			return
		self.ui.statusBar.showMessage("Saving to \'" + open_fn + "\'...")
		try:
			if open_fn.endswith(".csv"):
				self.df.to_csv(open_fn, index=False)
			elif open_fn.endswith(".tsv"):
				openh = open(open_fn, "w")
				openh.write("\t".join(self.headers) + "\n")
				for i in range(0, self.df.shape[0]):
					openh.write("\t".join(list(map(str, self.df.iloc[i, :].tolist()))) + "\n")
				openh.close()
			elif open_fn.endswith(".xlsx"):
				try:
					self.df.to_excel(open_fn, index=False)
				except ImportError:
					QMessageBox.critical(self, "ImportError",
										 "Saving as Excel needs an additional model, 'openpyxl', which is not installed.")
			elif open_fn.endswith(".json"):
				self.df.to_json(open_fn)
			self.ui.statusBar.showMessage("Saved to \'" + open_fn + "\'")
		except Exception as e:
			QMessageBox.critical(self, e.__str__(), traceback.format_exc())
			return

	def fill_table(self):
		self.ui.tableWidget.setRowCount(self.df.shape[0])
		self.ui.tableWidget.setColumnCount(self.df.shape[1])
		self.ui.tableWidget.setHorizontalHeaderLabels(self.headers * self.df.shape[0])
		self.ui.progressBar.setValue(0)
		self.ui.progressBar.setMaximum(self.df.shape[0])
		n = 0
		for i in range(0, self.df.shape[0]):
			for j in range(0, self.df.shape[1]):
				n += 1
				self.ui.tableWidget.setItem(i, j, QTableWidgetItem(str(self.df.iloc[i, j])))
				self.ui.progressBar.setValue(n)

	def submitSQL_click(self):
		if self.myconnection == None:
			QMessageBox.critical(self, "ConnectionError", "Connection not established. Please click FIle --> Connect")
			return
		try:
			sqlm = self.ui.SQLBox.text()
			self.ui.History.setPlainText(self.ui.History.toPlainText() + sqlm + "\n")
			self.ui.statusBar.showMessage("Executing " + sqlm + "...")
			self.ui.SQLBox.clear()
			self.headers = []
			mycursor = self.myconnection.cursor()
			data = mycursor.execute(sqlm)
			for row_name in data.description:
				self.headers.append(row_name[0])
			self.df = pandas.DataFrame(data.fetchall(), columns=self.headers)
			self.fill_table()
		except Exception as e:
			QMessageBox.critical(self, e.__str__(), traceback.format_exc())
			return
		self.ui.statusBar.showMessage("Executed " + sqlm)

	def submitVALUE_click(self):
		if self.myconnection == None:
			QMessageBox.critical(self, "ConnectionError", "Connection not established. Please click FIle --> Connect")
			return
		conditions = []
		rows = []
		if self.ui.checkBoxCR.isChecked():
			rows.append("Country")
		if self.ui.checkBoxDate.isChecked():
			rows.append("Date")
		if self.ui.checkBoxC.isChecked():
			rows.append("Confirmed")
		if self.ui.checkBoxR.isChecked():
			rows.append("Recovered")
		if self.ui.checkBoxD.isChecked():
			rows.append("Deaths")
		sqlm = "SELECT " + ",".join(rows) + " FROM Country_CRD"
		if self.ui.contySelect.currentText() != "*":
			conditions.append("Country == \'" + self.ui.contySelect.currentText() + "\'")
		if self.ui.checkBoxDateStart.isChecked():
			conditions.append("Date >= " + "date(\'" + self.ui.dateStart.date().toString("yyyy-MM-dd") + "\')")
		if self.ui.checkBoxDateEnd.isChecked():
			conditions.append("Date <= " + "date(\'" + self.ui.dateEnd.date().toString("yyyy-MM-dd")  + "\')")
			if self.ui.checkBoxDateStart.isChecked() and self.ui.dateEnd.date() < self.ui.dateStart.date():
				QMessageBox.critical(self, "VlueError", "End date smaller than start date. Abort")
				return
		if self.ui.CS.text() != "*":
			conditions.append("Confirmed >= " + self.ui.CS.text())
		if self.ui.CE.text() != "*":
			conditions.append("Confirmed <= " + self.ui.CE.text())
			if self.ui.CS.text() != "*" and int(self.ui.CS.text()) > int(self.ui.CE.text()):
				QMessageBox.critical(self, "VlueError", "End confirmed smaller than start confirmed. Abort")
				return
		if self.ui.RS.text() != "*":
			conditions.append("Recovered >= " + self.ui.RS.text())
		if self.ui.RE.text() != "*":
			conditions.append("Recovered <= " + self.ui.RE.text())
			if self.ui.RS.text() != "*" and int(self.ui.RS.text()) > int(self.ui.RE.text()):
				QMessageBox.critical(self, "VlueError", "End recovered smaller than start recovered. Abort")
				return
		if self.ui.DS.text() != "*":
			conditions.append("Deaths >= " + self.ui.DS.text())
		if self.ui.DE.text() != "*":
			conditions.append("Deaths <= " + self.ui.DE.text())
			if self.ui.DS.text() != "*" and int(self.ui.DS.text()) > int(self.ui.DE.text()):
				QMessageBox.critical(self, "VlueError", "End deaths smaller than start deaths. Abort")
				return
		if conditions != []:
			sqlm += " WHERE " + " AND ".join(conditions)
		sqlm += ";"
		self.ui.History.setPlainText(self.ui.History.toPlainText() + sqlm + "\n")
		try:
			self.ui.statusBar.showMessage("Executing " + sqlm + "...")
			self.headers = []
			mycursor = self.myconnection.cursor()
			data = mycursor.execute(sqlm)
			for row_name in data.description:
				self.headers.append(row_name[0])
			self.df = pandas.DataFrame(data.fetchall(), columns=self.headers)
			self.fill_table()
		except Exception as e:
			QMessageBox.critical(self, e.__str__(), traceback.format_exc())
			return
		self.ui.statusBar.showMessage("Executed " + sqlm)

	def clear_click(self):
		self.ui.checkBoxCR.setChecked(True)
		self.ui.checkBoxDate.setChecked(True)
		self.ui.checkBoxC.setChecked(True)
		self.ui.checkBoxR.setChecked(True)
		self.ui.checkBoxD.setChecked(True)
		self.ui.contySelect.setCurrentText("*")
		self.ui.checkBoxDateStart.setChecked(False)
		self.ui.checkBoxDateEnd.setChecked(False)
		self.ui.CE.setText("*")
		self.ui.CS.setText("*")
		self.ui.RE.setText("*")
		self.ui.RS.setText("*")
		self.ui.DE.setText("*")
		self.ui.DS.setText("*")
		self.ui.dateStart.setDateTime(QtCore.QDateTime(QtCore.QDate(2020, 1, 22), QtCore.QTime(0, 0, 0)))
		self.ui.dateEnd.setDate(datetime.date.today())

	def actionAbout_click(self):
		MA = MyAboutDialogue()
		MA.exec_()


class MyAboutDialogue(QDialog):
	def __init__(self):
		super().__init__()
		self.ui = Ui_AboutDialogue()
		self.ui.setupUi(self)
		self.ui.pyQtVer.setText("PyQt5 Version " + PyQt5.QtCore.qVersion())
		self.ui.pushButton.clicked.connect(lambda: self.close())


app = QApplication(sys.argv)
MainForm = MyMainForm()
sys.exit(app.exec_())
