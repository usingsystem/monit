/* xmpp.c
** responsible for xmpp connection and authorization, and stream parse.
**
** Copyright (C) 2005-2009 Collecta, Inc. 
**
**  This software is provided AS-IS with no warranty, either express 
**  or implied.
**
**  This software is distributed under license and may not be copied,
**  modified or distributed except as expressly authorized under the
**  terms of the license contained in the file LICENSE.txt in this
**  distribution.
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <stdint.h>
#include <unistd.h>

#include "log.h"
#include "anet.h"
#include "xmpp.h"
#include "zmalloc.h"

/** @def DEFAULT_SEND_QUEUE_MAX
 *  The default maximum send queue size.
 */
#define DEFAULT_SEND_QUEUE_MAX 64

/** @def DISCONNECT_TIMEOUT 
 *  The time to wait (in milliseconds) for graceful disconnection to
 *  complete before the connection is reset.
 */
#define DISCONNECT_TIMEOUT 2000 /* 2 seconds */

/** @def CONNECT_TIMEOUT
 *  The time to wait (in milliseconds) for a connection attempt to succeed 
 * or error.  The default is 5 seconds.
 */
#define CONNECT_TIMEOUT 10000 /* 5 seconds */

static int _disconnect_cleanup(XmppConn * const conn, 
			       void * const userdata);

static void _handle_stream_start(char *name, char **attrs, 
                                 void * const userdata);
static void _handle_stream_end(char *name,
                               void * const userdata);
static void _handle_stream_stanza(XmppStanza *stanza,
                                  void * const userdata);

/** Return an integer based time stamp.
 *  This function uses gettimeofday or timeGetTime (on Win32 platforms) to
 *  compute an integer based time stamp.  This is used internally by the
 *  event loop and timed handlers.
 *
 *  @return an integer time stamp
 */
uint64_t time_stamp(void) {
    struct timeval tv;

    gettimeofday(&tv, NULL);

    return (uint64_t)tv.tv_sec * 1000 + (uint64_t)tv.tv_usec / 1000;
}

/** Get the time elapsed between two time stamps.
 *  This function returns the time elapsed between t1 and t2 by subtracting
 *  t1 from t2.  If t2 happened before t1, the result will be negative.  This
 *  function is used internally by the event loop and timed handlers.
 *
 *  @param t1 first time stamp
 *  @param t2 second time stamp
 *
 *  @return number of milliseconds between the stamps
 */
uint64_t time_elapsed(uint64_t t1, uint64_t t2) {
    return (uint64_t)(t2 - t1);
}

XmppConn *xmpp_conn_new()
{
    XmppConn *conn = NULL;

	conn = zmalloc(sizeof(XmppConn));
    
    if (conn == NULL) return NULL;

	conn->type = XMPP_UNKNOWN;
	conn->fd = -1;
	conn->timeout_stamp = 0;
	conn->error = 0;
	conn->stream_error = NULL;
    conn->buddies = NULL;

	/* default send parameters */
	conn->blocking_send = 0;
	conn->send_queue_max = DEFAULT_SEND_QUEUE_MAX;
	conn->send_queue_len = 0;
	conn->send_queue_head = NULL;
	conn->send_queue_tail = NULL;

	/* default timeouts */
	conn->connect_timeout = CONNECT_TIMEOUT;

	conn->lang = strdup("en");
	if (!conn->lang) {
	    zfree(conn);
	    return NULL;
	}
	conn->domain = NULL;
	conn->jid = NULL;
	conn->pass = NULL;
	conn->stream_id = NULL;
    conn->bound_jid = NULL;

    conn->secured = 0;

	conn->bind_required = 0;
	conn->session_required = 0;

	conn->parser = parser_new(_handle_stream_start,
                          _handle_stream_end,
                          _handle_stream_stanza,
                          conn);
    conn->reset_parser = 0;
    conn_prepare_reset(conn, auth_handle_open);

	conn->authenticated = 0;
	conn->conn_handler = NULL;
	conn->userdata = NULL;
	conn->timed_handlers = NULL;
	/* we own (and will free) the hash values */
	conn->id_handlers = hash_new(32, NULL);
	conn->handlers = NULL;

	/* give the caller a reference to connection */
	conn->ref = 1;

    return conn;
}

