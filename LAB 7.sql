create table dealer (
    id integer primary key ,
    name varchar(255),
    location varchar(255),
    commission float
);

INSERT INTO dealer (id, name, location, commission) VALUES (101, 'Oleg', 'Astana', 0.15);
INSERT INTO dealer (id, name, location, commission) VALUES (102, 'Amirzhan', 'Almaty', 0.13);
INSERT INTO dealer (id, name, location, commission) VALUES (105, 'Ademi', 'Taldykorgan', 0.11);
INSERT INTO dealer (id, name, location, commission) VALUES (106, 'Azamat', 'Kyzylorda', 0.14);
INSERT INTO dealer (id, name, location, commission) VALUES (107, 'Rahat', 'Satpayev', 0.13);
INSERT INTO dealer (id, name, location, commission) VALUES (103, 'Damir', 'Aktobe', 0.12);

create table client (
    id integer primary key ,
    name varchar(255),
    city varchar(255),
    priority integer,
    dealer_id integer references dealer(id)
);

INSERT INTO client (id, name, city, priority, dealer_id) VALUES (802, 'Bekzat', 'Satpayev', 100, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (807, 'Aruzhan', 'Almaty', 200, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (805, 'Али', 'Almaty', 200, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (808, 'Yerkhan', 'Taraz', 300, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (804, 'Aibek', 'Kyzylorda', 300, 106);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (809, 'Arsen', 'Taldykorgan', 100, 103);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (803, 'Alen', 'Shymkent', 200, 107);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (801, 'Zhandos', 'Astana', null, 105);

create table sell (
    id integer primary key,
    amount float,
    date timestamp,
    client_id integer references client(id),
    dealer_id integer references dealer(id)
);

INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (201, 150.5, '2021-10-05 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (209, 270.65, '2021-09-10 00:00:00.000000', 801, 105);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (202, 65.26, '2021-10-05 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (204, 110.5, '2021-08-17 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (207, 948.5, '2021-09-10 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (205, 2400.6, '2021-07-27 00:00:00.000000', 807, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (208, 5760, '2021-09-10 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (210, 1983.43, '2021-10-10 00:00:00.000000', 804, 106);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (203, 2480.4, '2021-10-10 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (212, 250.45, '2021-06-27 00:00:00.000000', 808, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (211, 75.29, '2021-08-17 00:00:00.000000', 803, 107);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (213, 3045.6, '2021-04-25 00:00:00.000000', 802, 101);

-- drop table client;
-- drop table dealer;
-- drop table sell;
/*1 Problem*/

-- a Task
select * from client
where priority > 300;
-- b Task
select * from dealer
full join client on dealer.id = client.dealer_id;
-- c Task
select dealer.id, dealer.name, client.id, client.name, client.city, client.priority, sell.amount, sell.date from dealer
inner join client on dealer.id = client.dealer_id
inner join sell on client.id = sell.client_id and dealer.id = sell.dealer_id;
-- d Task
select dealer.location, client.city from dealer
inner join client on dealer.id = client.dealer_id and dealer.location = client.city;
-- e Task
select sell.id, sell.amount, sell.date, client.id, client.name, client.city from sell
inner join client on sell.client_id = client.id and sell.amount > 200 and sell.amount < 500;
-- f Task
select dealer.id, dealer.name, count(dealer.name) as number_of_orders from dealer
inner join client on dealer.id = client.dealer_id
group by dealer.id, dealer.name;
-- g Task
select client.name, client.city, dealer.name, dealer.commission from dealer
inner join client on dealer.id = client.dealer_id;
-- h Task
select client.name, client.city, dealer.name, dealer.commission from dealer
inner join client on dealer.id = client.dealer_id and dealer.commission >= 0.13;
-- i Task
select client.name, client.city, sell.id, sell.date, sell.amount, dealer.name, dealer.commission from dealer
inner join client on dealer.id = client.dealer_id
full join sell on client.id = sell.client_id;
-- j Task
select client.name, client.priority, dealer.name, sell.id, sell.amount from client
inner join dealer on dealer.id = client.dealer_id
inner join sell on client.id = sell.client_id and dealer.id = sell.dealer_id and (sell.amount > 2000 or client.priority is not null or sell.dealer_id is null);

/*2 Problem*/

-- a Task
create view a_Task as select client.id, client.name, count(client.name), avg(sell.amount), sum(sell.amount) from sell
inner join client on sell.client_id = client.id
group by client.id, client.name;

select * from a_Task;

-- b Task
create view b_Task as select sell.date, sum(sell.amount) as total from sell
group by sell.date
order by sum(sell.amount) desc;

select total from b_Task
limit 5;
-- c Task
create view c_Task as select dealer.id ,dealer.name ,count(dealer.name) as sales, avg(sell.amount) as avg_sales, sum(sell.amount) as tot_sales from sell
inner join dealer on sell.dealer_id = dealer.id
group by dealer.id ,dealer.name;

select * from c_Task;
-- d Task
create view d_Task as select dealer.id ,dealer.name ,count(dealer.name) as sales, avg(sell.amount) as avg_sales, sum(sell.amount) as tot_sales, dealer.commission, (sum(sell.amount) * dealer.commission) as earned_from_comission from sell
inner join dealer on sell.dealer_id = dealer.id
group by dealer.id ,dealer.name;

select id, name, tot_sales, commission, earned_from_comission from d_Task
order by tot_sales desc;
-- e Task
/*The first way*/
create view e_Task as select client.city, count(client.city), avg(sell.amount) as avg_sales, sum(sell.amount) as tot_sales from sell
inner join client on client.id = sell.client_id
group by client.city;

select * from e_Task
order by tot_sales desc;

/*The second way*/
create view e_Task_dealer as select dealer.location, count(dealer.location), avg(sell.amount) as avg_sales, sum(sell.amount) as tot_sales from sell
inner join dealer on dealer.id = sell.dealer_id
group by dealer.location;

select * from e_Task_dealer
order by tot_sales desc;

-- f Task (I think that this is same as e_Task)
create view f_Task as select client.city, count(client.city), avg(sell.amount) as avg_sales, sum(sell.amount) as tot_sales from sell
inner join client on client.id = sell.client_id
group by client.city;

select * from f_Task
order by avg_sales desc;
-- g Task
create view g_Task as select f_Task.city as city, f_Task.tot_sales as city_total, e_Task_dealer.location as location, e_Task_dealer.tot_sales as location_total from f_Task
inner join e_Task_dealer on f_Task.city = e_Task_dealer.location and f_Task.tot_sales > e_Task_dealer.tot_sales;

select * from g_Task
order by city;
