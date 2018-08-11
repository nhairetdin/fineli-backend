const mysql = require('mysql2/promise');
require('dotenv').config()

const pool = mysql.createPool({
    host: 'localhost',
    user: process.env.DB_USER,
    database: 'fineli',
    password: process.env.DB_PASS,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
    multipleStatements: true//,
    // typeCast: function (field, next) {
    //     if (field.type.includes("DECIMAL")) {
    //     	//console.log(true)
    //         var value = field.string();
    //         return (value === null) ? 0 : parseFloat(value);
    //     }
    //     return next();
    // }
})

module.exports = pool