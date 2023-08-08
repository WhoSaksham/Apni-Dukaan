const express = require('express');
const router = express.Router();
const { shopOwnerLoginController, shopOwnerSignupController, forgotPasswordController, resetPasswordController } = require('../../controllers/shopOwner/auth.controller'); // ShopOwner Controllers

// SIGNUP api for SHOPOWNER

router.post('/signup', shopOwnerSignupController);

// LOGIN api for SHOPOWNER

router.post('/login', shopOwnerLoginController);

// FORGOT PASS api for SHOPOWNER

router.post('/forgot', forgotPasswordController);

// RESET PASS api for SHOPOWNER

router.put('/reset', resetPasswordController);

module.exports = router;