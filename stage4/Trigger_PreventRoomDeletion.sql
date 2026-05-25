-- 1. Trigger Function: Prevents deletion of a room if it has pending tasks.
CREATE OR REPLACE FUNCTION prevent_room_deletion_with_pending_tasks()
RETURNS TRIGGER AS $$
DECLARE
    v_pending_tasks INT;
BEGIN
    -- Count pending tasks for the room being deleted.
    -- A task is considered "pending" if its status is not 'Clean' or 'Inspected'.
    SELECT COUNT(ht.taskID)
    INTO v_pending_tasks
    FROM HOUSEKEEPINGTASK ht
    JOIN HOUSEKEEPINGSTATUS hs ON ht.statusID = hs.statusID
    WHERE ht.roomID = OLD.roomID
      AND hs.statusName NOT IN ('Clean', 'Inspected');

    -- If there are any pending tasks, raise an exception to block the deletion.
    IF v_pending_tasks > 0 THEN
        RAISE EXCEPTION 'Cannot delete room % because it has % pending cleaning tasks.', OLD.roomID, v_pending_tasks;
    END IF;

    -- If there are no pending tasks, allow the deletion to proceed.
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- 2. The Trigger definition attached to the ROOM table.
CREATE TRIGGER trg_prevent_room_deletion
BEFORE DELETE ON ROOM
FOR EACH ROW
EXECUTE FUNCTION prevent_room_deletion_with_pending_tasks();
