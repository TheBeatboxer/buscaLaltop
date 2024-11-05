const express = require('express');
const router = express.Router();
const Laptop = require('../models/Laptop');

// Crear laptop
router.post('/', async (req, res) => {
    try {
        const laptop = new Laptop(req.body);
        await laptop.save();
        res.json(laptop);
    } catch (error) {
        res.status(500).send(error.message);
    }
});

// Obtener todas las laptops
router.get('/', async (req, res) => {
    try {
        const laptops = await Laptop.find();
        res.json(laptops);
    } catch (error) {
        res.status(500).send(error.message);
    }
});

// Actualizar laptop
router.put('/:id', async (req, res) => {
    try {
        const laptop = await Laptop.findByIdAndUpdate(req.params.id, req.body, { new: true });
        res.json(laptop);
    } catch (error) {
        res.status(500).send(error.message);
    }
});

// Eliminar laptop
router.delete('/:id', async (req, res) => {
    try {
        await Laptop.findByIdAndDelete(req.params.id);
        res.send('Laptop eliminada');
    } catch (error) {
        res.status(500).send(error.message);
    }
});

module.exports = router;
