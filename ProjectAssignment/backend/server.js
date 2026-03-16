const express = require('express');
const { Pool } = require('pg');
const app = express();
app.use(express.json());

const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: 5432,
});

// Auto-creates the table on startup
async function syncDatabase() {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS tasks (
        id SERIAL PRIMARY KEY,
        content TEXT NOT NULL
      );
    `);
    console.log("Database table synchronized.");
  } catch (err) {
    console.error("Sync error:", err);
  }
}
syncDatabase();

app.get('/health', (req, res) => res.json({ status: 'active' }));

app.post('/tasks', async (req, res) => {
  const { content } = req.body;
  const result = await pool.query('INSERT INTO tasks (content) VALUES ($1) RETURNING *', [content]);
  res.status(201).json(result.rows[0]);
});

app.get('/tasks', async (req, res) => {
  const result = await pool.query('SELECT * FROM tasks');
  res.json(result.rows);
});

app.listen(3000, '0.0.0.0', () => console.log('Backend listening on port 3000'));