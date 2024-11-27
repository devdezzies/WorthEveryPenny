const express = require('express')
const User = require("../models/user")
const bcryptjs = require('bcryptjs')

const authRouter = express.Router();

authRouter.post('/api/signup', async (req, res) => {
    try {
        const {name, email, password} = req.body
    
        const exsitingUser = await User.findOne({ email })
        if (exsitingUser) { // Equals to != NULL
            return res.status(400).json({msg: '⚠️ User with the same email already exists!'})
        }

        const hashedPassword = await bcryptjs.hash(password, 8)
    
        let user = new User({
            name, 
            email,
            password : hashedPassword,
        })
        user = await user.save()
        res.json(user)
    } catch (e) {
        res.status(500).json({ error: e.message })
    }
    
    // post that data in database
    // return that data to the user 
})

module.exports = authRouter;