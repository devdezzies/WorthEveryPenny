// IMPORTS FROM PACKAGES
const express = require('express');
const mongoose = require('mongoose');

// IMPORTS FROM OTHER FILES
const authRouter = require('./routes/auth'); 

// INIT
const PORT = 3000;
const app = express();

// CONNECTIONS
mongoose.connect().then(() => {
    console.log("Connection successfull");
}).catch((e) => {
    console.log(e);
})

app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at PORT ${PORT}`);
}); 