const mysql = require('mysql2/promise')

if (process.env.NODE_ENV !== 'production') {
  require('dotenv').config()
}

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    database: process.env.DB_NAME,
    password: process.env.DB_PASS,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
    multipleStatements: true
})

module.exports = pool
