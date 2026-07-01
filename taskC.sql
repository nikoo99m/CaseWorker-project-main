SELECT
    CONCAT(
        'Valuation Office Case Reference: CT-', p.property_id,
        ' | Property: ', a.building_number, ' ', a.street, ', ', a.town, ', ', a.postcode,
        ' | Billing Authority: ', ba.authority_name,
        ' | Current Band: ', p.band_code,
        ' | Date Issued: ', GETDATE()
    ) AS letterhead
FROM Property AS p
JOIN Address AS a
    ON a.address_id = p.address_id
JOIN BillingAuthority AS ba
    ON ba.billing_authority_id = p.billing_authority_id
ORDER BY p.property_id;