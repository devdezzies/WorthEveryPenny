// IMPORTS FROM PACKAGES
const express = require('express');
const mongoose = require('mongoose');

// IMPORTS FROM OTHER FILES
const authRouter = require('./routes/auth'); 

// INIT
const PORT = 3000;
const app = express();
const DB = "mongodb+srv://boltholt17:Npriwnl39zXZNaX3@cluster0.0x0x9.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

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