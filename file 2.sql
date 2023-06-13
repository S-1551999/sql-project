use interview;
SELECT * FROM HOTEL;
SELECT *  FROM ROOM;
SELECT *  FROM GUEST;
SELECT * FROM BOOKING;
SELECT * FROM BOOKING_OLD;

-- Simple Queries

-- 1. List full details of all hotels.

SELECT * FROM HOTEL;


-- 2. List full details of all hotels in London.

SELECT * FROM HOTEL WHERE ADDRESS='LONDON';


-- 3. List the names and addresses of all guests in London, alphabetically ordered by name.

SELECT NAME ,ADDRESS FROM GUEST WHERE ADDRESS='LONDON' ORDER BY NAME;


-- 4. List all double or family rooms with a price below £40.00 per night, in ascending order of price.

SELECT * FROM ROOM WHERE type in ('q','d') AND  PRICE<40 ORDER BY PRICE; 

-- 5. List the bookings for which no date_to has been specified.

SELECT * FROM BOOKING WHERE DATE_TO IS NULL; 


-- Aggregate Functions



-- 1. How many hotels are there?


SELECT COUNT(*) FROM HOTEL;

-- 2. What is the average price of a room?

select avg(price) from  room;

-- 3. What is the total revenue per night from all double rooms?
select sum(price) from room where type='d' ;


-- 4. How many different guests have made bookings for August?

select * from booking where month(date_from)=8 ;




-- Subqueries and Joins



-- 1. List the price and type of all rooms at the Grosvenor Hotel.

SELECT  DISTINCT(TYPE),PRICE , HOTEL_NO  FROM ROOM;

-- FROM GORUPBY (EXTRA)
select hotel_no, type,price from room  group by hotel_no,type;

-- 2. List all guests currently staying at the Grosvenor Hotel.
select * from booking where sysdate() between date_from and date_to;

-- 3. List the details of all rooms at the Grosvenor Hotel, including the name of the guest staying in the

-- room, if the room is occupied.


select  r.* ,g.name from room r natural join  booking b   natural join  guest g  where sysdate() between date_from and date_to;

select  r.* ,g.name from room r left  join  booking b  on r.room_no=b.room_no left join guest g  on b.guest_no=g.guest_no where sysdate() between date_from and date_to;

-- 4. What is the total income from bookings for the Grosvenor Hotel today?

select sum(price) from booking natural join room where date_from=current_date();


-- 5. List the rooms that are currently unoccupied at the Grosvenor Hotel.

select r.* from room r where room_no not in (select room_no from booking where current_date between date_from and date_to) ;

-- 6. What is the lost income from unoccupied rooms at the Grosvenor Hotel?
select sum(price)  from room r where room_no not in (select room_no from booking where current_date between date_from and date_to) ;


-- Grouping




-- 1. List the number of rooms in each hotel.

select  hotel_no,count(room_no) as nor from room group by hotel_no;

-- 2. List the number of rooms in each hotel in London.

select HOTEL_NO, ADDRESS,count(room_no) as nor from room r natural join hotel  h  group by hotel_no  having address in ('london');

-- 3. What is the average number of bookings for each hotel in August?

select hotel_no ,count(*) c from booking   group by hotel_no;

select avg(c) from (
select hotel_no ,count(*) c  from booking  where month(date_from)=8 group by hotel_no) t ;

-- 4. What is the most commonly booked room type for each hotel in London?

select hotel_no, type ,address,max(c) from(
 select * ,count(*) c  from room natural join booking natural join hotel h group by hotel_no,type having address='london' order by c desc) t ;


-- max booked type room   for each hotel

select hotel_no ,type ,c from(
select * ,count(*) c ,rank() over (partition by hotel_no order by count(*) desc) as rk from room natural join booking  group by hotel_no,type) yu where rk=1;


-- 5. What is the lost income from unoccupied rooms at each hotel today?

select hotel_no ,sum(price) lost_i from room r  where room_no not in (select room_no from booking where current_date between date_from and date_to)  group by hotel_no ;


