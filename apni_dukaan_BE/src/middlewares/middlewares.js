const jwt = require('jsonwebtoken');

const generateToken = (data) => {
    return jwt.sign(data, process.env.JWT_SECRET)
};

const verifyToken = (req, res, next) => {
    // Getting token from header
    const token = req.header("Authorization");

    // Check for empty token
    if (!token) return res.status(401).json({ success: false, message: "Authentication failed, No Token present in Headers" });

    // Checking token type
    if (!token.startsWith("Bearer ")) {
        return res.status(401).json({ success: false, message: "Invalid Token type" });
    }

    try {
        // Verifying token
        if (!jwt.verify(token.split(" ")[1], process.env.JWT_SECRET)) {
            return res.status(401).json({ success: false, message: "Authentication failed, Invalid Token" })
        }
        const data = jwt.verify(token.split(" ")[1], process.env.JWT_SECRET); // Extracting name and email value from token

        req.user = [data.user.name, data.user.email]// Sending name and email value from token for further use

        next(); // Token Verified

    } catch (error) {
        res.status(401).json({ success: false, message: 'Please Authenticate using a Valid Token' });
        console.log("Something went wrong", error);
    }
};

module.exports = { generateToken, verifyToken }