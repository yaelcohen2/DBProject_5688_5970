-- Procedure to suspend overdue tasks using a LOOP and DML
CREATE OR REPLACE PROCEDURE suspend_overdue_tasks()
LANGUAGE plpgsql
AS $$
DECLARE
    v_log_record RECORD;
BEGIN
    -- Requirement 4e (Loop)
    FOR v_log_record IN 
        SELECT * FROM cleaninglog WHERE task_status = 'Open'
    LOOP
        -- Check if the endtime has passed
        IF v_log_record.endtime < CURRENT_TIMESTAMP THEN
            -- Requirement 4c (DML Update)
            UPDATE cleaninglog
            SET task_status = 'Suspended'
            WHERE logid = v_log_record.logid;
        END IF;
    END LOOP;
END;
$$;