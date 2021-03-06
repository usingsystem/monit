/* auth.c
** strophe XMPP client library -- auth functions and handlers
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
 *  Authentication function and handlers.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "log.h"
#include "jid.h"
#include "xmpp.h"
#include "sasl.h"
#include "zmalloc.h"

/* TODO: these should configurable at runtime on a per connection basis  */

#ifndef FEATURES_TIMEOUT
/** @def FEATURES_TIMEOUT
 *  Time to wait for &lt;stream:features/&gt; stanza.
 */
#define FEATURES_TIMEOUT 15000 /* 15 seconds */
#endif
#ifndef BIND_TIMEOUT
/** @def BIND_TIMEOUT
 *  Time to wait for &lt;bind/&gt; stanza reply.
 */
#define BIND_TIMEOUT 15000 /* 15 seconds */
#endif
#ifndef SESSION_TIMEOUT
/** @def SESSION_TIMEOUT
 *  Time to wait for &lt;session/&gt; stanza reply.
 */
#define SESSION_TIMEOUT 15000 /* 15 seconds */
#endif
#ifndef LEGACY_TIMEOUT
/** @def LEGACY_TIMEOUT
 *  Time to wait for legacy authentication to complete.
 */
#define LEGACY_TIMEOUT 15000 /* 15 seconds */
#endif

static void _auth(XmppConn * const conn);
static void _handle_open_sasl(XmppConn * const conn);
static int _handle_missing_legacy(XmppConn * const conn,
				  void * const userdata);
static int _handle_legacy(XmppConn * const conn,
			  XmppStanza * const stanza,
			  void * const userdata);
static int _handle_features_sasl(XmppConn * const conn,
				 XmppStanza * const stanza,
				 void * const userdata);
static int _handle_sasl_result(XmppConn * const conn,
			XmppStanza * const stanza,
			void * const userdata);
static int _handle_digestmd5_challenge(XmppConn * const conn,
			XmppStanza * const stanza,
			void * const userdata);
static int _handle_digestmd5_rspauth(XmppConn * const conn,
			XmppStanza * const stanza,
			void * const userdata);

static int _handle_missing_features_sasl(XmppConn * const conn,
					 void * const userdata);
static int _handle_missing_bind(XmppConn * const conn,
				void * const userdata);
static int _handle_bind(XmppConn * const conn,
			XmppStanza * const stanza,
			void * const userdata);
static int _handle_session(XmppConn * const conn,
			   XmppStanza * const stanza,
			   void * const userdata);
static int _handle_missing_session(XmppConn * const conn,
				   void * const userdata);

