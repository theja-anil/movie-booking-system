-- 1. TRIGGER: Auto-update available seats after a booking
CREATE OR REPLACE FUNCTION update_seat_count()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE SHOWS 
    SET available_seats = available_seats - NEW.num_seats
    WHERE show_id = NEW.show_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_booking_insert
AFTER INSERT ON BOOKING
FOR EACH ROW
EXECUTE FUNCTION update_seat_count();

-- 2. CURSOR & PROCEDURE: Generate a Summary Report
-- This uses a cursor to iterate through bookings and calculate total revenue
CREATE OR REPLACE PROCEDURE generate_daily_report(p_date DATE)
AS $$
DECLARE
    -- Define the Cursor
    cur_bookings CURSOR FOR 
        SELECT b.booking_id, c.name, b.total_amount 
        FROM BOOKING b
        JOIN CUSTOMER c ON b.customer_id = c.customer_id
        WHERE b.booking_date::DATE = p_date;
    
    v_record RECORD;
    v_total_revenue DECIMAL(10,2) := 0;
BEGIN
    OPEN cur_bookings;
    LOOP
        FETCH cur_bookings INTO v_record;
        EXIT WHEN NOT FOUND;
        
        -- Business logic inside cursor
        v_total_revenue := v_total_revenue + v_record.total_amount;
        RAISE NOTICE 'Booking ID: %, Customer: %, Amount: %', 
                     v_record.booking_id, v_record.name, v_record.total_amount;
    END LOOP;
    CLOSE cur_bookings;
    
    RAISE NOTICE 'Total Revenue for %: %', p_date, v_total_revenue;
END;
$$ LANGUAGE plpgsql;
