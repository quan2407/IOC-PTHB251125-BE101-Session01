create database libraryDB;
create schema if not exists library;
set search_path to library;
create table if not exists Books(
    book_id serial primary key ,
    title varchar(100) not null ,
    author varchar(50) not null ,
    published_year int ,
    price float
) ;
alter table Books add column availabe bool DEFAULT TRUE;
create table if not exists Member(
    member_id serial primary key ,
    name varchar(50),
    email varchar(50) unique ,
    join_date date default current_date
);