/** Destroy a connection object.
 *  Decrement the reference count by one for a connection, freeing the 
 *  connection object if the count reaches 0.
 *
 *  @param conn a Strophe connection object
 *
 *  @return TRUE if the connection object was freed and FALSE otherwise
 *
 *  @ingroup Connections
 */
void xmpp_conn_destroy(XmppConn* const conn)
{
    XmppBuddy *thb, *buddy;
    xmpp_handlist_t *hlitem, *thli;
    hash_iterator_t *iter;
    const char *key;

    buddy = conn->buddies;
    while(buddy) {
        thb = buddy;
        buddy = buddy->next;
        zfree(buddy);
    }

    conn->buddies = NULL;

    /* free handler stuff
     * note that userdata is the responsibility of the client
     * and the handler pointers don't need to be freed since they
     * are pointers to functions */

    hlitem = conn->timed_handlers;
    while (hlitem) {
        thli = hlitem;
        hlitem = hlitem->next;

        zfree(thli);
    }

    /* id handlers
     * we have to traverse the hash table freeing list elements 
     * then release the hash table */
    iter = hash_iter_new(conn->id_handlers);
    while ((key = hash_iter_next(iter))) {
        hlitem = (xmpp_handlist_t *)hash_get(conn->id_handlers, key);
        while (hlitem) {
        thli = hlitem;
        hlitem = hlitem->next;
        zfree(thli->id);
        zfree(thli);
        }
    }
    hash_iter_release(iter);
    hash_release(conn->id_handlers);

    hlitem = conn->handlers;
    while (hlitem) {
        thli = hlitem;
        hlitem = hlitem->next;

        if (thli->ns) zfree(thli->ns);
        if (thli->name) zfree(thli->name);
        if (thli->type) zfree(thli->type);
        zfree(thli);
    }

    if (conn->stream_error) {
        xmpp_stanza_release(conn->stream_error->stanza);
        if (conn->stream_error->text)
        zfree(conn->stream_error->text);
        zfree(conn->stream_error);
    }

        parser_free(conn->parser);
    
    if (conn->domain) zfree(conn->domain);
    if (conn->jid) zfree(conn->jid);
    if (conn->bound_jid) zfree(conn->bound_jid);
    if (conn->pass) zfree(conn->pass);
    if (conn->stream_id) zfree(conn->stream_id);
    if (conn->lang) zfree(conn->lang);
    zfree(conn);
}

/** Get the JID which is or will be bound to the connection.
 *  
 *  @param conn a Strophe connection object
 *
 *  @return a string containing the full JID or NULL if it has not been set
 *
 *  @ingroup Connections
 */
const char *xmpp_conn_get_jid(const XmppConn* const conn)
{
    return conn->jid;
}

/**
 * Get the JID discovered during binding time.
 *
 * This JID will contain the resource used by the current connection.
 * This is useful in the case where a resource was not specified for
 * binding.
 *
 * @param conn a Strophe connection object.
 *
 * @return a string containing the full JID or NULL if it's not been discovered
 *
 * @ingroup Connections
 */
const char *xmpp_conn_get_bound_jid(const XmppConn* const conn)
{
    return conn->bound_jid;
}

/** Set the JID of the user that will be bound to the connection.
 *  If any JID was previously set, it will be discarded.  This should not be 
 *  be used after a connection is created.  The function will make a copy of
 *  the JID string.  If the supllied JID is missing the node, SASL
 *  ANONYMOUS authentication will be used.
 *
 *  @param conn a Strophe connection object
 *  @param jid a full or bare JID
 *
 *  @ingroup Connections
 */
void xmpp_conn_set_jid(XmppConn* const conn, const char * const jid)
{
    if (conn->jid) zfree(conn->jid);
    conn->jid = strdup(jid);
}

/** Get the password used for authentication of a connection.
 *
 *  @param conn a Strophe connection object
 *
 *  @return a string containing the password or NULL if it has not been set
 *
 *  @ingroup Connections
 */
const char *xmpp_conn_get_pass(const XmppConn* const conn)
{
    return conn->pass;
}

