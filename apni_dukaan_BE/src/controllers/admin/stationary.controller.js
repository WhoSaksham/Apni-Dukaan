const Stationary = require("../../models/admin/stationary.model"); // StationaryModel
const bcrypt = require('bcryptjs');
const { generateToken } = require("../../middlewares/middlewares"); // Middlewares

// Add Stationary api for ADMIN

const addStationaryController = async (req, res) => {
    try {
        // Check for unique company and name
        const stationaryExists = await Stationary.findOne({ company: req.body.company, name: req.body.name });

        if (stationaryExists) {
            return res.status(400).json({ success: false, message: "The same 'Stationary Company' or same 'Stationary Name' already exists." });
        }

        // Add Stationary
        const stationary = Stationary({
            category: req.body.category,
            company: req.body.company,
            name: req.body.name,
            quantity: req.body.quantity,
            price: req.body.price,
            createdBy: `${req.user[0]} ${req.user[1]}` // Getting user name and email from verifyToken middleware
        });

        const response = await stationary.save();

        res.status(200).json({ success: true, message: "New Stationary Created Successfully.", response });
    } catch (error) {
        res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
        console.log("Error =>", error);
    }
};

// View All Stationary api for ADMIN

const viewAllStationaryController = async (req, res) => {
    try {
        const stationaries = await Stationary.find();

        res.status(200).json({ success: true, message: "All Stationaries fetch Success.", response: stationaries });

    } catch (error) {
        res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
        console.log("Error =>", error);
    }
};

// View specific Stationary api for ADMIN

const viewOneStationaryController = async (req, res) => {
    try {
        // Finding stationary based on id from params
        const stationary = await Stationary.findOne({ _id: req.params.id });

        // Check for existence of particular stationary
        if (!stationary) {
            return res.status(404).json({ success: false, message: "No such Stationary found with given ID." });
        }

        res.status(200).json({ success: true, message: "Specific Stationary fetch Success.", response: stationary });

    } catch (error) {
        res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
        console.log("Error =>", error);
    }
};

// Update Stationary data api for ADMIN

const updateStationaryController = async (req, res) => {
    // Finding stationary based on id from params
    const stationary = await Stationary.findOne({ _id: req.params.id });

    // Check for existence of particular stationary
    if (!stationary) {
        return res.status(404).json({ success: false, message: "No such Stationary found with given ID." });
    }

    try {
        const updatedStationary = await Stationary.findByIdAndUpdate({ _id: req.params.id }, { $set: req.body }, { new: true });

        res.status(200).json({ success: true, message: "Stationary Update Success.", response: updatedStationary });

    } catch (error) {
        res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
        console.log("Error =>", error);
    }
};

// Delete Stationary data api for ADMIN

const deleteStationaryController = async (req, res) => {
    // Finding stationary based on id from params
    const stationary = await Stationary.findOne({ _id: req.params.id });

    // Check for existence of particular stationary
    if (!stationary) {
        return res.status(404).json({ success: false, message: "No such Stationary found with given ID." });
    }

    try {
        const deletedStationary = await Stationary.findByIdAndDelete({ _id: req.params.id });

        res.status(200).json({ success: true, message: "Stationary Delete Success.", response: deletedStationary });

    } catch (error) {
        res.status(500).json({ success: false, message: "Something went wrong", error: error.message });
        console.log("Error =>", error);
    }
};

module.exports = {
    addStationaryController,
    viewAllStationaryController,
    viewOneStationaryController,
    updateStationaryController,
    deleteStationaryController
};