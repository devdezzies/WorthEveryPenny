const express = require('express')
const User = require("../models/user")
const bcryptjs = require('bcryptjs')
const authRouter = express.Router();
const jwt = require('jsonwebtoken')

authRouter.post('/api/signup', async (req, res) => {
    try {
        const {name, email, password} = req.body
    
        const exsitingUser = await User.findOne({ email })
        if (exsitingUser) { // Equals to != NULL
            return res.status(400).json({msg: '⚠️ User with the same email already exists!'})
        }

        if (password.length < 6) {
            return res.status(400).json({msg: 'Please enter at least 6 length password'})
        }

        const hashedPassword = await bcryptjs.hash(password, 8)
    
        let user = new User({
            name, 
            email,
            // RESOLVED: hashedPassword made the validator for password doesn't work, because it's always > 6 length
            password : hashedPassword,
        })

        user = await user.save()
        res.json(user)
    } catch (e) {
        res.status(500).json({ error: e.message })
    }
})

// Sign Route 
authRouter.post('/api/signin', async (req, res) => {
    try {
        const {email, password} = req.body

        const user = await User.findOne({email})
        if (!user) {
            return res.status(400).json({msg: 'User with this email doesn\'t exist!'})
        }

        // hashed password check
        const isMatch = await bcryptjs.compare(password, user.password)
        if (!isMatch) {
            return res.status(400).json({msg: 'Incorrect password'})
        }

        const token = jwt.sign({id: user._id}, "passwordKey")
        res.json({token, ...user._doc})
    } catch(e) {
        res.status(500).json({error: e.message})
    }
})

module.exports = authRouter;