-------------------------------------------Labwork 8-------------------------------------------------------

create database assigment_8;
--a
CREATE FUNCTION plus_one (a int)
    RETURNS int AS
    $$BEGIN
        a=a+1;
        RETURN a;
    end;
    $$
LANGUAGE plpgsql;
--b
CREATE FUNCTION cube (a int)
    RETURNS int AS
    $$BEGIN
        a=a*a*a;
        RETURN a;
    end;
    $$
LANGUAGE plpgsql;
--c
CREATE FUNCTION sum_two (a int,b int)
    RETURNS int AS
    $$BEGIN
        RETURN a+b;
    end;
    $$
LANGUAGE plpgsql;
--d
CREATE FUNCTION even (a int)
    RETURNS bool AS
    $$BEGIN
        RETURN a%2=0;
    end;
    $$
LANGUAGE plpgsql;
--e
CREATE FUNCTION avg2 (variadic a int[],OUT total int)
    RETURNS int AS
    $$BEGIN
        SELECT INTO  total avg(a[i]) FROM generate_subscripts(a,1) g(i);
    end;
    $$
LANGUAGE plpgsql;
--f
CREATE FUNCTION count2 (variadic a int[],OUT total int)
    RETURNS int AS
    $$BEGIN
        SELECT INTO  total count(a[i]) FROM generate_subscripts(a,1) g(i);
    end;
    $$
LANGUAGE plpgsql;
--g
CREATE FUNCTION password (a text,b text )
    RETURNS bool AS
    $$BEGIN
        RETURN a=b;
    end;
    $$
LANGUAGE plpgsql;
--h
CREATE FUNCTION count_avg (variadic a int[],OUT total int,OUT total2 int)
    RETURNS record AS
    $$BEGIN
        SELECT INTO  total count(a[i]) FROM generate_subscripts(a,1) g(i);
        SELECT INTO  total2 avg(a[i]) FROM generate_subscripts(a,1) g(i);
    end;
    $$
LANGUAGE plpgsql;
SELECT plus_one(3);
SELECT cube(3);
SELECT sum_two(3,4);
SELECT even(3);
SELECT avg2(2,8);
SELECT count2(2,8);
SELECT password('12d','12d');
SELECT * FROM count_avg(1);
----
--2
----
--a
CREATE OR REPLACE FUNCTION now_date() RETURNS trigger AS
    $$
    BEGIN
        RAISE NOTICE 'UPDATE time=%', now();
        RETURN new;
    end;
    $$
LANGUAGE plpgsql;
CREATE OR REPLACE TRIGGER now_date1 BEFORE INSERT OR UPDATE ON task4
    FOR EACH ROW EXECUTE FUNCTION now_date();
--b
CREATE OR REPLACE FUNCTION age() RETURNS trigger AS
    $$
    BEGIN
        RAISE NOTICE 'AGE =%', age(now(),new.date_of_birth);
        RETURN new;
    end;
    $$
LANGUAGE plpgsql;
CREATE OR REPLACE TRIGGER age1 BEFORE INSERT OR UPDATE ON task4
    FOR EACH ROW EXECUTE FUNCTION age();
--c
CREATE OR REPLACE FUNCTION add12() RETURNS trigger AS
    $$
    BEGIN
        new.salary:=new.salary*1.12;
        RETURN new;
    end;
    $$
LANGUAGE plpgsql;
CREATE OR REPLACE TRIGGER add12 BEFORE INSERT OR UPDATE ON task4
    FOR EACH ROW EXECUTE FUNCTION add12();
--d
CREATE OR REPLACE FUNCTION stop() RETURNS trigger AS
    $$
    BEGIN
        RETURN new;
    end;
    $$
LANGUAGE plpgsql;
CREATE OR REPLACE TRIGGER stop BEFORE DELETE ON task4
    FOR EACH ROW EXECUTE FUNCTION stop();
--e
CREATE OR REPLACE FUNCTION d_and_e() RETURNS trigger AS
    $$
    BEGIN
        RAISE NOTICE 'AGE IS EVEN =% AVG OF salary,workexp,discount=%',even(new.age),avg2(new.salary,new.workexpirience,new.discount);
        RETURN new;
    end;
    $$
LANGUAGE plpgsql;
CREATE OR REPLACE TRIGGER d_and_e BEFORE INSERT OR UPDATE ON task4
    FOR EACH ROW EXECUTE FUNCTION d_and_e();
----
--3
----

CREATE TABLE task4(
    id int,
    name varchar,
    date_of_birth date,
    age int,
    salary int,
    workexpirience int,
    discount int,
    PRIMARY KEY(id)
);
--
--INSERT INTO task4 VALUES (3,'Karl','1998-12-12',20,120000,55,0);
--DELETE FROM task4 WHERE id =3;
--SELECT * FROM task4;
--
--a
BEGIN;
    UPDATE task4 SET salary=salary*pow(1.1,workexpirience/2), discount=10+(task4.workexpirience-2)/5 WHERE workexpirience>=2;
COMMIT;
--b
BEGIN;
    UPDATE task4 SET salary=salary*1.15 WHERE workexpirience=40;
    UPDATE task4 SET salary=salary*1.15, discount=20 WHERE workexpirience>=8;
COMMIT;