/** Set the password used to authenticate the connection.
 *  If any password was previously set, it will be discarded.  The function
 *  will make a copy of the password string.
 * 
 *  @param conn a Strophe connection object
 *  @param pass the password
 *
 *  @ingroup Connections
 */
void xmpp_conn_set_pass(XmppConn* const conn, const char * const pass)
{
    if (conn->pass) zfree(conn->pass);
    conn->pass = strdup(pass);
}

int xmpp_conn_reset(XmppConn* const conn)
{
    if(conn->parser) {
        parser_free(conn->parser); 
    }

	conn->parser = parser_new(_handle_stream_start,
                          _handle_stream_end,
                          _handle_stream_stanza,
                          conn);
    conn->reset_parser = 0;
    conn_prepare_reset(conn, auth_handle_open);

    return 1;
}




/** Cleanly disconnect the connection.
 *  This function is only called by the stream parser when </stream:stream>
 *  is received, and it not intended to be called by code outside of Strophe.
 *
 *  @param conn a Strophe connection object
 */
void conn_disconnect_clean(XmppConn* const conn)
{
    /* remove the timed handler */
    xmpp_timed_handler_delete(conn, _disconnect_cleanup);

    conn_disconnect(conn);
}

/** Disconnect from the XMPP server.
 *  This function immediately disconnects from the XMPP server, and should
 *  not be used outside of the Strophe library.
 *
 *  @param conn a Strophe connection object
 */
void conn_disconnect(XmppConn* const conn) 
{
    debugLog("xmpp", "Closing socket.");
    conn->state = XMPP_STATE_DISCONNECTED;
    close(conn->fd);

    /* fire off connection handler */
    conn->conn_handler(conn, XMPP_CONN_DISCONNECT, conn->error,
		       conn->stream_error, conn->userdata);
}

/* prepares a parser reset.  this is called from handlers. we can't
 * reset the parser immediately as it is not re-entrant. */
void conn_prepare_reset(XmppConn* const conn, xmpp_open_handler handler)
{
    conn->reset_parser = 1;
    conn->open_handler = handler;
}

/* reset the parser */
void conn_parser_reset(XmppConn* const conn)
{
    conn->reset_parser = 0;
    parser_reset(conn->parser);
}

/* timed handler for cleanup if normal disconnect procedure takes too long */
static int _disconnect_cleanup(XmppConn* const conn, 
			       void * const userdata)
{
    debugLog("xmpp", "disconnection forced by cleanup timeout");

    conn_disconnect(conn);

    return 0;
}

/** Initiate termination of the connection to the XMPP server.
 *  This function starts the disconnection sequence by sending
 *  </stream:stream> to the XMPP server.  This function will do nothing
 *  if the connection state is CONNECTING or CONNECTED.
 *
 *  @param conn a Strophe connection object
 *
 *  @ingroup Connections
 */
void xmpp_disconnect(XmppConn* const conn)
{
    if (conn->state != XMPP_STATE_CONNECTING &&
	conn->state != XMPP_STATE_CONNECTED)
	return;

    /* close the stream */
    xmpp_send_raw_string(conn, "</stream:stream>");

    /* setup timed handler in case disconnect takes too long */
    handler_add_timed(conn, _disconnect_cleanup,
		      DISCONNECT_TIMEOUT, NULL);
}

/** Send a raw string to the XMPP server.
 *  This function is a convenience function to send raw string data to the 
 *  XMPP server.  It is used by Strophe to send short messages instead of
 *  building up an XML stanza with DOM methods.  This should be used with care
 *  as it does not validate the data; invalid data may result in immediate
 *  stream termination by the XMPP server.
 *
 *  @param conn a Strophe connection object
 *  @param fmt a printf-style format string followed by a variable list of
 *      arguments to format
 */
