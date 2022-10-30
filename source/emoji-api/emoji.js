import express from 'express'
import { querySelectEmoji } from './queries.js'
const router = express.Router()

router.use((req, res, next) => {
  console.log('Time: ', Date.now())
  next()
})

router.get('/emoji', (req, res) => {
  querySelectEmoji((results) => {
    res.send(results)
  }, (error) => {
    res.status(500).send(error)
  })
})

export default router