#ifndef __LOG_H__
#define __LOG_H__

#define LOG_DEBUG 0
#define LOG_INFO 1
#define LOG_WARN 2
#define LOG_ERROR 3

void logInit(int level, const char *logfile);

void debugLog(const char *area, const char *fmt, ...);

void infoLog(const char *area, const char *fmt, ...);

void warnLog(const char *area, const char *fmt, ...); 

void errorLog(const char *area, const char *fmt, ...); 

#endif /* __LOG_H__*/
