const router = require('express').Router()
const mysql = require('mysql2/promise');
const db = require('./db')

const priorities = {
    'Hiilihydraattifraktiot': 2,
    'Kivennäis- ja hivenaineet': 4,
    'Perusravintoaineet': 6,
    'Rasva': 3,
    'Typpiyhdisteet': 1,
    'Vitamiinit': 5
}

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
  const query2 = `SELECT * FROM suositukset WHERE user_id = 'male';`
  const [rows, fields] = await db.query(`${query}${query2}`)
  console.log(rows)
  ////////////////////////////////////////////
  const rowsClassified = rows[0].reduce((res, i) => {
    let luokka = i.ylempiluokka
    res[luokka] = res[luokka] || { data: [], importance: priorities[luokka] }
    res[luokka].data.push(i)
    return res
  }, {})
  const rowsClassifiedArray = Object.keys(rowsClassified).map(i => rowsClassified[i])
  const sorted = rowsClassifiedArray.sort((a, b) => b.importance - a.importance)
  ////////////////////////////////////////////
  //console.log(rows)
  res.json({ originalRows: rows, classifiedRows: sorted })
})

router.get('/specdiet', async (req, res, next) => {
  const query = `SELECT * FROM erityisruokavalio_lyhennetty;`
  const query2 = `SELECT thscode, shortname FROM erityisruokavalio_fi;`
  const [rows, fields] = await db.query(`${query}${query2}`)
  res.json(rows)
})

module.exports = router