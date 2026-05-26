-- 1. Trigger Function: Prevents deletion of a room if it is currently 'In Progress'
CREATE OR REPLACE FUNCTION prevent_active_room_delete()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if the room being deleted is currently being cleaned
    IF OLD.room_status = 'In Progress' THEN
        RAISE EXCEPTION 'Cannot delete room %. It is currently being cleaned!', OLD.roomid;
    END IF;
    
    -- If it's not 'In Progress', allow the deletion
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- 2. The Trigger definition attached to the room table
CREATE TRIGGER trg_prevent_room_delete
BEFORE DELETE ON room
FOR EACH ROW
EXECUTE FUNCTION prevent_active_room_delete();