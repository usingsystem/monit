PLATFORM=/opt/platform

all: deps
	(cd src;$(MAKE))

deps:
	cp $(PLATFORM)/core/ebin/* ebin
	cp $(PLATFORM)/elog/include/* include
	cp $(PLATFORM)/sesnmp/ebin/* ebin
	cp $(PLATFORM)/mochiweb/ebin/reloader.beam ebin

clean:
	(cd src;$(MAKE) clean)
