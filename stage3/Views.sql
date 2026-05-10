-- ==========================================
-- Part 1: Creating the Views
-- ==========================================

-- 1. View: Cleaning assignments with employee details
-- This view joins the cleaning log with the unified employees table.
-- Using 'logid' and 'employeeid' based on the integrated schema.
CREATE OR REPLACE VIEW cleaning_assignments_view AS
SELECT 
    cl.logid,
    cl.starttime,
    cl.endtime,
    e.firstname,
    e.lastname,
    e.email
FROM cleaninglog cl
JOIN employees e ON cl.employeeid = e.employeeid;

-- 2. View: Room inspection report
-- Changed 'roomnumber' to 'roomid' to match your database structure.
CREATE OR REPLACE VIEW room_inspection_report AS
SELECT 
    rc.checkid,
    rc.roomid,
    rc.checkdate,
    rc.score,
    e.firstname AS inspector_first_name,
    e.lastname AS inspector_last_name
FROM roomcheck rc
JOIN employees e ON rc.employeeid = e.employeeid;

-- 3. View: Task management overview
-- Joining housekeeping tasks with the assigned employees.
-- Includes task priority and due date.
CREATE OR REPLACE VIEW task_employee_overview AS
SELECT 
    ht.taskid,
    ht.priority,
    ht.duedate,
    ht.roomid,
    e.firstname,
    e.lastname
FROM housekeepingtask ht
JOIN employees e ON ht.employeeid = e.employeeid;


-- ==========================================
-- Part 2: Queries on the Views
-- ==========================================

-- Queries for View 1: cleaning_assignments_view
-- Query 1.1: Count the number of cleanings performed by each employee by name.
SELECT firstname, lastname, COUNT(*) 
FROM cleaning_assignments_view 
GROUP BY firstname, lastname;

-- Query 1.2: Retrieve all cleanings performed by a specific employee (e.g., 'Dasi').
SELECT * FROM cleaning_assignments_view 
WHERE firstname = 'Dasi';


-- Queries for View 2: room_inspection_report
-- Query 2.1: Display the average score given by each inspector.
SELECT inspector_first_name, AVG(score) 
FROM room_inspection_report 
GROUP BY inspector_first_name;

-- Query 2.2: Retrieve inspections that received a score lower than 3.
SELECT * FROM room_inspection_report 
WHERE score < 3;


-- Queries for View 3: task_employee_overview
-- Query 3.1: Display only urgent tasks (Priority 1).
SELECT * FROM task_employee_overview 
WHERE priority = 1;

-- Query 3.2: Display tasks associated with a specific room (e.g., Room 104).
SELECT * FROM task_employee_overview 
WHERE roomid = 104;