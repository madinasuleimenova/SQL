create table classroom
	(building		varchar(15),
	 room_number		varchar(7),
	 capacity		numeric(4,0),
	 primary key (building, room_number)
	);

create table department
	(dept_name		varchar(20), 
	 building		varchar(15), 
	 budget		        numeric(12,2) check (budget > 0),
	 primary key (dept_name)
	);

create table course
	(course_id		varchar(8), 
	 title			varchar(50), 
	 dept_name		varchar(20),
	 credits		numeric(2,0) check (credits > 0),
	 primary key (course_id),
	 foreign key (dept_name) references department (dept_name)
		on delete set null
	);

create table instructor
	(ID			varchar(5), 
	 name			varchar(20) not null, 
	 dept_name		varchar(20), 
	 salary			numeric(8,2) check (salary > 29000),
	 primary key (ID),
	 foreign key (dept_name) references department (dept_name)
		on delete set null
	);

create table section
	(course_id		varchar(8), 
         sec_id			varchar(8),
	 semester		varchar(6)
		check (semester in ('Fall', 'Winter', 'Spring', 'Summer')), 
	 year			numeric(4,0) check (year > 1701 and year < 2100), 
	 building		varchar(15),
	 room_number		varchar(7),
	 time_slot_id		varchar(4),
	 primary key (course_id, sec_id, semester, year),
	 foreign key (course_id) references course (course_id)
		on delete cascade,
	 foreign key (building, room_number) references classroom (building, room_number)
		on delete set null
	);

create table teaches
	(ID			varchar(5), 
	 course_id		varchar(8),
	 sec_id			varchar(8), 
	 semester		varchar(6),
	 year			numeric(4,0),
	 primary key (ID, course_id, sec_id, semester, year),
	 foreign key (course_id, sec_id, semester, year) references section (course_id, sec_id, semester, year)
		on delete cascade,
	 foreign key (ID) references instructor (ID)
		on delete cascade
	);

create table student
	(ID			varchar(5), 
	 name			varchar(20) not null, 
	 dept_name		varchar(20), 
	 tot_cred		numeric(3,0) check (tot_cred >= 0),
	 primary key (ID),
	 foreign key (dept_name) references department (dept_name)
		on delete set null
	);

create table takes
	(ID			varchar(5), 
	 course_id		varchar(8),
	 sec_id			varchar(8), 
	 semester		varchar(6),
	 year			numeric(4,0),
	 grade		        varchar(2),
	 primary key (ID, course_id, sec_id, semester, year),
	 foreign key (course_id, sec_id, semester, year) references section (course_id, sec_id, semester, year)
		on delete cascade,
	 foreign key (ID) references student (ID)
		on delete cascade
	);

create table advisor
	(s_ID			varchar(5),
	 i_ID			varchar(5),
	 primary key (s_ID),
	 foreign key (i_ID) references instructor (ID)
		on delete set null,
	 foreign key (s_ID) references student (ID)
		on delete cascade
	);

create table time_slot
	(time_slot_id		varchar(4),
	 day			varchar(1),
	 start_hr		numeric(2) check (start_hr >= 0 and start_hr < 24),
	 start_min		numeric(2) check (start_min >= 0 and start_min < 60),
	 end_hr			numeric(2) check (end_hr >= 0 and end_hr < 24),
	 end_min		numeric(2) check (end_min >= 0 and end_min < 60),
	 primary key (time_slot_id, day, start_hr, start_min)
	);

create table prereq
	(course_id		varchar(8), 
	 prereq_id		varchar(8),
	 primary key (course_id, prereq_id),
	 foreign key (course_id) references course (course_id)
		on delete cascade,
	 foreign key (prereq_id) references course (course_id)
	);
--/////////////////////////////////////////////////////////////////////////////////--
----------------------------------My code -------------------------------------------
--////////////////////////////////////////////////////////////////////////////////--
-- 1a
;
SELECT title from course
where dept_name= 'Biology' and credits >3;
-- 1b
select * from classroom
where building = 'Watson' or building = 'Painter';
-- 1c
select * from course
where dept_name='Comp. Sci.';
-- 1d
select * from course
where course_id in (
select section.course_id from section
where semester= 'Spring'
    );
-- 1e
select * from student
where tot_cred> 45 and tot_cred< 85;
--1f
select * from course
where course.title LIKE ( '%a', '%e', '%y','%i', '%o','%u');

-- 1g
select * from course
    where course_id in (
    select course_id from prereq
    where prereq_id='EE-181'
    );
--2a
select dept_name, avg(salary) from instructor
group by dept_name
order by avg(salary);

--2b
select building, count(course_id) from section
group by building
having count(course_id) in (select count(course_id) from section
group by building order by count(course_id) desc limit 1);
--2c
select dept_name, count(course_id) from course
group by dept_name
having count(course_id) in (select count(course_id) from course
group by dept_name order by count(course_id) limit 1);

--2d

select name, id from student
where id in (
    select id from takes
               group by id having count(course_id)>3);
-- another solution is not finished
-- select name, student.id from student, takes where student.id=takes.id and count(takes.id)>3;


-- 2e
select id, name from instructor
where dept_name in(
    select dept_name from department
             where  building='Taylor'
    );

--2f
select * from instructor
where dept_name='Biology' or dept_name='Philosophy' or dept_name='Music';
-- 2g

select id from teaches
where year in (
select year from teaches
group by year
having year = 2018)
except
SELECT ID FROM teaches
where year in (
select year from teaches
group by year
having year = 2017);


-- 3a
select * from student
where dept_name in(
    select dept_name from course
    where dept_name = 'Comp. Sci.' and course_id in (
        select section.course_id from section
        where time_slot_id='A'
        or time_slot_id='A-'
        )
    )
order by name;

--3b

select distinct i_ID from advisor
where s_ID in(
    select id from takes
              except
              select id from takes
                        where grade not  in ( 'A','A-','B+'));


--3c
--correct one
select dept_name from student
except
select dept_name from student
where id not in (select id from takes
                       except
                       select id from takes where grade  in('C','F')) ;

--not correct
select dept_name from student
except
select dept_name from student
where id in (select id from takes
                       except
                       select id from takes where grade not in('C','F'));
--3d
--- not correct
select * from instructor where id in
(select id from teaches where (course_id, sec_id, semester) in (select (course_id, sec_id, semester) from takes where id in
(select id from takes
except select id from takes where grade in ('A', 'A-'))));

-- other solution
select * from instructor where id in
(select id from teaches where course_id in
(select course_id from takes
except select course_id from takes where grade in ('A', 'A-')));


--3e
select * from course
where course_id in (
select course_id from section
except select course_id from section
where time_slot_id in (
select time_slot_id from time_slot
where end_hr>=13)) order by title;










