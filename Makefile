#PREFIX ?= /usr
#INSTALL_DIR ?= $(PREFIX)
#SRC = $(wildcard src/**/*.hx)

install:
	chmod +x bin/service.js
	cp archillect-search.service /etc/systemd/system/
	#systemctl daemon-reload

uninstall:
	rm -f /etc/systemd/system/archillect-search.service

clean:
	rm -f app/app.js
	rm -f app/app.js.map
	rm -f bin/service.js
	rm -f bin/service.js.map

.PHONY: install uninstall clean
