import express from 'express'
import { querySelectVotes, queryInsertVote } from './queries.js'
const router = express.Router()

router.use((req, res, next) => {
  console.log('Time: ', Date.now())
  next()
})

router.get('/vote', (req, res) => {
  querySelectVotes((results) => {
    res.send(results)
  }, (error) => {
    res.status(500).send(error)
  })
})

router.post('/vote', (req, res) => {
  queryInsertVote(req.body.emoji_id, (results) => {
    res.send({
      "result": "success",
      "voted": req.body
    })
  }, (error) => {
    res.status(500).send(error)
  })
})

export default router