%%service status
%%-define(OK, 0).  
%%-define(WARNING, 1).
%%-define(CRITICAL, 2).
%%-define(UNKNOWN, 3).
%%-define(PENDING, 4).

%%oper type
-define(OPER_ADD, 1).
-define(OPER_DELETE, 2).
-define(OPER_UPDATE, 3).

%%id: {class, object_id}
-record(monit_object, {id, 
        uuid, 
        parent, 
        agent,
        class, 
        attrs}).

%%id: {class, object_type_id}
-record(object_type, {id, 
        name, 
        parent_id}).

-record(metric_type, {id, 
        type_id, 
        name, 
        calc}).

-record(monit_agent, {bjid, 
        username, 
        id, 
        tenant_id, 
        presence}).

-record(monit_locale, {key,
        string}).

-record(monit_last, {key,
        uuid,
        data}).

%id=service uuid
-record(monit_task, {taskid, 
        name, %service name
        agent, %schedule agent
        counter = 0,
        status,
        status_type,
        summary,
        check_interval,
        attempt_interval,
        max_attempts,
        command,
        current_attempts = 0,
        args, 
        tref = undefined, 
        duration, 
        latency, 
        is_collect = true,
        warning,
        critical,
        last_check_at, 
        next_check_at,
        created_at}). 

