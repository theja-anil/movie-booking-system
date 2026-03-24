-- MOVIE
INSERT INTO movie (movie_name, language, duration, rating)
VALUES 
('Inception', 'English', 150, 'U/A'),
('Leo', 'Tamil', 160, 'A');

-- THEATRE
INSERT INTO theatre (theatre_name, location)
VALUES 
('PVR Cinemas', 'Kochi'),
('Cinepolis', 'Ernakulam');

-- SHOWS
INSERT INTO shows (movie_id, theatre_id, show_date, show_time, ticket_price, available_seats)
VALUES 
(1, 1, CURRENT_DATE, '6 PM', 200, 100),
(2, 2, CURRENT_DATE, '9 PM', 180, 80);

-- CUSTOMER
INSERT INTO customer (customer_name, phone_number)
VALUES 
('Rahul', '9876543210'),
('Anjali', '9123456780');

-- BOOKING (optional test entry)
INSERT INTO booking (show_id, customer_id, seats_booked, total_amount)
VALUES 
(1, 1, 2, 400);