void xmpp_send_raw_string(XmppConn* const conn, 
			  const char * const fmt, ...)
{
    va_list ap;
    size_t len;
    char buf[1024]; /* small buffer for common case */
    char *bigbuf;

    va_start(ap, fmt);
    len = vsnprintf(buf, 1024, fmt, ap);
    va_end(ap);

    if (len >= 1024) {
	/* we need more space for this data, so we allocate a big 
	 * enough buffer and print to that */
	len++; /* account for trailing \0 */
	bigbuf = zmalloc(len);
	if (!bigbuf) {
	    debugLog("xmpp", "Could not allocate memory for send_raw_string");
	    return;
	}
	va_start(ap, fmt);
	vsnprintf(bigbuf, len, fmt, ap);
	va_end(ap);

    printf("%s \n", bigbuf);

	debugLog("conn", "SENT: %s", bigbuf);

	/* len - 1 so we don't send trailing \0 */
	xmpp_send_raw(conn, bigbuf, len - 1);

	zfree(bigbuf);
    } else {
	debugLog("conn", "SENT: %s", buf);

	xmpp_send_raw(conn, buf, len);
    }
}

/** Send raw bytes to the XMPP server.
 *  This function is a convenience function to send raw bytes to the 
 *  XMPP server.  It is usedly primarly by xmpp_send_raw_string.  This 
 *  function should be used with care as it does not validate the bytes and
 *  invalid data may result in stream termination by the XMPP server.
 *
 *  @param conn a Strophe connection object
 *  @param data a buffer of raw bytes
 *  @param len the length of the data in the buffer
 */
void xmpp_send_raw(XmppConn* const conn,
		   const char * const data, const size_t len)
{

    anetWrite(conn->fd, data, len);

}

/** Send an XML stanza to the XMPP server.
 *  This is the main way to send data to the XMPP server.  The function will
 *  terminate without action if the connection state is not CONNECTED.
 *
 *  @param conn a Strophe connection object
 *  @param stanza a Strophe stanza object
 *
 *  @ingroup Connections
 */
void xmpp_send(XmppConn* const conn,
	       XmppStanza * const stanza)
{
    char *buf;
    size_t len;
    int ret;

    if (conn->state == XMPP_STATE_CONNECTED) {
	if ((ret = XmppStanzao_text(stanza, &buf, &len)) == 0) {
	    xmpp_send_raw(conn, buf, len);
	    debugLog("conn", "SENT: %s", buf);
	    zfree(buf);
	}
    }
}

/** Send the opening &lt;stream:stream&gt; tag to the server.
 *  This function is used by Strophe to begin an XMPP stream.  It should
 *  not be used outside of the library.
 *
 *  @param conn a Strophe connection object
 */
void conn_open_stream(XmppConn* const conn)
{
    xmpp_send_raw_string(conn, 
			 "<?xml version=\"1.0\"?>"			\
			 "<stream:stream to=\"%s\" "			\
			 "xml:lang=\"%s\" "				\
			 "version=\"1.0\" "				\
			 "xmlns=\"%s\" "				\
			 "xmlns:stream=\"%s\">", 
			 conn->domain,
			 conn->lang,
			 conn->type == XMPP_CLIENT ? XMPP_NS_CLIENT : XMPP_NS_COMPONENT,
			 XMPP_NS_STREAMS);
}

static void _log_open_tag(XmppConn*conn, char **attrs)
{
    char buf[4096];
    size_t len, pos;
    int i;
    
    if (!attrs) return;

    pos = 0;
    len = snprintf(buf, 4096, "<stream:stream");
    if (len < 0) return;
    
    pos += len;
    
    for (i = 0; attrs[i]; i += 2) {
        len = snprintf(&buf[pos], 4096 - pos, " %s='%s'",
                            attrs[i], attrs[i+1]);
        if (len < 0) return;
        pos += len;
    }

    len = snprintf(&buf[pos], 4096 - pos, ">");
    if (len < 0) return;

    debugLog("xmpp", "RECV: %s", buf);
}

static char *_get_stream_attribute(char **attrs, char *name)
{
    int i;

    if (!attrs) return NULL;

    for (i = 0; attrs[i]; i += 2)
        if (strcmp(name, attrs[i]) == 0)
            return attrs[i+1];

    return NULL;
}

