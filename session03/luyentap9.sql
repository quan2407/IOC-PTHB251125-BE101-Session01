create database schoolDB;
create schema if not exists school;
set search_path to school;
create type enum_grade as ENUM ('A','B','C','D','F');
create table if not exists Students(
    student_id serial primary key ,
    name varchar(50),
    dob date
);
create table if not exists Courses(
    course_id serial primary key ,
    course_name varchar(50),
    credits int
);
create table if not exists Enrollments(
    enrollment_id serial primary key ,
    student_id int,
    course_id int,
    grade enum_grade,
    constraint enroll_student foreign key (student_id) references Students(student_id),
    constraint enroll_course foreign key (course_id) references Courses(course_id)
);
