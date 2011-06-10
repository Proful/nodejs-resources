(function() {
  var app, express;
  express = require("express");
  app = module.exports = express.createServer();
  app.configure(function() {
    app.set("views", __dirname + "/views");
    app.set("view engine", "jade");
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    return app.use(express.static(__dirname + "/public"));
  });
  app.configure("development", function() {
    return app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
  });
  app.configure("production", function() {
    return app.use(express.errorHandler());
  });
  app.get("/", function(req, res) {
    return res.render("index", {
      title: "Express"
    });
  });
  app.get("/login", function(req, res) {
    var data;
    data = {};
    return res.render("login", {
      title: "Admin login",
      data: data
    });
  });
  app.get("/admin", function(req, res) {
    return res.render("admin", {
      title: "Admin Page"
    });
  });
  app.post("/login", function(req, res) {
    var data;
    if (req.body.password === 'password') {
      return res.redirect("/admin");
    } else {
      data = {
        error_msg: "error"
      };
      return res.render("login", {
        title: "Admin login",
        data: data
      });
    }
  });
  app.listen(3000);
  console.log("Express server listening on port %d", app.address().port);
}).call(this);