static void _handle_stream_start(char *name, char **attrs, 
                                 void * const userdata)
{
    XmppConn *conn = (XmppConn *)userdata;
    char *id;

    if (strcmp(name, "stream:stream") != 0) {
        printf("name = %s\n", name);
        errorLog("conn", "Server did not open valid stream.");
        conn_disconnect(conn);
    } else {
        _log_open_tag(conn, attrs);
        
        if (conn->stream_id) zfree(conn->stream_id);

        id = _get_stream_attribute(attrs, "id");
        if (id)
            conn->stream_id = strdup(id);

        if (!conn->stream_id) {
            errorLog("conn", "Memory allocation failed.");
            conn_disconnect(conn);
        }
    }
    
    /* call stream open handler */
    conn->open_handler(conn);
}

static void _handle_stream_end(char *name,
                               void * const userdata)
{
    XmppConn *conn = (XmppConn *)userdata;

    /* stream is over */
    debugLog("xmpp", "RECV: </stream:stream>");
    conn_disconnect_clean(conn);
}

static void _handle_stream_stanza(XmppStanza *stanza,
                                  void * const userdata)
{
    XmppConn *conn = (XmppConn *)userdata;
    char *buf;
    size_t len;

    if (XmppStanzao_text(stanza, &buf, &len) == 0) {
        debugLog("xmpp", "RECV: %s", buf);
        zfree(buf);
    }

    handler_fire_stanza(conn, stanza);
}

/** Shutdown the Strophe library.
 *
 *  @ingroup Init
 */
void xmppShutdown(void) {
    //sock_shutdown();
}


/** Fire off all stanza handlers that match.
 *  This function is called internally by the event loop whenever stanzas
 *  are received from the XMPP server.
 *
 *  @param conn a Strophe connection object
 *  @param stanza a Strophe stanza object
 */
void handler_fire_stanza(XmppConn * const conn,
			 XmppStanza * const stanza) {

    xmpp_handlist_t *item, *prev;
    char *id, *ns, *name, *type;
    
    /* call id handlers */
    id = xmpp_stanza_get_id(stanza);
    if (id) {
	prev = NULL;
 	item = (xmpp_handlist_t *)hash_get(conn->id_handlers, id);
	while (item) {
	    xmpp_handlist_t *next = item->next;

	    if (item->user_handler && !conn->authenticated) {
		item = next;
 		continue;
	    }

	    if (!((xmpp_handler)(item->handler))(conn, stanza, item->userdata)) {
		/* handler is one-shot, so delete it */
		if (prev)
		    prev->next = next;
		else {
		    hash_drop(conn->id_handlers, id);
		    hash_add(conn->id_handlers, id, next);
		}
                zfree(item->id);
		zfree(item);
		item = NULL;
	    }
	    if (item)
		prev = item;
	    item = next;
	}
    }
    
    /* call handlers */
    ns = xmpp_stanza_get_ns(stanza);
    name = xmpp_stanza_get_name(stanza);
    type = xmpp_stanza_get_type(stanza);
    
    /* enable all added handlers */
    for (item = conn->handlers; item; item = item->next)
	item->enabled = 1;

    prev = NULL;
    item = conn->handlers;
    while (item) {
	/* skip newly added handlers */
	if (!item->enabled) {
	    prev = item;
	    item = item->next;
	    continue;
	}

	/* don't call user handlers until authentication succeeds */
	if (item->user_handler && !conn->authenticated) {
	    prev = item;
	    item = item->next;
	    continue;
	}

	if ((!item->ns || (ns && strcmp(ns, item->ns) == 0) ||
	     xmpp_stanza_get_child_by_ns(stanza, item->ns)) &&
	    (!item->name || (name && strcmp(name, item->name) == 0)) &&
	    (!item->type || (type && strcmp(type, item->type) == 0)))
	    if (!((xmpp_handler)(item->handler))(conn, stanza, item->userdata)) {
		/* handler is one-shot, so delete it */
		if (prev)
		    prev->next = item->next;
		else
		    conn->handlers = item->next;
                if (item->ns) zfree(item->ns);
                if (item->name) zfree(item->name);
                if (item->type) zfree(item->type);
		zfree(item);
		item = NULL;
	    }
	
	if (item) {
	    prev = item;
	    item = item->next;
	} else if (prev)
	    item = prev->next;
	else
	    item = conn->handlers;
    }
}

