-- Function to get dirty rooms above a certain urgency level using a Ref Cursor
CREATE OR REPLACE FUNCTION get_dirty_rooms(p_cursor_name refcursor, p_min_urgency INT)
RETURNS refcursor AS $$
BEGIN
    -- Opening the cursor for a query that fetches dirty rooms
    OPEN p_cursor_name FOR
        SELECT * FROM room
        WHERE room_status = 'Dirty' AND urgency_level >= p_min_urgency
        ORDER BY urgency_level DESC;
        
    RETURN p_cursor_name;
END;
$$ LANGUAGE plpgsql;