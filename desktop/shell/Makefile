CC?=cc
CFLAGS?=-O2 -Wall
all: nova-shell
nova-shell: main.c
	$(CC) $(CFLAGS) $< -o $@
install:
	install -Dm755 nova-shell $(DESTDIR)/usr/bin/nova-shell
clean:
	rm -f nova-shell
