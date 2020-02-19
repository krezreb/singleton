export TARGET=/usr/bin/singleton

test:
	tests/test3.sh $(realpath singleton.sh)
	tests/test1.sh $(realpath singleton.sh)
	tests/test2.sh $(realpath singleton.sh)

install:
	cp singleton.sh $$TARGET
	chmod +x  $$TARGET

uninstall:
	rm -f $$TARGET