/* stream:error handler */
static int _handle_error(XmppConn * const conn,
			 XmppStanza * const stanza,
			 void * const userdata)
{
    XmppStanza *child;
    char *name;

    /* free old stream error if it's still there */
    if (conn->stream_error) {
	xmpp_stanza_release(conn->stream_error->stanza);
	if (conn->stream_error->text) 
	    zfree(conn->stream_error->text);
	zfree(conn->stream_error);
    }

    /* create stream error structure */
    conn->stream_error = (xmpp_stream_error_t *)zmalloc(sizeof(xmpp_stream_error_t));

	conn->stream_error->text = NULL;
	conn->stream_error->type = XMPP_SE_UNDEFINED_CONDITION;

    if (conn->stream_error) {
	child = xmpp_stanza_get_children(stanza);
	do {
	    char *ns = NULL;

	    if (child) {
		ns = xmpp_stanza_get_ns(child);
	    }

	    if (ns && strcmp(ns, XMPP_NS_STREAMS_IETF) == 0) {
		name = xmpp_stanza_get_name(child);
		if (strcmp(name, "text") == 0) {
		    if (conn->stream_error->text)
			zfree(conn->stream_error->text);
		    conn->stream_error->text = xmpp_stanza_get_text(child);
		} else if (strcmp(name, "bad-format") == 0)
		    conn->stream_error->type = XMPP_SE_BAD_FORMAT;
		else if (strcmp(name, "bad-namespace-prefix") == 0)
		    conn->stream_error->type = XMPP_SE_BAD_NS_PREFIX;
		else if (strcmp(name, "conflict") == 0)
		    conn->stream_error->type = XMPP_SE_CONFLICT;
		else if (strcmp(name, "connection-timeout") == 0)
		    conn->stream_error->type = XMPP_SE_CONN_TIMEOUT;
		else if (strcmp(name, "host-gone") == 0)
		    conn->stream_error->type = XMPP_SE_HOST_GONE;
		else if (strcmp(name, "host-unknown") == 0)
		    conn->stream_error->type = XMPP_SE_HOST_UNKNOWN;
		else if (strcmp(name, "improper-addressing") == 0)
		    conn->stream_error->type = XMPP_SE_IMPROPER_ADDR;
		else if (strcmp(name, "internal-server-error") == 0)
		    conn->stream_error->type = XMPP_SE_INTERNAL_SERVER_ERROR;
		else if (strcmp(name, "invalid-from") == 0)
		    conn->stream_error->type = XMPP_SE_INVALID_FROM;
		else if (strcmp(name, "invalid-id") == 0)
		    conn->stream_error->type = XMPP_SE_INVALID_ID;
		else if (strcmp(name, "invalid-namespace") == 0)
		    conn->stream_error->type = XMPP_SE_INVALID_NS;
		else if (strcmp(name, "invalid-xml") == 0)
		    conn->stream_error->type = XMPP_SE_INVALID_XML;
		else if (strcmp(name, "not-authorized") == 0)
		    conn->stream_error->type = XMPP_SE_NOT_AUTHORIZED;
		else if (strcmp(name, "policy-violation") == 0)
		    conn->stream_error->type = XMPP_SE_POLICY_VIOLATION;
		else if (strcmp(name, "remote-connection-failed") == 0)
		    conn->stream_error->type = XMPP_SE_REMOTE_CONN_FAILED;
		else if (strcmp(name, "resource-constraint") == 0)
		    conn->stream_error->type = XMPP_SE_RESOURCE_CONSTRAINT;
		else if (strcmp(name, "restricted-xml") == 0)
		    conn->stream_error->type = XMPP_SE_RESTRICTED_XML;
		else if (strcmp(name, "see-other-host") == 0)
		    conn->stream_error->type = XMPP_SE_SEE_OTHER_HOST;
		else if (strcmp(name, "system-shutdown") == 0)
		    conn->stream_error->type = XMPP_SE_SYSTEM_SHUTDOWN;
		else if (strcmp(name, "undefined-condition") == 0)
		    conn->stream_error->type = XMPP_SE_UNDEFINED_CONDITION;
		else if (strcmp(name, "unsupported-encoding") == 0)
		    conn->stream_error->type = XMPP_SE_UNSUPPORTED_ENCODING;
		else if (strcmp(name, "unsupported-stanza-type") == 0)
		    conn->stream_error->type = XMPP_SE_UNSUPPORTED_STANZA_TYPE;
		else if (strcmp(name, "unsupported-version") == 0)
		    conn->stream_error->type = XMPP_SE_UNSUPPORTED_VERSION;
		else if (strcmp(name, "xml-not-well-formed") == 0)
		    conn->stream_error->type = XMPP_SE_XML_NOT_WELL_FORMED;
	    }
	} while ((child = xmpp_stanza_get_next(child)));

	conn->stream_error->stanza = xmpp_stanza_clone(stanza);
    }

    return 1;
}

/* stream:features handlers */
static int _handle_missing_features(XmppConn * const conn,
				    void * const userdata)
{
    debugLog("xmpp", "didn't get stream features");

    /* legacy auth will be attempted */
    _auth(conn);

    return 0;
}



static int _handle_features(XmppConn * const conn,
			    XmppStanza * const stanza,
			    void * const userdata)
{
    XmppStanza *child, *mech;
    char *text;

    /* remove the handler that detects missing stream:features */
    xmpp_timed_handler_delete(conn, _handle_missing_features);

    /* check for SASL */
    child = xmpp_stanza_get_child_by_name(stanza, "mechanisms");
    if (child && (strcmp(xmpp_stanza_get_ns(child), XMPP_NS_SASL) == 0)) {
	for (mech = xmpp_stanza_get_children(child); mech; 
	     mech = xmpp_stanza_get_next(mech)) {
	    if (strcmp(xmpp_stanza_get_name(mech), "mechanism") == 0) {
		text = xmpp_stanza_get_text(mech);
		if (strcasecmp(text, "PLAIN") == 0)
		    conn->sasl_support |= SASL_MASK_PLAIN;
		else if (strcasecmp(text, "DIGEST-MD5") == 0)
		    conn->sasl_support |= SASL_MASK_DIGESTMD5;
		else if (strcasecmp(text, "ANONYMOUS") == 0)
		    conn->sasl_support |= SASL_MASK_ANONYMOUS;

		zfree(text);
	    }
	}
    }

    _auth(conn);
 
    return 0;
}

