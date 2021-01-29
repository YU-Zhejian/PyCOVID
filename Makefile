.PHONY : all doc src clean distclean

all: doc src

src:
	@-$(MAKE) -C src
	chmod +x pyCOVID*

clean:
	@-$(MAKE) -C src clean
	@-$(MAKE) -C doc clean
	rm -rf OFFLINE

distclean:
	@-$(MAKE) -C src distclean
	@-$(MAKE) -C doc distclean
	rm -rf OFFLINE

doc:
	@-$(MAKE) -C doc

OFFLINE: doc src clean
	mkdir -p OFFLINE
	cp -r src pyCOVID* OFFLINE
	cp doc/main.pdf OFFLINE/Usage.pdf
	rm -rf OFFLINE/src/*.ui OFFLINE/src/Makefile OFFLINE/src/ParseCountry.gawk OFFLINE/src/sqlite_insert.py OFFLINE/src/__pycache__
	tar cvf - OFFLINE | xz -9cvvf > OFFLINE.txz
	rm -rf OFFLINE

update:upgrade

upgrade:
	rm -f src/data.db
	@-$(MAKE) -C src clean
	@-$(MAKE) -C src data.db
