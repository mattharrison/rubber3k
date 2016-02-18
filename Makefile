# This is the makefile for Rubber.
# As part of Rubber, it is covered by the GPL (see COPYING for details).
# (c) Emmanuel Beffara, 2002

prefix = /usr/local
bindir = ${prefix}/bin
moddir = ${datadir}/rubber
mandir = ${prefix}/man

###  standard targets

all:
	/Users/matt/.env/py27/bin/python2 setup.py build
	cd doc && $(MAKE) all

clean: clean-local
	cd doc && $(MAKE) clean

clean-local:
	rm -rf build dist MANIFEST
	find . \( -name '*~' -or -name '*.py[co]' \) -exec rm {} \;

distclean: clean-local
	rm -f rubber.spec Makefile settings.py src/version.py
	cd doc && $(MAKE) distclean

install:
	/Users/matt/.env/py27/bin/python2 setup.py inst ${prefix}

###  distribution-related targets

sdist:
	rm -f MANIFEST
	/Users/matt/.env/py27/bin/python2 setup.py sdist

deb: sdist
	cd dist ; tar zxf rubber-1.2.tar.gz ; \
		mv rubber-1.2.tar.gz rubber_1.2.orig.tar.gz
	cp -r debian dist/rubber-1.2/
	rm -rf dist/rubber-1.2/debian/CVS
	cd dist/rubber-1.2 ; dpkg-buildpackage -rfakeroot

rpm: sdist
	mkdir -p build/rpm/{BUILD,RPMS/noarch,SOURCES,SPECS,SRPMS}
	cp rubber.spec build/rpm/SPECS/
	cp dist/rubber-1.2.tar.gz build/rpm/SOURCES/
	rpmbuild --define _topdir`pwd`/build/rpm --buildroot `pwd`/build/root -ba rubber.spec
	mv build/rpm/RPMS/noarch/rubber-1.2-1.noarch.rpm build/rpm/SRPMS/rubber-1.2-1.src.rpm dist/
