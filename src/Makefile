SOURCES := $(wildcard *.ui)
OBJECTS := $(SOURCES:.ui=.py)

all: data.db $(OBJECTS)

%.py: %.ui
	@echo "\033[33mCompiling user interface...\033[0m"
	pyuic5 $< -o $@
	@echo "\033[33mDone!\033[0m"

data.db:data.db.sql
	@echo "\033[33mImporting SQL script into database...\033[0m"
	python sqlite_insert.py
	@echo "\033[33mDone!\033[0m"

data.db.sql:countries-aggregated.csv
	@echo "\033[33mBuilding SQL script...\033[0m"
	echo "CREATE TABLE Country_CRD(Date DATE, Country TEXT, Confirmed INTEGER, Recovered INTEGER, Deaths INTEGER);" > data.db.sql
	printf -- "--" >> data.db.sql
	cat countries-aggregated.csv | sed "s;';'';" | awk -f ParseCountry.gawk >> data.db.sql
	@echo "\033[33mDone!\033[0m"

countries-aggregated.csv:
	@echo "\033[33mDownloading data...\033[0m"
	curl --location --ssl datahub.io/core/covid-19/r/countries-aggregated.csv -o countries-aggregated.csv
	@echo "\033[33mDone!\033[0m"

clean:
	@echo -e "\033[33mCleaning intermediate files...\033[0m"
	rm -f data.db.sql countries-aggregated.csv
	@echo -e "\033[33mDone!\033[0m"

distclean: clean
	@echo -e "\033[33mCleaning compiled files...\033[0m"
	rm -f data.db $(OBJECTS)
	@echo -e "\033[33mDone!\033[0m"
