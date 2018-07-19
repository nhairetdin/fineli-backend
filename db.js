const mysql = require('mysql2/promise');

const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    database: 'fineli',
    password: 'root',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0//,
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