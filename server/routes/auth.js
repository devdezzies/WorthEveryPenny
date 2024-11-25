const express = require('express'); 

const authRouter = express.Router();

// authRouter.get("/user", (req, res) => {
//     res.json({
//         msg: "hello"
//     })
// })

authRouter.post('api/signup', (req, res) => {
    // get the data from the client
    console.log(req.body);
    // post that data in database
    
    // return that data to the user 
})

module.exports = authRouter;