const bcrypt = require('bcryptjs')
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
        gender: body.gender,
        recommendation: body.gender
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
})

// userdata, fetch user specific data: suggestions, saved meals
router.post('/profile', async (req, res) => {
  const token = req.token
  console.log(token)
  const decodedToken = tokenForUser.verify(token)
  console.log(decodedToken)
  if (!token || !decodedToken.id) {
    console.log("invalid token")
    return res.status(401).json({ error: 'token missing or invalid' })
  }
  try {
    const [suggestions, fields] = await db.query(querySuggestions, decodedToken.id)
    const [result2, fields2] = await db.query(queryMeals, decodedToken.id)
    const meals = formatRows(result2)
    res.status(200).json([...suggestions, [...meals]])
  } catch (e) {
    res.status(503).json({ msg: 'Virhe palvelussa, yritä myöhemmin uudelleen.'})
  }
})

const validateCredentials = (email) => {
  return validator.validate(email)
}

const formatRows = (rows) => {
  const reduced = rows.reduce((res, row) => {
    if (res[row.meal_id]) {
      res[row.meal_id] = { 
        ...res[row.meal_id], 
        foods: [ ...res[row.meal_id].foods, 
        { foodid: row.foodid, foodname: row.foodname, amount: row.amount } ] }
    } else {
      res[row.meal_id] = {
        meal_id: row.meal_id, 
        name: row.name, 
        pvm: row.pvm, 
        foods: [{ foodid: row.foodid, foodname: row.foodname, amount: row.amount }]
      }
    }
    return res
  }, {})

  return Object.keys(reduced).map(obj => {
    return { ...reduced[obj] }
  })
}

const querySuggestions = 
`SELECT * FROM suositukset WHERE user_id IN (select recommendation from user where id = ?);`

const queryMeals = 
`
  SELECT 
   ateria.id as meal_id, 
   ateria.user_id, 
   ateria.name, 
   SUBSTRING(ateria.pvm, 1, 10) as pvm, 
   ateria_elintarvike.foodid, 
   elintarvike.foodname, 
   ateria_elintarvike.amount 
  FROM ateria 
   JOIN ateria_elintarvike ON ateria.id = ateria_elintarvike.meal_id
   JOIN elintarvike ON ateria_elintarvike.foodid = elintarvike.foodid
  WHERE user_id = ?;
`

module.exports = router