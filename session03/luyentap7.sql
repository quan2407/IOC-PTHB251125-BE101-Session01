create schema if not exists sales;
set search_path to sales;
create table if not exists Products(
    product_id serial primary key ,
    product_name varchar(50),
    price numeric(10,2),
    stock_quantity int CHECK ( stock_quantity >=0 )
);
create table if not exists Orders(
    order_id serial primary key ,
    order_date date default current_date,
    member_id int,
    constraint order_member FOREIGN KEY (member_id) references library.member(member_id)
);
create table if not exists OrderDetails (
    order_detail_id serial primary key ,
    order_id int,
    product_id int,
    quantity int check ( quantity > 0),
    constraint orderDetail_order foreign key (order_id) references Orders(order_id),
    constraint orderDetail_product foreign key (product_id) references Products(product_id)
);