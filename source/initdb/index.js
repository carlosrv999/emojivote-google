import * as mysql from 'mysql';
import * as fs from 'fs'
import { exit } from 'process';

const initializeDb = async () => {
  try {
    const connection = mysql.createConnection({
      host: process.env.MYSQL_HOST,
      user: process.env.MYSQL_USER,
      password: process.env.MYSQL_PASSWD,
      multipleStatements: true,
      charset: 'utf8mb4',
    })

    connection.connect();

    const sqlScript = fs.readFileSync('initialize.sql').toString();
    console.log(sqlScript);
    const query = connection.query(sqlScript, (error, results) => {
      if (error) throw error;
      console.log("success, ", results);
    })

    exit(0);

  } catch (error) {
    console.log("an error happened: ", error)
    throw error;
  }

}

try {
  initializeDb();
} catch (error) {
  console.log("an error happened: ", error)
  throw error;
}
