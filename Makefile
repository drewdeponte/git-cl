prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release --disable-sandbox

install: build
	install ".build/release/git-changelog" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/git-changelog"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
