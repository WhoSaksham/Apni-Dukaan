const Order = require('../../models/shopOwner/orderHistory.model');

// View All History api for SHOPOWNER

const getHistoryController = async (req, res) => {
    try {
        const orders = await Order.find();

        res.status(200).json({ success: true, message: "All Order History fetch Success.", response: orders });

    } catch (error) {
        res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
        console.log("Error =>", error);
    }
};

// View All History for Particular Owner api for SHOPOWNER
const getOwnerHistoryController = async (req, res) => {
    try {
        const orders = await Order.find({ purchasedBy: req.params.purchasedBy });

        // Check for Orders
        if (orders.length <= 0) {
            return res.status(404).json({ success: false, message: "No Orders found." });
        }

        res.status(200).json({ success: true, message: "All Order History fetch Success.", response: orders });

    } catch (error) {
        res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
        console.log("Error =>", error);
    }
};



// Add Order History api for SHOPOWNER

const addHistoryController = async (req, res) => {
    try {
        // Add Order
        const order = Order({
            category: req.body.category,
            company: req.body.company,
            name: req.body.name,
            originalPrice: req.body.originalPrice,
            quantity: req.body.quantity,
            orderTotal: req.body.orderTotal,
            purchasedBy: `${req.user[0]} ${req.user[1]}`, // Getting user name and email from verifyToken middleware
        });

        const response = await order.save();

        res.status(200).json({ success: true, message: "New Order Created Successfully.", response });
    } catch (error) {
        res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
        console.log("Error =>", error);
    }
};

// Edit Order History api for SHOPOWNER

const editHistoryController = async (req, res) => {
    // Finding order based on id from params
    const order = await Order.findOne({ _id: req.params.id });

    // Check for existence of particular Order
    if (!order) {
        return res.status(404).json({ success: false, message: "No such Order found with given ID." });
    }

    try {
        const updatedOrder = await Order.findByIdAndUpdate({ _id: req.params.id }, { $set: req.body }, { new: true });

        res.status(200).json({ success: true, message: "Order Update Success.", response: updatedOrder });
    } catch (error) {
        res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
        console.log("Error =>", error);
    }
};

// Delete Order History api for SHOPOWNER

const deleteHistoryController = async (req, res) => {
    // Finding order based on id from params
    const order = await Order.findOne({ _id: req.params.id });

    // Check for existence of particular Order
    if (!order) {
        return res.status(404).json({ success: false, message: "No such Order found with given ID." });
    }

    try {
        const deletedOrder = await Order.findByIdAndDelete({ _id: req.params.id });

        res.status(200).json({ success: true, message: "Order Delete Success.", response: deletedOrder });

    } catch (error) {
        res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
        console.log("Error =>", error);
    }
};


module.exports = {
    getHistoryController,
    getOwnerHistoryController,
    addHistoryController,
    editHistoryController,
    deleteHistoryController
};