-- Function to count how many cleaners are currently busy with 'Open' tasks
CREATE OR REPLACE FUNCTION get_busy_cleaners_count()
RETURNS INT AS $$
DECLARE
    v_cleaner_record RECORD; -- Using a Record (Requirement 4g)
    v_busy_count INT := 0;
    v_open_tasks INT;
    
    -- Explicit Cursor (Requirement 4a)
    c_cleaners CURSOR FOR SELECT employeeid FROM housekeepingemployee;
BEGIN
    OPEN c_cleaners;
    
    LOOP
        -- Fetching into the record
        FETCH c_cleaners INTO v_cleaner_record;
        EXIT WHEN NOT FOUND;

        -- Check how many open tasks this specific cleaner has
        SELECT COUNT(*) INTO v_open_tasks
        FROM cleaninglog
        WHERE employeeid = v_cleaner_record.employeeid
          AND task_status = 'Open';

        -- If they have at least one open task, count them as busy
        IF v_open_tasks > 0 THEN
            v_busy_count := v_busy_count + 1;
        END IF;
    END LOOP;
    
    CLOSE c_cleaners;

    RETURN v_busy_count;
END;
$$ LANGUAGE plpgsql;