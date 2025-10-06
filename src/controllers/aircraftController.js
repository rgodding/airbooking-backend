import Router from 'express';
import pool from '../databases/mysqlManager.js';
const aircraftRouter = Router();

// Get all aircraft
aircraftRouter.get('/aircraft', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM aircraft');
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server error');
    }
});

// Get aircraft by ID
aircraftRouter.get('/aircraft/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const [rows] = await pool.query('SELECT * FROM aircraft WHERE aircraft_id = ?', [id]);
        if (rows.length === 0) {
            return res.status(404).send('Aircraft not found');
        }
        res.json(rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).send('Server error');
    }
});

// Add a new aircraft
aircraftRouter.post('/aircraft', async (req, res) => {
    const { model, manufacturer, capacity } = req.body;
    try {
        const [result] = await pool.query('INSERT INTO aircraft (model, manufacturer, capacity) VALUES (?, ?, ?)', [model, manufacturer, capacity]);
        res.status(201).json({ id: result.insertId, model, manufacturer, capacity });
    } catch (err) {
        console.error(err);
        res.status(500).send('Server error');
    }
});

// Update an aircraft
aircraftRouter.put('/aircraft/:id', async (req, res) => {
    const { id } = req.params;
    const { model, manufacturer, capacity } = req.body;
    try {
        const [result] = await pool.query('UPDATE aircraft SET model = ?, manufacturer = ?, capacity = ? WHERE aircraft_id = ?', [model, manufacturer, capacity, id]);
        if (result.affectedRows === 0) {
            return res.status(404).send('Aircraft not found');
        }
        res.send('Aircraft updated successfully');
    } catch (err) {
        console.error(err);
        res.status(500).send('Server error');
    } 
});

// Delete an aircraft
aircraftRouter.delete('/aircraft/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const [result] = await pool.query('DELETE FROM aircraft WHERE aircraft_id = ?', [id]);
        if (result.affectedRows === 0) {
            return res.status(404).send('Aircraft not found');
        }
        res.send('Aircraft deleted successfully');
    } catch (err) {
        console.error(err);
        res.status(500).send('Server error');
    }
});

export default aircraftRouter;