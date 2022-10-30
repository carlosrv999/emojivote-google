import grpc from '@grpc/grpc-js'
import protoLoader from '@grpc/proto-loader'
import { querySelectVotes, queryInsertVote } from './queries.js'

const PROTO_FILE = './emoji.proto'

const options = {
  keepCase: true,
  longs: String,
  enums: String,
  defaults: true,
  oneofs: true,
}

// load the proto file
const pkgDefs = protoLoader.loadSync(PROTO_FILE, options)

// load defs into gRPC
const emojiProto = grpc.loadPackageDefinition(pkgDefs)
const emojiPackage = emojiProto.emojiPackage

const server = new grpc.Server()

const readVotes = (input, callback) => {
  querySelectVotes((results) => {
    console.log("recibida peticion gRPC readVotes")
    callback(null, {votes: results})
  }, (error) => {
    callback(error, null)
  })
}

const createVote = (input, callback) => {
  if (!input.request.emoji_id) return callback({"error": "no ha seteado el emoji_id"}, null)
  if (input.request.emoji_id < 1 || input.request.emoji_id > 20) return callback({"error": "el emoji_id debe ser un numero del 1 al 20"}, null)
  queryInsertVote(input.request.emoji_id,
    (results) => {
      console.log("recibida peticion gRPC createVote")
      console.log(results)
      callback(null, {
        result: "success",
        voted: {"emoji_id": input.request.emoji_id
      }
    })
    }, 
    (error) => {
      callback(error, null)
    })
}

// Implement EmojiService
server.addService(emojiPackage.EmojiService.service, {
  "readVotes": readVotes,
  "createVote": createVote,
})

export { server, grpc }
