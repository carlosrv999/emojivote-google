import { pool } from './index.js'

export const querySelectVotes = (successHandler, errorHandler) => {
  pool.query(`select emoji_id, count(*) as vote_quantity from votes group by emoji_id order by vote_quantity desc;`, (error, results, fields) => {
    if (error) {
      errorHandler(error)
    }
    successHandler(results)
  })
}

export const queryInsertVote = (emoji_id, successHandler, errorHandler) => {
  pool.query(`insert into votes (emoji_id, voting_date) values (?, CURRENT_TIMESTAMP);`, [emoji_id], (error, results, fields) => {
    if (error) {
      errorHandler(error)
    }
    successHandler(results)
  })
}