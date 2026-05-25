-- Procedure to assign a cleaning task with Exception handling, IF statement, and DML
CREATE OR REPLACE PROCEDURE assign_cleaning_task(p_room_id INT, p_task_id INT, p_employee_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_current_status VARCHAR(20);
BEGIN
    -- Fetch the current status of the room
    SELECT room_status INTO v_current_status
    FROM room
    WHERE roomid = p_room_id;

    -- Requirement 4d (Branching) & 4f (Exception)
    IF v_current_status = 'Clean' THEN
        RAISE EXCEPTION 'Cannot assign task: Room % is already clean!', p_room_id;
    ELSE
        -- Requirement 4c (DML - Insert into log)
        INSERT INTO cleaninglog (taskid, employeeid, starttime, endtime, task_status)
        VALUES (p_task_id, p_employee_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '2 hours', 'Open');
        
        -- Requirement 4c (DML - Update room status)
        UPDATE room
        SET room_status = 'In Progress'
        WHERE roomid = p_room_id;
    END IF;
END;
$$;