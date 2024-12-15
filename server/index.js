require('dotenv').config({path: '../.env'});

// IMPORTS FROM PACKAGES
const express = require('express');
const mongoose = require('mongoose');

// IMPORTS FROM OTHER FILES
const authRouter = require('./routes/auth'); 

// INIT
const PORT = process.env.PORT;
const app = express();
const DB = process.env.DB;

// MIDDLEWARE 
app.use(express.json())
app.use(authRouter)

// CONNECTIONS
mongoose.connect(DB).then(() => {
    console.log("Connection successfull");
}).catch((e) => {
    console.log(e);
})

app.get("/api/user", (req, res) => {
    res.json({name: 'hello'})
})

app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at PORT ${PORT}`);
});