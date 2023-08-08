const { Schema, model } = require('mongoose');

const adminAuthSchema = Schema({
    firstName: {
        type: String,
        minLength: 3,
        maxLength: 20,
        trim: true,
        required: [true, "Provide First Name"]
    },
    lastName: {
        type: String,
        minLength: 3,
        maxLength: 20,
        trim: true,
        required: [true, "Provide Last Name"]
    },
    email: {
        type: String,
        required: [true, "Provide Email Address"],
        unique: [true, "Email already exists"],
        lowercase: true,
        trim: true,
        // validate: {
        //     validator: function (val) {
        //         return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val);
        //     },
        //     message: 'Invalid Email type!'
        // }
        // validate: { if(!validator.isEmail()) { throw new Error("Invalid Email")} }
    },
    password: {
        type: String,
        minLength: 8,
        required: [true, "Provide Password"]
    },
    role: {
        type: String,
        enum: ['ADMIN'],
        required: true,
        default: "ADMIN"
    },
    createdAt: {
        type: Date,
        default: Date.now()
    }
},
    { toJSON: { transform(doc, ret) { delete ret.password } } });  // Exclude password from JSON

const AdminAuth = model('AdminAuth', adminAuthSchema);

// Indexing
// AdminAuth.createIndexes();

module.exports = AdminAuth;