const { connect } = require('mongoose');

const connectDB = async () => {
    try {
        await connect(process.env.MONGO_URI, {
            // useNewUrlParser: true,
            // useUnifiedTopology: true,
        });
        console.log("Connected to MongoDB");
    } catch (error) {
        console.log("Can't connect to MongoDB", error.message);
    }
}

module.exports = connectDB;