-- who made it
create table manufacturer(
 id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 manufacturer_name VARCHAR(100) UNIQUE NOT null,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP,
 deleted_at TIMESTAMP
);

-- is it dickens village or a snow village etc
create table collection(
 id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 collection_name VARCHAR(100) UNIQUE NOT null,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP,
 deleted_at TIMESTAMP
);

-- is it a tree, figure or a house etc
create table category(
 id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 category_name VARCHAR(100) UNIQUE NOT null,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP,
 deleted_at TIMESTAMP
);

-- bin information
CREATE TABLE bin (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    bin_no numeric,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP
);

-- location of rooms
create table location(
 id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 location_name VARCHAR(100) UNIQUE NOT null,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP,
 deleted_at TIMESTAMP
);

-- items information
CREATE TABLE item (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
     manufacturer_id INT,
    constraint fk_manufacturer_id
    foreign key (manufacturer_id) references manufacturer(id)
    on delete cascade,
    
    collection_id INT,
    constraint fk_collection_id
    foreign key (collection_id) references collection(id)
    on delete cascade,
    
    category_id INT,
    constraint fk_category_id
    foreign key (category_id) references category(id)
    on delete cascade,
    
    bin_id INT,
    constraint fk_bin_id
    foreign key (bin_id) references bin(id)
    on delete cascade, 

    location_id INT,
    constraint fk_location_id
    foreign key (location_id) references location(id)
    on delete cascade, 
    
    sku text UNIQUE NOT NULL,
    item_name text UNIQUE NOT NULL,
    full_set VARCHAR(100),
    org_total_no numeric, 
    actual_total_no numeric,
    total_missing_no numeric,
    price numeric,
    notes text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP
);

-- how the houses were decorated every year
CREATE TABLE themes (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_id INT,
    constraint fk_category_id
    foreign key (category_id) references category(id)
    on delete cascade,
    
    item_id INT,
    constraint fk_item_id
    foreign key (item_id) references item(id)
    on delete cascade,
    
    bin_id INT,
    constraint fk_bin_id
    foreign key (bin_id) references bin(id)
    on delete cascade,
    location VARCHAR(100) UNIQUE NOT NULL,
    line_no numeric,
    theme_name  text, 
    theme_year TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP
);
