const { Schema, model } = require('mongoose');

const orderHistorySchema = Schema({
    category: {
        type: String,
        minLength: 3,
        maxLength: 30,
        trim: true,
        required: [true, "Provide Category"]
    },
    company: {
        type: String,
        minLength: 3,
        maxLength: 50,
        trim: true,
        required: [true, "Provide Company"]
    },
    name: {
        type: String,
        minLength: 3,
        maxLength: 100,
        trim: true,
        required: [true, "Provide Name"]
    },
    originalPrice: {
        type: Number,
        min: 1,
        max: 1000,
        required: [true, "Provide Price"]
    },
    quantity: {
        type: Number,
        min: 1,
        max: 1000,
        required: [true, "Provide Quantity"]
    },
    orderTotal: {
        type: Number,
        min: 1,
        required: [true, "Provide Total Amount"]
    },
    purchasedAt: {
        type: Date,
        default: Date.now()
    },
    purchasedBy: {
        type: String,
        ref: "ShopOwnerAuth"
    },
});

const Order = model('Order', orderHistorySchema);

// Indexing
// Order.createIndexes();

module.exports = Order;