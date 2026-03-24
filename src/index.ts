import { MovieService } from './booking';
import { pool } from './db';

const bookingSystem = new MovieService();

async function startApp() {
    try {
        console.log("--- Welcome to the Theatre Booking System ---");

        // 1. Example: Book 2 tickets for Customer 1 on Show 101
        // The SQL Trigger will automatically reduce the available_seats
        await bookingSystem.bookTicket(1, 101, 2);

        // 2. Example: Generate a report using the SQL Cursor procedure
        console.log("\n--- Generating Daily Sales Report ---");
        await bookingSystem.printReport('2026-03-24');

    } catch (error) {
        console.error("Application Error:", error);
    } finally {
        // Always close the pool when the app finishes
        await pool.end();
        console.log("\nDatabase connection closed.");
    }
}

// Start the execution
startApp();
