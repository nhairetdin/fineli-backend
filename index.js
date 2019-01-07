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
const HOST = '0.0.0.0'

server.listen(PORT, HOST, () => {
  console.log(`Server running on port ${PORT}`)
})

server.on('close', () => {
  // close connection..
  db.end()
})

module.exports = db
