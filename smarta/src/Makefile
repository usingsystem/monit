include ../support/include.mk

all: $(EBIN_FILES)
	(cd plugins;$(MAKE))

clean:
	rm -rf $(EBIN_FILES)
	(cd plugins;$(MAKE) clean)

