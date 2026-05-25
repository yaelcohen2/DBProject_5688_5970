-- 1. Trigger Function: Checks if the employee already has 3 or more open tasks
CREATE OR REPLACE FUNCTION check_employee_workload()
RETURNS TRIGGER AS $$
DECLARE
    v_open_tasks INT;
BEGIN
    -- Only verify if the new task is marked as 'Open'
    IF NEW.task_status = 'Open' THEN
        -- Count existing open tasks for this specific employee
        SELECT COUNT(*) INTO v_open_tasks
        FROM cleaninglog
        WHERE employeeid = NEW.employeeid AND task_status = 'Open';
        
        -- If they already have 3 or more, abort the operation
        IF v_open_tasks >= 3 THEN
            RAISE EXCEPTION 'Employee % already has 3 or more open tasks. Cannot assign more.', NEW.employeeid;
        END IF;
    END IF;
    
    -- If everything is fine, proceed with the INSERT/UPDATE
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. The Trigger definition attached to the cleaninglog table
CREATE TRIGGER trg_check_workload
BEFORE INSERT OR UPDATE ON cleaninglog
FOR EACH ROW
EXECUTE FUNCTION check_employee_workload();