import dotenv from 'dotenv';
dotenv.config({ path: '../.env' });

// IMPORTS FROM PACKAGES
import express from 'express';
import mongoose from 'mongoose';

// IMPORTS FROM OTHER FILES
import authRouter from './routes/auth.js'; 

// INIT
const PORT = process.env.PORT;
const app = express();
const DB = process.env.DB;

// === MIDDLEWARE ===
app.use(express.json());
// LOGGING 
app.use((req, res, next) => {
    console.log(`Request Method: ${req.method}, request URL: ${req.url}`);
    next();
});
// AUTHENTICATION
app.use(authRouter);

// CONNECTIONS
mongoose.connect(DB).then(() => {
    console.log("Connection successful");
}).catch((e) => {
    console.log(e);
});

app.get("/api/user", (req, res) => {
    res.json({ name: 'hello' });
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at PORT ${PORT}`);
});