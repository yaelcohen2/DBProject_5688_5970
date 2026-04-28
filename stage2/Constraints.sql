-- Constraint 1: Check that the stock quantity is not negative
ALTER TABLE CLEANNINGSUPPLIES 
ADD CONSTRAINT chk_quantity_not_negative CHECK (quantity >= 0);


-- Constraint 2: Check that the score is between 0 and 100
ALTER TABLE ROOMCHECK 
ADD CONSTRAINT chk_score_range CHECK (score >= 0 AND score <= 100);

-- Constraint 3: Ensure a unique task per room, type, and date
ALTER TABLE housekeepingtask
ADD CONSTRAINT unique_task_room_date UNIQUE (roomid, tasktypeid, duedate);