/** Fire off all timed handlers that are ready.
 *  This function is called internally by the event loop.
 *
 *  @param ctx a Strophe context object
 *
 *  @return the time in milliseconds until the next handler will be ready
 */
uint64_t handler_fire_timed(XmppConn *conn)
{
    xmpp_handlist_t *handitem, *temp;
    int ret, fired;
    uint64_t elapsed, min;

    min = (uint64_t)(-1);

	//if (conn->state != XMPP_STATE_CONNECTED) {
        //TODO: how to handle disconnection?
	//    return min;
	//}
	
	/* enable all handlers that were added */
	for (handitem = conn->timed_handlers; handitem; 
        handitem = handitem->next)
	    handitem->enabled = 1;

	handitem = conn->timed_handlers;
	while (handitem) {
	    /* skip newly added handlers */
	    if (!handitem->enabled) {
            handitem = handitem->next;
            continue;
	    }

	    /* only fire user handlers after authentication */
	    if (handitem->user_handler && !conn->authenticated) {
            handitem = handitem->next;
            continue;
	    }

	    fired = 0;
	    elapsed = time_elapsed(handitem->last_stamp, time_stamp());
	    if (elapsed >= handitem->period) {
            /* fire! */
            fired = 1;
            handitem->last_stamp = time_stamp();
            ret = ((xmpp_timed_handler)handitem->handler)(conn, handitem->userdata);
	    } else if (min > (handitem->period - elapsed))
            min = handitem->period - elapsed;
		
	    temp = handitem;
	    handitem = handitem->next;

	    /* delete handler if it returned false */
	    if (fired && !ret)
            xmpp_timed_handler_delete(conn, temp->handler);
	}

    return min;
}

/** Reset all timed handlers.
 *  This function is called internally when a connection is successful.
 *
 *  @param conn a Strophe connection object
 *  @param user_only whether to reset all handlers or only user ones
 */
void handler_reset_timed(XmppConn *conn, int user_only)
{
    xmpp_handlist_t *handitem;

    handitem = conn->timed_handlers;
    while (handitem) {
	if ((user_only && handitem->user_handler) || !user_only)
	    handitem->last_stamp = time_stamp();
	
	handitem = handitem->next;
    }
}

static void _timed_handler_add(XmppConn * const conn,
			       xmpp_timed_handler handler,
			       const unsigned long period,
			       void * const userdata, 
			       const int user_handler)
{
    xmpp_handlist_t *item, *tail;

    /* check if handler is already in the list */
    for (item = conn->timed_handlers; item; item = item->next) {
	if (item->handler == (void *)handler)
	    break;
    }
    if (item) return;

    /* build new item */
    item = zmalloc(sizeof(xmpp_handlist_t));
    if (!item) return;

    item->user_handler = user_handler;
    item->handler = (void *)handler;
    item->userdata = userdata;
    item->enabled = 0;
    item->next = NULL;

    item->period = period;
    item->last_stamp = time_stamp();

    /* append item to list */
    if (!conn->timed_handlers)
	conn->timed_handlers = item;
    else {
	tail = conn->timed_handlers;
	while (tail->next) 
	    tail = tail->next;
	tail->next = item;
    }
}

/** Delete a timed handler.
 *
 *  @param conn a Strophe connection object
 *  @param handler function pointer to the handler
 *
 *  @ingroup Handlers
 */
void xmpp_timed_handler_delete(XmppConn * const conn,
			       xmpp_timed_handler handler)
{
    xmpp_handlist_t *item, *prev;

    if (!conn->timed_handlers) return;

    prev = NULL;
    item = conn->timed_handlers;
    while (item) {
	if (item->handler == (void *)handler)
	    break;
	prev = item;
	item = item->next;
    }

    if (item) {
	if (prev)
	    prev->next = item->next;
	else
	    conn->timed_handlers = item->next;
	
	zfree(item);
    }
}

