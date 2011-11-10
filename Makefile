PLATFORM=/opt/monit

all: 
	(cd cloud;$(MAKE))
	(cd node;$(MAKE))
	(cd smarta;$(MAKE))

clean: 
	(cd cloud;$(MAKE) clean)
	(cd node;$(MAKE) clean)
	(cd smarta;$(MAKE) clean)

