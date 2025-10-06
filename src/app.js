import express from 'express';
import dotenv from 'dotenv';
import pool from './databases/mysqlManager.js';

dotenv.config();
const app = express();
app.use(express.json());

const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
    res.send('Hello, World!');
});

// Import and use routers
import aircraftRouter from './controllers/aircraftController.js';

const routers = [
    aircraftRouter
];

app.use('/api', routers);

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});