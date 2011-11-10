/* 
** Copyright (C) 2011 <ery.lee at gmail dot com>
**
**  This software is provided AS-IS with no warranty, either express
**  or implied.
**
**  This software is distributed under license and may not be copied,
**  modified or distributed except as expressly authorized under the
**  terms of the license contained in the file LICENSE.txt in this
**  distribution.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <stdarg.h>
#include <sys/types.h>
#include <unistd.h>

#include <signal.h>

#ifdef HAVE_BACKTRACE
#include <execinfo.h>
#include <ucontext.h>
#endif /* HAVE_BACKTRACE */

#include <sys/wait.h>
#include <errno.h>
#include <assert.h>
#include <ctype.h>
#include <stdarg.h>
#include <inttypes.h>
#include <arpa/inet.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/uio.h>
#include <limits.h>
#include <float.h>
#include <math.h>

#include "ae.h"
#include "log.h"
#include "jid.h"
#include "anet.h"
#include "xmpp.h"
#include "zmalloc.h"

/* Error codes */
#define SMARTA_OK       0

#define SMARTA_ERR      -1

#define SMARTA_VERSION "1.2.12"

typedef struct {
    char *jid;
    char *password;
    char *bindir;
    int loglevel;
    int daemonize;
    char *logfile; /* NULL = log on standard output */
    char *pidfile;
    string_list *allow_buddies;
    XmppConn *conn;
    aeEventLoop *el;
} Smarta;

static Smarta smarta;

static char *trim(char *s);

static void send_reply(XmppConn *conn, char *to, char *replytext);

int roster_handler(XmppConn * const conn,
		 XmppStanza * const stanza,
		 void * const userdata) {
    XmppStanza *query, *item;
    char *type, *name, *jid, *subscription;
    XmppBuddy *buddy;

    type = xmpp_stanza_get_type(stanza);
    if (strcmp(type, "error") == 0) {
        fprintf(stderr, "ERROR: roster query failed\n");
        return 0;
    }

    query = xmpp_stanza_get_child_by_name(stanza, "query");
    for (item = xmpp_stanza_get_children(query); item; 
        item = xmpp_stanza_get_next(item)) {
        name = xmpp_stanza_get_attribute(item, "name");
        jid = xmpp_stanza_get_attribute(item, "jid");
        subscription = xmpp_stanza_get_attribute(item, "subscription");
        printf("roster item: %s \n", jid);
        buddy = conn->buddies;
        while(buddy) {
            if(strcmp(buddy->jid, jid) == 0) {
                break;
            }
            buddy = buddy->next;
        }
        if(buddy == NULL) {
            buddy = zmalloc(sizeof(XmppBuddy));
            buddy->jid = jid;
            buddy->nick = name;
            buddy->pres = 0;
            buddy->sub = subscription;
            buddy->next = conn->buddies;
            conn->buddies = buddy;
        }
    }

    return 0;
}

int version_handler(XmppConn * const conn, XmppStanza * const stanza, void * const userdata)
{
	XmppStanza *reply, *query, *name, *version, *text;
	char *ns;
	printf("Received version request from %s\n", xmpp_stanza_get_attribute(stanza, "from"));
	
	reply = xmpp_stanza_new();
	xmpp_stanza_set_name(reply, "iq");
	xmpp_stanza_set_type(reply, "result");
	xmpp_stanza_set_id(reply, xmpp_stanza_get_id(stanza));
	xmpp_stanza_set_attribute(reply, "to", xmpp_stanza_get_attribute(stanza, "from"));
	
	query = xmpp_stanza_new();
	xmpp_stanza_set_name(query, "query");
    ns = xmpp_stanza_get_ns(xmpp_stanza_get_children(stanza));
    if (ns) {
        xmpp_stanza_set_ns(query, ns);
    }

	name = xmpp_stanza_new();
	xmpp_stanza_set_name(name, "name");
	xmpp_stanza_add_child(query, name);
	
	text = xmpp_stanza_new();
	xmpp_stanza_set_text(text, "libstrophe example bot");
	xmpp_stanza_add_child(name, text);
	
	version = xmpp_stanza_new();
	xmpp_stanza_set_name(version, "version");
	xmpp_stanza_add_child(query, version);
	
	text = xmpp_stanza_new();
	xmpp_stanza_set_text(text, "1.0");
	xmpp_stanza_add_child(version, text);
	
	xmpp_stanza_add_child(reply, query);

	xmpp_send(conn, reply);
	xmpp_stanza_release(reply);
	return 1;
}

