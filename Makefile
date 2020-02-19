export TARGET=/usr/bin/singleton

test:
	tests/test.sh

install:
	cp singleton.sh $$TARGET
	chmod +x  $$TARGET

uninstall:
	rm -f $$TARGET