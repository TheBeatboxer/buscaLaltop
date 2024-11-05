const mongoose = require('mongoose');

const laptopSchema = new mongoose.Schema({
    brand: String,
    model: String,
    status: { type: String, enum: ['available', 'sold', 'pending'], default: 'available' },
    price: Number,
});

module.exports = mongoose.model('Laptop', laptopSchema);
