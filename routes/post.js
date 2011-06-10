(function() {
  var Post, basicAuth;
  basicAuth = require("express").basicAuth;
  Post = require("../models/post");
  module.exports = function(app) {
    app.all("/post(/*)?", basicAuth(function(user, pass) {
      return "admin" === user && "express" === pass;
    }));
    app.param("post", function(req, res, next, id) {
      return Post.get(id, function(err, post) {
        if (err) {
          return next(err);
        }
        if (!post) {
          return next(new Error("failed to load post " + id));
        }
        req.post = post;
        return next();
      });
    });
    app.get("/post/add", function(req, res) {
      return res.render("post/form", {
        post: {}
      });
    });
    app.post("/post", function(req, res) {
      var data, post;
      data = req.body.post;
      post = new Post(data.title, data.body);
      return post.validate(function(err) {
        if (err) {
          req.flash("error", err.message);
          return res.redirect("back");
        }
        return post.save(function(err) {
          req.flash("info", "Successfully created post _%s_", post.title);
          return res.redirect("/post/" + post.id);
        });
      });
    });
    app.get("/post/:post", function(req, res) {
      return res.render("post", {
        post: req.post
      });
    });
    app.get("/post/:post/edit", function(req, res) {
      return res.render("post/form", {
        post: req.post
      });
    });
    return app.put("/post/:post", function(req, res, next) {
      var post;
      post = req.post;
      return post.validate(function(err) {
        if (err) {
          req.flash("error", err.message);
          return res.redirect("back");
        }
        return post.update(req.body.post, function(err) {
          if (err) {
            return next(err);
          }
          req.flash("info", "Successfully updated post");
          return res.redirect("back");
        });
      });
    });
  };
}).call(this);
