CREATE SCHEMA IF NOT EXISTS sales;
set search_path to sales;
create table if not exists Customers(
    customer_id serial primary key ,
    first_name varchar(50) not null ,
    last_name varchar(50) not null ,
    email varchar(50) not null unique ,
    phone char(10)
);
create table if not exists Products(
    product_id serial primary key ,
    product_name varchar(100) not null ,
    price float not null ,
    stock_quanity int not null
);
create table if not exists Orders(
    order_id serial primary key ,
    customer_id int,
    order_date timestamp,
    CONSTRAINT order_cus FOREIGN KEY (customer_id) references Customers(customer_id)

);
create table if not exists OrderItems(
    order_item_id serial primary key ,
    order_id int,
    product_id int,
    quantity int check ( quantity >= 1 ),
    CONSTRAINT orderItem_order FOREIGN KEY (order_id) references Orders(order_id),
    CONSTRAINT orderItem_product FOREIGN KEY (product_id) references Products(product_id)
)