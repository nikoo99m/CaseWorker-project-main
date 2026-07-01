SELECT
    ba.authority_name,
    p.band_code,
    COUNT(*) AS total_property
FROM Property AS p
JOIN BillingAuthority AS ba
    ON ba.billing_authority_id = p.billing_authority_id
GROUP BY
    ba.authority_name,
    p.band_code
ORDER BY
    ba.authority_name,
    p.band_code;
