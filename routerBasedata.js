const router = require('express').Router()
const mysql = require('mysql2/promise');
const db = require('./db')

router.get('/', async (req, res, next) => {
  //const db = await getConnection()
  const data = await db.query(
    'SELECT foodname FROM `base` WHERE `foodid` = 34611'
  )
  res.json(data[0])
})

module.exports = router