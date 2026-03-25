-- 1. Table for physical rooms
CREATE TABLE ROOM (
  roomID SERIAL PRIMARY KEY
);

COMMENT ON TABLE ROOM IS 'Physical room records within the hotel';

-- 2. Categories of cleaning tasks
CREATE TABLE TASKTYPE (
  taskTypeID SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL -- e.g., 'Deep Clean', 'Turn-down Service', 'Stay-over'
);

COMMENT ON TABLE TASKTYPE IS 'Definition of cleaning task types and their categories';

-- 3. Possible statuses for rooms/tasks
CREATE TABLE HOUSEKEEPINGSTATUS (
  statusID SERIAL PRIMARY KEY,
  statusName VARCHAR(50) NOT NULL -- e.g., 'Dirty', 'In Progress', 'Clean', 'Inspected'
);

COMMENT ON TABLE HOUSEKEEPINGSTATUS IS 'Look-up table for housekeeping and room cleanliness statuses';

-- 4. Specific housekeeping assignments
CREATE TABLE HOUSEKEEPINGTASK (
  taskID SERIAL PRIMARY KEY,
  roomID INT NOT NULL,
  taskTypeID INT NOT NULL,
  statusID INT NOT NULL,
  priority INT NOT NULL, -- Numeric scale (e.g., 1 for low, 5 for urgent)
  dueDate DATE NOT NULL,
  CONSTRAINT fk_room FOREIGN KEY (roomID) REFERENCES ROOM(roomID),
  CONSTRAINT fk_tasktype FOREIGN KEY (taskTypeID) REFERENCES TASKTYPE(taskTypeID),
  CONSTRAINT fk_status FOREIGN KEY (statusID) REFERENCES HOUSEKEEPINGSTATUS(statusID)
);

COMMENT ON TABLE HOUSEKEEPINGTASK IS 'Scheduled cleaning assignments assigned to specific rooms';

-- 5. Housekeeping staff records
CREATE TABLE HOUSEKEEPINGEMPLOYEE (
  employeeID SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  shiftID INT NOT NULL -- Reference to a shift schedule (e.g., 1 for Morning, 2 for Night)
);

COMMENT ON TABLE HOUSEKEEPINGEMPLOYEE IS 'Details of employees working within the housekeeping department';

-- 6. Execution logs for tasks
CREATE TABLE CLEANINGLOG (
  logID SERIAL PRIMARY KEY,
  taskID INT NOT NULL,
  employeeID INT NOT NULL,
  startTime TIMESTAMP NOT NULL,
  endTime TIMESTAMP,
  comment TEXT, -- Optional notes about the cleaning process
  CONSTRAINT fk_log_task FOREIGN KEY (taskID) REFERENCES HOUSEKEEPINGTASK(taskID),
  CONSTRAINT fk_log_employee FOREIGN KEY (employeeID) REFERENCES HOUSEKEEPINGEMPLOYEE(employeeID)
);

COMMENT ON TABLE CLEANINGLOG IS 'Real-time tracking of when cleaning started and finished for a task';

-- 7. Quality control and inspections
CREATE TABLE ROOMCHECK (
  checkID SERIAL PRIMARY KEY,
  roomID INT NOT NULL,
  employeeID INT NOT NULL, -- The supervisor/inspector performing the check
  checkDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  score INT CHECK (score >= 0 AND score <= 100), -- Quality score percentage
  CONSTRAINT fk_check_room FOREIGN KEY (roomID) REFERENCES ROOM(roomID),
  CONSTRAINT fk_check_employee FOREIGN KEY (employeeID) REFERENCES HOUSEKEEPINGEMPLOYEE(employeeID)
);

COMMENT ON TABLE ROOMCHECK IS 'Quality inspection records and scores after a room has been cleaned';

-- 8. Cleaning inventory
CREATE TABLE CLEANINGSUPPLIES (
  suppliesID SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  quantity INT NOT NULL DEFAULT 0 -- Current stock level
);

COMMENT ON TABLE CLEANINGSUPPLIES IS 'Inventory of cleaning materials, chemicals, and tools';

-- 9. Relationship between employees and tasks
CREATE TABLE BELONGSTO (
  employeeID INT NOT NULL,
  taskID INT NOT NULL,
  PRIMARY KEY (employeeID, taskID),
  CONSTRAINT fk_belongs_employee FOREIGN KEY (employeeID) REFERENCES HOUSEKEEPINGEMPLOYEE(employeeID),
  CONSTRAINT fk_belongs_task FOREIGN KEY (taskID) REFERENCES HOUSEKEEPINGTASK
  (taskID)
);

COMMENT ON TABLE BELONGSTO IS 'Mapping table linking employees to their assigned cleaning tasks';

-- 10. Usage tracking for supplies
CREATE TABLE USES (
  suppliesID INT NOT NULL,
  taskID INT NOT NULL,
  quantityUsed INT DEFAULT 1 CHECK (quantityUsed > 0)
  PRIMARY KEY (suppliesID, taskID),
  CONSTRAINT fk_uses_supply FOREIGN KEY (suppliesID) REFERENCES CLEANINGSUPPLIES(suppliesID),
  CONSTRAINT fk_uses_task FOREIGN KEY (taskID) REFERENCES HOUSEKEEPINGTASK(taskID)
);

COMMENT ON TABLE USES IS 'Records of cleaning supplies consumed during specific tasks';

-- Adding Column-level comments for better documentation
COMMENT ON COLUMN HOUSEKEEPINGTASK.priority IS 'Priority level: 1 (Low) to 5 (Urgent)';
COMMENT ON COLUMN ROOMCHECK.score IS 'Inspection result expressed as a percentage (0-100)';