static void _id_handler_add(XmppConn * const conn,
			 xmpp_handler handler,
			 const char * const id,
			 void * const userdata, int user_handler)
{
    xmpp_handlist_t *item, *tail;

    /* check if handler is already in the list */
    item = (xmpp_handlist_t *)hash_get(conn->id_handlers, id);
    while (item) {
	if (item->handler == (void *)handler)
	    break;
	item = item->next;
    }
    if (item) return;

    /* build new item */
    item = zmalloc(sizeof(xmpp_handlist_t));
    if (!item) return;

    item->user_handler = user_handler;
    item->handler = (void *)handler;
    item->userdata = userdata;
    item->enabled = 0;
    item->next = NULL;

    item->id = strdup(id);
    if (!item->id) {
	zfree(item);
	return;
    }

    /* put on list in hash table */
    tail = (xmpp_handlist_t *)hash_get(conn->id_handlers, id);
    if (!tail)
	hash_add(conn->id_handlers, id, item);
    else {
	while (tail->next) 
	    tail = tail->next;
	tail->next = item;
    }
}

/** Delete an id based stanza handler.
 *
 *  @param conn a Strophe connection object
 *  @param handler a function pointer to a stanza handler
 *  @param id a string containing the id the handler is for
 *
 *  @ingroup Handlers
 */
void xmpp_id_handler_delete(XmppConn * const conn,
			    xmpp_handler handler,
			    const char * const id)
{
    xmpp_handlist_t *item, *prev;

    prev = NULL;
    item = (xmpp_handlist_t *)hash_get(conn->id_handlers, id);
    if (!item) return;

    while (item) {
	if (item->handler == (void *)handler)
	    break;

	prev = item;
	item = item->next;
    }

    if (item) {
	if (prev)
	    prev->next = item->next;
	else {
	    hash_drop(conn->id_handlers, id);
	    hash_add(conn->id_handlers, id, item->next);
	}
	zfree(item->id);
	zfree(item);
    }
}

/* add a stanza handler */
static void _handler_add(XmppConn * const conn,
			 xmpp_handler handler,
			 const char * const ns,
			 const char * const name,
			 const char * const type,
			 void * const userdata, int user_handler)
{
    xmpp_handlist_t *item, *tail;

    /* check if handler already in list */
    for (item = conn->handlers; item; item = item->next) {
	if (item->handler == (void *)handler)
	    break;
    }
    if (item) return;

    /* build new item */
    item = (xmpp_handlist_t *)zmalloc(sizeof(xmpp_handlist_t));
    if (!item) return;

    item->user_handler = user_handler;
    item->handler = (void *)handler;
    item->userdata = userdata;
    item->enabled = 0;
    item->next = NULL;
    
    if (ns) {
	item->ns = strdup(ns);
	if (!item->ns) {
	    zfree(item);
	    return;
	}
    } else
	item->ns = NULL;
    if (name) {
	item->name = strdup(name);
	if (!item->name) {
	    if (item->ns) zfree(item->ns);
	    zfree(item);
	    return;
	}
    } else
	item->name = NULL;
    if (type) {
	item->type = strdup(type);
	if (!item->type) {
	    if (item->ns) zfree(item->ns);
	    if (item->name) zfree(item->name);
	    zfree(item);
	}
    } else
	item->type = NULL;

    /* append to list */
    if (!conn->handlers)
	conn->handlers = item;
    else {
	tail = conn->handlers;
	while (tail->next) 
	    tail = tail->next;
	tail->next = item;
    }
}

/** Delete a stanza handler.
 *
 *  @param conn a Strophe connection object
 *  @param handler a function pointer to a stanza handler
 *
 *  @ingroup Handlers
 */
void xmpp_handler_delete(XmppConn * const conn,
			 xmpp_handler handler)
{
    xmpp_handlist_t *prev, *item;

    if (!conn->handlers) return;

    prev = NULL;
    item = conn->handlers;
    while (item) {
	if (item->handler == (void *)handler)
	    break;
	
	prev = item;
	item = item->next;
    }

    if (item) {
	if (prev)
	    prev->next = item->next;
	else
	    conn->handlers = item->next;

	if (item->ns) zfree(item->ns);
	if (item->name) zfree(item->name);
	if (item->type) zfree(item->type);
	zfree(item);
    }
}

