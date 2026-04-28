
/* ======================================================================
   COMMIT & ROLLBACK DEMONSTRATION
   This file wraps all DELETE and UPDATE queries in transactions
   to demonstrate manual control over data flow.
   ====================================================================== */


/* ======================================================================
   DELETE QUERIES (with Transaction Control)
   ====================================================================== */

/* Query 1: Delete Specific Cleaning Log Entry */
-- Transaction: ROLLBACK — demonstrates undoing the deletion.
BEGIN;

DELETE FROM CLEANINGLOG
WHERE logID = 105;

ROLLBACK;


/* Query 2: Archive - Delete Old Cleaning Logs for Floor 1 */
-- Transaction: COMMIT — demonstrates saving the deletion permanently.
BEGIN;

DELETE FROM CLEANINGLOG
WHERE startTime < '2026-04-10'
AND taskID IN (
    SELECT taskID 
    FROM HOUSEKEEPINGTASK 
    WHERE roomID IN (
        SELECT roomID 
        FROM ROOM 
        WHERE roomnumber LIKE 'R-1%'
    )
);

COMMIT;


/* Query 3: Delete Usage History for a Specific Supply Item */
-- Transaction: ROLLBACK — demonstrates undoing the deletion.
BEGIN;

DELETE FROM USES
WHERE suppliesID = (
    SELECT suppliesID 
    FROM CLEANINGSUPPLIES 
    WHERE name = 'Supply_Item_27'
);

ROLLBACK;


/* ======================================================================
   UPDATE QUERIES (with Transaction Control)
   ====================================================================== */

/* Update 1: Escalate priority to urgent (5) for all 'In Progress' tasks that are overdue. */
-- Transaction: ROLLBACK — demonstrates undoing the change.
BEGIN;

UPDATE HOUSEKEPINGTASK
SET priority = 5
WHERE statusID = (
    SELECT statusID 
    FROM HOUSEKEEPINGSTATUS 
    WHERE statusName = 'In Progress'
)
AND dueDate < CURRENT_DATE;

ROLLBACK;


/* Update 2: Restock cleaning supplies by adding 50 units to any item with low inventory (below 10). */
-- Transaction: COMMIT — demonstrates saving the change permanently.
BEGIN;

UPDATE CLEANNINGSUPPLIES
SET quantity = quantity + 50
WHERE quantity < 10;

COMMIT;


/* Update 3: Mark tasks as 'Clean' when their cleaning log shows a completed end time. */
-- Transaction: ROLLBACK — demonstrates undoing the change.
BEGIN;

UPDATE HOUSEKEPINGTASK
SET statusID = (
    SELECT statusID 
    FROM HOUSEKEEPINGSTATUS 
    WHERE statusName = 'Clean'
)
WHERE taskID IN (
    SELECT taskID 
    FROM CLEANNINGLOG 
    WHERE endTime IS NOT NULL
)
AND statusID != (
    SELECT statusID 
    FROM HOUSEKEEPINGSTATUS 
    WHERE statusName = 'Clean'
);

ROLLBACK;
