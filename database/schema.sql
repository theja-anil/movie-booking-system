-- Tables
CREATE TABLE MOVIE (
    movie_id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    genre TEXT,
    duration_min INT
);

CREATE TABLE THEATRE (
    theatre_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    location TEXT,
    total_capacity INT
);

CREATE TABLE SHOWS (
    show_id SERIAL PRIMARY KEY,
    movie_id INT REFERENCES MOVIE(movie_id),
    theatre_id INT REFERENCES THEATRE(theatre_id),
    show_time TIMESTAMP,
    available_seats INT,
    price_per_seat DECIMAL(10,2)
);

CREATE TABLE CUSTOMER (
    customer_id SERIAL PRIMARY KEY,
    name TEXT,
    email TEXT UNIQUE,
    phone TEXT
);

CREATE TABLE BOOKING (
    booking_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES CUSTOMER(customer_id),
    show_id INT REFERENCES SHOWS(show_id),
    num_seats INT,
    total_amount DECIMAL(10,2),
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
