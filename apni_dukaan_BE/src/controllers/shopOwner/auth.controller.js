const bcrypt = require('bcryptjs');
const { generateToken } = require('../../middlewares/middlewares'); // Middlewares
const ShopOwnerAuth = require('../../models/shopOwner/shopOwnerAuth.model'); // ShopOwnerAuthModel

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

module.exports = {
    shopOwnerSignupController,
    shopOwnerLoginController
};