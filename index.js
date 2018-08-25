const mysql = require('mysql2/promise');

const http = require('http')
const compression = require('compression')
const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')
const app = express()
const routerBasedata = require('./routerBasedata')
const routerUser = require('./routerUser')
const routerMeal = require('./routerMeal')
const db = require('./db')
const tokenExtractor = require('./middlewareTokenExtractor')

app.use(cors())
app.use(compression({ level: 4 }))
app.use(bodyParser.json())
app.use(tokenExtractor.tokenExtractor)
app.use(express.static('build'))
app.use('/basedata', routerBasedata)
app.use('/user', routerUser)
app.use('/meal', routerMeal)

const server = http.createServer(app)

const PORT = 3002

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
})

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    database: 'fineli',
    password: 'root',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
})

// async function main() {
//   const data = await pool.query(
//     'SELECT * FROM `base` WHERE `foodid` = 34611'
//   )
//   console.log(data)
// }

// async function getdata() {
//   const data = await db.query(
//     'SELECT foodname FROM `base` WHERE `foodid` = 34611'
//   )
//   console.log(data)
// }
//getdata()
//main()

//const getConnection = () => pool.getConnection()

// const getData = async () => {
//   console.log(pool)
//   const data = await pool.query('SELECT * FROM `base` WHERE `foodid` = 34611')
//   console.log(data)
// }

// const pool = getPool().then(
//   getData()
// )

//getData()

server.on('close', () => {
  // close connection..
  db.end()
})

// const getConnection = async () => {
//   return await pool.getConnection((err, conn) => {

//   })
// }

// const connection = mysql.createConnection({
//   host: 'localhost',
//   user: 'root',
//   password: 'root',
//   database: 'fineli'
// });

// connection.query(
//   'SELECT * FROM `base` WHERE `foodid` = ?',
//   [34661],
//   function(err, results) {
//     console.log(results);
//   }
// );

module.exports = db