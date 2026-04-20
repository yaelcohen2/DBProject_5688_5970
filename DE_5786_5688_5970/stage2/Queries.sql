-- Query 1: Get the average room check score for each employee, along with the total number of checks performed.
-- This query uses JOIN, GROUP BY, and HAVING clauses to filter and aggregate data.
SELECT
    E.name AS EmployeeName,
    COUNT(RC.checkID) AS TotalChecksPerformed,
    ROUND(AVG(RC.score), 2) AS AverageScore
FROM
    HOUSEKEEPINGEMPLOYEE E
JOIN
    ROOMCHECK RC ON E.employeeID = RC.employeeID
GROUP BY
    E.name
HAVING
    COUNT(RC.checkID) > 1
ORDER BY
    AverageScore DESC;

-- Query 2: Find the total quantity used for each cleaning supply for urgent tasks (priority = 5).
-- This query joins three tables and filters by a specific priority level.
SELECT
    S.name AS SupplyName,
    SUM(U.quantityUsed) AS TotalUsed
FROM
    CLEANNINGSUPPLIES S
JOIN
    USES U ON S.suppliesID = U.suppliesID
JOIN
    HOUSEKEPINGTASK T ON U.taskID = T.taskID
WHERE
    T.priority = 5
GROUP BY
    S.name
ORDER BY
    TotalUsed DESC;

-- Query 3: For each room, find the total number of tasks that are currently 'In Progress'.
-- This query lists rooms directly since the 'floor' column is absent in the live data.
SELECT
    R.roomnumber AS RoomNumber,
    COUNT(T.taskID) AS InProgressTasks
FROM
    ROOM R
JOIN
    HOUSEKEPINGTASK T ON R.roomID = T.roomID
JOIN
    HOUSEKEEPINGSTATUS HS ON T.statusID = HS.statusID
WHERE
    HS.statusName = 'In Progress'
GROUP BY
    R.roomnumber
ORDER BY
    R.roomnumber;

-- Query 4: Calculate the average duration in minutes for each task type based on completed cleaning logs.
-- This query joins multiple tables, extracts the time duration, and groups by task type.
SELECT
    TT.name AS TaskTypeName,
    ROUND(AVG(EXTRACT(EPOCH FROM (CL.endTime - CL.startTime)) / 60), 2) AS AvgDurationMinutes
FROM
    TASKTYPE TT
JOIN
    HOUSEKEPINGTASK HT ON TT.taskTypeID = HT.taskTypeID
JOIN
    CLEANNINGLOG CL ON HT.taskID = CL.taskID
WHERE
    CL.endTime IS NOT NULL
GROUP BY
    TT.name
ORDER BY
    AvgDurationMinutes DESC;






/* ======================================================================
   QUERY 1: Task Execution Count by Type (April 2026)
   ====================================================================== */

/* Version A: Standard 3-Table Join 
   Description: Counts the number of times each task type was performed in April 2026.
   Logic: Joins the cleaning logs, assigned tasks, and task types.
   Performance: Suitable for small to medium-sized databases.
*/
SELECT 
    tt.name AS task_type_name, 
    COUNT(cl.logID) AS times_performed
FROM TASKTYPE tt
JOIN HOUSEKEEPINGTASK ht ON tt.taskTypeID = ht.taskTypeID
JOIN CLEANINGLOG cl ON ht.taskID = cl.taskID
WHERE cl.startTime >= '2026-04-01' AND cl.startTime < '2026-05-01'
GROUP BY tt.taskTypeID, tt.name
ORDER BY times_performed DESC;


/* Version B: Aggregated Subquery (Derived Table)
   Description: Counts the number of times each task type was performed in April 2026.
   Logic: Performs the aggregation (COUNT) in a subquery before joining to get the task name.
   Performance Benefit: The aggregation is performed only on numeric columns (IDs) before string data (name) is joined, saving memory and processing time.
*/
SELECT 
    tt.name AS task_type_name,
    task_summary.times_performed
FROM TASKTYPE tt
JOIN (
    -- Subquery: Counts logs per task type from the tasks and logs tables only
    SELECT ht.taskTypeID, COUNT(cl.logID) AS times_performed
    FROM HOUSEKEEPINGTASK ht
    JOIN CLEANINGLOG cl ON ht.taskID = cl.taskID
    WHERE cl.startTime >= '2026-04-01' AND cl.startTime < '2026-05-01'
    GROUP BY ht.taskTypeID
) AS task_summary ON tt.taskTypeID = task_summary.taskTypeID
ORDER BY times_performed DESC;


/* ======================================================================
QUERY 2: Identifying "Dormant" Employees (Inactive Personnel)
English Objective: This query identifies staff members who are registered in the hotel system but have no recorded activity in the execution logs.
   ====================================================================== */

/* Version A: Static Set Comparison.
   This version generates a complete list of room IDs from the ROOMCHECK table 
   and filters the ROOM table to find IDs that are NOT present in that list.
*/
SELECT roomID, roomNumber, floor
FROM ROOM
WHERE roomID NOT IN (
    SELECT DISTINCT roomID 
    FROM ROOMCHECK
);

/* Version B: Existence Check (Correlated Subquery).
   This version checks for the absence of a relationship for each room row. 
   It stops searching as soon as it finds a single match (Short-circuit logic).
*/
SELECT r.roomID, r.roomNumber, r.floor
FROM ROOM r
WHERE NOT EXISTS (
    SELECT 1 
    FROM ROOMCHECK rc 
    WHERE rc.roomID = r.roomID
);



