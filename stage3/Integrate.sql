-- =============================================================
-- PART 1: SCHEMA INTEGRATION (Structural Changes)
-- =============================================================

-- Add the employee reference column ONLY if it doesn't exist yet
ALTER TABLE housekeepingtask ADD COLUMN IF NOT EXISTS employeeid integer;

-- Drop the constraints first if they exist to avoid "already exists" errors
ALTER TABLE roomcheck DROP CONSTRAINT IF EXISTS fk_rc_new_emp;
ALTER TABLE cleaninglog DROP CONSTRAINT IF EXISTS fk_cl_new_emp;
ALTER TABLE housekeepingtask DROP CONSTRAINT IF EXISTS fk_ht_new_emp;

-- Apply Foreign Key constraints to link Housekeeping with HR System
ALTER TABLE roomcheck 
ADD CONSTRAINT fk_rc_new_emp 
FOREIGN KEY (employeeid) REFERENCES employees(employeeid);

ALTER TABLE cleaninglog 
ADD CONSTRAINT fk_cl_new_emp 
FOREIGN KEY (employeeid) REFERENCES employees(employeeid);

ALTER TABLE housekeepingtask 
ADD CONSTRAINT fk_ht_new_emp 
FOREIGN KEY (employeeid) REFERENCES employees(employeeid);


-- =============================================================
-- PART 2: DATA POPULATION (For Testing & Report Visibility)
-- =============================================================

-- Populate empty foreign key columns with a default employee (ID 1)
UPDATE housekeepingtask SET employeeid = 1 WHERE employeeid IS NULL;
UPDATE cleaninglog SET employeeid = 1 WHERE employeeid IS NULL;
UPDATE roomcheck SET employeeid = 1 WHERE employeeid IS NULL;