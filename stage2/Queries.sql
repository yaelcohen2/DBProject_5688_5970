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
    CLEANINGSUPPLIES S
JOIN
    USES U ON S.suppliesID = U.suppliesID
JOIN
    HOUSEKEEPINGTASK T ON U.taskID = T.taskID
WHERE
    T.priority = 5
GROUP BY
    S.name
ORDER BY
    TotalUsed DESC;

-- Query 3: For each floor, find the total number of tasks that are currently 'In Progress'.
-- This query aggregates data per floor, joining rooms, tasks, and statuses.
SELECT
    R.floor AS FloorNumber,
    COUNT(T.taskID) AS InProgressTasks
FROM
    ROOM R
JOIN
    HOUSEKEEPINGTASK T ON R.roomID = T.roomID
JOIN
    HOUSEKEEPINGSTATUS HS ON T.statusID = HS.statusID
WHERE
    HS.statusName = 'In Progress'
GROUP BY
    R.floor
ORDER BY
    R.floor;

-- Query 4: Calculate the average duration in minutes for each task type based on completed cleaning logs.
-- This query joins multiple tables, extracts the time duration, and groups by task type.
SELECT
    TT.name AS TaskTypeName,
    ROUND(AVG(EXTRACT(EPOCH FROM (CL.endTime - CL.startTime)) / 60), 2) AS AvgDurationMinutes
FROM
    TASKTYPE TT
JOIN
    HOUSEKEEPINGTASK HT ON TT.taskTypeID = HT.taskTypeID
JOIN
    CLEANINGLOG CL ON HT.taskID = CL.taskID
WHERE
    CL.endTime IS NOT NULL
GROUP BY
    TT.name
ORDER BY
    AvgDurationMinutes DESC;
