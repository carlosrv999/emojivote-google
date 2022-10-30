import { pool } from './index.js'

export const querySelectEmoji = (successHandler, errorHandler) => {
  pool.query('SELECT * from emojis;', (error, results, fields) => {
    if (error) {
      errorHandler(error)
    }
    successHandler(results)
  })
}