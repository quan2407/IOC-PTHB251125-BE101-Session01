CREATE SCHEMA IF NOT EXISTS elearning;
set search_path to elearning;
create table if not exists Students(
    student_id serial primary key ,
    first_name varchar(50) not null ,
    last_name varchar(50) not null ,
    email varchar(50) not null unique
);
create table if not exists Instructors (
    instructor_id serial primary key ,
    first_name varchar(50) not null ,
    last_name varchar(50) not null ,
    email varchar(50) not null unique
);
create table if not exists Courses (
    course_id serial primary key ,
    course_name varchar(100) not null ,
    instructor_id int,
    constraint course_instructor foreign key (instructor_id) references Instructors(instructor_id)
);
create table if not exists Enrollments(
    enrollment_id serial primary key ,
    student_id int,
    course_id int,
    enroll_date timestamp not null ,
    constraint enroll_student foreign key (student_id) references Students(student_id),
    constraint enroll_course foreign key (course_id) references Courses(course_id)
);
create table if not exists Assignments(
    assignment_id serial primary key ,
    course_id int,
    title varchar(100) not null ,
    due_date date,
    constraint assignment_course foreign key (course_id) references Courses(course_id)

);
create table if not exists Submissions(
    submission_id serial primary key ,
    assignment_id int,
    student_id int,
    submission_date timestamp not null ,
    grade float check ( grade >= 0 AND grade <= 100 ),
    constraint submission_assignment foreign key (assignment_id) references Assignments(assignment_id),
    constraint submission_student foreign key (student_id) references Students(student_id)
);