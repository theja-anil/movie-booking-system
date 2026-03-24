-- MOVIE TABLE
CREATE TABLE movie (
    movie_id SERIAL PRIMARY KEY,
    movie_name VARCHAR(50) NOT NULL,
    language VARCHAR(30),
    duration INT,
    rating VARCHAR(5)
);

-- THEATRE TABLE
CREATE TABLE theatre (
    theatre_id SERIAL PRIMARY KEY,
    theatre_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

-- SHOWS TABLE
CREATE TABLE shows (
    show_id SERIAL PRIMARY KEY,
    movie_id INT,
    theatre_id INT,
    show_date DATE,
    show_time VARCHAR(20),
    ticket_price INT,
    available_seats INT CHECK (available_seats >= 0),

    FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
    FOREIGN KEY (theatre_id) REFERENCES theatre(theatre_id)
);

-- CUSTOMER TABLE
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50),
    phone_number VARCHAR(15)
);

-- BOOKING TABLE
CREATE TABLE booking (
    booking_id SERIAL PRIMARY KEY,
    show_id INT,
    customer_id INT,
    seats_booked INT CHECK (seats_booked > 0),
    total_amount INT,
    booking_date DATE DEFAULT CURRENT_DATE,

    FOREIGN KEY (show_id) REFERENCES shows(show_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
