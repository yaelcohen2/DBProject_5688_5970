DO $$
DECLARE
    i INT;
BEGIN
    -- 1. Insert Base Lookup Data (Statuses and Types)
    INSERT INTO HOUSEKEEPINGSTATUS (statusName) VALUES ('Dirty'), ('In Progress'), ('Clean'), ('Inspected'), ('Maintenance Required');
    INSERT INTO TASKTYPE (name) VALUES ('Deep Clean'), ('Stay-over'), ('Check-out'), ('Turn-down'), ('Sanitization');

    -- 2. Insert 500 ROOMS
    FOR i IN 1..500 LOOP
        INSERT INTO ROOM DEFAULT VALUES;
    END LOOP;

    -- 3. Insert 500 EMPLOYEES
    FOR i IN 1..500 LOOP
        INSERT INTO HOUSEKEEPINGEMPLOYEE (name, shiftID) 
        VALUES ('Employee_' || i, (floor(random() * 3) + 1)); -- Shifts 1, 2, or 3
    END LOOP;

    -- 4. Insert 500 SUPPLIES
    FOR i IN 1..500 LOOP
        INSERT INTO CLEANNINGSUPPLIES (name, quantity) 
        VALUES ('Supply_Item_' || i, floor(random() * 1000) + 100);
    END LOOP;

    -- 5. Insert 500 TASKS
    FOR i IN 1..500 LOOP
        INSERT INTO HOUSEKEPINGTASK (roomID, taskTypeID, statusID, priority, dueDate)
        VALUES (
            (i), -- Linking 1:1 to rooms for the first 500
            (floor(random() * 5) + 1), 
            (floor(random() * 5) + 1), 
            (floor(random() * 5) + 1), 
            CURRENT_DATE + (i % 30)
        );
    END LOOP;

    -- 6. Insert 500 ROOM CHECKS (Quality Inspections)
    FOR i IN 1..500 LOOP
        INSERT INTO ROOMCHECK (roomID, employeeID, checkDate, score)
        VALUES (
            (floor(random() * 500) + 1),
            (floor(random() * 500) + 1),
            CURRENT_TIMESTAMP - (random() * INTERVAL '30 days'),
            (floor(random() * 41) + 60) -- Scores between 60 and 100
        );
    END LOOP;

    -- 7. Insert 500 BELONGSTO (Linking Employees to Tasks)
    FOR i IN 1..500 LOOP
        INSERT INTO BELONGSTO (employeeID, taskID)
        VALUES (i, i) ON CONFLICT DO NOTHING;
    END LOOP;

    -- 8. [BIG DATA] Insert 20,000 CLEANNINGLOG entries
    -- Represents the history of work performed
    FOR i IN 1..20000 LOOP
        INSERT INTO CLEANNINGLOG (taskID, employeeID, startTime, endTime, comment)
        VALUES (
            (floor(random() * 500) + 1),
            (floor(random() * 500) + 1),
            CURRENT_TIMESTAMP - (random() * INTERVAL '60 days'),
            CURRENT_TIMESTAMP - (random() * INTERVAL '59 days'),
            'Task completed successfully log entry #' || i
        );
    END LOOP;

    -- 9. [BIG DATA] Insert 20,000 USES entries
    -- Represents the consumption of supplies over time
    FOR i IN 1..20000 LOOP
        INSERT INTO USES (suppliesID, taskID, quantityUsed)
        VALUES (
            (floor(random() * 500) + 1),
            (floor(random() * 500) + 1),
            (floor(random() * 5) + 1)
        ) ON CONFLICT DO NOTHING;
    END LOOP;

END $$;