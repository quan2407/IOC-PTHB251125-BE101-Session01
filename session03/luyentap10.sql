create database companyDB;
create schema if not exists company;
set search_path to company;
create table if not exists departments(
    department_id serial primary key ,
    department_name varchar(50)
);
create table if not exists employees(
    emp_id serial primary key ,
    name varchar(50) not null ,
    dob date not null ,
    department_id int,
    constraint employees_department foreign key (department_id) references departments(department_id)
);
create table if not exists projects(
    project_id serial primary key ,
    project_name varchar(50) not null ,
    start_date date,
    end_date date check ( end_date > start_date )
);
create table if not exists EmployeeProjects(
    emp_id int,
    project_id int,
    primary key (emp_id,project_id),
    foreign key (emp_id) references employees(emp_id),
    foreign key (project_id) references projects(project_id)
);