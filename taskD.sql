SELECT
    ba.authority_name,
    p1.band_code,
    p1.property_id AS property_1,
    p2.property_id AS property_2,
    p1.floor_area_m2 AS floor_area_1,
    p2.floor_area_m2 AS floor_area_2
FROM Property AS p1
JOIN Property AS p2
    ON p1.property_id < p2.property_id
   AND p1.billing_authority_id = p2.billing_authority_id
   AND p1.band_code = p2.band_code
   AND p2.floor_area_m2 BETWEEN p1.floor_area_m2 * 0.90
                           AND p1.floor_area_m2 * 1.10
JOIN BillingAuthority AS ba
    ON ba.billing_authority_id = p1.billing_authority_id
ORDER BY
    ba.authority_name,
    p1.band_code


   

SELECT
    ba.authority_name,
    p1.band_code,
    COUNT(*) AS comparable_pairs
FROM Property AS p1
JOIN Property AS p2
    ON p1.property_id < p2.property_id
   AND p1.billing_authority_id = p2.billing_authority_id
   AND p1.band_code = p2.band_code
   AND p2.floor_area_m2 BETWEEN p1.floor_area_m2 * 0.90
                           AND p1.floor_area_m2 * 1.10
JOIN BillingAuthority AS ba
    ON ba.billing_authority_id = p1.billing_authority_id
GROUP BY
    ba.authority_name,
    p1.band_code
ORDER BY
    ba.authority_name,
    p1.band_code;
  





    





