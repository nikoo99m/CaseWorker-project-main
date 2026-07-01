USE CouncilTaxDB4;

BULK INSERT BillingAuthority
FROM 'C:\Users\negin\Desktop\Desktop\Nikoo2\answers auto\data\billing_authorities.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CHECK_CONSTRAINTS
);

BULK INSERT CouncilTaxBand
FROM 'C:\Users\negin\Desktop\Desktop\Nikoo2\answers auto\data\council_tax_bands.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CHECK_CONSTRAINTS
);

BULK INSERT Address
FROM 'C:\Users\negin\Desktop\Desktop\Nikoo2\answers auto\data\addresses.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CHECK_CONSTRAINTS
);

BULK INSERT Property
FROM 'C:\Users\negin\Desktop\Desktop\Nikoo2\answers auto\data\properties.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CHECK_CONSTRAINTS
    
);
