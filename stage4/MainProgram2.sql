-- Main Program 2: Calls Function 1 and Procedure 1
DO $$
DECLARE
    v_cursor REFCURSOR;
    v_room RECORD;
BEGIN
    -- 1. Call Function 1 (Returns Ref Cursor)
    SELECT get_dirty_rooms('main_cursor', 1) INTO v_cursor;
    FETCH v_cursor INTO v_room;
    
    IF FOUND THEN
        RAISE NOTICE 'Found dirty room: %', v_room.roomnumber;
        
        -- 2. Call Procedure 1 (Assign Task) 
        -- Assigning task 200 to employee 2 for this room
        CALL assign_cleaning_task(v_room.roomid, 200, 2);
        RAISE NOTICE 'Successfully assigned task to employee 2 for room %', v_room.roomid;
    ELSE
        RAISE NOTICE 'No dirty rooms found.';
    END IF;
    
    CLOSE v_cursor;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'An error occurred during assignment: %', SQLERRM;
END;
$$;