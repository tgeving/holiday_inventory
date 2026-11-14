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

insert into item 
(manufacturer_id, collection_id, category_id, bin_id, sku, item_name, full_set, org_total_no, actual_total_no, total_missing_no) 
values(1, 3, 1, 1, '56.55359', 'Santas Wonderland house','yes', 18, 18, 0);