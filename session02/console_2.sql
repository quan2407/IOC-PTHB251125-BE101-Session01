create schema customer_manager;
-- chuyen duong dan ve custom_manager
set search_path To customer_manager;
CREATE TYPE enum_sex AS ENUM ('Nam', 'Nu', 'Khac');
create table Customer(
    -- Liet ke cac cot

    customer_id char(5) PRIMARY KEY ,
    full_name varchar(25) NOT NULL ,
    phone_number char(10) NOT NULL UNIQUE ,
    email varchar(30) NOT NULL UNIQUE ,
    sex enum_sex default ('Khac') ,
    address TEXT

)