const router = require('express').Router()
const tokenForUser = require('./tokenForUser')
const db = require('./db')

// SAVE NEW MEAL
router.post('/', async (req, res) => {
  const token = req.token
  const decodedToken = tokenForUser.verify(token)
  if (!token || !decodedToken.id) {
    return res.status(401).json({ error: 'token missing or invalid' })
  }

  const meal = req.body
  const querySaveNewMeal = `INSERT INTO ateria SET ?;`

  try {
    const pvm = getDateString(null)
    const added = await db.query(querySaveNewMeal, {
      user_id: decodedToken.id,
      name: meal.name,
      pvm: pvm
    })
    const insertId = added[0].insertId
    const promiseArray = meal.foods.map(food =>
      db.query(`INSERT INTO ateria_elintarvike SET ?;`, {
        meal_id: insertId,
        foodid: food.foodid,
        amount: food.amount
      })
    )
    await Promise.all(promiseArray)
    return res.json({
      ...meal,
      meal_id: insertId,
      pvm: pvm.slice(0, 10),
      notSaved: false
    })
  } catch (e) {
    console.log(e)
    res
      .status(503)
      .json({ error: 'Virhe palvelussa, yritä myöhemmin uudelleen.' })
  }

  return res.status(200)
})

router.delete('/:id', async (req, res) => {
  const decodedToken = tokenForUser.verify(req.token)
  if (!decodedToken) {
    return res.status(401).json({ error: 'token missing or invalid' })
  }
  try {
    if (await isMealOwner(req.params.id, decodedToken.id)) {
      const q1 = `DELETE FROM ateria_elintarvike WHERE meal_id = ?;`
      const q2 = `DELETE FROM ateria WHERE id = ?;`
      await Promise.all([
        db.query(q1, req.params.id),
        db.query(q2, req.params.id)
      ])
      return res.status(204).json({ msg: 'successful delete' })
    } else {
      return res
        .status(403)
        .json({ error: 'Forbidden. Request ID is not the meal owner' })
    }
  } catch (e) {
    console.log(e)
    res
      .status(503)
      .json({ error: 'Virhe palvelussa, yritä myöhemmin uudelleen.' })
  }
})

// Update meal
router.put('/', async (req, res) => {
  const token = req.token
  const decodedToken = tokenForUser.verify(token)
  if (!token || !decodedToken.id) {
    return res.status(401).json({ error: 'token missing or invalid' })
  }
  const meal = req.body
  console.log(meal)
  try {
    if (await isMealOwner(meal.meal_id, decodedToken.id)) {
      const updateRes = await db.query(
        `UPDATE ateria SET name = ? WHERE id = ?`,
        [meal.name, meal.meal_id]
      )
      const deleteRes = await db.query(
        `DELETE FROM ateria_elintarvike WHERE meal_id = ?`,
        meal.meal_id
      )
      const promiseArray = meal.foods.map(food =>
        db.query(`INSERT INTO ateria_elintarvike SET ?;`, {
          meal_id: meal.meal_id,
          foodid: food.foodid,
          amount: food.amount
        })
      )
      await Promise.all(promiseArray)
      return res.json({ ...meal, notSaved: false })
    } else {
      return res
        .status(403)
        .json({ error: 'Forbidden. Request ID is not the meal owner' })
    }
  } catch (e) {
    res
      .status(503)
      .json({ error: 'Virhe palvelussa, yritä myöhemmin uudelleen.' })
  }
})

router.put('/date/:id', async (req, res) => {
  const token = req.token
  const decodedToken = tokenForUser.verify(token)
  if (!token || !decodedToken.id) {
    return res.status(401).json({ error: 'token missing or invalid' })
  }

  try {
    if (await isMealOwner(req.params.id, decodedToken.id)) {
      const date = req.body
      const dateString = getDateString(dateFromObj(date))
  
      await db.query(
        `UPDATE ateria SET pvm = ? WHERE id = ?`,
        [dateString, req.params.id]
      )
    } else {
      return res
        .status(403)
        .json({ error: 'Forbidden. Request ID is not the meal owner' })
    }
  } catch (err) {
    res
      .status(503)
      .json({ error: 'Virhe palvelussa, yritä myöhemmin uudelleen.' })
  }

  return res.status(200).json({ msg: 'successfully updated date' })
})

const dateFromObj = (obj) => {
  const date = new Date()
  date.setFullYear(obj.year)
  date.setMonth(obj.month)
  date.setDate(obj.day)
  date.setHours(obj.hours)
  date.setMinutes(obj.minutes)
  date.setSeconds(obj.seconds)
  return date
}

const isMealOwner = async (meal_id, user_id) => {
  const resultset = await db.query(
    `SELECT id, ateria.name FROM ateria WHERE user_id = ? AND id = ?;`,
    [user_id, meal_id]
  )
  return resultset[0].length === 0 ? false : true
}

const getDateString = (d) => {
  const date = d || new Date()
  const year = date.getFullYear()
  let month = parseInt(date.getMonth()) + 1
  month = addLeadingZeroIfNeeded(month.toString())
  const day = addLeadingZeroIfNeeded(date.getDate().toString())
  const hours = addLeadingZeroIfNeeded(date.getHours().toString())
  const minutes = addLeadingZeroIfNeeded(date.getMinutes().toString())
  const seconds = addLeadingZeroIfNeeded(date.getSeconds().toString())
  return (
    year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds
  )
}

const addLeadingZeroIfNeeded = string => {
  return string.length < 2 ? '0' + string : string
}

module.exports = router
