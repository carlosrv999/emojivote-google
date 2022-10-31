import * as mysql from 'mysql';
import * as fs from 'fs'
import * as process from 'process';

const initializeDb = () => {
  console.log("environment variables are:", process.env.MYSQL_HOST, process.env.MYSQL_USER, process.env.MYSQL_PASSWD)
  if (!process.env.MYSQL_HOST || !process.env.MYSQL_USER || !process.env.MYSQL_PASSWD) {
    console.log("ERROR. Please set environment variables")
    throw new Error("Environment variables have not been set");
  }
  try {
    const connection = new mysql.createConnection({
      host: process.env.MYSQL_HOST,
      user: process.env.MYSQL_USER,
      password: process.env.MYSQL_PASSWD,
      multipleStatements: true,
      charset: 'utf8mb4',
    })

    connection.connect((err) => {
      if (err) {
        console.log("connection error");
      } else {
        const sqlScript = fs.readFileSync('initialize.sql').toString();
        console.log(sqlScript);
        connection.query(sqlScript, (error, results) => {
          if (error) throw error;
          console.log("success, ", results);
        })

        console.log("success")
      }
    });
  } catch (error) {
    console.log("an error happened: ", error)
    throw error;
  }
}

try {
  initializeDb();
  setTimeout(() => {
    console.log("ha pasado un tiempo");
  }, 100000)
} catch (error) {
  console.log("an error happened: ", error)
  throw error;
}
