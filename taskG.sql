USE CouncilTaxDB4;
DECLARE @CASE_ID INT = 1;
DECLARE @PROPERTY_ID INT = 1008; 
DECLARE @CASE_WORKER VARCHAR(100) = 'Nikoo';
DECLARE @TAXPAYER_NAME VARCHAR(100) = 'John Smith'; 
DECLARE @OLD_BAND VARCHAR = 'C';
DECLARE @NEW_BAND VARCHAR = 'D';
DECLARE @UPRN VARCHAR(50) = 'UPRN008'; 
DECLARE @Audit_ID INT = 1 ;


/* Scenario:
   UPRN008, 11 Market Lane, Manchester, M1 3CC is currently in Band C.
   The taxpayer says similar nearby flats at 7 and 9 Market Lane are in Band B.
*/

/* 1. Open new Case */

INSERT INTO CaseActivity
(
    case_id,
    property_id,
    case_type,
    opened_date,
    status,
    outcome,
    case_worker,
    taxpayer_name,
    reason,
    evidence_summary
)
VALUES(
    @CASE_ID,
    @PROPERTY_ID,
    'Band challenge',
    GETDATE(),
    'Open',
    'Challenge accepted-under review',
    @CASE_WORKER,
    @TAXPAYER_NAME,
    'Neighbouring properties are in Band B.',
    'Photos and neighbouring property records submitted.')


/* 2. Capture the property address, postcode, current band,
      taxpayer details and reason for challenge. */
SELECT
    p.property_id,
    p.uprn,
    a.address_key AS property_address,
    a.postcode,
    p.band_code AS current_band,
    c.taxpayer_name, 
    c.reason
FROM Property AS p
   JOIN Address AS a
    ON a.address_id = p.address_id
   JOIN CaseActivity AS c
   ON c.property_id = p.property_id
WHERE p.uprn = @UPRN;


/* 3. Check whether comparable properties are similar by location,
      type, age and size. */

SELECT 
    cp.property_id,
    cp.uprn,
    ca.address_key AS comparable_address,
    cp.band_code AS comparable_band,
    cp.property_type,
    cp.age_period,
    cp.floor_area_m2,
    cp.total_rooms,
    cp.floors,
    ABS(cp.floor_area_m2 - p.floor_area_m2) AS floor_area_difference_m2
FROM Property AS p
JOIN Property AS cp
    ON cp.property_id <> p.property_id
JOIN Address AS ca
    ON ca.address_id = cp.address_id
WHERE p.uprn = @UPRN
  AND cp.billing_authority_id = p.billing_authority_id
  AND cp.property_type = p.property_type
  AND cp.age_period = p.age_period
  AND cp.floor_area_m2 BETWEEN p.floor_area_m2 * 0.80 AND p.floor_area_m2 * 1.20

    
/* 4 Update the property band from C to B. */
UPDATE Property
SET band_code = 'B'
WHERE uprn = @UPRN
  AND band_code = 'C';


/* 5 Record the band change in the audit trail. */


INSERT INTO AuditTrail
(   audit_id,
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
    'UPDATE',
    'band_code',
    @OLD_BAND,
    @NEW_BAND,
    @CASE_WORKER,
    GETDATE(),
    'Band challenge accepted after reviewing similar lower-banded comparable flats.')

    select * from AuditTrail



/* 6. Close the case */

UPDATE CaseActivity
SET
    status = 'Closed',
    outcome = 'Band changed',
    decision_date = GETDATE()
WHERE case_id = @CASE_ID






