import { pool } from './db';

export class MovieService {
    // Book a ticket (The trigger in SQL will handle seat subtraction)
    async bookTicket(customerId: number, showId: number, numSeats: number) {
        const client = await pool.connect();
        try {
            await client.query('BEGIN');
            
            // 1. Check if seats exist (Application-level validation)
            const showRes = await client.query('SELECT available_seats, price_per_seat FROM SHOWS WHERE show_id = $1', [showId]);
            const show = showRes.rows[0];

            if (show.available_seats < numSeats) {
                throw new Error("Sold out or not enough seats!");
            }

            // 2. Insert booking (Trigger 'after_booking_insert' fires automatically)
            const totalAmount = show.price_per_seat * numSeats;
            await client.query(
                'INSERT INTO BOOKING (customer_id, show_id, num_seats, total_amount) VALUES ($1, $2, $3, $4)',
                [customerId, showId, numSeats, totalAmount]
            );

            await client.query('COMMIT');
            console.log(`Success! Booked ${numSeats} seats.`);
        } catch (e) {
            await client.query('ROLLBACK');
            console.error("Transaction failed:", e);
        } finally {
            client.release();
        }
    }

    // Call the Cursor Procedure
    async printReport(date: string) {
        await pool.query('CALL generate_daily_report($1)', [date]);
    }
}
