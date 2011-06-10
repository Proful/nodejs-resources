express = require("express")
app = module.exports = express.createServer()
app.configure ->
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + "/public")

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()

app.get "/", (req, res) ->
  res.render "index", title: "Express"

app.get "/login", (req, res) ->
  data = {}
  res.render "login", title: "Admin login",data: data

app.get "/admin", (req, res) ->
  res.render "admin", title: "Admin Page"

app.post "/login", (req, res) ->
  if req.body.password is 'password'
    res.redirect "/admin"
    #res.render "admin", title: " Admin"
  else
    data = {error_msg: "error"}
    res.render "login", title: "Admin login",data:data

app.listen 3000
console.log "Express server listening on port %d", app.address().port
