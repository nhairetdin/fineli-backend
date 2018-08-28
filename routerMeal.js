const router = require('express').Router()
const tokenForUser = require('./tokenForUser')
const db = require('./db')

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

// const test = async () => {
// 	const [rows, fields] = await db.query(queryMeals)
// 	//console.log(rows)

// 	const r = rows.reduce((res, row) => {
// 		if (res[row.meal_id]) {
// 			res[row.meal_id] = { ...res[row.meal_id], foods: [ ...res[row.meal_id].foods, { foodid: row.foodid, foodname: row.foodname, amount: row.amount } ] }
// 		} else {
// 			res[row.meal_id] = {
// 				meal_id: row.meal_id, 
// 				name: row.name, 
// 				pvm: row.pvm, 
// 				foods: [{ foodid: row.foodid, foodname: row.foodname, amount: row.amount }]
// 			}
// 		}
// 		return res
// 	}, {})
// 	const arr = Object.keys(r).map(obj => {
// 		return { ...r[obj] }
// 	})
// 	console.log(r)
// 	console.log(arr)
// }
// test()

// GET ALL MEALS FOR A USER
router.get('/', async (req, res, next) => {
	const token = req.token
  console.log(token)
  const decodedToken = tokenForUser.verify(token)
  if (!token || !decodedToken.id) {
    return res.status(401).json({ error: 'token missing or invalid' })
  }
  try {
		const [rows, fields] = await db.query(queryMeals, decodedToken.id)
		res.json(formatRows(rows))
  } catch (e) {
  	res.status(503).json({ msg: 'Virhe palvelussa, yritä myöhemmin uudelleen.'})
  }
})

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

// SAVE NEW MEAL
router.post('/', async (req, res) => {
	const token = req.token
  const decodedToken = tokenForUser.verify(token)
  if (!token || !decodedToken.id) {
    return res.status(401).json({ error: 'token missing or invalid' })
  }
  const meal = req.body
  const querySaveNewMeal = `INSERT INTO ateria SET ?;`
  //const promiseArray = meal.foods.map(food => db.query(`INSERT INTO ateria_elintarvike (meal_id, foodid, amount) values (?, ?, ?);`, meal.meal_id, food.foodid, food.amount))
  try {
  	const pvm = getDateString()
  	const added = await db.query(querySaveNewMeal, { user_id: decodedToken.id, name: meal.name, pvm: pvm })
  	const insertId = added[0].insertId
  	const promiseArray = meal.foods.map(food => db.query(`INSERT INTO ateria_elintarvike SET ?;`, { meal_id: insertId, foodid: food.foodid, amount: food.amount }))
  	//console.log(added)
  	await Promise.all(promiseArray)
  	return res.json({ ...meal, meal_id: insertId, pvm: pvm.slice(0, 10), notSaved: false })
  } catch(e) {
  	console.log(e)
  	res.status(503).json({ msg: 'Virhe palvelussa, yritä myöhemmin uudelleen.'})
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
	  	return res.status(204).json({ msg: 'successful delete'})
    } else {
    	return res.status(403).json({ msg: 'Forbidden. Request ID is not the meal owner' })
    }
  } catch(e) {
  	console.log(e)
  	res.status(503).json({ msg: 'Virhe palvelussa, yritä myöhemmin uudelleen.'})
  }
  //console.log("req.params.id: " + req.params.id)
  //return res.status(204).end()
})

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
	  	const updateRes = await db.query(`UPDATE ateria SET name = ? WHERE id = ?`, [meal.name, meal.meal_id])
	  	const deleteRes = await db.query(`DELETE FROM ateria_elintarvike WHERE meal_id = ?`, meal.meal_id)
	  	const promiseArray = meal.foods.map(food => db.query(`INSERT INTO ateria_elintarvike SET ?;`, { meal_id: meal.meal_id, foodid: food.foodid, amount: food.amount }))
	  	await Promise.all(promiseArray)
	  	return res.json({ ...meal, notSaved: false })
  	} else {
  		return res.status(403).json({ msg: 'Forbidden. Request ID is not the meal owner' })
  	}
  } catch (e) {
  	res.status(503).json({ msg: 'Virhe palvelussa, yritä myöhemmin uudelleen.'})
  }
})

const isMealOwner = async (meal_id, user_id) => {
	const resultset = await db.query(`SELECT id, ateria.name FROM ateria WHERE user_id = ? AND id = ?;`, [user_id, meal_id])
	return resultset[0].length === 0 ? false : true
}

const getDateString = () => {
	const date = new Date()
	const year = date.getFullYear()
	let month = parseInt(date.getMonth()) + 1
	month = addLeadingZeroIfNeeded(month.toString())
	const day = addLeadingZeroIfNeeded(date.getDate().toString())
	const hours = addLeadingZeroIfNeeded(date.getHours().toString())
	const minutes = addLeadingZeroIfNeeded(date.getMinutes().toString())
	const seconds = addLeadingZeroIfNeeded(date.getSeconds().toString())
	return year + "-" + month  + "-" + day + " " + hours + ":" + minutes + ":" + seconds
}

const addLeadingZeroIfNeeded = (string) => {
	return string.length < 2 ? ("0"+string) : string
}

module.exports = router

		// if (res[row.meal_id]) {
		// 	res[row.meal_id] = { ...res[row.meal_id], foods: { ...res[row.meal_id].foods, [row.foodid]: { foodname: row.foodname} } }
		// } else {
		// 	res[row.meal_id] = {
		// 		meal_id: row.meal_id, 
		// 		name: row.name, 
		// 		pvm: row.pvm, 
		// 		foods: { [row.foodid]: { foodname: row.foodname } }
		// 	}
		// }

		// res[row.meal_id] = { ...res[row.meal_id], foods: { ...res[row.meal_id].foods, [row.foodid]: { foodname: row.foodname} } } || { 
		// 	meal_id: row.meal_id, 
		// 	name: row.name, 
		// 	pvm: row.pvm, 
		// 	foods: res[row.meal_id].foods ?  : false
		// }
			//foods: res[row.meal_id].foods ? res[row.meal_id].foods.concat({ name: row.foodname }) : [{ name: row.foodname }] }
		//res[row.meal_id][foods[row.foodid]] = res[row.meal_id][foods[row.foodid]] || { foodid: row.foodid }
