PLATFORM=/opt/platform

all: deps
	(cd src;$(MAKE))

deps:
	cp $(PLATFORM)/amqp/ebin/* ebin
	cp $(PLATFORM)/core/ebin/* ebin
	cp $(PLATFORM)/elog/ebin/* ebin
	cp $(PLATFORM)/sesnmp/ebin/* ebin
	cp $(PLATFORM)/mochiweb/ebin/reloader.beam ebin

clean:
	(cd src;$(MAKE) clean)
