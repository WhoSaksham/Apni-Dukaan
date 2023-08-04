const { Schema, model } = require('mongoose');

const stationarySchema = Schema({
    category: {
        type: String,
        minLength: 3,
        maxLength: 20,
        trim: true,
        required: [true, "Provide Category"]
    },
    company: {
        type: String,
        minLength: 3,
        maxLength: 20,
        trim: true,
        required: [true, "Provide Company"]
    },
    name: {
        type: String,
        minLength: 3,
        maxLength: 30,
        trim: true,
        required: [true, "Provide Name"]
    },
    quantity: {
        type: Number,
        min: 10,
        max: 1000,
        required: [true, "Provide Quantity"]
    },
    price: {
        type: Number,
        min: 1,
        max: 1000,
        required: [true, "Provide Price"]
    },
    createdAt: {
        type: Date,
        default: Date.now()
    },
    createdBy: {
        type: String,
        ref: "AdminAuth"
    }
});

const Stationary = model('Stationary', stationarySchema);

// Indexing
Stationary.createIndexes();

module.exports = Stationary;