const express = require('express');
const router = express.Router();
const { verifyToken } = require('../../middlewares/middlewares'); // Middleware
const { addStationaryController, viewAllStationaryController, viewOneStationaryController, updateStationaryController, deleteStationaryController } = require('../../controllers/admin/stationary.controller'); // Stationary Controllers

// Add Stationary api for ADMIN
router.post('/stationary', verifyToken, addStationaryController);

// View All Stationary api for ADMIN
router.get('/stationary', verifyToken, viewAllStationaryController);

// View specific Stationary api for ADMIN
router.get('/stationary/:id', verifyToken, viewOneStationaryController);

// Update Stationary data api for ADMIN
router.put('/stationary/:id', verifyToken, updateStationaryController);

// Delete Stationary data api for ADMIN
router.delete('/stationary/:id', verifyToken, deleteStationaryController);

module.exports = router;