int presence_handler(XmppConn * const conn, XmppStanza * const stanza, void * const userdata)
{
    char *type, *from, *bare_from;
    XmppStanza *pres;
    type = xmpp_stanza_get_attribute(stanza, "type");
    if(type == NULL) type = "available";
    from = xmpp_stanza_get_attribute(stanza, "from");
    bare_from = jid_bare(from);
    if(strcmp(smarta.jid, bare_from) == 0) { //self
        return 1;
    }
    printf("presence from %s: %s \n", from, type);
    if(strcmp(type, "subscribe") == 0) {
        string_list *buddy = smarta.allow_buddies;
        while(buddy) {
            if(strcmp(buddy->s, bare_from) == 0) {
                printf("send subcribed presenct to %s \n", from);
                pres = xmpp_stanza_new();
                xmpp_stanza_set_name(pres, "presence");
                xmpp_stanza_set_type(pres, "subscribed");
                xmpp_stanza_set_attribute(pres, "to", from);
                xmpp_send(conn, pres);
                xmpp_stanza_release(pres);
                break;
            }
            buddy = buddy->next;
        }
    } else if(strcmp(type, "subscribed") == 0) {
    
    } else if(strcmp(type, "unavailable") == 0) {
    
    } else {
        //NOTHING
    }

    return 1;
}

int message_handler(XmppConn * const conn, XmppStanza * const stanza, void * const userdata)
{
    char buffer[4096];
    int result;
    FILE *fp = NULL;
	char *intext, *from, *cmdpath, *p;
	
	if(!xmpp_stanza_get_child_by_name(stanza, "body")) return 1;
	if(!strcmp(xmpp_stanza_get_attribute(stanza, "type"), "error")) return 1;

    from = xmpp_stanza_get_attribute(stanza, "from");
	
	intext = xmpp_stanza_get_text(xmpp_stanza_get_child_by_name(stanza, "body"));
	printf("Incoming message from %s: %s\n", xmpp_stanza_get_attribute(stanza, "from"), intext);
    intext = trim(intext);
    p = strchr(intext, ';');
    if(p) {
       *p = '\0'; 
    }
    p = strchr(intext, '|');
    if(p) {
       *p = '\0'; 
    }
    
    cmdpath = zmalloc(strlen(intext) + strlen(smarta.bindir) + 1);
    strcpy(cmdpath, smarta.bindir);
    strcat(cmdpath, "/");
    strcat(cmdpath, intext);

    /* run the plugin check command */
    fp=popen(cmdpath, "r");
    if(fp==NULL) {
        printf("error cmd: %s", intext);
        zfree(cmdpath);
        send_reply(conn, from, "command not found.");
        return 1;
    }
        
    result = fread(buffer, 1, sizeof(buffer)-2, fp);
    printf("result: %d \n", result);
    if(result <= 0) {
        zfree(cmdpath);
        pclose(fp);
        send_reply(conn, from, "no output.");
        return 1;
    }
    buffer[result] = '\0';

    zfree(cmdpath);
    pclose(fp);

    send_reply(conn, from, buffer);
	
	return 1;
}

