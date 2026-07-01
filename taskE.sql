USE CouncilTaxDB4;
DECLARE @CASE_ID INT = 2;
DECLARE @PROPERTY_ID INT = 1009; 
DECLARE @CASE_WORKER VARCHAR(100) = 'Nikoo';
DECLARE @TAXPAYER_NAME VARCHAR(100) = 'Rose King'; 
DECLARE @UPRN VARCHAR(50) = 'UPRN009';
DECLARE @ADDRESS_ID INT = 10;
DECLARE @Audit_ID INT = 2;



/* Scenario:
   Finding exact duplicate address records.

   The duplicate address rows does not point to any property, so they can be
   reviewed and removed after the case worker confirms the duplication.
*/


/* 1. Find exact duplicate address records */


WITH DuplicateAddressKeys AS (
    SELECT
        address_key
    FROM Address
    GROUP BY address_key
    HAVING COUNT(*) > 1
)
SELECT
    p.property_id,
    p.uprn,
    a.address_id,
    a.address_key,
    CASE
        WHEN p.property_id IS NULL
            THEN 1
        ELSE 0
    END AS is_duplciate
FROM Address AS a
    JOIN DuplicateAddressKeys AS d
    ON d.address_key = a.address_key
LEFT JOIN Property AS p
    ON p.address_id = a.address_id
ORDER BY
    a.address_key,
    a.address_id;


/* 2. Open new duplicate address review cases after finding the duplicates */

INSERT INTO CaseActivity(

    case_id,
    property_id,
    case_type,
    opened_date,
    status,
    outcome,
    case_worker,
    taxpayer_name,
    reason,
    evidence_summary)
VALUES(
    @CASE_ID,
    @PROPERTY_ID,
    'Duplicate address review',
    GETDATE(),
    'Open',
    'Duplicate under review',
    @CASE_WORKER,
    @TAXPAYER_NAME,
    'Exact duplicate address found.',
    'Exact duplicate address found with no property linked to one duplicate address row..')



/* 3. Remove the unused duplicate address rows */

DELETE FROM Address
WHERE address_id = @ADDRESS_ID
 


/* 4. Record the duplicate address decision in the audit trail */

INSERT INTO AuditTrail
(
    audit_id,
    case_id,
    property_id,
    action_type,
    column_name,
    old_value,
    new_value,
    changed_by,
    change_date,
    reason
)
VALUES(
    @Audit_ID,    
    @CASE_ID,
    @PROPERTY_ID,
    'DELETE',
    'address_id',
    Null,
    NULL,
    @CASE_WORKER,
    GETDATE(),
    'Duplicate address ID 10 removed. Address ID 9 retained as the valid address record.')


/* 5. Close the duplicate address review cases */

UPDATE CaseActivity
SET
    status = 'Closed',
    outcome = 'Duplicate address removed',
    decision_date = GETDATE()
WHERE case_id = @CASE_ID







