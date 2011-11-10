%id=service uuid
-record(monit_task, {taskid,
        sid = 0, %service id
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
        external = true,
        current_attempts = 0,
        args, 
        tref = undefined, 
        duration, 
        latency, 
        is_collect = true,
        warning,
        critical,
        last_sample, %{timestamp, [{ifinoctets, 22288282}, {ifoutoctets, 283892}]}
        last_check_at, 
        next_check_at,
        created_at}). 
