/* parser.h
** strophe XMPP client library -- parser structures and functions
**
** Copyright (C) 2005-2009 Collecta, Inc. 
**
**  This software is provided AS-IS with no warranty, either express or
**  implied.
**
**  This software is distributed under license and may not be copied,
**  modified or distributed except as expressly authorized under the
**  terms of the license contained in the file LICENSE.txt in this
**  distribution.
*/

/** @file
 *  Internally used functions and structures.
 */

#ifndef __PARSER_H__
#define __PARSER_H__

#include "stanza.h"

typedef struct _XmppParser XmppParser;

typedef void (*parser_start_callback)(char *name,
                                      char **attrs,
                                      void * const userdata);
typedef void (*parser_end_callback)(char *name, void * const userdata);
typedef void (*parser_stanza_callback)(XmppStanza *stanza,
                                       void * const userdata);


XmppParser *parser_new(parser_start_callback startcb,
                     parser_end_callback endcb,
                     parser_stanza_callback stanzacb,
                     void *userdata);
void parser_free(XmppParser * const parser);
int parser_reset(XmppParser *parser);
int parser_feed(XmppParser *parser, char *chunk, int len);

#endif /* __PARSER_H__ */
