const jwt = require('jsonwebtoken')
require('dotenv').config()

const sign = (user) => {
  return jwt.sign(user, process.env.SECRET)
}

const verify = (token) => {
  const verified = jwt.verify(token, process.env.SECRET, (err, decoded) => {
  	if (err) {
  	  return err
  	} else {
  	  return decoded
  	}
  })
  console.log("verified: ",verified)
  return verified
}

module.exports = { sign, verify }