/* returns the correct auth id for a component or a client.
 * returned string must be freed by caller */
static char *_get_authid(XmppConn * const conn)
{
	/* authid is the node portion of jid */
	if (!conn->jid) return NULL;
	return jid_node(conn->jid);
}

static int _handle_sasl_result(XmppConn * const conn,
			       XmppStanza * const stanza,
			       void * const userdata)
{
    char *name;

    name = xmpp_stanza_get_name(stanza);

    /* the server should send a <success> or <failure> stanza */
    if (strcmp(name, "failure") == 0) {
	debugLog("xmpp", "SASL %s auth failed", 
		   (char *)userdata);
	
	/* fall back to next auth method */
	_auth(conn);
    } else if (strcmp(name, "success") == 0) {
	/* SASL PLAIN auth successful, we need to restart the stream */
	debugLog("xmpp", "SASL %s auth successful", 
		   (char *)userdata);

	/* reset parser */
	conn_prepare_reset(conn, _handle_open_sasl);

	/* send stream tag */
	conn_open_stream(conn);
    } else {
	/* got unexpected reply */
	errorLog("xmpp", "Got unexpected reply to SASL %s"\
		   "authentication.", (char *)userdata);
	xmpp_disconnect(conn);
    }

    return 0;
}

/* handle the challenge phase of digest auth */
static int _handle_digestmd5_challenge(XmppConn * const conn,
			      XmppStanza * const stanza,
			      void * const userdata)
{
    char *text;
    char *response;
    XmppStanza *auth, *authdata;
    char *name;

    name = xmpp_stanza_get_name(stanza);
    debugLog("xmpp", "handle digest-md5 (challenge) called for %s", name);

    if (strcmp(name, "challenge") == 0) {
	text = xmpp_stanza_get_text(stanza);
	response = sasl_digest_md5(text, conn->jid, conn->pass);
	if (!response) {
        //TODO: //disconnect_mem_error(conn);
	    return 0;
	}
	zfree(text);

	auth = xmpp_stanza_new();
	if (!auth) {
        //TODO:
	    //disconnect_mem_error(conn);
	    return 0;
	}	
	xmpp_stanza_set_name(auth, "response");
	xmpp_stanza_set_ns(auth, XMPP_NS_SASL);
	
	authdata = xmpp_stanza_new();
	if (!authdata) {
        //TODO:
	    //disconnect_mem_error(conn);
	    return 0;
	}

	xmpp_stanza_set_text(authdata, response);
	zfree(response);

	xmpp_stanza_add_child(auth, authdata);
	xmpp_stanza_release(authdata);

	handler_add(conn, _handle_digestmd5_rspauth, 
		    XMPP_NS_SASL, NULL, NULL, NULL);

	xmpp_send(conn, auth);
	xmpp_stanza_release(auth);

    } else {
	return _handle_sasl_result(conn, stanza, "DIGEST-MD5");
    }

    /* remove ourselves */
    return 0;
}

/* handle the rspauth phase of digest auth */
static int _handle_digestmd5_rspauth(XmppConn * const conn,
			      XmppStanza * const stanza,
			      void * const userdata)
{
    XmppStanza *auth;
    char *name;

    name = xmpp_stanza_get_name(stanza);
    debugLog("xmpp", "handle digest-md5 (rspauth) called for %s", name);

    if (strcmp(name, "challenge") == 0) {
	/* assume it's an rspauth response */
	auth = xmpp_stanza_new();
	if (!auth) {
        //TODO
	    //disconnect_mem_error(conn);
	    return 0;
	}	
	xmpp_stanza_set_name(auth, "response");
	xmpp_stanza_set_ns(auth, XMPP_NS_SASL);
	xmpp_send(conn, auth);
	xmpp_stanza_release(auth);
    } else {
	return _handle_sasl_result(conn, stanza, "DIGEST-MD5");
    }

    return 1;
}


