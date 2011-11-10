
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <time.h>

#include "log.h"

static const char *log_level_names[] = {"DEBUG", "INFO", "WARN", "ERROR"};

struct _logState {
    int level;
    char *logfile;
};

static struct _logState logState;

static void _doLog(int level, const char *area, const char *fmt, va_list ap); 

void logInit(int level, const char *logfile) {
    logState.level = level;
    
    logState.logfile = strdup(logfile);
}

void debugLog(const char *area, const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    _doLog(LOG_DEBUG, area, fmt, ap);
    va_end(ap);
}

void infoLog(const char *area, const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    _doLog(LOG_INFO, area, fmt, ap);
    va_end(ap);
}

void warnLog(const char *area, const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    _doLog(LOG_WARN, area, fmt, ap);
    va_end(ap);
}

void errorLog(const char *area, const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);
    _doLog(LOG_ERROR, area, fmt, ap);
    va_end(ap);
}

static void _doLog(int level, const char *area, const char *fmt, va_list ap) {
    FILE *fp;
    char buf[64];
    time_t now;

    if (level < logState.level) return;

    fp = (logState.logfile == NULL) ? stdout : fopen(logState.logfile,"a");
    if (!fp) return;

    now = time(NULL);
    strftime(buf,64,"%d %b %H:%M:%S", localtime(&now));
    fprintf(fp,"[%s] %s %s ", log_level_names[level], area, buf);
    vfprintf(fp, fmt, ap);
    fprintf(fp,"\n");
    fflush(fp);

    if (logState.logfile) fclose(fp);
}

