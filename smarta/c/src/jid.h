#ifndef __JID_H
#define __JID_H

char *jid_new(const char *node, const char *domain, const char *resource);

char *jid_bare(const char *jid);

char *jid_node(const char *jid);

char *jid_domain(const char *jid);

char *jid_resource(const char *jid);

#endif
