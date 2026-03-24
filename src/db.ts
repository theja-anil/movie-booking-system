import { Pool } from 'pg';

export const pool = new Pool({
    user: 'theja',
    host: 'localhost',
    database: 'movie_db',
    password: 'theja',
    port: 5432,
});
