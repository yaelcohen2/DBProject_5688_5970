-- Main Program 1: Calls Function 2 and Procedure 2
DO $$
DECLARE
    v_busy_count INT;
BEGIN
    -- 1. Call Function 2
    v_busy_count := get_busy_cleaners_count();
    RAISE NOTICE 'Busy cleaners count BEFORE update: %', v_busy_count;
    
    -- 2. Call Procedure 2
    CALL suspend_overdue_tasks();
    RAISE NOTICE 'Executed suspend_overdue_tasks().';
    
    -- 3. Call Function 2 again
    v_busy_count := get_busy_cleaners_count();
    RAISE NOTICE 'Busy cleaners count AFTER update: %', v_busy_count;
END;
$$;