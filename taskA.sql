SELECT
    p.property_id,
    p.uprn,
    ba.authority_name,
    p.band_code,
    ba.region
    FROM Property AS p
JOIN BillingAuthority AS ba
    ON ba.billing_authority_id = p.billing_authority_id

ORDER BY band_code, authority_name
