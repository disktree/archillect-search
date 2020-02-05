#PREFIX ?= /usr
#INSTALL_DIR ?= $(PREFIX)
#SRC = $(wildcard src/**/*.hx)

all: build

build: app/app.js service.js

app/app.js: src/archillect/search/App.hx
	haxe app.hxml

service.js: src/archillect/search/Service.hx
	haxe service.hxml

install:
	chmod +x service.js
	cp archillect-search.service /etc/systemd/system/
	#systemctl daemon-reload

uninstall:
	rm -f /etc/systemd/system/archillect-search.service

clean:
	rm -f app/app.css
	rm -f app/app.css.map
	rm -f app/app.js
	rm -f app/app.js.map
	rm -f bin/service.js
	rm -f bin/service.js.map

.PHONY: install uninstall clean