/** Add a timed handler.
 *  The handler will fire for the first time once the period has elapsed,
 *  and continue firing regularly after that.  Strophe will try its best
 *  to fire handlers as close to the period times as it can, but accuracy
 *  will vary depending on the resolution of the event loop.
 *   
 *  @param conn a Strophe connection object
 *  @param handler a function pointer to a timed handler
 *  @param period the time in milliseconds between firings
 *  @param userdata an opaque data pointer that will be passed to the handler
 *
 *  @ingroup Handlers
 */
void xmpp_timed_handler_add(XmppConn * const conn,
			    xmpp_timed_handler handler,
			    const unsigned long period,
			    void * const userdata)
{
    _timed_handler_add(conn, handler, period, userdata, 1);
}

/** Add a timed system handler.
 *  This function is used to add internal timed handlers and should not be
 *  used outside of the library.
 *
 *  @param conn a Strophe connection object
 *  @param handler a function pointer to a timed handler
 *  @param period the time in milliseconds between firings
 *  @param userdata an opaque data pointer that will be passed to the handler
 */
void handler_add_timed(XmppConn * const conn,
		       xmpp_timed_handler handler,
		       const unsigned long period,
		       void * const userdata)
{
    _timed_handler_add(conn, handler, period, userdata, 0);
}

/** Add an id based stanza handler.

 *  This function adds a stanza handler for an &lt;iq/&gt; stanza of
 *  type 'result' or 'error' with a specific id attribute.  This can
 *  be used to handle responses to specific &lt;iq/&gt;s.
 *
 *  @param conn a Strophe connection object
 *  @param handler a function pointer to a stanza handler
 *  @param id a string with the id
 *  @param userdata an opaque data pointer that will be passed to the handler
 *
 *  @ingroup Handlers
 */
void xmpp_id_handler_add(XmppConn * const conn,
			 xmpp_handler handler,
			 const char * const id,
			 void * const userdata)
{
    _id_handler_add(conn, handler, id, userdata, 1);
}

/** Add an id based system stanza handler.
 *  This function is used to add internal id based stanza handlers and should
 *  not be used outside of the library.
 *
 *  @param conn a Strophe connection object
 *  @param handler a function pointer to a stanza handler
 *  @param id a string with the id
 *  @param userdata an opaque data pointer that will be passed to the handler
 */
void handler_add_id(XmppConn * const conn,
		    xmpp_handler handler,
		    const char * const id,
		    void * const userdata)
{
    _id_handler_add(conn, handler, id, userdata, 0);
}

/** Add a stanza handler.
 *  This function is used to add a stanza handler to a connection.
 *  The handler will be called when the any of the filters match.  The
 *  name filter matches to the top level stanza name.  The type filter
 *  matches the 'type' attribute of the top level stanza.  The ns
 *  filter matches the namespace ('xmlns' attribute) of either the top
 *  level stanza or any of it's immediate children (this allows you do
 *  handle specific &lt;iq/&gt; stanzas based on the &lt;query/&gt;
 *  child namespace.
 *
 *  @param conn a Strophe connection object
 *  @param handler a function pointer to a stanza handler
 *  @param ns a string with the namespace to match
 *  @param name a string with the stanza name to match
 *  @param type a string with the 'type' attribute to match
 *  @param userdata an opaque data pointer that will be passed to the handler
 *
 *  @ingroup Handlers
 */
void xmpp_handler_add(XmppConn * const conn,
		      xmpp_handler handler,
		      const char * const ns,
		      const char * const name,
		      const char * const type,
		      void * const userdata) {
    _handler_add(conn, handler, ns, name, type, userdata, 1);
}

/** Add a system stanza handler.
 *  This function is used to add internal stanza handlers and should
 *  not be used outside of the library.
 *
 *  @param conn a Strophe connection object
 *  @param handler a function pointer to a stanza handler
 *  @param ns a string with the namespace to match
 *  @param name a string with the stanza name to match
 *  @param type a string with the 'type' attribute value to match
 *  @param userdata an opaque data pointer that will be passed to the handler
 */
void handler_add(XmppConn * const conn,
		 xmpp_handler handler,
		 const char * const ns,
		 const char * const name,
		 const char * const type,
		 void * const userdata) {
    _handler_add(conn, handler, ns, name, type, userdata, 0);
}
