express = require("express")
messages = require("express-messages")
app = module.exports = express.createServer()
app.set "views", __dirname + "/views"
app.set "view engine", "jade"
app.mounted (other) ->
  console.log "ive been mounted!"

app.dynamicHelpers 
  messages: messages
  base: ->
    (if "/" == app.route then "" else app.route)

app.configure ->
  app.use express.logger("\u001b[33m:method\u001b[0m \u001b[32m:url\u001b[0m :response-time")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session(secret: "keyboard cat")
  app.use app.router
  app.use express.static(__dirname + "/public")
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

require("./routes/site") app
require("./routes/post") app
if not module.parent
  app.listen 3000
  console.log "Express started on port 3000"
