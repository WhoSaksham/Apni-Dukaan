const AdminAuth = require("../../models/admin/adminAuth.model"); // AdminAuthModel
const bcrypt = require('bcryptjs');
const { generateToken } = require("../../middlewares/middlewares"); // Middlewares

// SIGNUP Controller for ADMIN

const adminSignupController = async (req, res) => {
    try {
        // Check for unique email
        const adminExists = await AdminAuth.findOne({ email: req.body.email });

        if (adminExists) {
            return res.status(400).json({ success: false, message: 'Another ADMIN already exists with this Email.' });
        }

        // Signup admin
        const admin = AdminAuth({
            firstName: req.body.firstName,
            lastName: req.body.lastName,
            email: req.body.email,
            password: bcrypt.hashSync(req.body.password, 10) // Secure password
        });

        const response = await admin.save();

        // Generating and Setting token in header
        res.header("Authorization", `Bearer ${generateToken({ user: { name: admin.firstName, email: admin.email } })}`)

        res.status(200).json({ success: true, message: "New Admin Created Successfully.", response });
    } catch (error) {
        res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
        console.log("Error =>", error);
    }
};

// LOGIN Controller for ADMIN

const adminLoginController = async (req, res) => {
    // check if admin really exists
    const adminExists = await AdminAuth.findOne({ email: req.body.email });

    if (!adminExists) return res.status(400).json({ success: false, message: "Invalid Email or Password" })

    try {
        // Verify Password
        if (!bcrypt.compareSync(req.body.password, adminExists.password)) return res.status(400).json({ success: false, message: "Invalid Email or Password" });

        // Generating and Setting token in header
        res.header("Authorization", `Bearer ${generateToken({ user: { name: adminExists.firstName, email: adminExists.email } })}`)

        res.status(200).json({ success: true, message: "Admin Login Success.", response: adminExists });

    } catch (error) {
        res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
        console.log("Error =>", error);
    }

};

module.exports = {
    adminSignupController,
    adminLoginController
};