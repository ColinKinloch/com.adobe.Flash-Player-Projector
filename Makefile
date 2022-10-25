DEBUG:=0
PREFIX:=/app
FLATPAK_ID:=com.adobe.Flash-Player-Projector

icon_resolutions = 32 64 128 256

all: libfix-config-location.so $(icon_resolutions:=_icon.png)

clean:
	rm -f fix-config-location.o libfix-config-location.so
	$(foreach s, $(icon_resolutions), rm -f $(s)_icon.png;)

%_icon.png: $(FLATPAK_ID).svg
	rsvg-convert $< -w "$*" -a -o $@;

fix-config-location.o: fix-config-location.c directories.h
	gcc -Wall -DDEBUG=$(DEBUG) -fPIC -c -o fix-config-location.o fix-config-location.c

libfix-config-location.so: fix-config-location.o
	gcc -shared -fPIC -Wl,-soname -Wl,libfix-config-location.so -o libfix-config-location.so fix-config-location.o

install: libfix-config-location.so $(icon_resolutions:=_icon.png)
	install -m755 -Dt $(PREFIX)/lib libfix-config-location.so
	$(foreach s, $(icon_resolutions), \
		install -Dm644 $(s)_icon.png \
		$(PREFIX)/share/icons/hicolor/$(s)x$(s)/apps/$(FLATPAK_ID).png ; \
	)
