-- Adding a status column to the room table to track cleaning status
ALTER TABLE room
ADD COLUMN room_status VARCHAR(20) DEFAULT 'Dirty';

-- Adding an urgency level column to the room table (e.g., for VIPs or quick turnovers)
ALTER TABLE room
ADD COLUMN urgency_level INT DEFAULT 1;

-- Adding a task status column to the cleaninglog table to track if a task is completed
ALTER TABLE cleaninglog
ADD COLUMN task_status VARCHAR(20) DEFAULT 'Open';