-- Adding a status column to the Rooms table to track cleaning status
ALTER TABLE Rooms
ADD COLUMN room_status VARCHAR(20) DEFAULT 'Dirty';

-- Adding an urgency level column to the Rooms table (e.g., for VIPs or quick turnovers)
ALTER TABLE Rooms
ADD COLUMN urgency_level INT DEFAULT 1;

-- Adding a task status column to the CleaningLogs table to track if a task is completed
ALTER TABLE CleaningLogs
ADD COLUMN task_status VARCHAR(20) DEFAULT 'Open';