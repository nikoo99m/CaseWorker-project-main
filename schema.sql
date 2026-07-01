USE CouncilTaxDB4;

DROP TABLE IF EXISTS AuditTrail;
DROP TABLE IF EXISTS CaseActivity;
DROP TABLE IF EXISTS Property;
DROP TABLE IF EXISTS Address;
DROP TABLE IF EXISTS CouncilTaxBand;
DROP TABLE IF EXISTS BillingAuthority;

CREATE TABLE BillingAuthority (
    billing_authority_id INT NOT NULL PRIMARY KEY,
    authority_name VARCHAR(100) NOT NULL,
    region VARCHAR(100) NULL
);

CREATE TABLE CouncilTaxBand (
    band_code CHAR(1) NOT NULL PRIMARY KEY,
    lower_value DECIMAL(12, 2) NULL,
    upper_value DECIMAL(12, 2) NULL,
    country VARCHAR(50) NULL,
    CONSTRAINT CK_CouncilTaxBand_BandCode CHECK (band_code BETWEEN 'A' AND 'H')
);

CREATE TABLE Address (
    address_id INT NOT NULL PRIMARY KEY,
    building_number VARCHAR(20) NULL,
    street VARCHAR(100) NULL,
    town VARCHAR(100) NOT NULL,
    postcode VARCHAR(10) NULL,
    address_key AS UPPER(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        CONCAT(building_number, '_', street, '_', town, '_', postcode),
                        ' ',
                        ''
                    ),
                    ',',
                    ''
                ),
                '.',
                ''
            ),
            '-',
            ''
        )
    ) 
   
);

CREATE TABLE Property (
    property_id INT NOT NULL PRIMARY KEY,
    uprn VARCHAR(50) NOT NULL,
    address_id INT NOT NULL,
    billing_authority_id INT NOT NULL,
    band_code CHAR(1) NOT NULL,
    property_type VARCHAR(50) NOT NULL,
    age_period VARCHAR(50) NOT NULL,
    floor_area_m2 INT NOT NULL,
    total_rooms INT NULL,
    bedrooms INT NULL,
    bathrooms INT NULL,
    floors INT NULL,
    status VARCHAR(20) NULL,
    CONSTRAINT FK_Property_Address FOREIGN KEY (address_id) REFERENCES Address(address_id),
    CONSTRAINT FK_Property_BillingAuthority FOREIGN KEY (billing_authority_id) REFERENCES BillingAuthority(billing_authority_id),
    CONSTRAINT FK_Property_CouncilTaxBand FOREIGN KEY (band_code) REFERENCES CouncilTaxBand(band_code),
    CONSTRAINT CK_Property_FloorArea CHECK (floor_area_m2 > 0),
    CONSTRAINT CK_Property_TotalRooms CHECK (total_rooms > 0),
    CONSTRAINT CK_Property_Bedrooms CHECK (bedrooms >= 0),
    CONSTRAINT CK_Property_Bathrooms CHECK (bathrooms >= 0),
    CONSTRAINT CK_Property_Floors CHECK (floors > 0),
);


CREATE TABLE CaseActivity (
    case_id INT NOT NULL PRIMARY KEY,
    property_id INT NOT NULL,
    case_type VARCHAR(50) NOT NULL,
    opened_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    outcome VARCHAR(100) NULL,
    case_worker VARCHAR(100) NOT NULL,
    taxpayer_name VARCHAR(100) NULL,
    reason VARCHAR(500) NULL,
    evidence_summary VARCHAR(500) NULL,
    decision_date DATE NULL,
    CONSTRAINT FK_CaseActivity_Property FOREIGN KEY (property_id) REFERENCES Property(property_id)
);

CREATE TABLE AuditTrail (
    audit_id INT NOT NULL PRIMARY KEY,
    case_id INT NOT NULL,
    property_id INT NOT NULL,
    action_type VARCHAR(20) NOT NULL,
    column_name VARCHAR(50) NOT NULL,
    old_value VARCHAR(255) NULL,
    new_value VARCHAR(255) NULL,
    changed_by VARCHAR(100) NOT NULL,
    change_date DATETIME NOT NULL,
    reason VARCHAR(255) NULL,
    CONSTRAINT FK_AuditTrail_Case FOREIGN KEY (case_id) REFERENCES CaseActivity(case_id),
    CONSTRAINT FK_AuditTrail_Property FOREIGN KEY (property_id) REFERENCES Property(property_id),
    
);