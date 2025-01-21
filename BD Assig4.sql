-- 1a
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
where course.title LIKE '%a'
OR course.title LIKE '%e'
OR course.title LIKE '%y'
OR course.title LIKE '%i'
OR course.title LIKE '%o'
OR course.title LIKE '%u';
-- 1g
select * from course
    where course_id in (
    select course_id from prereq
    where prereq_id='EE-181'
    );
--2a
select dept_name, avg(salary) from instructor
group by dept_name;

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

--???


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
--???

-- 3a
select * from student
where dept_name in(
    select dept_name from course
    where dept_name = 'Comp. Sci.' and course_id in (
        select section.course_id from section
        where time_slot_id='A'
        or time_slot_id='A-'
        )
    );

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
select * from course
where course_id in (
select course_id from section
except
select course_id from section
where time_slot_id in (
select time_slot_id from time_slot
where end_hr>=13)) order by title;


--3e
--???





