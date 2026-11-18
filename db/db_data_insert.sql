DO $$
BEGIN
    FOR i IN 2..27 LOOP
        RAISE NOTICE 'Current number: %', i;
        insert into bin(bin_no) values(i);
    END LOOP;
END $$;

insert into manufacturer (manufacturer_name) values('Department 56'),('Heritage Village Collection' );
insert into collection (collection_name) values('Dickens Village'),('North Pole Series'), ('Snow Village'), ('New England Village Series'),('Heritage Village Collection'), ('Seasons Bay'), ('Village'), ('Village Accessories'),('Village Pole Pine Tree');
insert into category (category_name) values('House'),('Tree'), ('Figurine');

select * from  bin;
select * from  manufacturer;
select * from  collection;

select * from  category;
select * from item;
select * from themes;

-- 1. Create the temporary staging table for raw data ingest
CREATE TEMP TABLE item_stage (
    manufacturer_name TEXT,
    collection_name TEXT,
    category_name TEXT,
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

-- 2. Insert all 59 rows into staging
INSERT INTO item_stage VALUES
('Department 56', 'Snow Village', 'House', '56.55359', 'Santa''s Wonderland house', '1', 'yes', '18', '', '', '', ''),
('Department 56', 'Dickens'' Village', 'House', '56.5847', 'Fezzwig''s Ballroom', '1', 'yes', '2', '', '', '112.5', ''),
('Department 56', 'Dickens'' Village', 'House', '58500', 'Tower Of London', '1', 'Yes', '5', '', '', '165', ''),
('Department 56', 'Dickens'' Village', 'House', '5834-3', 'Dudden Cross Church', '2', 'Yes', '1', '', '', '', ''),
('Department 56', 'Dickens'' Village', 'House', '5584-0', 'Theater Royal', '2', 'yes', '1', '', '', '45', ''),
('Department 56', 'Dickens'' Village', 'House', '5823-8', 'Hather Harness', '2', 'Yes', '1', '', '', '', ''),
('Department 56', 'North Pole Series', 'House', '4025277', 'Cars holiday Detail Shop', '3', 'Yes', '1', '', '', '100', ''),
('Department 56', 'North Pole Series', 'House', '80545', 'Coca Chocolate Works', '3', 'yes', '1', '', '', '85', ''),
('Department 56', 'Dickens'' Village', 'House', '58344', 'Nettie Quinn Puppets & Marionettes', '3', 'yes', '1', '', '', '', ''),
('Department 56', 'Dickens'' Village', 'House', '58347', 'The Melancholy Tavern', '4', 'yes', '1', '', '', '45', ''),
('Department 56', 'Dickens'' Village', 'House', '5808-4', 'WM. Wheat Chakes & Puddings', '4', 'yes', '1', '', '', '', ''),
('Heritage Village Collection', 'Dickens'' Village', 'House', '5925-0', 'Nicholas Nickleby Cottage', '4', 'no', '1', '1', '0', '38', ''),
('Heritage Village Collection', 'Dickens'' Village', 'House', '58331', 'T. Puddlewick Spectacle shop', '4', 'no', '1', '1', '0', '35', ''),
('Department 56', 'Dickens'' Village', 'House', '58340', 'The Horse And Hounds Pub', '5', 'Yes', '1', '', '', '70', 'It seems like there is a part missing that goes to the house.  I can''t find it however.  It should go o the side of the house by the storm drain'),
('Department 56', 'Dickens'' Village', 'House', '56.58723', 'J. Horsley Christmas Cards', '5', 'yes', '1', '', '', '65', ''),
('Department 56', 'Dickens'' Village', 'House', '58303', 'Leacock Poulterer', '6', 'yes', '1', '', '', '48', ''),
('Department 56', 'Dickens'' Village', 'House', '56.58486', 'Cratchit''s Corner', '6', 'yes', '1', '', '', '80', ''),
('Department 56', 'Dickens'' Village', 'House', '6500-5', 'Fezziwig''s Warehouse', '6', 'yes', '1', '', '', '30', ''),
('Department 56', 'New England Village Series', 'House', '5932-3', 'Old North Church', '6', 'yes', '1', '', '', '42', ''),
('Department 56', 'Dickens'' Village', 'House', '56.58446', 'Leed''s Oyster House', '7', 'Yes', '1', '', '', '68', ''),
('Department 56', 'North Pole Series', 'House', '56.56739', 'Barbie Boutique', '7', 'yes', '1', '', '', '80', ''),
('Department 56', 'Dickens'' Village', 'House', '56.58483', 'Scrooge & Marley Counting House', '7', 'yes', '1', '', '', '80', ''),
('Department 56', 'Dickens'' Village', 'House', '5587-5', 'The Flat Of Ebenezer Scrooge', '7', 'yes', '1', '', '', '37.5', ''),
('Department 56', 'Dickens'' Village', 'House', '58314', 'Teaman & Crupp China Shop', '8', 'Yes', '2', '', '', '64', ''),
('Department 56', 'Dickens'' Village', 'House', '56.58748', 'Beckingham''s Christmas Candles', '8', 'yes', '', '', '', '80', ''),
('Department 56', 'Dickens'' Village', 'House', '56.58717', 'Victorian Family Christmas House', '8', 'yes', '6', '', '', '75', ''),
('Department 56', 'Dickens'' Village', 'House', '58341', 'Big Ben', '9', 'Yes', '2', '', '', '95', ''),
('Department 56', 'Dickens'' Village', 'House', '56.58506', 'Royal Tree Court', '9', 'yes', '8', '', '', '75', ''),
('Department 56', 'Dickens'' Village', 'House', '56.58742', 'The Timbers Hotel', '10', 'Yes', '4', '', '', '', ''),
('Department 56', 'Dickens'' Village', 'House', '56.58747', 'Thomas Gainsworth, Portrait Artist To The Queen', '10', 'No', '3', '1', '2', '85', 'The Portait Sign and the Portrait Painter sign are missing (broken)'),
('Department 56', 'Dickens'' Village', 'House', '58313', 'Heathmoor Castle', '10', 'Yes', '3', '', '', '90', ''),
('Department 56', 'North Pole Series', 'House', '56.56953', 'Light The Way - Santa''s Beacon', '11', 'no', '2', '', '1', '', 'Missing the North, west, south, east topper'),
('Department 56', 'North Pole Series', 'House', '56.5679', 'Around The World In 24 Hours Flight Center', '11', 'yes', '2', '', '', '70', ''),
('Department 56', 'North Pole Series', 'House', '4020207', 'Santa''s Hot Chocolate Cafe', '11', 'yes', '1', '', '', '45', ''),
('Department 56', 'North Pole Series', 'House', '5633-2', 'Elfin Snow Cone Works', '11', 'yes', '1', '', '', '40', ''),
('Department 56', 'North Pole Series', 'House', '56396', 'Glass Ornament Works', '12', 'yes', '1', '', '', '60', ''),
('Department 56', 'North Pole Series', 'House', '56015', 'Reindeer Barn', '12', 'yes', '1', '', '', '', ''),
('Department 56', 'North Pole Series', 'House', '56403', 'Real Plastic Snow Factory', '12', 'yes', '1', '', '', '80', ''),
('Department 56', 'North Pole Series', 'House', '56.56391', 'Route 1, North Pole, Home of Mr & Mrs Claus', '15', 'yes', '1', '', '', '110', ''),
('Department 56', 'North Pole Series', 'House', '56.56787', 'Frosty''s Christmas Weather Station', '15', 'yes', '6', '', '', '', ''),
('Department 56', 'North Pole Series', 'House', '56.56754', 'Coca -Cola Fizz Factory', '16', 'yes', '3', '', '2', '', 'Missing the flags (broken)'),
('Department 56', 'North Pole Series', 'House', '56390', 'Start A Tradition Set', '17', 'yes', '12', '', '', '', E'Gift wrap & Ribbons\nCandy Cane &. Peppermint houses'),
('Department 56', 'Dickens'' Village', 'House', '59', 'Norfolk Biffins Bakery', '18', 'yes', '', '', '', '65', ''),
('Department 56', 'Dickens'' Village', 'House', '58323', 'J. Lytes Coal Merchant', '18', 'yes', '', '', '', '50', ''),
('Department 56', 'Dickens'' Village', 'House', '58307', 'Thomas Mudge Timepieces', '19', 'yes', '', '', '', '60', ''),
('Department 56', 'Dickens'' Village', 'House', '5809-2', 'Boarding & Lodging School', '19', 'yes', '', '', '', '48', ''),
('Department 56', 'Dickens'' Village', 'House', '5567-0', 'Bishops Oast House', '20', 'yes', '', '', '', '', ''),
('Department 56', 'Dickens'' Village', 'House', '57534', 'The Grapes In', '20', 'yes', '', '', '', '', ''),
('Department 56', 'Dickens'' Village', 'House', '5557-3', 'Nephew Fred''s Flat', '21', 'yes', '', '', '', '', ''),
('Department 56', 'Dickens'' Village', 'House', '57535', 'Gad''s Hill Place', '21', 'yes', '', '', '', '', ''),
('Department 56', 'Dickens'' Village', 'House', '56.587115', 'The Red Lion Pub', '22', 'No', '3', '2', '1', '', 'Missing the banner on the front'),
('Department 56', 'Dickens'' Village', 'House', '56.58758', 'Pearce & Crump Silversmiths', '22', 'yes', '3', '', '', '85', 'Banner on the side is broken'),
('Department 56', 'Dickens'' Village', 'House', '5821-1', 'Whittlebourne Church', '22', 'yes', '1', '', '', '85', ''),
('Department 56', 'Dickens'' Village', 'House', '56.58757', 'Prettywell Sisters Lace Makers', '23', 'yes', '2', '', '', '70', 'Banner on the side is broken'),
('Department 56', 'Dickens'' Village', 'House', '56.5849', 'Ebenezer Scrooge''s House', '23', 'no', '2', '1', '1', '85', 'Hanging tree thing on the side is missing'),
('Department 56', 'Dickens'' Village', 'House', '56.58443', 'Old Queensbridge Station', '24', 'yes', '2', '', '', '100', ''),
('Department 56', 'Dickens'' Village', 'House', '56.58352', 'Chancery Courner', '26', 'No', '7', '', '1', '105', 'Missing bird feeder'),
('Department 56', 'Dickens'' Village', 'House', '56.58759', 'Cartwright Coach Builders', '25', 'yes', '2', '2', '0', '105', 'Tip of stage coach broke.  Fixed it with hot glue'),
('Department 56', 'Dickens'' Village', 'House', '5752-5', 'Dedlock Arms', '26', 'yes', '1', '1', '0', '100', '');

-- 3. Auto-ensure parent/lookup tables contain all required names/bins automatically
INSERT INTO manufacturer (manufacturer_name)
SELECT DISTINCT manufacturer_name FROM item_stage
ON CONFLICT (manufacturer_name) DO NOTHING;

INSERT INTO collection (collection_name)
SELECT DISTINCT collection_name FROM item_stage
ON CONFLICT (collection_name) DO NOTHING;

INSERT INTO category (category_name)
SELECT DISTINCT category_name FROM item_stage
ON CONFLICT (category_name) DO NOTHING;

INSERT INTO bin (bin_no)
SELECT DISTINCT bin_no::numeric FROM item_stage
ON CONFLICT (bin_no) DO NOTHING;

-- 4. Clear and cleanly load the main item table with joined IDs
TRUNCATE TABLE item RESTART IDENTITY CASCADE;

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
JOIN category cat ON cat.category_name = s.category_name
JOIN bin b ON b.bin_no = s.bin_no::numeric;

-- 5. Clean up staging
DROP TABLE item_stage;

---- figures

-- 1. Ensure bin_no has a unique constraint so ON CONFLICT works
ALTER TABLE bin DROP CONSTRAINT IF EXISTS bin_no_unique;
ALTER TABLE bin ADD CONSTRAINT bin_no_unique UNIQUE (bin_no);
ALTER TABLE item DROP CONSTRAINT IF EXISTS item_sku_key;


-- 2. Create temporary staging table for the Figurine tab
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

-- 3. Insert all rows into staging
INSERT INTO item_stage VALUES
('Department 56', 'Heritage Village Collection', '5578-6', 'Royal Coach', '9', 'Yes', '1', '', '', '56', ''),
('Department 56', 'Heritage Village Collection', '56390', 'Candy Cane Elves', '11', 'no', '2', '1', '1', '', 'Missing an elf'),
('Department 56', 'New England Village Series', '56.57108', 'Hear Ye Citizens', '11', 'yes', '1', '', '', '15', ''),
('Department 56', 'Dickens'' Village', '56.58595', 'One More Christmas Card To Post, Please', '11', 'yes', '1', '', '', '15', ''),
('Department 56', 'Dickens'' Village', '56.5846', 'Under The Bumbershoot', '11', 'yes', '1', '', '', '20', ''),
('Department 56', 'Dickens'' Village', '58393', 'Ye Old Lamplighter', '11', 'yes', '1', '', '', '', ''),
('Department 56', 'North Pole Series', '56.5609', 'Santa & Mrs. Clause', '11', 'yes', '2', '', '', '15', ''),
('Department 56', 'North Pole Series', '56.56841', 'Coca-Cola Taste Test', '11', 'yes', '1', '', '', '17.5', ''),
('Department 56', 'Heritage Village Collection', '56372', 'Don''t Break The Ornaments', '11', 'yes', '2', '', '', '27.5', ''),
('Department 56', 'Heritage Village Collection', '5571-9', 'Holiday Travelers', '14', 'yes', '3', '', '', '25', ''),
('Department 56', 'Dickens'' Village', '804449', 'Heading Home From The Market', '14', 'yes', '1', '', '', '17.5', ''),
('Department 56', 'Heritage Village Collection', '5564-6', 'Street Musicians', '14', 'yes', '3', '', '', '25.5', ''),
('Department 56', 'Heritage Village Collection', '5654-5', 'Over The River and Through The Woods', '14', 'Yes', '1', '', '', '', ''),
('Department 56', 'Heritage Village Collection', '5816-5', 'Chelsea Lane Shoppers', '14', 'Yes', '4', '', '', '30.5', ''),
('Department 56', 'Dickens'' Village', '58410', 'Here We Come A-Wassailing', '18', 'yes', '5', '', '', '45', ''),
('Department 56', 'Dickens'' Village', '58400', 'The Fezzwig Delivery Wagon', '19', 'yes', '1', '', '', '', ''),
('Department 56', 'Dickens'' Village', '56.58631', 'Christmas Carolers', '19', 'yes', '3', '', '', '27.5', ''),
('Department 56', 'Heritage Village Collection', '5966-8', 'Shopkeepers', '20', 'yes', '4', '', '', '20', ''),
('Department 56', 'Heritage Village Collection', '5884-0', 'Chamber Orchestra', '20', 'yes', '4', '', '', '', ''),
('Department 56', 'Heritage Village Collection', '56594', 'Christmas Bazaar ... Handmade Quilts', '20', 'yes', '2', '', '', '25', ''),
('Department 56', 'Dickens'' Village', '56.583', 'A Peaceful Glow On Christmas', '23', 'yes', '3', '', '', '30', ''),
('Department 56', 'Heritage Village Collection', '5581-6', 'Kings Road Cab', '23', 'yes', '1', '', '', '30', ''),
('Department 56', 'North Pole Series', '4023617', 'Lightning''s Ready To Race', '24', 'Yes', '1', '', '', '30', ''),
('Department 56', 'Heritage Village Collection', '58403', 'A Christmas Carol'' Reading By Charles Dickens', '24', 'Yes', '4', '', '', '', ''),
('Department 56', 'Dickens'' Village', '58414', 'Until We Meet Again', '24', 'Yes', '2', '', '', '27.5', ''),
('Department 56', 'Heritage Village Collection', '5561-1', 'Holiday Coach', '', 'yes', '', '', '', '', ''),
('Department 56', 'Heritage Village Collection', '5551-4', 'David Copperfield', '', 'yes', '5', '', '', '32.5', ''),
('Department 56', 'Heritage Village Collection', '5570-0', 'Carolers On The Doorstep', '', 'yes', '4', '', '', '25', ''),
('Department 56', 'Heritage Village Collection', '5588-3', 'A Christmas Carol Morning', '', 'yes', '3', '', '', '18', ''),
('Department 56', 'Heritage Village Collection', '5803-3', 'The Bird Seller', '', 'yes', '3', '', '', '', ''),
('Department 56', 'Heritage Village Collection', '5839-4', 'Cobbler & Clock Peddler', '', 'yes', '2', '', '', '', ''),
('Department 56', 'Dickens'' Village', '56.5881', 'Making Bobbin Lace', '', 'yes', '1', '', '', '15', ''),
('Department 56', 'Dickens'' Village', '56.5852', 'Holiday Quintet', '', 'no', '6', '5', '1', '37.5', 'Missing the fluet player'),
('Department 56', 'Dickens'' Village', '56.5855', 'Street Merchants', '', 'Yes', '3', '', '', '17.5', ''),
('Department 56', 'Dickens'' Village', '807230', 'Dickens Carolers', '', 'Yes', '1', '', '', '28.5', ''),
('Department 56', 'Heritage Village Collection', '5826-2', 'Chelsea Market Mistetoe Monger & Cart', '', 'Yes', '2', '', '', '25', ''),
('Department 56', 'Heritage Village Collection', '565996', 'Christmas Bazaar ...Flap Jacks & Hot Cider', '', 'Yes', '2', '', '', '27.5', ''),
('Department 56', 'Christmas In The City Series', '58901', 'A Carriage Ride For The Bride', '', 'yes', '1', '', '', '40', ''),
('Department 56', 'Heritage Village Collection', '58402', 'Gingerbread Vendor', '', 'Yes', '2', '', '', '22.5', ''),
('Department 56', 'Heritage Village Collection', '58858', 'Holiday Field Trip', '', 'Yes', '3', '', '', '', ''),
('Department 56', 'Heritage Village Collection', '58326', 'Delievering Coal For The Hearth', '', 'yes', '2', '', '', '32.5', ''),
('Department 56', 'Dickens'' Village', '56.58387', 'Twelve Drumers Drumming', '', 'Yes', '1', '', '', '65', ''),
('Department 56', 'Dickens'' Village', '58379', 'Four Calling Birds', '', 'Yes', '2', '', '', '32.5', ''),
('Department 56', 'Dickens'' Village', '58382', 'Six Geese A Laying', '', 'Yes', '2', '', '', '', ''),
('Department 56', 'Dickens'' Village', '58381', 'Five Golden Rings', '', 'Yes', '2', '', '', '', ''),
('Department 56', 'Dickens'' Village', '58385', 'Nine Ladies Dancing', '', 'Yes', '3', '', '', '30', ''),
('Department 56', 'Dickens'' Village', '58378', 'Three French Hens', '', 'Yes', '3', '', '', '', ''),
('Department 56', 'Dickens'' Village', '58386', 'Ten Pipers Piping', '', 'Yes', '3', '', '', '30', ''),
('Department 56', 'Dickens'' Village', '58383', 'Seven Swans A Swimming', '', 'Yes', '4', '', '', '27.5', ''),
('Department 56', 'Dickens'' Village', '58384', 'Eight Maids A-Milking', '', 'Yes', '2', '', '', '25', ''),
('Department 56', 'Dickens'' Village', '58413', 'Eleven Lords A-Leaping', '', '', '1', '', '', '27.5', ''),
('Department 56', 'Dickens'' Village', '5835-1', 'A Partridge In A Pear Tree', '', '', '1', '', '', '', ''),
('Department 56', 'Dickens'' Village', '5836-0', 'Two Turtle Doves', '', 'Yes', '4', '', '', '32.5', ''),
('Department 56', 'Heritage Village Collection', '5820-3', 'Dashing Through The Snow', '', 'yes', '1', '', '', '', ''),
('Department 56', 'Heritage Village Collection', '5619-7', 'Buying Baker''s Bread', '', 'Yes', '2', '', '', '', ''),
('Department 56', 'Heritage Village Collection', '5817-3', 'Vision Of A Christmas Past', '', 'Yes', '3', '', '', '', ''),
('Department 56', 'Heritage Village Collection', '58396', 'Caroling With The Cratchit Family', '', 'yes', '3', '', '', '', ''),
('Department 56', 'Dickens'' Village', '58415', 'Child''s Play', '', 'Yes', '2', '', '', '25', ''),
('Department 56', 'Heritage Village Collection', '5540-9', 'Rest Ye Merry Gentleman', '', 'yes', '1', '', '', '13', ''),
('Department 56', 'New England Village Series', '5656615', 'Pennyfarthing Pedaling', '', 'yes', '1', '', '', '13.5', ''),
('Department 56', 'Dickens'' Village', '58411', 'Sitting In Camden Park', '', 'Yes', '4', '', '', '35', ''),
('Department 56', 'Heritage Village Collection', '5928-5', 'Fezziwegs and friends', '', 'Yes', '3', '', '', '12.5', ''),
('Department 56', 'New England Village Series', '56631', 'Under the Mistletoe', '', 'Yes', '1', '', '', '16.5', ''),
('Department 56', 'North Pole Series', '56.56443', 'Happy New Year', '', 'yes', '1', '', '', '17.5', ''),
('Department 56', 'Seasons Bay', '53323', 'Fun In The Snow', '', 'Yes', '2', '', '', '15', ''),
('Department 56', 'Heritage Village Collection', '5828-9', 'Portobello Road Peddler', '', 'No', '3', '', '', '27.5', 'Missing stanta ordament for the peddler'),
('Department 56', 'Dickens'' Village', '6.58537', 'Bob Cratchit and Tiny Tim', '', 'Yes', '1', '', '', '15', '');

-- 4. Ensure 'Figurine' category exists
INSERT INTO category (category_name)
VALUES ('Figurine')
ON CONFLICT (category_name) DO NOTHING;

-- 5. Auto-ensure any new manufacturers, collections, or bins exist
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

insert into location(location_name) values('Office'),('Kitchen - Pantry'), ('Kitchen - Main Cabinet'), ('Kitchen - Fridge - Cabinet'), ('Kitchen - Cabinet'), ('Dinet - Tree'),('Downstairs - Tree')

-- 6. Insert rows into the main item table (appending alongside your previous house items)
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
CROSS JOIN category cat 
LEFT JOIN bin b ON b.bin_no = NULLIF(s.bin_no, '')::numeric
WHERE cat.category_name = 'Figurine';

-- 7. Clean up staging
DROP TABLE item_stage;


-- adding in accessories
ALTER TABLE item DROP CONSTRAINT IF EXISTS item_item_name_key;
-- 1. Create temporary staging table for the Accessories tab
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

-- 2. Insert all rows into staging
INSERT INTO item_stage VALUES
('Department 56', 'Village Accessories', '52722', 'Holy Split Rail Fence', '1', 'Yes', '4', '', '', '18', ''),
('Department 56', 'Village Accessories', '52722', 'Holy Split Rail Fence', '1', 'Yes', '4', '', '', '18', ''),
('Department 56', 'Heritage Village Collection', '5513-1', 'Town Square Gazebo', '1', 'Yes', '1', '', '', '', ''),
('Department 56', 'Heritage Village Collection', '5252-3', 'Victorian Wrought Iron Fence & Gate', '1', 'Yes', '5', '', '', '', ''),
('Department 56', 'Heritage Village Collection', '9871-0', 'Postern', '1', 'Yes', '1', '', '', '17.5', ''),
('Department 56', 'Heritage Village Collection', '5807-6', 'Churchyard Fence', '1', 'Yes', '4', '', '', '16.5', ''),
('Department 56', 'Village Accessories', '52646', 'Stone Footbridge', '1', 'Yes', '1', '', '', '16', ''),
('Department 56', 'Heritage Village Collection', '5575-1', 'Victoria Station Train Platform', '1', 'Yes', '1', '', '', '22', ''),
('Department 56', 'Village Accessories', '52635', 'Mill Creek Bridge', '13', 'yes', '1', '', '', '', ''),
('Department 56', 'Village Accessories', '52633', 'Straight Section', '13', 'yes', '1', '', '', '', ''),
('Department 56', 'Village Accessories', '52634', 'Curved Section', '13', 'yes', '1', '', '', '', ''),
('Department 56', 'Village Accessories', '52654', 'Mill Creek Park Bench', '13', 'yes', '1', '', '', '14', ''),
('Department 56', 'Village Accessories', '56.53154', 'Let''s Swing', '16', 'yes', '1', '', '', '30', ''),
('Department 56', 'Village Accessories', '810830', 'Classic Luminaries', '17', 'yes', '2', '', '', '20', ''),
('Department 56', 'Village Accessories', '810830', 'Classic Luminaries', '17', 'yes', '2', '', '', '20', '');

-- 3. Auto-ensure any new manufacturers, collections, or bins exist
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

-- 4. Insert rows into the main item table under the 'Accessories' category
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
JOIN category cat ON cat.category_name = 'Accessories'
LEFT JOIN bin b ON b.bin_no = NULLIF(s.bin_no, '')::numeric;

-- 5. Clean up staging
DROP TABLE item_stage;


--- adding in trees
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