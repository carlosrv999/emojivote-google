import express from 'express'
import cors from 'cors'
import mysql from 'mysql'
import router from './emoji.js'
import { dbConnectionParams } from './db-config.js'
import {server, grpc} from './grpc-server.js'

const app = express()
const port = 3000
const grpcPort = 50050
var connectionTest = mysql.createConnection(dbConnectionParams)
export const pool = mysql.createPool(dbConnectionParams)

app.use(cors())
app.use(express.json())

const myLogger = function (req, res, next) {
  console.log('LOGGED')
  next()
}

app.use(myLogger)

app.use(router)

app.get('/', (req, res) => {
  res.send('App is running')
})

connectionTest.connect((err) => {
  if (err) {
    console.log("Error connecting to database: "+err.stack)
    throw err
  }
  console.log("Successfully connected to database with credentials.")
  app.listen(port, () => {
    console.log(`REST API Server listening on port ${port}`)
  })
  server.bindAsync(`0.0.0.0:${grpcPort}`, grpc.ServerCredentials.createInsecure(), (error, port) => {
    console.log(`gRPC Server listening on ${port}`)
    server.start()
  })
})
