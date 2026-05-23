CREATE TABLE Hotel (
    hotel_id INTEGER PRIMARY KEY,
    hotel_name VARCHAR2(50) NOT NULL,
    hotel_address VARCHAR2(50),
    hotel_city VARCHAR2(20),
    hotel_phone VARCHAR2(20),
    hotel_email VARCHAR2(40) UNIQUE,
    rating INTEGER,
    CONSTRAINT chk_hotel_rating CHECK (rating BETWEEN 1 AND 5)
);
/

CREATE TABLE Room (
    room_id INTEGER PRIMARY KEY,
    hotel_id INTEGER NOT NULL,
    room_number INTEGER NOT NULL,
    room_type VARCHAR2(50) NOT NULL,
    price_per_night NUMBER(10, 2) NOT NULL,
    status VARCHAR2(15),
    room_capacity INTEGER,
    CONSTRAINT chk_room_price CHECK (price_per_night >= 0),
    CONSTRAINT chk_room_status CHECK (status IN ('Available', 'Booked', 'Maintenance')),
    CONSTRAINT chk_room_capacity CHECK (room_capacity > 0),
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);
/

CREATE TABLE Customer (
    customer_id INTEGER PRIMARY KEY,
    cust_fname VARCHAR2(20) NOT NULL,
    cust_lname VARCHAR2(50) NOT NULL,
    cust_email VARCHAR2(100) UNIQUE,
    cust_phone VARCHAR2(13),
    cust_address VARCHAR2(50),
    national_id VARCHAR2(10) UNIQUE
);
/

CREATE TABLE Booking (
    booking_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    room_id INTEGER NOT NULL,
    booking_date DATE NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    status VARCHAR2(15),
    CONSTRAINT chk_booking_status CHECK (status IN ('Confirmed', 'Cancelled', 'Completed')),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (room_id) REFERENCES Room(room_id)
);
/

