const express = require('express');
const app = express();
require('dotenv').config(); // .env
require('./db')(); // DB
const cors = require('cors');

app.use(cors()); // CORS

app.use(express.json()); // To deal data in JSON (parse requests of content-type : application/json)

app.use(express.urlencoded({
    extended: true
})); // parse requests of content-type : application/x-www-form-urlencoded

// Test
app.get("/", (req, res) => {
    res.status(200).send("<h1>Welcome to Apni Dukaan API</h1>")
});

// API ROUTES =>

// Admin routes
app.use('/admin', require("./routes/admin/auth.routes")); // Admin Auth

app.use('/admin', require("./routes/admin/stationary.routes")); // Admin Stationary


// ShopOwner routes
app.use('/shopowner', require("./routes/shopOwner/auth.routes")); // ShopOwner Auth

app.use('/orders', require("./routes/shopOwner/orderHistory.routes")); // ShopOwner Purchase History

// Error route
app.get("*", (req, res) => {
    res.status(404).send("Not Found");
});

// Server Listening
app.listen(process.env.PORT || 8000, () => {
    console.log(`Server has started successfully`);
});