static XmppStanza *_make_sasl_auth(XmppConn * const conn,
				 const char * const mechanism)
{
    XmppStanza *auth;

    /* build auth stanza */
    auth = xmpp_stanza_new();
    if (auth) {
	xmpp_stanza_set_name(auth, "auth");
	xmpp_stanza_set_ns(auth, XMPP_NS_SASL);
	xmpp_stanza_set_attribute(auth, "mechanism", mechanism);
    }
    
    return auth;
}

/* authenticate the connection 
 * this may get called multiple times.  if any auth method fails, 
 * this will get called again until one auth method succeeds or every
 * method fails 
 */
static void _auth(XmppConn * const conn)
{
    XmppStanza *auth, *authdata, *query, *child, *iq;
    char *str, *authid;
    int anonjid;

    /* if there is no node in conn->jid, we assume anonymous connect */
    str = jid_node(conn->jid);
    if (str == NULL) {
	anonjid = 1;
    } else {
	zfree(str);
	anonjid = 0;
    }

    if (anonjid && conn->sasl_support & SASL_MASK_ANONYMOUS) {
	/* some crap here */
	auth = _make_sasl_auth(conn, "ANONYMOUS");
	if (!auth) {
        //TODO:
	    //disconnect_mem_error(conn);
	    return;
	}

	handler_add(conn, _handle_sasl_result, XMPP_NS_SASL,
	            NULL, NULL, "ANONYMOUS");

	xmpp_send(conn, auth);
	xmpp_stanza_release(auth);

	/* SASL ANONYMOUS was tried, unset flag */
	conn->sasl_support &= ~SASL_MASK_ANONYMOUS;
    } else if (anonjid) {
	errorLog("auth", "No node in JID, and SASL ANONYMOUS unsupported.");
	xmpp_disconnect(conn);
    } else if (conn->sasl_support & SASL_MASK_DIGESTMD5) {
	auth = _make_sasl_auth(conn, "DIGEST-MD5");
	if (!auth) {
        //TODO;
	    //disconnect_mem_error(conn);
	    return;

	}

	handler_add(conn, _handle_digestmd5_challenge, 
		    XMPP_NS_SASL, NULL, NULL, NULL);

	xmpp_send(conn, auth);
	xmpp_stanza_release(auth);

	/* SASL DIGEST-MD5 was tried, unset flag */
	conn->sasl_support &= ~SASL_MASK_DIGESTMD5;
    } else if (conn->sasl_support & SASL_MASK_PLAIN) {
	auth = _make_sasl_auth(conn, "PLAIN");
	if (!auth) {
	    //disconnect_mem_error(conn);
	    return;
	}
	authdata = xmpp_stanza_new();
	if (!authdata) {
	    //disconnect_mem_error(conn);
	    return;
	}	
	authid = _get_authid(conn);
	if (!authid) {
	    //disconnect_mem_error(conn);
	    return;
	}
	str = sasl_plain(authid, conn->pass);
	if (!str) {
	    //disconnect_mem_error(conn);
	    return;
	}
	xmpp_stanza_set_text(authdata, str);
	zfree(str);

	xmpp_stanza_add_child(auth, authdata);
	xmpp_stanza_release(authdata);

	handler_add(conn, _handle_sasl_result,
		    XMPP_NS_SASL, NULL, NULL, "PLAIN");

	xmpp_send(conn, auth);
	xmpp_stanza_release(auth);

	/* SASL PLAIN was tried */
	conn->sasl_support &= ~SASL_MASK_PLAIN;
    } else if (conn->type == XMPP_CLIENT) {
	/* legacy client authentication */
	
	iq = xmpp_stanza_new();
	if (!iq) {
	    //disconnect_mem_error(conn);
	    return;
	}
	xmpp_stanza_set_name(iq, "iq");
	xmpp_stanza_set_type(iq, "set");
	xmpp_stanza_set_id(iq, "_xmpp_auth1");

	query = xmpp_stanza_new();
	if (!query) {
	    xmpp_stanza_release(iq);
	    //disconnect_mem_error(conn);
	    return;
	}
	xmpp_stanza_set_name(query, "query");
	xmpp_stanza_set_ns(query, XMPP_NS_AUTH);
	xmpp_stanza_add_child(iq, query);
	xmpp_stanza_release(query);

	child = xmpp_stanza_new();
	if (!child) {
	    xmpp_stanza_release(iq);
	    //disconnect_mem_error(conn);
	    return;
	}
	xmpp_stanza_set_name(child, "username");
	xmpp_stanza_add_child(query, child);
	xmpp_stanza_release(child);

	authdata = xmpp_stanza_new();
	if (!authdata) {
	    xmpp_stanza_release(iq);
	    //disconnect_mem_error(conn);
	    return;
	}
	str = jid_node(conn->jid);
	xmpp_stanza_set_text(authdata, str);
	zfree(str);
	xmpp_stanza_add_child(child, authdata);
	xmpp_stanza_release(authdata);

	child = xmpp_stanza_new();
	if (!child) {
	    xmpp_stanza_release(iq);
	    //disconnect_mem_error(conn);
	    return;
	}
	xmpp_stanza_set_name(child, "password");
	xmpp_stanza_add_child(query, child);
	xmpp_stanza_release(child);

	authdata = xmpp_stanza_new();
	if (!authdata) {
	    xmpp_stanza_release(iq);
	    //disconnect_mem_error(conn);
	    return;
	}
	xmpp_stanza_set_text(authdata, conn->pass);
	xmpp_stanza_add_child(child, authdata);
	xmpp_stanza_release(authdata);

	child = xmpp_stanza_new();
	if (!child) {
	    xmpp_stanza_release(iq);
	    //disconnect_mem_error(conn);
	    return;
	}
	xmpp_stanza_set_name(child, "resource");
	xmpp_stanza_add_child(query, child);
	xmpp_stanza_release(child);

	authdata = xmpp_stanza_new();
	if (!authdata) {
	    xmpp_stanza_release(iq);
	    //disconnect_mem_error(conn);
	    return;
	}
	str = jid_resource(conn->jid);
	if (str) {
	    xmpp_stanza_set_text(authdata, str);
	    zfree(str);
	} else {
	    xmpp_stanza_release(authdata);
	    xmpp_stanza_release(iq);
	    errorLog("auth", "Cannot authenticate without resource");
	    xmpp_disconnect(conn);
	    return;
	}
	xmpp_stanza_add_child(child, authdata);
	xmpp_stanza_release(authdata);

	handler_add_id(conn, _handle_legacy, "_xmpp_auth1", NULL);
	handler_add_timed(conn, _handle_missing_legacy, 
			  LEGACY_TIMEOUT, NULL);

	xmpp_send(conn, iq);
	xmpp_stanza_release(iq);
    }
}


