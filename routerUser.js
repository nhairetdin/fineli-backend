const bcrypt = require('bcrypt')
const router = require('express').Router()
const mysql = require('mysql2/promise')
const db = require('./db')
const validator = require("email-validator")
const tokenForUser = require('./tokenForUser')
require('dotenv').config()

router.post('/', async (req, res) => {
  try {
    const body = req.body
    if (validateCredentials(body)) {
      const user = {
        email: body.email,
        passhash: await bcrypt.hash(body.password, 10)
      }
      const [results, fields] = await db.query('INSERT INTO user SET ?', user)
      const token = tokenForUser.sign({ email: body.email, id: results.insertId })
      console.log("decoded user:", tokenForUser.verify(token))
      console.log("user added with id", results.insertId)
      res.json({ token, email: body.email })
    } else {
      res.status(401).json({ error: 'Virheellinen käyttäjätunnus tai salasana.' })
    }
  } catch (e) {
    let msg = "error"
    if (e.errno === 1062) {
      msg = "Antamasi email-osoite on jo rekisteröity palveluun."
    }
    res.status(500).json({ error: msg })
  }
})

const validateCredentials = (creds) => {
  return validator.validate(creds.email) && creds.password.length > 5
}

module.exports = router