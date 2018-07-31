const jwt = require('jsonwebtoken')
require('dotenv').config()

const sign = (user) => {
  return jwt.sign(user, process.env.SECRET)
}

const verify = (token) => {
  return jwt.verify(token, process.env.SECRET)
}

module.exports = { sign, verify }