void send_reply(XmppConn *conn, char *to, char *replytext) {

	XmppStanza *reply, *body, *text;

	reply = xmpp_stanza_new();
	xmpp_stanza_set_name(reply, "message");
	xmpp_stanza_set_type(reply, "chat");
	xmpp_stanza_set_attribute(reply, "to", to);
	
	body = xmpp_stanza_new();
	xmpp_stanza_set_name(body, "body");
	
	text = xmpp_stanza_new();
	xmpp_stanza_set_text(text, replytext);
	xmpp_stanza_add_child(body, text);
	xmpp_stanza_add_child(reply, body);
	
	xmpp_send(conn, reply);

	xmpp_stanza_release(reply);
}

int reconnect_handler(XmppConn *, void *);

/* define a handler for connection events */
void conn_handler(XmppConn * const conn, const xmpp_conn_event_t status, 
		  const int error, xmpp_stream_error_t * const stream_error,
		  void * const userdata) 
{

    XmppStanza *iq, *query;

    if (status == XMPP_CONN_CONNECT) {
        XmppStanza* pres;
        fprintf(stderr, "DEBUG: connected\n");
        xmpp_handler_add(conn,version_handler, "jabber:iq:version", "iq", NULL, NULL);
        xmpp_handler_add(conn,message_handler, NULL, "message", NULL, NULL);
        xmpp_handler_add(conn,presence_handler, NULL, "presence", NULL, NULL);
        
        /* Send initial <presence/> so that we appear online to contacts */
        pres = xmpp_stanza_new();
        xmpp_stanza_set_name(pres, "presence");
        xmpp_send(conn, pres);
        xmpp_stanza_release(pres);

        /* create iq stanza for request */
        iq = xmpp_stanza_new();
        xmpp_stanza_set_name(iq, "iq");
        xmpp_stanza_set_type(iq, "get");
        xmpp_stanza_set_id(iq, "roster1");

        query = xmpp_stanza_new();
        xmpp_stanza_set_name(query, "query");
        xmpp_stanza_set_ns(query, XMPP_NS_ROSTER);

        xmpp_stanza_add_child(iq, query);

        /* we can release the stanza since it belongs to iq now */
        xmpp_stanza_release(query);

        /* set up reply handler */
        xmpp_id_handler_add(conn, roster_handler, "roster1", NULL);

        /* send out the stanza */
        xmpp_send(conn, iq);

        /* release the stanza */
        xmpp_stanza_release(iq);
    }
    else {
        fprintf(stderr, "DEBUG: disconnected\n");
        xmpp_timed_handler_add(conn, reconnect_handler, 10000, NULL);
    }
}

int reconnect_handler(XmppConn * const conn, void * const userdata) {
	printf("reconnect to xmpp server...\n");

    //TODO:
    //xmpp_connect_reset(conn);

    /* initiate connection */
    //xmpp_connect_client(conn, NULL, 0, conn_handler, NULL);
    
    //xmpp_conn_release(conn);

    return 0;
}

static int smartaCron(struct aeEventLoop *eventLoop, long long id, void *clientData) {
    printf("cron called \n");
    return 1000;
}

static void smarta_init() {
    smarta.jid = NULL;
    smarta.password = NULL;
    smarta.loglevel = 1;
    smarta.logfile = NULL; /* NULL = log on standard output */
    smarta.daemonize = 0;
    smarta.pidfile = "/var/run/smarta.pid";
    smarta.el = aeCreateEventLoop();
    aeCreateTimeEvent(smarta.el, 100, smartaCron, NULL, NULL);
}


char *ltrim(char *s) {
    while(isspace(*s)) s++;
    return s;
}

char *rtrim(char *s) {
    char* back = s + strlen(s);
    while(isspace(*--back));
    *(back+1) = '\0';
    return s;
}

char *trim(char *s) {
    return rtrim(ltrim(s)); 
}

static int parse_line(char *line, char **argv) {
    char array[4096];
    char *buf = array;
    char *delim;
    int argc = 0;
    strcpy(buf, line);
    while((delim = strchr(buf, ' '))) {
        argv[argc++] = buf;
        *delim = '\0';
        buf = delim + 1;
        while(*buf && (*buf == ' ')) /*ignore spaces*/
            buf++;
    }
    argv[argc] = buf;
    return argc+1;
}

