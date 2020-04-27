prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release --disable-sandbox

install: build
	install ".build/release/git-cl" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/git-cl"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
