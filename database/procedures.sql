-- =========================================
-- FUNCTION: Calculate Total Amount
-- =========================================
CREATE OR REPLACE FUNCTION calculate_total(p_show_id INT, p_seats INT)
RETURNS INT AS $$
DECLARE
    price INT;
BEGIN
    SELECT ticket_price INTO price
    FROM shows
    WHERE show_id = p_show_id;

    RETURN price * p_seats;
END;
$$ LANGUAGE plpgsql;


-- =========================================
-- PROCEDURE: Book Ticket
-- =========================================
CREATE OR REPLACE PROCEDURE book_ticket(
    p_show_id INT,
    p_customer_id INT,
    p_seats INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    available INT;
    total INT;
BEGIN
    -- Check available seats
    SELECT available_seats INTO available
    FROM shows
    WHERE show_id = p_show_id;

    IF available < p_seats THEN
        RAISE EXCEPTION 'Not enough seats available';
    END IF;

    -- Calculate total amount
    total := calculate_total(p_show_id, p_seats);

    -- Insert booking
    INSERT INTO booking(show_id, customer_id, seats_booked, total_amount)
    VALUES (p_show_id, p_customer_id, p_seats, total);
END;
$$;


-- =========================================
-- TRIGGER FUNCTION: Reduce Seats After Booking
-- =========================================
CREATE OR REPLACE FUNCTION update_seat_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE shows
    SET available_seats = available_seats - NEW.seats_booked
    WHERE show_id = NEW.show_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- TRIGGER: After Insert on Booking
CREATE TRIGGER after_booking_insert
AFTER INSERT ON booking
FOR EACH ROW
EXECUTE FUNCTION update_seat_count();


-- =========================================
-- TRIGGER FUNCTION: Restore Seats After Cancel
-- =========================================
CREATE OR REPLACE FUNCTION restore_seat_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE shows
    SET available_seats = available_seats + OLD.seats_booked
    WHERE show_id = OLD.show_id;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


-- TRIGGER: After Delete on Booking
CREATE TRIGGER after_booking_delete
AFTER DELETE ON booking
FOR EACH ROW
EXECUTE FUNCTION restore_seat_count();


-- =========================================
-- PROCEDURE: Daily Report using Cursor
-- =========================================
CREATE OR REPLACE PROCEDURE generate_daily_report(p_date DATE)
LANGUAGE plpgsql
AS $$
DECLARE
    cur_bookings CURSOR FOR 
        SELECT b.booking_id, c.customer_name, b.total_amount 
        FROM booking b
        JOIN customer c ON b.customer_id = c.customer_id
        WHERE b.booking_date = p_date;

    v_record RECORD;
    v_total_revenue INT := 0;
BEGIN
    OPEN cur_bookings;

    LOOP
        FETCH cur_bookings INTO v_record;
        EXIT WHEN NOT FOUND;

        v_total_revenue := v_total_revenue + v_record.total_amount;

        RAISE NOTICE 'Booking ID: %, Customer: %, Amount: %',
                     v_record.booking_id,
                     v_record.customer_name,
                     v_record.total_amount;
    END LOOP;

    CLOSE cur_bookings;

    RAISE NOTICE 'Total Revenue for %: %', p_date, v_total_revenue;
END;
$$;
