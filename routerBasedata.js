const router = require('express').Router()
//const mysql = require('mysql2/promise');
const db = require('./db')

const priorities = {
  Hiilihydraattifraktiot: 2,
  'Kivennäis- ja hivenaineet': 4,
  Perusravintoaineet: 6,
  Rasva: 3,
  Typpiyhdisteet: 1,
  Vitamiinit: 5
}
const b1 = `SELECT * FROM base;`
const b2 = `SELECT * FROM erityisruokavalio_lyhennetty;`

let basedata
db.query(`${b1}${b2}`).then(rows => {
  const specdiet = rows[0][1].reduce((result, row) => {
    const foodid = row.foodid
    if (result[foodid]) {
      result[foodid] = [...result[foodid], row.specdiet]
      return result
    } else {
      result = { ...result, [foodid]: [row.specdiet] }
      return result
    }
  }, {})

  const base = rows[0][0].reduce((result, row) => {
    if (result.length > 0) {
      result = result.concat({ ...row, specdiet: specdiet[row.foodid] })
    } else {
      result = [{ ...row, specdiet: specdiet[row.foodid] }]
    }
    return result
  }, [])
  console.log('initial')
  basedata = base
})

router.get('/food', async (req, res, next) => {
  res.json(basedata)
})

router.get('/components', async (req, res, next) => {
  const query = `SELECT * FROM ravintotekija_yksikko_luokka;`
  const query2 = `SELECT * FROM suositukset WHERE user_id = 'male';`
  const [rows, fields] = await db.query(`${query}${query2}`)
  const rowsClassified = rows[0].reduce((res, i) => {
    let luokka = i.ylempiluokka
    res[luokka] = res[luokka] || { data: [], importance: priorities[luokka] }
    res[luokka].data.push(i)
    return res
  }, {})
  const rowsClassifiedArray = Object.keys(rowsClassified).map(
    i => rowsClassified[i]
  )
  const sorted = rowsClassifiedArray.sort((a, b) => b.importance - a.importance)

  res.json({ originalRows: rows, classifiedRows: sorted })
})

router.get('/specdiet', async (req, res, next) => {
  const query = `SELECT thscode, shortname FROM erityisruokavalio_fi;`
  const [rows, fields] = await db.query(query)
  res.json(rows)
})

module.exports = router
