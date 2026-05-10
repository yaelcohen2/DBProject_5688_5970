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