const bcrypt = require('bcrypt')
const router = require('express').Router()
const mysql = require('mysql2/promise')
const db = require('./db')
const validator = require("email-validator")
const tokenForUser = require('./tokenForUser')
require('dotenv').config()

// register
router.post('/', async (req, res) => {
  try {
    const body = req.body
    let errorMsg = validateCredentials(body.email) ? '' : 'Virheellinen sähköposti.'
    errorMsg += body.password.length > 5 ? '' : ' Liian lyhyt salasana.'
    if (errorMsg.length === 0) {
      const user = {
        email: body.email,
        passhash: await bcrypt.hash(body.password, 10),
        gender: body.gender
      }
      const [results, fields] = await db.query('INSERT INTO user SET ?', user)
      const token = tokenForUser.sign({ email: body.email, id: results.insertId })
      console.log("decoded user:", tokenForUser.verify(token))
      console.log("user added with id", results.insertId)
      res.json({ token, email: body.email })
    } else {
      res.status(401).json({ error: errorMsg })
    }
  } catch (e) {
    let msg = "error"
    if (e.errno === 1062) {
      msg = "Antamasi email-osoite on jo rekisteröity palveluun."
    }
    res.status(500).json({ error: msg })
  }
})

// login
router.post('/session', async (req, res) => {
  console.log("login attempt",req.body)
  if (!req.body.email || !req.body.password) {
    return res.status(400).send()
  }

  try {
    const [result, fields] = await db.query('SELECT id, email, passhash FROM user WHERE email = ?', req.body.email)

    if(result.length === 0) {
      return res.status(401).json({ error: 'Sähköposti ei ole rekisteröity.'})
    }
    if(!await bcrypt.compare(req.body.password, result[0].passhash)) {
      return res.status(401).json({ error: 'Virheellinen salasana.'})
    }

    const token = tokenForUser.sign({ email: req.body.email, id: result[0].id })
    res.status(200).json({ token, email: req.body.email })
  } catch (e) {
    res.status(503).json({ msg: 'Virhe palvelussa, yritä myöhemmin uudelleen.'})
  }

  //res.status(200).json({ msg: 'valid' })
})

const validateCredentials = (email) => {
  return validator.validate(email)
}

module.exports = router