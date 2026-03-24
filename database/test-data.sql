INSERT INTO movie(movie_name, language, duration, rating)
VALUES ('Inception', 'English', 150, 'U/A');

INSERT INTO theatre(theatre_name, location)
VALUES ('PVR', 'Kochi');

INSERT INTO shows(movie_id, theatre_id, show_date, show_time, ticket_price, available_seats)
VALUES (1, 1, CURRENT_DATE, '6 PM', 200, 100);

INSERT INTO customer(customer_name, phone_number)
VALUES ('Rahul', '9876543210');
