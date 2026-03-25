-- 1. First, drop relationship and log tables (which depend on tasks, employees, and supplies)
DROP TABLE IF EXISTS USES;
DROP TABLE IF EXISTS BELONGSTO;
DROP TABLE IF EXISTS CLEANNINGLOG;
DROP TABLE IF EXISTS ROOMCHECK;

-- 2. Next, drop the main transaction table (which depends on rooms, statuses, and types)
DROP TABLE IF EXISTS HOUSEKEPINGTASK;

-- 3. Finally, drop the base lookup and entity tables (which have no foreign keys)
DROP TABLE IF EXISTS CLEANINGSUPPLIES;
DROP TABLE IF EXISTS HOUSEKEEPINGEMPLOYEE;
DROP TABLE IF EXISTS HOUSEKEEPINGSTATUS;
DROP TABLE IF EXISTS TASKTYPE;
DROP TABLE IF EXISTS ROOM;