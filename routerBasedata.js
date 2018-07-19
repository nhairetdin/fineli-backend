const router = require('express').Router()
const mysql = require('mysql2/promise');
const db = require('./db')

router.get('/food', async (req, res, next) => {
  //const db = await getConnection()
  const q1 = `SELECT * FROM base;`
  const q2 = 'SELECT foodname FROM `base` WHERE `foodid` = 34611'
  const [rows, fields] = await db.query(q1)
  //console.log(rows.sort((a, b) => parseFloat(b.ENERC) - parseFloat(a.ENERC)))
  res.json(rows)
})

router.get('/components', async (req, res, next) => {
  const query = `SELECT * FROM ravintotekija_yksikko_luokka;`
  const [rows, fields] = await db.query(query)
  //console.log(rows)
  res.json(rows)
})

module.exports = router