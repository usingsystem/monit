AUTOMAKE_OPTIONS = subdir-objects

CFLAGS = -g -Wall

builtin_CFLAGS = -I$(top_srcdir)/lib/expat
builtin_LIBS = libexpat.a

PARSER_CFLAGS=@PARSER_CFLAGS@
PARSER_LIBS=@PARSER_LIBS@

STROPHE_FLAGS = -I$(top_srcdir)
STROPHE_LIBS = libsmarta.a $(PARSER_LIBS) -lssl -lresolv

## Main build targets
if BUILD_EXPAT
lib_LIBRARIES = libsmarta.a libexpat.a
else
lib_LIBRARIES = libsmarta.a
endif

libsmarta_a_includedir=${top_srcdir}
libsmarta_a_CFLAGS=$(STROPHE_FLAGS) $(PARSER_CFLAGS)
libsmarta_a_SOURCES = src/log.c src/ae.c \
    src/anet.c src/sds.c src/zmalloc.c \
    src/auth.c src/xmpp.c src/hash.c \
	src/jid.c src/md5.c src/sasl.c src/sha1.c \
	src/stanza.c src/parser.c 

libexpat_a_CFLAGS=-DXML_DTD -DXML_NS -DXML_CONTEXT_BYTES=1024 -DXML_STATIC \
	-I$(top_srcdir)/lib/expat
libexpat_a_SOURCES=lib/expat/xmlparse.c lib/expat/xmltok.c lib/expat/xmlrole.c


## Examples
noinst_PROGRAMS = smarta
smarta_SOURCES = src/smarta.c
smarta_CFLAGS = $(STROPHE_FLAGS)
smarta_LDADD = $(STROPHE_LIBS) 

