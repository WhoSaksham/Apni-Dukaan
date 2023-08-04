const express = require('express');
const router = express.Router();
const { adminLoginController, adminSignupController } = require('../../controllers/admin/auth.controller'); // Admin Controllers

// SIGNUP api for ADMIN

router.post('/signup', adminSignupController);

// LOGIN api for ADMIN

router.post('/login', adminLoginController);

module.exports = router;