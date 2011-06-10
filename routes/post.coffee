basicAuth = require("express").basicAuth
Post = require("../models/post")
module.exports = (app) ->
  app.all "/post(/*)?", basicAuth((user, pass) ->
    "admin" == user and "express" == pass
  )
  app.param "post", (req, res, next, id) ->
    Post.get id, (err, post) ->
      if err
        return next(err)
      if not post
        return next(new Error("failed to load post " + id))
      req.post = post
      next()
  
  app.get "/post/add", (req, res) ->
    res.render "post/form", post: {}
  
  app.post "/post", (req, res) ->
    data = req.body.post
    post = new Post(data.title, data.body)
    post.validate (err) ->
      if err
        req.flash "error", err.message
        return res.redirect("back")
      post.save (err) ->
        req.flash "info", "Successfully created post _%s_", post.title
        res.redirect "/post/" + post.id
  
  app.get "/post/:post", (req, res) ->
    res.render "post", post: req.post
  
  app.get "/post/:post/edit", (req, res) ->
    res.render "post/form", post: req.post
  
  app.put "/post/:post", (req, res, next) ->
    post = req.post
    post.validate (err) ->
      if err
        req.flash "error", err.message
        return res.redirect("back")
      post.update req.body.post, (err) ->
        if err
          return next(err)
        req.flash "info", "Successfully updated post"
        res.redirect "back"
