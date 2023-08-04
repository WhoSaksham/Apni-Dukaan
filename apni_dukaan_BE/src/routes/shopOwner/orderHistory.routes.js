const express = require('express');
const router = express.Router();
const { verifyToken } = require('../../middlewares/middlewares'); // Middleware
const { getHistoryController, addHistoryController, editHistoryController, deleteHistoryController } = require('../../controllers/shopOwner/orderHistory.controller'); // ShopOwner Controllers

// View ORDER HISTORY api for SHOPOWNER

router.get('/', verifyToken, getHistoryController);

// Add ORDER HISTORY api for SHOPOWNER

router.post('/', verifyToken, addHistoryController);

// Update ORDER HISTORY api for SHOPOWNER

router.put('/:id', verifyToken, editHistoryController);

// Delete ORDER HISTORY api for SHOPOWNER

router.delete('/:id', verifyToken, deleteHistoryController);

module.exports = router;