/** Set up handlers at stream start.
 *  This function is called internally to Strophe for handling the opening
 *  of an XMPP stream.  It's called by the parser when a stream is opened
 *  or reset, and adds the initial handlers for <stream:error/> and 
 *  <stream:features/>.  This function is not intended for use outside
 *  of Strophe.
 *
 *  @param conn a Strophe connection object
 */
void auth_handle_open(XmppConn * const conn)
{
    /* reset all timed handlers */
    handler_reset_timed(conn, 0);

    /* setup handler for stream:error */
    handler_add(conn, _handle_error,
		NULL, "stream:error", NULL, NULL);

    /* setup handlers for incoming <stream:features> */
    handler_add(conn, _handle_features,
		NULL, "stream:features", NULL, NULL);
    handler_add_timed(conn, _handle_missing_features,
		      FEATURES_TIMEOUT, NULL);
}

/* called when stream:stream tag received after SASL auth */
static void _handle_open_sasl(XmppConn * const conn)
{
    debugLog("xmpp", "Reopened stream successfully.");

    /* setup stream:features handlers */
    handler_add(conn, _handle_features_sasl,
		NULL, "stream:features", NULL, NULL);
    handler_add_timed(conn, _handle_missing_features_sasl,
		      FEATURES_TIMEOUT, NULL);
}