static int yesnotoi(char *s) {
    if (!strcmp(s,"yes")) return 1;
    else if (!strcmp(s,"no")) return 0;
    else return -1;
}

static void add_allow_buddy(char *jid) {
    string_list *buddy = zmalloc(sizeof(string_list));
    buddy->s = strdup(jid);
    buddy->next = smarta.allow_buddies;
    smarta.allow_buddies = buddy;
}

static void load_smarta_config(char *filename) {
    FILE *fp;
    char buf[4096], *err = NULL;
    char *line;
    int linenum = 0;

    if (filename[0] == '-' && filename[1] == '\0')
        fp = stdin;
    else {
        if ((fp = fopen(filename,"r")) == NULL) {
            warnLog("Fatal error, can't open config file '%s'", filename);
            exit(1);
        }
    }

    while(fgets(buf, 4096, fp) != NULL) {
        char *argv[10];
        int argc = 0;
        int i;

        linenum++;
        line = buf;
        line = trim(line);
        /* Skip comments and blank lines*/
        if (line[0] == '#' || line[0] == '\0') {
            continue;
        }

        argc = parse_line(line, argv);

        printf("argc: %d, ", argc);
        for(i = 0; i < argc; i++) {
            printf("argv[%d]: %s, ", i, argv[i]); 
        }
        printf("\n");


        /* Execute config directives */
        if (!strcmp(argv[0],"jid") && argc == 2) {
            smarta.jid = strdup(argv[1]);
        } else if (!strcmp(argv[0],"password") && argc == 2) {
            smarta.password = strdup(argv[1]);
        } else if (!strcmp(argv[0],"buddy") && argc == 2) {
            add_allow_buddy(strdup(argv[1]));
        } else if (!strcmp(argv[0],"bindir") && argc == 2) {
            smarta.bindir = strdup(argv[1]);
        } else if (!strcmp(argv[0],"daemonize") && argc == 2) {
            if ((smarta.daemonize = yesnotoi(argv[1])) == -1) {
                err = "argument must be 'yes' or 'no'"; goto loaderr;
            }
        } else if (!strcmp(argv[0],"pidfile") && argc == 2) {
            smarta.pidfile = strdup(argv[1]);
        } else if (!strcmp(argv[0],"loglevel") && argc == 2) {
            if (!strcmp(argv[1],"debug")) smarta.loglevel= 0;
            else if (!strcmp(argv[1],"info")) smarta.loglevel = 1;
            else if (!strcmp(argv[1],"warn")) smarta.loglevel = 2;
            else if (!strcmp(argv[1],"error")) smarta.loglevel = 3;
            else {
                err = "Invalid log level. Must be one of debug, info, warn, error";
                goto loaderr;
            }
        } else if (!strcmp(argv[0],"logfile") && argc == 2) {
            FILE *logfp;

            smarta.logfile = strdup(argv[1]);
            if (!strcmp(smarta.logfile,"stdout")) {
                smarta.logfile = NULL;
            }
            if (smarta.logfile) {
                /* Test if we are able to open the file. The server will not
                 * be able to abort just for this problem later... */
                logfp = fopen(smarta.logfile,"a");
                if (logfp == NULL) {
                    err = "Can't open the log file";
                    goto loaderr;
                }
                fclose(logfp);
            }
        } else {
            printf("argv[0]: %s", argv[0]);
            err = "Bad directive or wrong number of arguments"; goto loaderr;
        }
    }
    if (fp != stdin) fclose(fp);
    return;

loaderr:
    fprintf(stderr, "\n*** FATAL CONFIG FILE ERROR ***\n");
    fprintf(stderr, "Reading the configuration file, at line %d\n", linenum);
    fprintf(stderr, ">>> '%s'\n", line);
    fprintf(stderr, "%s\n", err);
    exit(1);
}

static void version() {
    printf("Smarta version %s\n", SMARTA_VERSION);
    exit(0);
}

