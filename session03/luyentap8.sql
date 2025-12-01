set search_path to library;
alter table books add column genre varchar;
alter table books rename column availabe to is_available;
alter table member drop column email;
set search_path to sales;
drop table sales.orderdetails;