static int _handle_features_sasl(XmppConn * const conn,
				 XmppStanza * const stanza,
				 void * const userdata)
{
    XmppStanza *bind, *session, *iq, *res, *text;
    char *resource;

    /* remove missing features handler */
    xmpp_timed_handler_delete(conn, _handle_missing_features_sasl);

    /* we are expecting <bind/> and <session/> since this is a
       XMPP style connection */

    bind = xmpp_stanza_get_child_by_name(stanza, "bind");
    if (bind && strcmp(xmpp_stanza_get_ns(bind), XMPP_NS_BIND) == 0) {
	/* resource binding is required */
	conn->bind_required = 1;
    }

    session = xmpp_stanza_get_child_by_name(stanza, "session");
    if (session && strcmp(xmpp_stanza_get_ns(session), XMPP_NS_SESSION) == 0) {
	/* session establishment required */
	conn->session_required = 1;
    }

    /* if bind is required, go ahead and start it */
    if (conn->bind_required) {
	/* bind resource */
	
	/* setup response handlers */
	handler_add_id(conn, _handle_bind, "_xmpp_bind1", NULL);
	handler_add_timed(conn, _handle_missing_bind,
			  BIND_TIMEOUT, NULL);

	/* send bind request */
	iq = xmpp_stanza_new();
	if (!iq) {
	    //disconnect_mem_error(conn);
	    return 0;
	}

	xmpp_stanza_set_name(iq, "iq");
	xmpp_stanza_set_type(iq, "set");
	xmpp_stanza_set_id(iq, "_xmpp_bind1");

	bind = xmpp_stanza_copy(bind);
	if (!bind) {
	    xmpp_stanza_release(iq);
	    //disconnect_mem_error(conn);
	    return 0;
	}

	/* request a specific resource if we have one */
        resource = jid_resource(conn->jid);
	if ((resource != NULL) && (strlen(resource) == 0)) {
	    /* jabberd2 doesn't handle an empty resource */
	    zfree(resource);
	    resource = NULL;
	}

	/* if we have a resource to request, do it. otherwise the 
	   server will assign us one */
	if (resource) {
	    res = xmpp_stanza_new();
	    if (!res) {
		xmpp_stanza_release(bind);
		xmpp_stanza_release(iq);
		//disconnect_mem_error(conn);
		return 0;
	    }
	    xmpp_stanza_set_name(res, "resource");
	    text = xmpp_stanza_new();
	    if (!text) {
		xmpp_stanza_release(res);
		xmpp_stanza_release(bind);
		xmpp_stanza_release(iq);
		//disconnect_mem_error(conn);
		return 0;
	    }
	    xmpp_stanza_set_text(text, resource);
	    xmpp_stanza_add_child(res, text);
	    xmpp_stanza_add_child(bind, res);
	    zfree(resource);
	}

	xmpp_stanza_add_child(iq, bind);
	xmpp_stanza_release(bind);

	/* send bind request */
	xmpp_send(conn, iq);
	xmpp_stanza_release(iq);
    } else {
	/* can't bind, disconnect */
	errorLog("xmpp", "Stream features does not allow "\
		   "resource bind.");
	xmpp_disconnect(conn);
    }

    return 0;
}

static int _handle_missing_features_sasl(XmppConn * const conn,
					 void * const userdata)
{
    errorLog("xmpp", "Did not receive stream features "\
	       "after SASL authentication.");
    xmpp_disconnect(conn);
    return 0;
}
					  
