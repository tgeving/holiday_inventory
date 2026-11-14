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


iINSERT INTO item (
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
    v.sku, 
    v.item_name, 
    v.full_set, 
    NULLIF(v.org_total_no, '')::numeric, 
    NULLIF(v.actual_total_no, '')::numeric, 
    NULLIF(v.total_missing_no, '')::numeric, 
    NULLIF(v.price, '')::numeric, 
    NULLIF(v.notes, '')
FROM (
    VALUES 
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
    ('Department 56', 'Dickens'' Village', 'House', '5752-5', 'Dedlock Arms', '26', 'yes', '1', '1', '0', '100', '')
) AS v(manufacturer_name, collection_name, category_name, sku, item_name, bin_no, full_set, org_total_no, actual_total_no, total_missing_no, price, notes)
JOIN manufacturer m ON m.manufacturer_name = v.manufacturer_name
JOIN collection c ON c.collection_name = v.collection_name
JOIN category cat ON cat.category_name = v.category_name
JOIN bin b ON b.bin_no = v.bin_no::numeric;
