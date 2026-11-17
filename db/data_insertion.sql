
ALTER TABLE item DROP CONSTRAINT IF EXISTS item_full_set_key;
ALTER TABLE item DROP CONSTRAINT IF EXISTS item_org_total_no_key;
ALTER TABLE item DROP CONSTRAINT IF EXISTS item_actual_total_no_key;
ALTER TABLE item DROP CONSTRAINT IF EXISTS item_total_missing_no_key;


select * from item;


SELECT sku, COUNT(*) 
FROM item 
GROUP BY sku 
HAVING COUNT(*) > 1;

delete from item;


select * from  bin;
select * from  manufacturer;
select * from  collection;

select * from  category;
select * from item;
select * from themes;

select count(*) from item where category_id  = 8;

delete from category where id = 2;

-- 1. Ensure 'Trees' category exists
INSERT INTO category (category_name)
VALUES ('Trees')
ON CONFLICT (category_name) DO NOTHING;

-- 2. Create temporary staging table for the Trees tab
CREATE TEMP TABLE item_stage (
    manufacturer_name TEXT,
    collection_name TEXT,
    sku TEXT,
    item_name TEXT,
    bin_no TEXT,
    full_set TEXT,
    org_total_no TEXT,
    actual_total_no TEXT,
    total_missing_no TEXT,
    price TEXT,
    notes TEXT
);

-- 3. Insert all rows into staging (with Trees in planters mapped to Village Accessories)
INSERT INTO item_stage VALUES
('Department 56', 'Village Accessories', '52639', 'Lighted Town Tree', '', 'yes', '', '', '', '', ''),
('Department 56', 'Village Pole Pine Tree', '5528-0', 'Cold Cast Porcelain Tree', '11', 'yes', '1', '', '', '10.5', ''),
('Department 56', 'Village Pole Pine Tree', '5221-3', 'Cold Cast Porcelain Tree', '12', 'yes', '2', '', '', '', ''),
('Department 56', 'Village Accessories', '56.5263', 'Holly Tree', '12', 'yes', '1', '', '', '10', ''),
('Department 56', 'Village Accessories', '5246-9', 'Pencil Pines', '13', 'yes', '3', '', '', '14.99', ''),
('Department 56', 'Village Accessories', '52051', 'Evergreen Trees', '14', 'yes', '3', '', '', '', ''),
('Department 56', 'Village Accessories', '5205-1', 'Evergreen Trees', '14', 'yes', '3', '', '', '13.79', ''),
('Department 56', 'Village Accessories', '52615', 'Snowy Scotch Pines', '14', 'yes', '3', '', '', '', ''),
('Department 56', 'Village Accessories', '5205-1', 'Evergreen Trees', '14', 'yes', '3', '', '', '', ''),
('Department 56', 'Village Accessories', '810836', 'Snow Laden Sisals', '16', 'yes', '3', '', '', '27.5', ''),
('Department 56', 'Village Accessories', '52615', 'Snowy Scotch Pines', '17', 'yes', '3', '', '', '15', ''),
('Department 56', 'Village Accessories', '5221-3', 'Pine Cone Trees', '18', 'yes', '2', '', '', '', ''),
('Department 56', 'Village Accessories', '5192-6', 'Trees in planters', '20', 'yes', '2', '', '', '', ''),
('Department 56', 'Village Accessories', '5246-9', 'Pencil Pines', '23', 'yes', '3', '', '', '', ''),
('Department 56', 'Village Accessories', '5205-1', 'Evergreen Trees', '23', 'no', '3', '', '1', '13.79', 'Missing medium tree');

-- 4. Auto-ensure any new manufacturers, collections, or bins exist
INSERT INTO manufacturer (manufacturer_name)
SELECT DISTINCT manufacturer_name FROM item_stage
ON CONFLICT (manufacturer_name) DO NOTHING;

INSERT INTO collection (collection_name)
SELECT DISTINCT collection_name FROM item_stage
ON CONFLICT (collection_name) DO NOTHING;

INSERT INTO bin (bin_no)
SELECT DISTINCT bin_no::numeric FROM item_stage
WHERE bin_no ~ '^[0-9]+$'
ON CONFLICT (bin_no) DO NOTHING;

-- 5. Insert rows into the main item table under the 'Trees' category
INSERT INTO item (
    manufacturer_id, 
    collection_id, 
    category_id,
    bin_id, 
    sku, 
    item_name, 
    full_set, 
    org_total_no, 
    actual_total_no, 
    total_missing_no, 
    price, 
    notes
)
SELECT 
    m.id, 
    c.id, 
    cat.id,
    b.id, 
    s.sku, 
    s.item_name, 
    s.full_set, 
    NULLIF(s.org_total_no, '')::numeric, 
    NULLIF(s.actual_total_no, '')::numeric, 
    NULLIF(s.total_missing_no, '')::numeric, 
    NULLIF(s.price, '')::numeric, 
    NULLIF(s.notes, '')
FROM item_stage s
JOIN manufacturer m ON m.manufacturer_name = s.manufacturer_name
JOIN collection c ON c.collection_name = s.collection_name
JOIN category cat ON cat.category_name = 'Trees'
LEFT JOIN bin b ON b.bin_no = NULLIF(s.bin_no, '')::numeric;

-- 6. Clean up staging
DROP TABLE item_stage;