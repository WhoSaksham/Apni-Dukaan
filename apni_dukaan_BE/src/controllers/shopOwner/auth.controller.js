const bcrypt = require('bcryptjs');
const { generateToken } = require('../../middlewares/middlewares'); // Middlewares
const ShopOwnerAuth = require('../../models/shopOwner/shopOwnerAuth.model'); // ShopOwnerAuthModel
const nodemailer = require("nodemailer");

// SIGNUP Controller for SHOPOWNER

const shopOwnerSignupController = async (req, res) => {
    try {
        // Check for unique email
        const ownerExists = await ShopOwnerAuth.findOne({ email: req.body.email });

        if (ownerExists) {
            return res.status(400).json({ success: false, message: 'Another ShopOwner already exists with this Email.' });
        }

        // Signup owner
        const owner = ShopOwnerAuth({
            firstName: req.body.firstName,
            lastName: req.body.lastName,
            email: req.body.email,
            password: bcrypt.hashSync(req.body.password, 10), // Secure password
            company: req.body.company,
        });

        const response = await owner.save();

        // Generating and Setting token in header
        res.header("Authorization", `Bearer ${generateToken({ user: { name: owner.firstName, email: owner.email } })}`)

        res.status(200).json({ success: true, message: "New ShopOwner Created Successfully.", response });
    } catch (error) {
        res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
        console.log("Error =>", error);
    }
};

// LOGIN Controller for SHOPOWNER

const shopOwnerLoginController = async (req, res) => {
    // check if owner really exists
    const ownerExists = await ShopOwnerAuth.findOne({ email: req.body.email });

    if (!ownerExists) return res.status(400).json({ success: false, message: "Invalid Email or Password" })

    try {
        // Verify Password
        if (!bcrypt.compareSync(req.body.password, ownerExists.password)) return res.status(400).json({ success: false, message: "Invalid Email or Password" });

        // Generating and Setting token in header
        res.header("Authorization", `Bearer ${generateToken({ user: { name: ownerExists.firstName, email: ownerExists.email } })}`)

        res.status(200).json({ success: true, message: "ShopOwner Login Success.", response: ownerExists });

    } catch (error) {
        res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
        console.log("Error =>", error);
    }
};

// RESET PASSWORD Controller for SHOPOWNER

const forgotPasswordController = async (req, res) => {
    // check if owner really exists
    const ownerExists = await ShopOwnerAuth.findOne({ email: req.body.email });

    if (!ownerExists) return res.status(400).json({ success: false, message: "No Account Found" })

    try {
        const transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: process.env.EMAIL,
                pass: process.env.PASSWORD
            }
        });

        // Generate random 8 digit number
        const randomNumber = Math.floor(Math.random() * (99999999 - 10000000 + 1)) + 10000000;

        const mailOptions = {
            from: process.env.EMAIL,
            to: req.body.email,
            subject: 'Reset Password For ApniDukaan Account',
            html: `<h2>Hi, ${ownerExists.firstName}</h2>
            <p>Your Secret number to reset your password is <h3><strong>${randomNumber}</strong></h3> You can use this to get approved.</p>
            <p>Do not share your secret.</p><br>
            <p>Your's Faithfully<br>
            Apni Dukaan<br>
            For Help - hello@apnidukaan.com</p>`
        };

        transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
                console.log("Error =>", error);
                return res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
            } else {
                res.header({ 'Code': randomNumber });
                return res.status(200).json({ success: true, message: "Mail has been sent, Check your Inbox", response: info.response, user: ownerExists });
            }
        });
    } catch (error) {
        res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
        console.log("Error =>", error);
    }
};

const resetPasswordController = async (req, res) => {
    try {
        // Getting email and password from body and updating password 
        const response = await ShopOwnerAuth.updateOne({ email: req.body.email }, { $set: { password: bcrypt.hashSync(req.body.password, 10) } });

        res.status(200).json({ success: true, message: "Password Update Success", response });

    } catch (error) {
        res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
        console.log("Error =>", error);
    }
}

module.exports = {
    shopOwnerSignupController,
    shopOwnerLoginController,
    forgotPasswordController,
    resetPasswordController
};