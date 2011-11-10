PLATFORM=/opt/platform

all: deps
	(cd src;$(MAKE))

deps:
	cp $(PLATFORM)/amqp/ebin/* ebin/
	cp $(PLATFORM)/core/ebin/* ebin/
	cp $(PLATFORM)/elog/ebin/* ebin/
	cp $(PLATFORM)/elog/include/* include/
	cp $(PLATFORM)/mysql/ebin/* ebin/
	cp $(PLATFORM)/mochiweb/ebin/* ebin/
	cp $(PLATFORM)/cassandra/ebin/* ebin/

clean:
	(cd src;$(MAKE) clean)