CREATE TABLE Payment (
    payment_id INTEGER PRIMARY KEY,
    booking_id INTEGER NOT NULL,
    amount NUMBER(10, 2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR2(10),
    status VARCHAR2(20),
    CONSTRAINT chk_payment_amount CHECK (amount >= 0),
    CONSTRAINT chk_payment_method CHECK (payment_method IN ('Card', 'Cash', 'Online')),
    CONSTRAINT chk_payment_status CHECK (status IN ('Paid', 'Refunded')),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);
/

CREATE TABLE Staff (
    staff_id INTEGER PRIMARY KEY,
    hotel_id INTEGER NOT NULL,
    staff_fname VARCHAR2(20) NOT NULL,
    staff_lname VARCHAR2(50) NOT NULL,
    role VARCHAR2(20) NOT NULL,
    staff_phone VARCHAR2(13),
    staff_email VARCHAR2(50) UNIQUE,
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);
/

CREATE TABLE Hotel_service (
    service_id INTEGER PRIMARY KEY,
    serv_name VARCHAR2(100) NOT NULL,
    serv_price NUMBER(10, 2) NOT NULL,
    CONSTRAINT chk_service_price CHECK (serv_price >= 0)
);
/

CREATE TABLE Booking_Service (
    booking_id INTEGER,
    service_id INTEGER,
    customer_id INTEGER,
    quantity INTEGER NOT NULL,
    CONSTRAINT chk_service_quantity CHECK (quantity > 0),
    PRIMARY KEY (booking_id, service_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    FOREIGN KEY (service_id) REFERENCES Hotel_service(service_id)
);
/

CREATE TABLE Customer_feedback (
    feedback_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    hotel_id INTEGER NOT NULL,
    rating INTEGER,
    date_submitted DATE NOT NULL,
    CONSTRAINT chk_feedback_rating CHECK (rating BETWEEN 1 AND 5),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);
/

CREATE TABLE Login (
    user_id INTEGER PRIMARY KEY,
    user_email VARCHAR2(100) UNIQUE NOT NULL,
    password_hash VARCHAR2(255) NOT NULL,
    role VARCHAR2(20),
    CONSTRAINT chk_login_role CHECK (role IN ('Admin', 'Customer', 'Staff'))
);
/

CREATE TABLE Inventory (
    item_id INTEGER PRIMARY KEY,
    hotel_id INTEGER NOT NULL,
    item_name VARCHAR2(30) NOT NULL,
    quantity INTEGER NOT NULL,
    unit VARCHAR2(20),
    last_updated DATE,
    CONSTRAINT chk_inventory_quantity CHECK (quantity >= 0),
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);
/

CREATE TABLE Event (
    event_id INTEGER PRIMARY KEY,
    hotel_id INTEGER NOT NULL,
    event_name VARCHAR2(50) NOT NULL,
    event_type VARCHAR2(50),
    start_datetime TIMESTAMP NOT NULL,
    end_datetime TIMESTAMP NOT NULL,
    organizer_name VARCHAR2(50),
    expected_guests INTEGER,
    CONSTRAINT chk_event_guests CHECK (expected_guests >= 0),
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);
/

CREATE TABLE Event_Booking (
    event_booking_id INTEGER PRIMARY KEY,
    event_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    booking_date DATE NOT NULL,
    total_cost NUMBER(10, 2),
    CONSTRAINT chk_event_cost CHECK (total_cost >= 0),
    FOREIGN KEY (event_id) REFERENCES Event(event_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);
/

COMMIT;
/

-- Hotels
INSERT ALL
    INTO Hotel(hotel_id, hotel_name, hotel_address, hotel_city, hotel_phone, hotel_email, rating) 
        VALUES  (1, 'Grand Hotel', 'ul. Marszałkowska 1', 'Warsaw', '+48220000000', 'contact@grandhotel.pl', 5)
    INTO Hotel(hotel_id, hotel_name, hotel_address, hotel_city, hotel_phone, hotel_email, rating) 
        VALUES (2, 'Seaside Resort', 'ul. Nadmorska 10', 'Gdańsk', '+48581112222', 'contact@seasideresort.pl', 4)
    INTO Hotel(hotel_id, hotel_name, hotel_address, hotel_city, hotel_phone, hotel_email, rating)  
        VALUES  (3, 'Mountain Inn', 'ul. Górska 5', 'Zakopane', '+48183334444', 'contact@mountaininn.pl', 3)
SELECT * FROM dual;
/

-- Rooms
INSERT ALL
    INTO Room (room_id, hotel_id, room_number, room_type, price_per_night, status, room_capacity)
        VALUES (1, 1, '101', 'Single', 200, 'Available', 1)
    INTO Room (room_id, hotel_id, room_number, room_type, price_per_night, status, room_capacity)
        VALUES (2, 1, '102', 'Double', 350, 'Booked', 2)
    INTO Room (room_id, hotel_id, room_number, room_type, price_per_night, status, room_capacity)
        VALUES (3, 2, '201', 'Suite', 500, 'Available', 4)
    INTO Room (room_id, hotel_id, room_number, room_type, price_per_night, status, room_capacity)
        VALUES (4, 3, '301', 'Double', 300, 'Maintenance', 2)
SELECT * FROM dual;
/


-- Customers
INSERT ALL
    INTO Customer (customer_id, cust_fname, cust_lname, cust_email, cust_phone, cust_address, national_id)
        VALUES (1, 'George', 'Ntinoudios', 'big.g.ntin@example.com', '+30600111222', 'Ampelokoipoi 132, Athens', 'AN123456')
    INTO Customer (customer_id, cust_fname, cust_lname, cust_email, cust_phone, cust_address, national_id)
        VALUES (2, 'Billaros', 'Kaggalos', 'bill.kagg@example.com', '+307700900123', 'Skalidi 50, Chania', 'MO987654')
    INTO Customer (customer_id, cust_fname, cust_lname, cust_email, cust_phone, cust_address, national_id)
        VALUES (3, 'Vaggas', 'Kazakos IV', 'v.kazakos@example.com', '+48600333444', 'ul. Lipowa 7, Krakow', 'DF456789')
SELECT * FROM dual;
/

-- Bookings
INSERT ALL
    INTO Booking (booking_id, customer_id, room_id, booking_date, check_in_date, check_out_date, status)
        VALUES (1, 1, 2, TO_DATE('2025-04-20','YYYY-MM-DD'), TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-05-05','YYYY-MM-DD'), 'Confirmed')
    INTO Booking (booking_id, customer_id, room_id, booking_date, check_in_date, check_out_date, status)
        VALUES (2, 2, 3, TO_DATE('2025-04-25','YYYY-MM-DD'), TO_DATE('2025-06-10','YYYY-MM-DD'), TO_DATE('2025-06-15','YYYY-MM-DD'), 'Cancelled')
    INTO Booking (booking_id, customer_id, room_id, booking_date, check_in_date, check_out_date, status)
        VALUES (3, 3, 1, TO_DATE('2025-05-02','YYYY-MM-DD'), TO_DATE('2025-05-10','YYYY-MM-DD'), TO_DATE('2025-05-12','YYYY-MM-DD'), 'Completed')
SELECT * FROM dual;
/

-- Payments
INSERT ALL
    INTO Payment (payment_id, booking_id, amount, payment_date, payment_method, status)
        VALUES (1, 1, 1400, TO_DATE('2025-04-21','YYYY-MM-DD'), 'Card', 'Paid')
    INTO Payment (payment_id, booking_id, amount, payment_date, payment_method, status)
        VALUES (2, 2, 2500, TO_DATE('2025-04-26','YYYY-MM-DD'), 'Online', 'Refunded')
    INTO Payment (payment_id, booking_id, amount, payment_date, payment_method, status)
        VALUES (3, 3, 400, TO_DATE('2025-05-03','YYYY-MM-DD'), 'Cash', 'Paid')
SELECT * FROM dual;
/

-- Staff
INSERT ALL
    INTO Staff (staff_id, hotel_id, staff_fname, staff_lname, role, staff_phone, staff_email)
        VALUES (1, 1, 'Anna', 'Nowak', 'Manager', '+48600555666', 'anna.nowak@grandhotel.pl')
    INTO Staff (staff_id, hotel_id, staff_fname, staff_lname, role, staff_phone, staff_email)
        VALUES (2, 1, 'Piotr', 'Wiśniewski', 'Receptionist', '+48600777888', 'piotr.wisniewski@grandhotel.pl')
SELECT * FROM dual;
/

-- Services
INSERT ALL
    INTO Hotel_service (service_id, serv_name, serv_price)
        VALUES (1, 'Breakfast', 30)
    INTO Hotel_service (service_id, serv_name, serv_price)
        VALUES(2, 'Spa', 100)
    INTO Hotel_service (service_id, serv_name, serv_price)
        VALUES (3, 'Airport Pickup', 80)
SELECT * FROM dual;
/

-- Booking Services
INSERT ALL
    INTO Booking_Service (booking_id, service_id, customer_id, quantity) 
        VALUES (1, 1, 2, 2)
    INTO Booking_Service (booking_id, service_id, customer_id, quantity)
        VALUES (1, 3, 3, 1)
    INTO Booking_Service (booking_id, service_id, customer_id, quantity)
        VALUES (3, 2, 3, 3)
SELECT * FROM dual;
/

-- Feedback
INSERT ALL 
    INTO Customer_feedback (feedback_id, customer_id, hotel_id, rating, date_submitted)
        VALUES (1, 1, 1, 5, TO_DATE('2025-05-06','YYYY-MM-DD'))
    INTO Customer_feedback (feedback_id, customer_id, hotel_id, rating, date_submitted)
        VALUES (2, 3, 1, 4, TO_DATE('2025-05-15','YYYY-MM-DD'))
SELECT * FROM dual;
/

INSERT ALL 
    INTO Customer_feedback (feedback_id, customer_id, hotel_id, rating, date_submitted)
        VALUES (3, 1, 2, 4, TO_DATE('2025-05-06','YYYY-MM-DD'))
    INTO Customer_feedback (feedback_id, customer_id, hotel_id, rating, date_submitted)
        VALUES (4, 2, 2, 2, TO_DATE('2025-05-18','YYYY-MM-DD'))
SELECT * FROM dual;
/

-- Login
INSERT ALL
    INTO Login (user_id, user_email, password_hash, role)
        VALUES (1, 'big.g.ntin@example.com', 'hashed_pw1', 'Customer')
    INTO Login (user_id, user_email, password_hash, role)
        VALUES (2, 'bill.kagg@example.com', 'hashed_pw2', 'Customer')
    INTO Login (user_id, user_email, password_hash, role)
        VALUES (3, 'v.kazakos@example.com', 'hashed_pw3', 'Customer')
    INTO Login (user_id, user_email, password_hash, role)
        VALUES (4, 'anna.nowak@grandhotel.pl', 'hashed_pw4', 'Staff')
    INTO Login (user_id, user_email, password_hash, role)
        VALUES (5, 'piotr.wisniewski@grandhotel.pl', 'hashed_pw5', 'Staff')
    INTO Login (user_id, user_email, password_hash, role)
        VALUES (6, 'admin@hotel.com', 'hashed_pw6', 'Admin')
SELECT * FROM dual;
/

-- Inventory
INSERT ALL
    INTO Inventory (item_id, hotel_id, item_name, quantity, unit, last_updated)
        VALUES (1, 1, 'Towels', 100, 'pcs', TO_DATE('2025-05-01','YYYY-MM-DD'))
    INTO Inventory (item_id, hotel_id, item_name, quantity, unit, last_updated)
        VALUES (2, 1, 'Water bottle', 200, 'bottles', TO_DATE('2025-05-02','YYYY-MM-DD'))
    INTO Inventory (item_id, hotel_id, item_name, quantity, unit, last_updated)
        VALUES (3, 2, 'Shampoo', 150, 'bottles', TO_DATE('2025-04-28','YYYY-MM-DD'))
SELECT * FROM dual;
/

-- Events
INSERT ALL
    INTO Event (event_id, hotel_id, event_name, event_type, start_datetime, end_datetime, organizer_name, expected_guests)
        VALUES (1, 1, 'Tech Conference', 'Conference', 
                TO_TIMESTAMP('2025-07-10 09:00:00','YYYY-MM-DD HH24:MI:SS'),
                TO_TIMESTAMP('2025-07-12 18:00:00','YYYY-MM-DD HH24:MI:SS'),
                'GlobalTech', 200)
    INTO Event (event_id, hotel_id, event_name, event_type, start_datetime, end_datetime, organizer_name, expected_guests)
        VALUES (2, 1, 'Wedding of Jan and Anna', 'Wedding',
                TO_TIMESTAMP('2025-08-15 14:00:00','YYYY-MM-DD HH24:MI:SS'),
                TO_TIMESTAMP('2025-08-15 22:00:00','YYYY-MM-DD HH24:MI:SS'),
                'Jan Kowalski', 150)
SELECT * FROM dual;
/

-- Event Bookings
INSERT ALL 
    INTO Event_Booking (event_booking_id, event_id, customer_id, booking_date, total_cost)
        VALUES (1, 1, 1, TO_DATE('2025-04-30','YYYY-MM-DD'), 5000)
    INTO Event_Booking (event_booking_id, event_id, customer_id, booking_date, total_cost)
        VALUES (2, 2, 3, TO_DATE('2025-05-05','YYYY-MM-DD'), 3000)
SELECT * FROM dual;
/

COMMIT;
/

-- 1. List all bookings with customer name, hotel name, room number, and status 
SELECT
    b.booking_id, c.cust_fname || ' ' || c.cust_lname   AS customer,
    h.hotel_name, r.room_number, b.status
FROM Booking b
JOIN Customer c          
    ON b.customer_id = c.customer_id
JOIN Room r              
    ON b.room_id     = r.room_id
JOIN Hotel h             
    ON r.hotel_id    = h.hotel_id
ORDER BY b.booking_date;

-- 2. Count of rooms per hotel
SELECT
    h.hotel_name, COUNT(r.room_id) AS total_rooms
FROM Hotel h
LEFT JOIN Room r        
    ON h.hotel_id = r.hotel_id
GROUP BY h.hotel_name;


-- 3. Average customer rating per hotel
SELECT
    h.hotel_name, ROUND(AVG(f.rating), 2) AS avg_rating
FROM Customer_feedback f
JOIN Hotel h            
    ON f.hotel_id = h.hotel_id
GROUP BY h.hotel_name
HAVING AVG(f.rating) IS NOT NULL;

-- 4. Total payment amount per booking (using NVL to treat nulls as zero)
SELECT
    b.booking_id, NVL(p.amount,0) AS total_payment_amount
FROM Booking b
LEFT JOIN Payment p     
    ON b.booking_id = p.booking_id;


-- 5. Total revenue per hotel
SELECT
    h.hotel_name, SUM(p.amount) AS total_revenue
FROM Payment p
JOIN Booking b          
    ON p.booking_id = b.booking_id
JOIN Room r             
    ON b.room_id = r.room_id
JOIN Hotel h            
    ON r.hotel_id = h.hotel_id
GROUP BY h.hotel_name;

-- 6. List all available rooms (status = 'Available') with hotel and capacity
SELECT
    r.room_id, h.hotel_name, room_number, r.room_type, r.price_per_night, r.room_capacity
FROM Room r
JOIN Hotel h           
    ON r.hotel_id = h.hotel_id
WHERE r.status = 'Available'
ORDER BY h.hotel_name, r.room_number;

-- 7. Staff roster: staff name, role, and hotel, sorted by role
SELECT
    s.staff_id, s.staff_fname || ' ' || s.staff_lname AS staff_name,
    s.role, h.hotel_name
FROM Staff s
JOIN Hotel h            
    ON s.hotel_id = h.hotel_id
ORDER BY s.role, s.staff_lname;

-- 8. How many of each service each customer has used
SELECT
    c.cust_fname || ' ' || c.cust_lname AS customer,
    s.serv_name, SUM(bs.quantity) AS total_used
FROM Booking_Service bs
JOIN Customer c        
    ON bs.customer_id = c.customer_id
JOIN Hotel_service s   
    ON bs.service_id  = s.service_id
GROUP BY c.cust_fname, c.cust_lname, s.serv_name
ORDER BY total_used DESC;


-- 9. Upcoming events (start in the future) with duration in days
SELECT
    e.event_name,
    TO_CHAR(e.start_datetime, 'YYYY-MM-DD') AS start_date,
    TO_CHAR(e.end_datetime,   'YYYY-MM-DD') AS end_date,
    ROUND((CAST(e.end_datetime AS DATE) - CAST(e.start_datetime AS DATE)) * 24, 2) AS duration_hours
FROM Event e
WHERE e.start_datetime > SYSTIMESTAMP
ORDER BY e.start_datetime;

-- 10. Inventory items needing reorder (quantity below threshold)
UPDATE Inventory
SET quantity = 23
WHERE item_name = 'Towels';

SELECT
    item_name, quantity,
    CASE
      WHEN quantity < 50 THEN 'Reorder Soon'
      ELSE 'Sufficient'
    END AS status
FROM Inventory 
ORDER BY quantity ASC;

CREATE OR REPLACE PROCEDURE Add_Hotel_Service(
    p_service_id   IN Hotel_service.service_id%TYPE,
    p_serv_name    IN Hotel_service.serv_name%TYPE,
    p_serv_price   IN Hotel_service.serv_price%TYPE
) IS
    v_exists NUMBER := 0;
BEGIN
    -- Check if service name already exists
    SELECT COUNT(*) INTO v_exists
    FROM Hotel_service
    WHERE LOWER(serv_name) = LOWER(p_serv_name);

    IF v_exists > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Service with the same name already exists.');
    END IF;

    -- Check if price is valid
    IF p_serv_price < 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Service price cannot be negative.');
    END IF;

    -- Insert the new service
    INSERT INTO Hotel_service (service_id, serv_name, serv_price)
    VALUES (p_service_id, p_serv_name, p_serv_price);

    DBMS_OUTPUT.PUT_LINE('Service "' || p_serv_name || '" added successfully.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error adding service: ' || SQLERRM);
END;
/

BEGIN 
    Add_Hotel_Service(4, 'babysitting_per_hour', 15);
END;


CREATE OR REPLACE TRIGGER trg_update_room_status_on_booking
AFTER INSERT OR UPDATE ON Booking
FOR EACH ROW
BEGIN
    IF :NEW.status IN ('Confirmed', 'Completed') THEN

        UPDATE Room r
        SET r.status = 'Booked'
        WHERE r.room_id = :NEW.room_id;

    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_SetRoomAvailableOnCancel
AFTER UPDATE OF status ON Booking
FOR EACH ROW
WHEN (NEW.status = 'Cancelled')
BEGIN
    UPDATE Room
    SET status = 'Available'
    WHERE room_id = :NEW.room_id;
END;
/

INSERT INTO Booking (booking_id, customer_id, room_id, booking_date, check_in_date, check_out_date, status)
        VALUES (5, 1, 3, TO_DATE('2025-05-09','YYYY-MM-DD'), TO_DATE('2025-05-11','YYYY-MM-DD'), TO_DATE('2025-05-13','YYYY-MM-DD'), 'Completed');
/

CREATE OR REPLACE PROCEDURE find_available_rooms
(
    p_start_date DATE,
    p_end_date DATE
) IS

    CURSOR c1 IS
        SELECT DISTINCT r.room_id, r.room_number
        FROM Room r
        JOIN Booking b
         ON b.room_id = r.room_id
        WHERE (r.status = 'Available')
        OR (TO_DATE(p_start_date, 'YYYY-MM-DD') >= TO_DATE(b.check_out_date, 'YYYY-MM-DD'))
        OR (TO_DATE(p_end_date, 'YYYY-MM-DD') <= TO_DATE(b.check_in_date, 'YYYY-MM-DD'));

BEGIN
    DBMS_OUTPUT.PUT_LINE('Available rooms: ');
    FOR available_rec IN c1 LOOP
        DBMS_OUTPUT.PUT_LINE('Room number: ' || available_rec.room_number);
        DBMS_OUTPUT.PUT_LINE('Room id: ' || available_rec.room_id);
        DBMS_OUTPUT.PUT_LINE('--------------------');
    END LOOP;
END;
/


BEGIN
    find_available_rooms(
        TO_DATE('2025-05-04', 'YYYY-MM-DD'),
        TO_DATE('2025-05-06', 'YYYY-MM-DD')
    );
END;
/

CREATE OR REPLACE PROCEDURE GenerateBookingInvoice ( 
    p_booking_id IN Booking.booking_id%TYPE
) IS
    v_customer_name    VARCHAR2(100);
    v_room_cost        NUMBER := 0;
    v_service_cost     NUMBER := 0;
    v_total_paid       NUMBER := 0;
    v_nights           NUMBER := 0;
    v_total_due        NUMBER := 0;
BEGIN
    -- Get customer name and nights stayed
    SELECT c.cust_fname || ' ' || c.cust_lname,
           b.check_out_date - b.check_in_date
    INTO v_customer_name, v_nights
    FROM Booking b
    JOIN Customer c ON b.customer_id = c.customer_id
    WHERE b.booking_id = p_booking_id;

    -- Calculate room cost
    SELECT r.price_per_night * v_nights
    INTO v_room_cost
    FROM Room r
    JOIN Booking b ON r.room_id = b.room_id
    WHERE b.booking_id = p_booking_id;

    -- Calculate service cost
    SELECT NVL(SUM(bs.quantity * hs.serv_price), 0)
    INTO v_service_cost
    FROM Booking_Service bs
    JOIN Hotel_service hs ON bs.service_id = hs.service_id
    WHERE bs.booking_id = p_booking_id;

    -- Total payments made
    SELECT NVL(SUM(amount), 0)
    INTO v_total_paid
    FROM Payment
  WHERE booking_id = p_booking_id;

    -- Final amount due
    v_total_due := (v_room_cost + v_service_cost) - v_total_paid;

    -- Display invoice summary
    DBMS_OUTPUT.PUT_LINE('===== INVOICE =====');
    DBMS_OUTPUT.PUT_LINE('Customer: ' || v_customer_name);
    DBMS_OUTPUT.PUT_LINE('Room Cost: ' || v_room_cost);
    DBMS_OUTPUT.PUT_LINE('Service Cost: ' || v_service_cost);
    DBMS_OUTPUT.PUT_LINE('Total Paid: ' || v_total_paid);
    DBMS_OUTPUT.PUT_LINE('Amount Due: ' || v_total_due);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Booking not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/

BEGIN 
    GenerateBookingInvoice (1);
    GenerateBookingInvoice (2);
END;
/

CREATE OR REPLACE FUNCTION CountUpcomingEvents (
    p_hotel_id IN Hotel.hotel_id%TYPE
) RETURN NUMBER IS
    v_event_count NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO v_event_count
    FROM Event
    WHERE hotel_id = p_hotel_id
      AND start_datetime > SYSTIMESTAMP;

    RETURN v_event_count;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1; -- indicates error
END;
/

SELECT CountUpcomingEvents(1) AS TOTAL_EVENTS
FROM dual;

CREATE OR REPLACE FUNCTION GetHotelRevenue (
    p_hotel_id IN Hotel.hotel_id%TYPE
) RETURN NUMBER IS
    v_room_revenue   NUMBER := 0;
    v_service_revenue NUMBER := 0;
    v_total_revenue  NUMBER := 0;
BEGIN
    -- Calculate total room revenue
    SELECT SUM(NVL(p.amount,0))
    INTO v_room_revenue
    FROM Payment p
    JOIN Booking b ON p.booking_id = b.booking_id
    JOIN Room r ON b.room_id = r.room_id
    WHERE r.hotel_id = p_hotel_id;

    -- Calculate total service revenue
    SELECT SUM(NVL(bs.quantity * hs.serv_price, 0))
    INTO v_service_revenue
    FROM Booking_Service bs
    JOIN Booking b ON bs.booking_id = b.booking_id
    JOIN Room r ON b.room_id = r.room_id
    JOIN Hotel_service hs ON bs.service_id = hs.service_id
    WHERE r.hotel_id = p_hotel_id;

    -- Total revenue = room + service revenue
    v_total_revenue := v_room_revenue + v_service_revenue;

    RETURN ROUND(v_total_revenue, 2);
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END;
/

SELECT GetHotelRevenue(1) AS HOTEL_REVENUE
FROM dual;
/

COMMIT;
/


-- INDEXES

-- 1
CREATE INDEX idx_room_status ON Room(status);
/

EXPLAIN PLAN FOR
SELECT room_number
FROM Room
WHERE status = 'Available';
/

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
/

-- 2
CREATE INDEX idx_customer_name
    ON Customer(cust_lname, cust_fname);
/

EXPLAIN PLAN FOR
SELECT cust_fname, cust_lname
FROM Customer
WHERE cust_lname = 'K%';
/

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
/

-- 3
CREATE INDEX idx_payment_booking ON Payment(booking_id);
/

EXPLAIN PLAN FOR
SELECT SUM(amount)
FROM Payment
WHERE booking_id = '123';
/

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
/

-- 4
CREATE INDEX idx_event_start ON Event(start_datetime);
/

EXPLAIN PLAN FOR
SELECT event_name, start_datetime
FROM Event
WHERE start_datetime > SYSTIMESTAMP
ORDER BY start_datetime;
/

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());
/

COMMIT;
/