static void usage() {
    fprintf(stderr,"Usage: ./smarta [/path/to/smarta.conf]\n");
    exit(1);
}

static void daemonize(void) {
    int fd;
    FILE *fp;

    if (fork() != 0) exit(0); /* parent exits */
    setsid(); /* create a new session */

    /* Every output goes to /dev/null. If Redis is daemonized but
     * the 'logfile' is set to 'stdout' in the configuration file
     * it will not log at all. */
    if ((fd = open("/dev/null", O_RDWR, 0)) != -1) {
        dup2(fd, STDIN_FILENO);
        dup2(fd, STDOUT_FILENO);
        dup2(fd, STDERR_FILENO);
        if (fd > STDERR_FILENO) close(fd);
    }
    /* Try to write the pid file */
    fp = fopen(smarta.pidfile,"w");
    if (fp) {
        fprintf(fp,"%d\n",getpid());
        fclose(fp);
    }
}

static void connect_handler(aeEventLoop *el, int fd, 
    void *privdata, int mask) {

    char buf[4096];
    int nread;

   XmppConn *conn = (XmppConn *)privdata;

    nread = read(fd, buf, 4096);
    printf("errno: %d \n", errno);
    printf("nread: %d \n", nread);
    debugLog("smarta", "len: %d", nread);
    if (nread == -1) {
        if (errno == EAGAIN) {
            nread = 0;
        } else {
            return;
        }
    } else if (nread == 0) {
        //TODO: closed
        printf("xmpp server is disconnected");
        exit(0);
    }
    printf("receive: %s \n", buf);
    debugLog("smarta", "len: %d, data: %s \n", nread, buf);
    //parser_feed(conn->parser, buf, nread);
}

static int smarta_connect() {
    char err[4096];
    XmppConn *conn = xmpp_conn_new();
    xmpp_conn_set_jid(conn, smarta.jid);
    xmpp_conn_set_pass(conn, smarta.password);

    conn->type = XMPP_CLIENT;

    conn->domain = jid_domain(smarta.jid);

    conn->fd = anetTcpConnect(err, conn->domain, 5222);
    printf("connect to %s:, socket: %d\n", conn->domain, conn->fd);
    debugLog("xmpp", "sock_connect to %s, returned %d",
               conn->domain, conn->fd);
    if (conn->fd == -1) return -1;
    
    aeCreateFileEvent(smarta.el, conn->fd, 
        AE_READABLE, connect_handler, conn); //| AE_WRITABLE

    conn_open_stream(conn);

    //anetWrite(conn->sock, "haha", 4);

    conn->state = XMPP_STATE_CONNECTING;

    conn->timeout_stamp = time_stamp();
    debugLog("xmpp", "attempting to connect to %s", conn->domain);

    return conn->fd;
}

static void beforeSleep(struct aeEventLoop *eventLoop) {
    //printf("sleep....\n");
    //NOTHING
}

static void smarta_run() {
    aeSetBeforeSleepProc(smarta.el, beforeSleep);
    aeMain(smarta.el);
    aeDeleteEventLoop(smarta.el);
}

static void smarta_destroy() {
    xmpp_conn_destroy(smarta.conn);
}

int main(int argc, char **argv) {
    //time_t start;

    smarta_init();
    if (argc == 2) {
        if (strcmp(argv[1], "-v") == 0 ||
            strcmp(argv[1], "--version") == 0) version();
        if (strcmp(argv[1], "-h") == 0 ||
            strcmp(argv[1], "--help") == 0) usage();
        load_smarta_config(argv[1]);
    } else if ((argc > 2)) {
        usage();
    } else {
        printf("ERROR: no config file specified, In order to specify a config file use 'smarta /path/to/smarta.conf'");
        exit(1);
    }

    if(smarta.daemonize) daemonize();

    logInit(smarta.loglevel, smarta.logfile);


    if(smarta_connect() < 0) {
        fprintf(stderr, "Cannot connect server");
        exit(1);
    }

    smarta_run();

    smarta_destroy();
    
    return 0;
}

