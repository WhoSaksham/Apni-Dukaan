const express = require('express');
const router = express.Router();
const { shopOwnerLoginController, shopOwnerSignupController } = require('../../controllers/shopOwner/auth.controller'); // ShopOwner Controllers

// SIGNUP api for SHOPOWNER

router.post('/signup', shopOwnerSignupController);

// LOGIN api for SHOPOWNER

router.post('/login', shopOwnerLoginController);

module.exports = router;