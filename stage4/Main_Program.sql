-- =================================================================
-- Main Program: Demonstrate calling one function and one procedure
-- =================================================================

DO $$
DECLARE
    v_dirty_room_id INT;
BEGIN
    -- -----------------------------------------------------------------
    -- Step 1: Call a function.
    -- We will use GetDirtyRooms() to find a single room that needs cleaning.
    -- -----------------------------------------------------------------
    RAISE NOTICE '--- Calling Function ---';
    RAISE NOTICE 'Searching for a dirty room...';

    SELECT roomid INTO v_dirty_room_id
    FROM getdirtyrooms()
    LIMIT 1;

    IF v_dirty_room_id IS NOT NULL THEN
        RAISE NOTICE 'Function found dirty room with ID: %', v_dirty_room_id;
    ELSE
        RAISE NOTICE 'Function found no dirty rooms.';
    END IF;

    RAISE NOTICE 'Function call complete.';
    RAISE NOTICE ' '; -- Adding a blank line for readability

    -- -----------------------------------------------------------------
    -- Step 2: Call a procedure.
    -- We will use SuspendOverdueTasks() to update the status of any
    -- tasks that are past their due date.
    -- -----------------------------------------------------------------
    RAISE NOTICE '--- Calling Procedure ---';
    RAISE NOTICE 'Executing procedure to suspend overdue tasks...';

    CALL suspendoverduetasks();

    RAISE NOTICE 'Procedure call complete.';
    RAISE NOTICE ' ';
    RAISE NOTICE 'Main program finished.';

END $$;