static int _handle_bind(XmppConn * const conn,
			XmppStanza * const stanza,
			void * const userdata)
{
    char *type;
    XmppStanza *iq, *session;

    /* delete missing bind handler */
    xmpp_timed_handler_delete(conn, _handle_missing_bind);

    /* server has replied to bind request */
    type = xmpp_stanza_get_type(stanza);
    if (type && strcmp(type, "error") == 0) {
	errorLog("xmpp", "Binding failed.");
	xmpp_disconnect(conn);
    } else if (type && strcmp(type, "result") == 0) {
        XmppStanza *binding = xmpp_stanza_get_child_by_name(stanza, "bind");
	debugLog("xmpp", "Bind successful.");

        if (binding) {
            XmppStanza *jid_stanza = xmpp_stanza_get_child_by_name(binding,
                                                                      "jid");
            if (jid_stanza) {
                conn->bound_jid = xmpp_stanza_get_text(jid_stanza);
            }
        }

	/* establish a session if required */
	if (conn->session_required) {
	    /* setup response handlers */
	    handler_add_id(conn, _handle_session, "_xmpp_session1", NULL);
	    handler_add_timed(conn, _handle_missing_session, 
			      SESSION_TIMEOUT, NULL);

	    /* send session request */
	    iq = xmpp_stanza_new();
	    if (!iq) {
		//disconnect_mem_error(conn);
		return 0;
	    }

	    xmpp_stanza_set_name(iq, "iq");
	    xmpp_stanza_set_type(iq, "set");
	    xmpp_stanza_set_id(iq, "_xmpp_session1");

	    session = xmpp_stanza_new();
	    if (!session) {
		xmpp_stanza_release(iq);
		//disconnect_mem_error(conn);
	    }

	    xmpp_stanza_set_name(session, "session");
	    xmpp_stanza_set_ns(session, XMPP_NS_SESSION);

	    xmpp_stanza_add_child(iq, session);
	    xmpp_stanza_release(session);

	    /* send session establishment request */
	    xmpp_send(conn, iq);
	    xmpp_stanza_release(iq);
	} else {
	    conn->authenticated = 1;
	   
	    /* call connection handler */
	    conn->conn_handler(conn, XMPP_CONN_CONNECT, 0, NULL, 
			       conn->userdata);
	}
    } else {
	errorLog("xmpp", "Server sent malformed bind reply.");
	xmpp_disconnect(conn);
    }

    return 0;
}

static int _handle_missing_bind(XmppConn * const conn,
				void * const userdata)
{
    errorLog("xmpp", "Server did not reply to bind request.");
    xmpp_disconnect(conn);
    return 0;
}

static int _handle_session(XmppConn * const conn,
			   XmppStanza * const stanza,
			   void * const userdata)
{
    char *type;

    /* delete missing session handler */
    xmpp_timed_handler_delete(conn, _handle_missing_session);

    /* server has replied to the session request */
    type = xmpp_stanza_get_type(stanza);
    if (type && strcmp(type, "error") == 0) {
	errorLog("xmpp", "Session establishment failed.");
	xmpp_disconnect(conn);
    } else if (type && strcmp(type, "result") == 0) {
	debugLog("xmpp", "Session establishment successful.");

	conn->authenticated = 1;
	
	/* call connection handler */
	conn->conn_handler(conn, XMPP_CONN_CONNECT, 0, NULL, conn->userdata);
    } else {
	errorLog("xmpp", "Server sent malformed session reply.");
	xmpp_disconnect(conn);
    }

    return 0;
}

static int _handle_missing_session(XmppConn * const conn,
				   void * const userdata)
{
    errorLog("xmpp", "Server did not reply to session request.");
    xmpp_disconnect(conn);
    return 0;
}

static int _handle_legacy(XmppConn * const conn,
			  XmppStanza * const stanza,
			  void * const userdata)
{
    char *type, *name;

    /* delete missing handler */
    xmpp_timed_handler_delete(conn, _handle_missing_legacy);

    /* server responded to legacy auth request */
    type = xmpp_stanza_get_type(stanza);
    name = xmpp_stanza_get_name(stanza);
    if (!type || strcmp(name, "iq") != 0) {
	errorLog("xmpp", "Server sent us an unexpected response "\
		   "to legacy authentication request.");
	xmpp_disconnect(conn);
    } else if (strcmp(type, "error") == 0) {
	/* legacy client auth failed, no more fallbacks */
	errorLog("xmpp", "Legacy client authentication failed.");
	xmpp_disconnect(conn);
    } else if (strcmp(type, "result") == 0) {
	/* auth succeeded */
	debugLog("xmpp", "Legacy auth succeeded.");

	conn->authenticated = 1;
	conn->conn_handler(conn, XMPP_CONN_CONNECT, 0, NULL, conn->userdata);
    } else {
	errorLog("xmpp", "Server sent us a legacy authentication "\
		   "response with a bad type.");
	xmpp_disconnect(conn);
    }

    return 0;
}

static int _handle_missing_legacy(XmppConn * const conn,
				  void * const userdata)
{
    errorLog("xmpp", "Server did not reply to legacy "\
	       "authentication request.");
    xmpp_disconnect(conn);
    return 0;
}

