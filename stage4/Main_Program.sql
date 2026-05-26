-- =================================================================
-- Main Program: Demonstrate calling a function and a procedure
-- =================================================================

DO $$
DECLARE
    v_dirty_room_id INT;
    v_available_employee_id INT;
    v_task_type_id INT;
BEGIN
    -- -----------------------------------------------------------------
    -- Step 1: Call the GetDirtyRooms function to find a room to clean.
    -- -----------------------------------------------------------------
    RAISE NOTICE 'Searching for a dirty room...';

    -- We select the first dirty room found by the function.
    SELECT roomid INTO v_dirty_room_id
    FROM getdirtyrooms()
    LIMIT 1;

    IF v_dirty_room_id IS NULL THEN
        RAISE NOTICE 'No dirty rooms found. Nothing to assign.';
        RETURN;
    ELSE
        RAISE NOTICE 'Found dirty room with ID: %', v_dirty_room_id;
    END IF;

    -- -----------------------------------------------------------------
    -- Step 2: Find an available employee to assign the task to.
    -- For this example, we'll just pick an employee who is not busy.
    -- A more complex system might check schedules or current workload.
    -- -----------------------------------------------------------------
    RAISE NOTICE 'Searching for an available employee...';
    
    SELECT employeeid INTO v_available_employee_id
    FROM housekeepingemployee
    WHERE employeeid NOT IN (SELECT employeeid FROM getbusycleaners())
    LIMIT 1;

    IF v_available_employee_id IS NULL THEN
        RAISE NOTICE 'No available employees found. Cannot assign task.';
        RETURN;
    ELSE
        RAISE NOTICE 'Found available employee with ID: %', v_available_employee_id;
    END IF;

    -- -----------------------------------------------------------------
    -- Step 3: Call the AssignTask procedure to create the assignment.
    -- -----------------------------------------------------------------
    
    -- For this example, we'll assign a 'Check-out' clean. Let's get its ID.
    SELECT tasktypeid INTO v_task_type_id FROM tasktype WHERE name = 'Check-out';

    RAISE NOTICE 'Assigning employee % to clean room %...', v_available_employee_id, v_dirty_room_id;

    -- Call the procedure with the IDs we found.
    CALL assigntask(
        p_room_id := v_dirty_room_id,
        p_employee_id := v_available_employee_id,
        p_task_type_id := v_task_type_id
    );

    RAISE NOTICE 'Procedure executed. Task should be assigned.';
    
    -- You can verify the assignment by checking the 'housekeepingtask' and 'cleaninglog' tables.

END $$;
