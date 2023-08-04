const { connect } = require('mongoose');

const connectDB = async () => {
    try {
        // await connect('mongodb://127.0.0.1:27017/ApniDukaan');
        await connect(process.env.MONGO_URI);
        console.log("Connected to MongoDB");
    } catch (error) {
        console.log("Can't connect to MongoDB", error.message);
    }
}

module.exports = connectDB;