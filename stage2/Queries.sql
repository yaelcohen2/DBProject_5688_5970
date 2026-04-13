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
